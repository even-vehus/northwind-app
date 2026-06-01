namespace Northwind.Domain.Entities;

public class PurchaseOrder
{
    public int PurchaseOrderId { get; set; }
    public int? VendorId { get; set; }
    public int? SubmittedById { get; set; }
    public DateTime? SubmittedDate { get; set; }
    public int? ApprovedById { get; set; }
    public DateTime? ApprovedDate { get; set; }
    public int? StatusId { get; set; }
    public DateTime? ReceivedDate { get; set; }
    public decimal? ShippingFee { get; set; }
    public decimal? TaxAmount { get; set; }
    public DateTime? PaymentDate { get; set; }
    public decimal? PaymentAmount { get; set; }
    public string? PaymentMethod { get; set; }
    public string? Notes { get; set; }
    public string? AddedBy { get; set; }
    public DateTime? AddedOn { get; set; }
    public string? ModifiedBy { get; set; }
    public DateTime? ModifiedOn { get; set; }

    // Navigation
    public Company? Vendor { get; set; }
    public Employee? SubmittedBy { get; set; }
    public Employee? ApprovedBy { get; set; }
    public PurchaseOrderStatus? Status { get; set; }
    public ICollection<PurchaseOrderDetail> PurchaseOrderDetails { get; set; } = [];
}
