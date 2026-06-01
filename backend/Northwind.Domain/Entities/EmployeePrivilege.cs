namespace Northwind.Domain.Entities;

public class EmployeePrivilege
{
    public int EmployeePrivilegeId { get; set; }
    public int? EmployeeId { get; set; }
    public int? PrivilegeId { get; set; }
    public string? AddedBy { get; set; }
    public DateTime? AddedOn { get; set; }
    public string? ModifiedBy { get; set; }
    public DateTime? ModifiedOn { get; set; }

    // Navigation
    public Employee? Employee { get; set; }
    public Privilege? Privilege { get; set; }
}
