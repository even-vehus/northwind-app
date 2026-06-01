namespace Northwind.Domain.Entities;

public class Order
{
    public int OrderId { get; set; }
    public int? EmployeeId { get; set; }
    public int? CustomerId { get; set; }
    public int? OrderStatusId { get; set; }
    public DateTime? OrderDate { get; set; }
    public DateTime? InvoiceDate { get; set; }
    public DateTime? ShippedDate { get; set; }
    public DateTime? PaidDate { get; set; }
    public int? ShipperId { get; set; }
    public decimal? ShippingFee { get; set; }
    public double? TaxRate { get; set; }
    public int? TaxStatusId { get; set; }
    public string? PaymentMethod { get; set; }
    public string? Notes { get; set; }
    public string? AddedBy { get; set; }
    public DateTime? AddedOn { get; set; }
    public string? ModifiedBy { get; set; }
    public DateTime? ModifiedOn { get; set; }

    // Navigation
    public Company? Customer { get; set; }
    public Employee? Employee { get; set; }
    public ICollection<OrderDetail> OrderDetails { get; set; } = [];
}
