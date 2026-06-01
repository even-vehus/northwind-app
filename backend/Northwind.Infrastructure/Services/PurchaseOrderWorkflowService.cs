using Microsoft.EntityFrameworkCore;
using Northwind.Domain.Entities;
using Northwind.Domain.Enums;
using Northwind.Infrastructure.Data;

namespace Northwind.Infrastructure.Services;

/// <summary>
/// Port of the PO workflow in Access frmPurchaseOrderDetails. Messages taken verbatim
/// from the Strings table.
/// </summary>
public class PurchaseOrderWorkflowService(NorthwindDbContext db, IInventoryService inventory)
    : IPurchaseOrderWorkflowService
{
    private const string OnlyNewCanSubmit = "The purchase order can only be submitted if it is in the New status.";        // 20
    private const string OnlySubmittedCanApprove = "The purchase order can only be approved if it is in the Submitted status."; // 21
    private const string OnlyApprovedCanReceive = "The purchase order can only be received if it is in the Approved status.";   // 24
    private const string OnlyReceivedCanClose = "The purchase order can only be closed if it is in the Received status.";       // 25
    private const string CloseFieldsRequired = "Shipping Fee and Payment Method are required before closing the purchase order."; // 26
    private const string CannotDelete = "A purchase order can only be deleted when its Status is New or Submitted.";           // 27

    public async Task SubmitAsync(int purchaseOrderId, CancellationToken ct = default)
    {
        var po = await LoadAsync(purchaseOrderId, ct);
        if (po.StatusId != (int)PurchaseOrderStatusId.New)
            throw new BusinessRuleException(OnlyNewCanSubmit);

        po.StatusId = (int)PurchaseOrderStatusId.Submitted;
        po.SubmittedDate ??= DateTime.UtcNow;
        Touch(po);
        await db.SaveChangesAsync(ct);
    }

    public async Task ApproveAsync(int purchaseOrderId, CancellationToken ct = default)
    {
        var po = await LoadAsync(purchaseOrderId, ct);
        if (po.StatusId != (int)PurchaseOrderStatusId.Submitted)
            throw new BusinessRuleException(OnlySubmittedCanApprove);

        // NOTE: Access requires the "Approve PO" privilege here. Auth is bypassed in this app
        // (no ClientId), so the privilege check is intentionally not enforced yet.
        po.StatusId = (int)PurchaseOrderStatusId.Approved;
        po.ApprovedDate ??= DateTime.UtcNow;
        Touch(po);
        await db.SaveChangesAsync(ct);
    }

    public async Task ReceiveAsync(int purchaseOrderId, CancellationToken ct = default)
    {
        var po = await LoadAsync(purchaseOrderId, ct);
        if (po.StatusId != (int)PurchaseOrderStatusId.Approved)
            throw new BusinessRuleException(OnlyApprovedCanReceive);

        var now = DateTime.UtcNow;
        po.StatusId = (int)PurchaseOrderStatusId.Received;
        po.ReceivedDate = now;
        // Stamp every line's ReceivedDate — inventory's "bought" calc keys off this.
        foreach (var line in po.PurchaseOrderDetails)
            line.ReceivedDate = now;
        Touch(po);
        await db.SaveChangesAsync(ct);

        // Now that stock has arrived, re-evaluate orders waiting on each product.
        var productIds = po.PurchaseOrderDetails
            .Where(d => d.ProductId != null)
            .Select(d => d.ProductId!.Value)
            .Distinct()
            .ToList();
        foreach (var productId in productIds)
            await inventory.AllocateInventoryAsync(productId, ct);
    }

    public async Task CloseAsync(int purchaseOrderId, ClosePurchaseOrderArgs args, CancellationToken ct = default)
    {
        var po = await LoadAsync(purchaseOrderId, ct);

        if (args.ShippingFee is not null) po.ShippingFee = args.ShippingFee;
        if (args.PaymentMethod is not null) po.PaymentMethod = args.PaymentMethod;

        if (po.StatusId != (int)PurchaseOrderStatusId.Received)
            throw new BusinessRuleException(OnlyReceivedCanClose);
        if (po.ShippingFee is null || string.IsNullOrWhiteSpace(po.PaymentMethod))
            throw new BusinessRuleException(CloseFieldsRequired);

        po.StatusId = (int)PurchaseOrderStatusId.Closed;
        Touch(po);
        await db.SaveChangesAsync(ct);
    }

    public async Task DeleteAsync(int purchaseOrderId, CancellationToken ct = default)
    {
        var po = await LoadAsync(purchaseOrderId, ct);
        if (po.StatusId != (int)PurchaseOrderStatusId.New
            && po.StatusId != (int)PurchaseOrderStatusId.Submitted)
            throw new BusinessRuleException(CannotDelete);

        db.PurchaseOrderDetails.RemoveRange(po.PurchaseOrderDetails);
        db.PurchaseOrders.Remove(po);
        await db.SaveChangesAsync(ct);
    }

    public async Task<int> AddOrMergeDetailAsync(
        int purchaseOrderId, int productId, int quantity, decimal unitCost, CancellationToken ct = default)
    {
        var line = await db.PurchaseOrderDetails
            .FirstOrDefaultAsync(d => d.PurchaseOrderId == purchaseOrderId && d.ProductId == productId, ct);

        if (line is null)
        {
            line = new PurchaseOrderDetail
            {
                PurchaseOrderId = purchaseOrderId,
                ProductId = productId,
                Quantity = quantity,
                UnitCost = unitCost,
                AddedOn = DateTime.UtcNow,
            };
            db.PurchaseOrderDetails.Add(line);
        }
        else
        {
            // BUSINESS RULE: add to the quantity already there.
            line.Quantity = (line.Quantity ?? 0) + quantity;
            line.ModifiedOn = DateTime.UtcNow;
        }

        await db.SaveChangesAsync(ct);
        return line.PurchaseOrderDetailId;
    }

    public async Task<int> ReorderProductAsync(
        int productId, int vendorId, int quantity, decimal unitCost, CancellationToken ct = default)
    {
        var now = DateTime.UtcNow;
        var po = new PurchaseOrder
        {
            VendorId = vendorId,
            StatusId = (int)PurchaseOrderStatusId.New,
            AddedOn = now,
            ModifiedOn = now,
        };
        db.PurchaseOrders.Add(po);
        await db.SaveChangesAsync(ct);   // assigns PurchaseOrderId

        await AddOrMergeDetailAsync(po.PurchaseOrderId, productId, quantity, unitCost, ct);
        return po.PurchaseOrderId;
    }

    private async Task<PurchaseOrder> LoadAsync(int id, CancellationToken ct) =>
        await db.PurchaseOrders
            .Include(p => p.PurchaseOrderDetails)
            .FirstOrDefaultAsync(p => p.PurchaseOrderId == id, ct)
        ?? throw new KeyNotFoundException($"Purchase order {id} not found.");

    private static void Touch(PurchaseOrder po) => po.ModifiedOn = DateTime.UtcNow;
}
