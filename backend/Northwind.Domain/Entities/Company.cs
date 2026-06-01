namespace Northwind.Domain.Entities;

public class Company
{
    public int CompanyId { get; set; }
    public string? CompanyName { get; set; }
    public int? CompanyTypeId { get; set; }
    public string? BusinessPhone { get; set; }
    public string? Address { get; set; }
    public string? City { get; set; }
    public string? StateAbbrev { get; set; }
    public string? Zip { get; set; }
    public string? Website { get; set; }
    public string? Notes { get; set; }
    public int? StandardTaxStatusId { get; set; }
    public string? AddedBy { get; set; }
    public DateTime? AddedOn { get; set; }
    public string? ModifiedBy { get; set; }
    public DateTime? ModifiedOn { get; set; }

    // Navigation
    public CompanyType? CompanyType { get; set; }
    public ICollection<Contact> Contacts { get; set; } = [];
    public ICollection<Order> Orders { get; set; } = [];
}
