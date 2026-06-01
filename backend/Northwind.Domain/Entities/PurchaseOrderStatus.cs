namespace Northwind.Domain.Entities;

public class PurchaseOrderStatus
{
    public int StatusId { get; set; }
    public string? StatusName { get; set; }
    public int? SortOrder { get; set; }

    public ICollection<PurchaseOrder> PurchaseOrders { get; set; } = [];
}
