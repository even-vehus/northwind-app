namespace Northwind.Domain.Entities;

public class OrderDetail
{
    public int OrderDetailId { get; set; }
    public int? OrderId { get; set; }
    public int? ProductId { get; set; }
    public decimal? UnitPrice { get; set; }
    public int? Quantity { get; set; }   // DB column is INT
    public double? Discount { get; set; }
    public int? StatusId { get; set; }
    public DateTime? DateAllocated { get; set; }
    public int? PurchaseOrderId { get; set; }
    public int? InventoryId { get; set; }
    public string? AddedBy { get; set; }
    public DateTime? AddedOn { get; set; }
    public string? ModifiedBy { get; set; }
    public DateTime? ModifiedOn { get; set; }

    // Navigation
    public Order? Order { get; set; }
    public Product? Product { get; set; }
}
