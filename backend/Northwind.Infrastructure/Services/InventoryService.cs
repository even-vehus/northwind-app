using Microsoft.EntityFrameworkCore;
using Northwind.Domain.Enums;
using Northwind.Infrastructure.Data;

namespace Northwind.Infrastructure.Services;

/// <summary>
/// Port of Access modInventory (391 lines). Inventory availability and order allocation.
///
/// Availability uses Allen Browne's stock-take formula (per the original):
///   available = lastStockTakeQty + (bought since last stock take) - (sold since last stock take)
/// where "sold" = quantity on invoiced orders and "bought" = quantity received on POs.
/// </summary>
public class InventoryService(NorthwindDbContext db) : IInventoryService
{
    // g_dtNorthwindInception in the VBA — used as the floor date when a product has no stock take.
    private static readonly DateTime NorthwindInception = new(2022, 11, 1);

    public async Task<ProductInventory> GetInventoryAsync(int productId, CancellationToken ct = default)
    {
        var product = await db.Products
            .AsNoTracking()
            .FirstOrDefaultAsync(p => p.ProductId == productId, ct)
            ?? throw new KeyNotFoundException($"Product {productId} not found.");

        var (lastDate, lastQty) = await LastStockTakeAsync(productId, product.AddedOn, ct);

        var sold = await SumOrderDetailQtyAsync(od =>
            od.ProductId == productId && od.Order!.InvoiceDate >= lastDate, ct);
        var bought = await SumReceivedQtyAsync(productId, lastDate, ct);
        var available = lastQty + bought - sold;

        var allocated = await QuantityByDetailStatusAsync(productId, OrderDetailStatusId.Allocated, ct);
        var noStock = await QuantityByDetailStatusAsync(productId, OrderDetailStatusId.NoStock, ct);
        var onOrder = await ProductOnOrderAsync(productId, ct);
        var toSell = available - allocated;

        var reorder = ReorderQuantity(
            toSell, onOrder, noStock,
            product.TargetLevel ?? 0,
            product.MinimumReorderQuantity ?? 1);

        return new ProductInventory(
            productId, lastDate, lastQty,
            available, allocated, onOrder, noStock, toSell, reorder);
    }

    public async Task<int> ProductAvailableAsync(int productId, CancellationToken ct = default)
    {
        var addedOn = await db.Products
            .Where(p => p.ProductId == productId)
            .Select(p => p.AddedOn)
            .FirstOrDefaultAsync(ct);

        var (lastDate, lastQty) = await LastStockTakeAsync(productId, addedOn, ct);
        var sold = await SumOrderDetailQtyAsync(od =>
            od.ProductId == productId && od.Order!.InvoiceDate >= lastDate, ct);
        var bought = await SumReceivedQtyAsync(productId, lastDate, ct);
        return lastQty + bought - sold;
    }

    public async Task<int> ProductToSellAsync(int productId, CancellationToken ct = default)
    {
        var available = await ProductAvailableAsync(productId, ct);
        var allocated = await QuantityByDetailStatusAsync(productId, OrderDetailStatusId.Allocated, ct);
        return available - allocated;
    }

    public async Task<int> ProductOnOrderAsync(int productId, CancellationToken ct = default)
        => (int)(await db.PurchaseOrderDetails
            .Where(pod => pod.ProductId == productId
                       && pod.PurchaseOrder!.StatusId == (int)PurchaseOrderStatusId.Approved)
            .SumAsync(pod => (int?)pod.Quantity, ct) ?? 0);

    public async Task<int> ProductReorderQuantityAsync(int productId, CancellationToken ct = default)
    {
        var product = await db.Products
            .Where(p => p.ProductId == productId)
            .Select(p => new { p.TargetLevel, p.MinimumReorderQuantity })
            .FirstOrDefaultAsync(ct);
        if (product is null) return 0;

        var toSell = await ProductToSellAsync(productId, ct);
        var onOrder = await ProductOnOrderAsync(productId, ct);
        var noStock = await QuantityByDetailStatusAsync(productId, OrderDetailStatusId.NoStock, ct);

        return ReorderQuantity(
            toSell, onOrder, noStock,
            product.TargetLevel ?? 0,
            product.MinimumReorderQuantity ?? 1);
    }

    public async Task AllocateInventoryAsync(int productId, CancellationToken ct = default)
    {
        // Physical stock available right now, plus what is on order, defines what we can promise.
        var available = await ProductAvailableAsync(productId, ct);
        var qtyToAllocate = available + await ProductOnOrderAsync(productId, ct);

        // Open lines for this product, oldest order first (OrderID breaks date ties).
        var openStatuses = new[]
        {
            (int)OrderDetailStatusId.Allocated,
            (int)OrderDetailStatusId.NoStock,
            (int)OrderDetailStatusId.OnOrder,
        };

        var lines = await db.OrderDetails
            .Where(od => od.ProductId == productId
                      && od.StatusId != null
                      && openStatuses.Contains(od.StatusId.Value))
            .OrderBy(od => od.Order!.OrderDate)
            .ThenBy(od => od.OrderId)
            .ToListAsync(ct);

        foreach (var line in lines)
        {
            var q = (int)(line.Quantity ?? 0);
            if (q <= available)
            {
                line.StatusId = (int)OrderDetailStatusId.Allocated;
                available -= q;
                qtyToAllocate -= q;
            }
            else if (q <= qtyToAllocate)
            {
                line.StatusId = (int)OrderDetailStatusId.OnOrder;
                qtyToAllocate -= q;
            }
            else
            {
                line.StatusId = (int)OrderDetailStatusId.NoStock;
            }
        }

        await db.SaveChangesAsync(ct);
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

    /// <summary>
    /// Most recent stock take for the product. If none exists, falls back to (productAddedOn, 0)
    /// — the same baseline the VBA would have created. Read path does not persist the baseline.
    /// </summary>
    private async Task<(DateTime Date, int Quantity)> LastStockTakeAsync(
        int productId, DateTime? productAddedOn, CancellationToken ct)
    {
        var last = await db.StockTakes
            .Where(s => s.ProductId == productId)
            .OrderByDescending(s => s.StockTakeDate)
            .Select(s => new { s.StockTakeDate, s.QuantityOnHand })
            .FirstOrDefaultAsync(ct);

        if (last is null)
            return (productAddedOn ?? NorthwindInception, 0);

        return (last.StockTakeDate ?? productAddedOn ?? NorthwindInception, last.QuantityOnHand ?? 0);
    }

    private async Task<int> QuantityByDetailStatusAsync(
        int productId, OrderDetailStatusId status, CancellationToken ct)
        => await SumOrderDetailQtyAsync(od =>
            od.ProductId == productId && od.StatusId == (int)status, ct);

    private async Task<int> SumOrderDetailQtyAsync(
        System.Linq.Expressions.Expression<Func<Northwind.Domain.Entities.OrderDetail, bool>> predicate,
        CancellationToken ct)
        => (int)(await db.OrderDetails.Where(predicate).SumAsync(od => (decimal?)od.Quantity, ct) ?? 0m);

    private async Task<int> SumReceivedQtyAsync(int productId, DateTime asOf, CancellationToken ct)
        => (int)(await db.PurchaseOrderDetails
            .Where(pod => pod.ProductId == productId && pod.ReceivedDate >= asOf)
            .SumAsync(pod => (int?)pod.Quantity, ct) ?? 0);

    /// <summary>Reorder calc from modInventory.ProductReorderQuantity.</summary>
    private static int ReorderQuantity(int toSell, int onOrder, int noStock, int targetLevel, int minReorder)
    {
        if (toSell + onOrder >= noStock + targetLevel)
            return minReorder;

        var reorder = (noStock + targetLevel) - (toSell + onOrder);
        return Math.Max(reorder, minReorder);
    }
}
