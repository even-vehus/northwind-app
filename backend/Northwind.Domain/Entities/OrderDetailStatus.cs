namespace Northwind.Domain.Entities;

public class OrderDetailStatus
{
    public int OrderDetailStatusId { get; set; }
    public string? OrderDetailStatusName { get; set; }
    public int? SortOrder { get; set; }
}
