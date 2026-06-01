namespace Northwind.Domain.Entities;

public class OrderStatus
{
    public int OrderStatusId { get; set; }
    public string? OrderStatusCode { get; set; }
    public string? OrderStatusName { get; set; }
    public int? SortOrder { get; set; }
}
