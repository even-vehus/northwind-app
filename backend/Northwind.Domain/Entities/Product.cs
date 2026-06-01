namespace Northwind.Domain.Entities;

public class Product
{
    public int ProductId { get; set; }
    public string? ProductName { get; set; }
    public string? ProductCode { get; set; }
    public int? ProductCategoryId { get; set; }
    public string? QuantityPerUnit { get; set; }
    public decimal? ListPrice { get; set; }        // DB column: UnitPrice
    public decimal? StandardCost { get; set; }     // DB column: StandardUnitCost
    public string? Description { get; set; }       // DB column: ProductDescription
    public int? ReorderLevel { get; set; }
    public int? TargetLevel { get; set; }
    public bool? Discontinued { get; set; }
    public int? MinimumReorderQuantity { get; set; }
    public string? AddedBy { get; set; }
    public DateTime? AddedOn { get; set; }
    public string? ModifiedBy { get; set; }
    public DateTime? ModifiedOn { get; set; }

    // Navigation
    public ProductCategory? ProductCategory { get; set; }
    public ICollection<OrderDetail> OrderDetails { get; set; } = [];
    public ICollection<ProductVendor> ProductVendors { get; set; } = [];
    public ICollection<StockTake> StockTakes { get; set; } = [];
    public ICollection<PurchaseOrderDetail> PurchaseOrderDetails { get; set; } = [];
}
