using Microsoft.EntityFrameworkCore;
using Northwind.Domain.Entities;
using Northwind.Domain.Enums;
using Northwind.Infrastructure.Data;

namespace Northwind.Infrastructure.Services;

/// <summary>
/// Port of the order workflow in Access frmOrderDetails. User-facing messages are taken
/// verbatim from the Strings table where one existed.
/// </summary>
public class OrderWorkflowService(NorthwindDbContext db, IInventoryService inventory) : IOrderWorkflowService
{
    // Messages (Access Strings table IDs noted).
    private const string OnlyNewCanInvoice = "Only orders with status of New can be invoiced.";              // 50
    private const string AtLeastOneLine = "An order must have at least one line item.";                      // 34
    private const string AllLinesAllocated = "The order cannot be invoiced until all line items have a status of Allocated. Allocation happens automatically when a PO is received with sufficient quantity."; // 17
    private const string ShippingFeeRequired = "Shipping Fee is required for the invoice.";                  // literal in VBA
    private const string OnlyInvoicedCanShip = "Only orders with status of Invoiced can be shipped.";        // 10
    private const string ShippingFieldsRequired = "The order cannot be shipped until all Shipping related fields are filled out."; // 9
    private const string OnlyShippedCanPay = "Only orders with status of Shipped can be paid.";              // 49
    private const string PaymentFieldsRequired = "The order cannot be paid until all Payment related fields are filled out."; // 36
    private const string OnlyPaidCanClose = "Only orders with status of Paid can be closed.";                // 4
    private const string CannotDelete = "An order can only be deleted before it is Shipped or Closed.";      // 6

    public async Task InvoiceAsync(int orderId, CancellationToken ct = default)
    {
        var order = await LoadWithDetailsAsync(orderId, ct);

        if (order.OrderStatusId != (int)OrderStatusId.New)
            throw new BusinessRuleException(OnlyNewCanInvoice);
        if (order.OrderDetails.Count == 0)
            throw new BusinessRuleException(AtLeastOneLine);
        if (order.OrderDetails.Any(d => d.StatusId != (int)OrderDetailStatusId.Allocated))
            throw new BusinessRuleException(AllLinesAllocated);
        if (order.ShippingFee is null)
            throw new BusinessRuleException(ShippingFeeRequired);

        order.OrderStatusId = (int)OrderStatusId.Invoiced;
        order.InvoiceDate = DateTime.UtcNow;
        SetLineItemsStatus(order, OrderDetailStatusId.Invoiced);
        Touch(order);

        await db.SaveChangesAsync(ct);
    }

    public async Task ShipAsync(int orderId, ShipOrderArgs args, CancellationToken ct = default)
    {
        var order = await LoadWithDetailsAsync(orderId, ct);

        if (args.ShippedDate is not null) order.ShippedDate = args.ShippedDate;
        if (args.ShipperId is not null) order.ShipperId = args.ShipperId;
        if (args.ShippingFee is not null) order.ShippingFee = args.ShippingFee;

        if (order.OrderStatusId != (int)OrderStatusId.Invoiced)
            throw new BusinessRuleException(OnlyInvoicedCanShip);
        if (order.ShippedDate is null || order.ShipperId is null || order.ShippingFee is null)
            throw new BusinessRuleException(ShippingFieldsRequired);

        order.OrderStatusId = (int)OrderStatusId.Shipped;
        SetLineItemsStatus(order, OrderDetailStatusId.Shipped);
        Touch(order);

        await db.SaveChangesAsync(ct);
    }

    public async Task PayAsync(int orderId, PayOrderArgs args, CancellationToken ct = default)
    {
        var order = await LoadWithDetailsAsync(orderId, ct);

        if (args.PaymentMethod is not null) order.PaymentMethod = args.PaymentMethod;
        if (args.PaidDate is not null) order.PaidDate = args.PaidDate;

        if (order.OrderStatusId != (int)OrderStatusId.Shipped)
            throw new BusinessRuleException(OnlyShippedCanPay);
        if (string.IsNullOrWhiteSpace(order.PaymentMethod) || order.PaidDate is null)
            throw new BusinessRuleException(PaymentFieldsRequired);

        order.OrderStatusId = (int)OrderStatusId.Paid;
        Touch(order);

        await db.SaveChangesAsync(ct);
    }

    public async Task CloseAsync(int orderId, CancellationToken ct = default)
    {
        var order = await LoadWithDetailsAsync(orderId, ct);

        if (order.OrderStatusId != (int)OrderStatusId.Paid)
            throw new BusinessRuleException(OnlyPaidCanClose);

        order.OrderStatusId = (int)OrderStatusId.Closed;
        Touch(order);

        await db.SaveChangesAsync(ct);
    }

    public async Task DeleteAsync(int orderId, CancellationToken ct = default)
    {
        var order = await LoadWithDetailsAsync(orderId, ct);

        if (order.OrderStatusId != (int)OrderStatusId.New
            && order.OrderStatusId != (int)OrderStatusId.Invoiced)
            throw new BusinessRuleException(CannotDelete);

        // Products that were on this order — their allocations must be recomputed once the
        // order's demand is gone (mirrors Form_Delete looping line items + AllocateInventory).
        var productIds = order.OrderDetails
            .Where(d => d.ProductId != null)
            .Select(d => d.ProductId!.Value)
            .Distinct()
            .ToList();

        db.OrderDetails.RemoveRange(order.OrderDetails);
        db.Orders.Remove(order);
        await db.SaveChangesAsync(ct);

        foreach (var productId in productIds)
            await inventory.AllocateInventoryAsync(productId, ct);
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

    private async Task<Order> LoadWithDetailsAsync(int orderId, CancellationToken ct) =>
        await db.Orders
            .Include(o => o.OrderDetails)
            .FirstOrDefaultAsync(o => o.OrderId == orderId, ct)
        ?? throw new KeyNotFoundException($"Order {orderId} not found.");

    private static void SetLineItemsStatus(Order order, OrderDetailStatusId status)
    {
        foreach (var line in order.OrderDetails)
            line.StatusId = (int)status;
    }

    private static void Touch(Order order)
    {
        order.ModifiedOn = DateTime.UtcNow;
    }
}
