namespace Northwind.Infrastructure.Services;

/// <summary>
/// A point-in-time inventory snapshot for a product. Ported from Access modInventory.
/// All quantities are whole units.
/// </summary>
public record ProductInventory(
    int ProductId,
    DateTime LastStockTakeDate,
    int LastStockTakeQuantity,
    int QuantityAvailable,          // physical on hand right now (stock take + bought - sold)
    int QuantityAllocated,          // committed to existing orders
    int QuantityOnOrder,            // on Approved purchase orders
    int QuantityNoStock,            // ordered but unfulfillable
    int QuantityToSell,             // available - allocated
    int SuggestedReorderQuantity);

public interface IInventoryService
{
    /// <summary>Full inventory snapshot for a product (modInventory calculations).</summary>
    Task<ProductInventory> GetInventoryAsync(int productId, CancellationToken ct = default);

    /// <summary>Physical quantity on hand: last stock take + bought since - sold since.</summary>
    Task<int> ProductAvailableAsync(int productId, CancellationToken ct = default);

    /// <summary>Available minus the quantity already allocated to orders.</summary>
    Task<int> ProductToSellAsync(int productId, CancellationToken ct = default);

    /// <summary>Quantity of this product on Approved purchase orders.</summary>
    Task<int> ProductOnOrderAsync(int productId, CancellationToken ct = default);

    /// <summary>Minimum quantity to reorder so allocations + target level are covered.</summary>
    Task<int> ProductReorderQuantityAsync(int productId, CancellationToken ct = default);

    /// <summary>
    /// Re-evaluate every open order line for this product (oldest order first) and move it
    /// to Allocated / OnOrder / NoStock based on physical stock and approved POs. Persists changes.
    /// Port of modInventory.AllocateInventory.
    /// </summary>
    Task AllocateInventoryAsync(int productId, CancellationToken ct = default);
}
