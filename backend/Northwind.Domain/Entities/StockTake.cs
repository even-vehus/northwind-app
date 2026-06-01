namespace Northwind.Domain.Entities;

public class StockTake
{
    public int StockTakeId { get; set; }
    public DateTime? StockTakeDate { get; set; }
    public int? ProductId { get; set; }
    public int? QuantityOnHand { get; set; }
    public int? ExpectedQuantity { get; set; }
    public string? AddedBy { get; set; }
    public DateTime? AddedOn { get; set; }
    public string? ModifiedBy { get; set; }
    public DateTime? ModifiedOn { get; set; }

    // Navigation
    public Product? Product { get; set; }
}
