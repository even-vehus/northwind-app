namespace Northwind.Domain.Entities;

public class ProductCategory
{
    public int CategoryId { get; set; }       // DB column: ProductCategoryID
    public string? CategoryName { get; set; } // DB column: ProductCategoryName
    public string? CategoryCode { get; set; } // DB column: ProductCategoryCode
    public string? CategoryDesc { get; set; } // DB column: ProductCategoryDesc
    public string? CategoryImage { get; set; }// DB column: ProductCategoryImage

    public ICollection<Product> Products { get; set; } = [];
}
