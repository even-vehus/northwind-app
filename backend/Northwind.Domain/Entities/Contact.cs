namespace Northwind.Domain.Entities;

public class Contact
{
    public int ContactId { get; set; }
    public int? CompanyId { get; set; }
    public string? LastName { get; set; }
    public string? FirstName { get; set; }
    public string? EmailAddress { get; set; }
    public string? JobTitle { get; set; }
    public string? PrimaryPhone { get; set; }
    public string? SecondaryPhone { get; set; }
    public string? Notes { get; set; }
    public string? AddedBy { get; set; }
    public DateTime? AddedOn { get; set; }
    public string? ModifiedBy { get; set; }
    public DateTime? ModifiedOn { get; set; }

    // Navigation
    public Company? Company { get; set; }
}
