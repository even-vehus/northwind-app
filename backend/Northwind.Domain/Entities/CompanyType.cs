namespace Northwind.Domain.Entities;

public class CompanyType
{
    public int CompanyTypeId { get; set; }
    public string? CompanyType1 { get; set; }
    public string? AddedBy { get; set; }
    public DateTime? AddedOn { get; set; }
    public string? ModifiedBy { get; set; }
    public DateTime? ModifiedOn { get; set; }

    public ICollection<Company> Companies { get; set; } = [];
}
