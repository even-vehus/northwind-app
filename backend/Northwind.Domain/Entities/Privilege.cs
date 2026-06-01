namespace Northwind.Domain.Entities;

public class Privilege
{
    public int PrivilegeId { get; set; }
    public string? PrivilegeName { get; set; }

    public ICollection<EmployeePrivilege> EmployeePrivileges { get; set; } = [];
}
