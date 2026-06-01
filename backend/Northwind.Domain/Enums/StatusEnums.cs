namespace Northwind.Domain.Enums;

// Values MUST equal the seed IDs in the source DB (OrderStatus / OrderDetailStatus /
// PurchaseOrderStatus tables). Confirmed from migration_output csv_data.
// Named "...Id" to avoid clashing with the lookup entities of the same concept.

public enum OrderStatusId
{
    Closed = 1,
    Invoiced = 2,
    New = 3,
    Shipped = 4,
    Paid = 5,
}

public enum OrderDetailStatusId
{
    Allocated = 1,
    Invoiced = 2,
    New = 3,
    NoStock = 4,
    OnOrder = 5,
    Shipped = 6,
}

public enum PurchaseOrderStatusId
{
    Approved = 1,
    Closed = 2,
    New = 3,
    Submitted = 4,
    Received = 5,
}
