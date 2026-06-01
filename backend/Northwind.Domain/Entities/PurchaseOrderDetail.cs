namespace Northwind.Domain.Entities;

public class PurchaseOrderDetail
{
    public int PurchaseOrderDetailId { get; set; }
    public int? PurchaseOrderId { get; set; }
    public int? ProductId { get; set; }
    public int? Quantity { get; set; }
    public decimal? UnitCost { get; set; }
    public DateTime? ReceivedDate { get; set; }
    public string? AddedBy { get; set; }
    public DateTime? AddedOn { get; set; }
    public string? ModifiedBy { get; set; }
    public DateTime? ModifiedOn { get; set; }

    // Navigation
    public PurchaseOrder? PurchaseOrder { get; set; }
    public Product? Product { get; set; }
}
