namespace Northwind.Domain.Entities;

public class Employee
{
    public int EmployeeId { get; set; }
    public string? FirstName { get; set; }
    public string? LastName { get; set; }
    public string? EmailAddress { get; set; }
    public string? JobTitle { get; set; }
    public string? PrimaryPhone { get; set; }
    public string? SecondaryPhone { get; set; }
    public string? Title { get; set; }
    public string? Notes { get; set; }
    public int? SupervisorId { get; set; }
    public string? WindowsUserName { get; set; }
    public string? AddedBy { get; set; }
    public DateTime? AddedOn { get; set; }
    public string? ModifiedBy { get; set; }
    public DateTime? ModifiedOn { get; set; }

    public ICollection<Order> Orders { get; set; } = [];
    public ICollection<EmployeePrivilege> EmployeePrivileges { get; set; } = [];
    public ICollection<PurchaseOrder> SubmittedPurchaseOrders { get; set; } = [];
    public ICollection<PurchaseOrder> ApprovedPurchaseOrders { get; set; } = [];
}
