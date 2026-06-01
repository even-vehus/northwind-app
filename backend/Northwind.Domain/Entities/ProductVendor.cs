namespace Northwind.Domain.Entities;

public class ProductVendor
{
    public int ProductVendorId { get; set; }
    public int? ProductId { get; set; }
    public int? VendorId { get; set; }
    public string? AddedBy { get; set; }
    public DateTime? AddedOn { get; set; }
    public string? ModifiedBy { get; set; }
    public DateTime? ModifiedOn { get; set; }

    // Navigation
    public Product? Product { get; set; }
    public Company? Vendor { get; set; }
}
