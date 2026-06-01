using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Northwind.Api.Dtos;
using Northwind.Domain.Entities;
using Northwind.Infrastructure.Data;
using Northwind.Infrastructure.Services;

namespace Northwind.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class ProductsController(NorthwindDbContext db, IInventoryService inventory) : ControllerBase
{
    [HttpGet]
    public async Task<ActionResult<PagedResult<ProductDto>>> GetAll(
        [FromQuery] string? search,
        [FromQuery] int? categoryId,
        [FromQuery] bool? discontinued,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 25,
        CancellationToken ct = default)
    {
        var query = db.Products
            .Include(p => p.ProductCategory)
            .AsNoTracking();

        if (!string.IsNullOrWhiteSpace(search))
            query = query.Where(p =>
                p.ProductName!.Contains(search) ||
                p.ProductCode!.Contains(search));

        if (categoryId.HasValue)
            query = query.Where(p => p.ProductCategoryId == categoryId);

        if (discontinued.HasValue)
            query = query.Where(p => p.Discontinued == discontinued);

        var total = await query.CountAsync(ct);
        var items = await query
            .OrderBy(p => p.ProductName)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .Select(p => ToDto(p))
            .ToListAsync(ct);

        return Ok(new PagedResult<ProductDto>(items, total, page, pageSize));
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<ProductDto>> GetById(int id, CancellationToken ct)
    {
        var product = await db.Products
            .Include(p => p.ProductCategory)
            .AsNoTracking()
            .FirstOrDefaultAsync(p => p.ProductId == id, ct);

        return product is null ? NotFound() : Ok(ToDto(product));
    }

    [HttpPost]
    public async Task<ActionResult<ProductDto>> Create([FromBody] CreateProductRequest req, CancellationToken ct)
    {
        var product = new Product
        {
            ProductName = req.ProductName,
            ProductCode = req.ProductCode,
            ProductCategoryId = req.ProductCategoryId,
            Description = req.Description,
            ListPrice = req.ListPrice,
            StandardCost = req.StandardCost,
            Discontinued = req.Discontinued ?? false,
            AddedBy = User.Identity?.Name,
            AddedOn = DateTime.UtcNow,
        };
        db.Products.Add(product);
        await db.SaveChangesAsync(ct);
        return CreatedAtAction(nameof(GetById), new { id = product.ProductId }, ToDto(product));
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] UpdateProductRequest req, CancellationToken ct)
    {
        var product = await db.Products.FindAsync([id], ct);
        if (product is null) return NotFound();

        product.ProductName = req.ProductName;
        product.ProductCode = req.ProductCode;
        product.ProductCategoryId = req.ProductCategoryId;
        product.Description = req.Description;
        product.ListPrice = req.ListPrice;
        product.StandardCost = req.StandardCost;
        product.Discontinued = req.Discontinued;
        product.ModifiedBy = User.Identity?.Name;
        product.ModifiedOn = DateTime.UtcNow;

        await db.SaveChangesAsync(ct);
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id, CancellationToken ct)
    {
        var product = await db.Products.FindAsync([id], ct);
        if (product is null) return NotFound();
        db.Products.Remove(product);
        await db.SaveChangesAsync(ct);
        return NoContent();
    }

    [HttpGet("categories")]
    public async Task<ActionResult<IReadOnlyList<ProductCategoryLookupDto>>> GetCategories(CancellationToken ct)
    {
        var categories = await db.ProductCategories
            .AsNoTracking()
            .OrderBy(c => c.CategoryName)
            .Select(c => new ProductCategoryLookupDto(c.CategoryId, c.CategoryName, c.CategoryCode))
            .ToListAsync(ct);
        return Ok(categories);
    }

    // ── Vendors sub-resource ──────────────────────────────────────────────────

    [HttpGet("{productId:int}/vendors")]
    public async Task<ActionResult<IReadOnlyList<ProductVendorDto>>> GetVendors(
        int productId, CancellationToken ct)
    {
        var vendors = await db.ProductVendors
            .Include(pv => pv.Vendor)
            .Where(pv => pv.ProductId == productId)
            .AsNoTracking()
            .ToListAsync(ct);
        return Ok(vendors.Select(pv => new ProductVendorDto(
            pv.ProductVendorId, pv.ProductId, null, pv.VendorId, pv.Vendor?.CompanyName)).ToList());
    }

    [HttpPost("{productId:int}/vendors")]
    public async Task<IActionResult> AddVendor(
        int productId, [FromBody] CreateProductVendorRequest req, CancellationToken ct)
    {
        var exists = await db.Products.AnyAsync(p => p.ProductId == productId, ct);
        if (!exists) return NotFound();
        var already = await db.ProductVendors
            .AnyAsync(pv => pv.ProductId == productId && pv.VendorId == req.VendorId, ct);
        if (already) return Conflict("Vendor already linked to this product.");
        db.ProductVendors.Add(new ProductVendor
        {
            ProductId = productId,
            VendorId = req.VendorId,
            AddedOn = DateTime.UtcNow
        });
        await db.SaveChangesAsync(ct);
        return NoContent();
    }

    [HttpDelete("{productId:int}/vendors/{productVendorId:int}")]
    public async Task<IActionResult> RemoveVendor(
        int productId, int productVendorId, CancellationToken ct)
    {
        var pv = await db.ProductVendors
            .FirstOrDefaultAsync(x => x.ProductVendorId == productVendorId
                && x.ProductId == productId, ct);
        if (pv is null) return NotFound();
        db.ProductVendors.Remove(pv);
        await db.SaveChangesAsync(ct);
        return NoContent();
    }

    // ── StockTake sub-resource ────────────────────────────────────────────────

    [HttpGet("{productId:int}/stock-takes")]
    public async Task<ActionResult<IReadOnlyList<StockTakeDto>>> GetStockTakes(
        int productId, CancellationToken ct)
    {
        var takes = await db.StockTakes
            .Where(st => st.ProductId == productId)
            .OrderByDescending(st => st.StockTakeDate)
            .AsNoTracking()
            .ToListAsync(ct);
        return Ok(takes.Select(st => new StockTakeDto(
            st.StockTakeId, st.ProductId, null, st.StockTakeDate,
            st.QuantityOnHand, st.ExpectedQuantity, st.AddedOn)).ToList());
    }

    [HttpPost("{productId:int}/stock-takes")]
    public async Task<IActionResult> AddStockTake(
        int productId, [FromBody] CreateStockTakeRequest req, CancellationToken ct)
    {
        var exists = await db.Products.AnyAsync(p => p.ProductId == productId, ct);
        if (!exists) return NotFound();
        db.StockTakes.Add(new StockTake
        {
            ProductId = productId,
            StockTakeDate = req.StockTakeDate ?? DateTime.UtcNow,
            QuantityOnHand = req.QuantityOnHand,
            ExpectedQuantity = req.ExpectedQuantity,
            AddedOn = DateTime.UtcNow
        });
        await db.SaveChangesAsync(ct);
        return NoContent();
    }

    [HttpPut("{productId:int}/stock-takes/{stockTakeId:int}")]
    public async Task<IActionResult> UpdateStockTake(
        int productId, int stockTakeId, [FromBody] UpdateStockTakeRequest req, CancellationToken ct)
    {
        var st = await db.StockTakes
            .FirstOrDefaultAsync(s => s.StockTakeId == stockTakeId && s.ProductId == productId, ct);
        if (st is null) return NotFound();
        st.StockTakeDate = req.StockTakeDate;
        st.QuantityOnHand = req.QuantityOnHand;
        st.ExpectedQuantity = req.ExpectedQuantity;
        st.ModifiedOn = DateTime.UtcNow;
        await db.SaveChangesAsync(ct);
        return NoContent();
    }

    [HttpDelete("{productId:int}/stock-takes/{stockTakeId:int}")]
    public async Task<IActionResult> DeleteStockTake(
        int productId, int stockTakeId, CancellationToken ct)
    {
        var st = await db.StockTakes
            .FirstOrDefaultAsync(s => s.StockTakeId == stockTakeId && s.ProductId == productId, ct);
        if (st is null) return NotFound();
        db.StockTakes.Remove(st);
        await db.SaveChangesAsync(ct);
        return NoContent();
    }

    private static ProductDto ToDto(Product p) => new(
        p.ProductId,
        p.ProductName,
        p.ProductCode,
        p.ProductCategoryId,
        p.ProductCategory?.CategoryName,
        p.Description,
        p.ListPrice,
        p.StandardCost,
        p.Discontinued
    );

    // ── Category CRUD ─────────────────────────────────────────────────────────

    [HttpGet("categories/{id:int}")]
    public async Task<ActionResult<ProductCategoryDto>> GetCategoryById(int id, CancellationToken ct)
    {
        var cat = await db.ProductCategories
            .AsNoTracking()
            .Where(c => c.CategoryId == id)
            .Select(c => new ProductCategoryDto(
                c.CategoryId, c.CategoryName, c.CategoryCode, c.CategoryDesc,
                c.Products.Count))
            .FirstOrDefaultAsync(ct);
        return cat is null ? NotFound() : Ok(cat);
    }

    [HttpPost("categories")]
    public async Task<ActionResult<ProductCategoryDto>> CreateCategory(
        [FromBody] CreateProductCategoryRequest req, CancellationToken ct)
    {
        var cat = new ProductCategory
        {
            CategoryName = req.CategoryName,
            CategoryCode = req.CategoryCode,
            CategoryDesc = req.CategoryDesc,
        };
        db.ProductCategories.Add(cat);
        await db.SaveChangesAsync(ct);
        return CreatedAtAction(nameof(GetCategoryById), new { id = cat.CategoryId },
            new ProductCategoryDto(cat.CategoryId, cat.CategoryName, cat.CategoryCode, cat.CategoryDesc, 0));
    }

    [HttpPut("categories/{id:int}")]
    public async Task<IActionResult> UpdateCategory(
        int id, [FromBody] UpdateProductCategoryRequest req, CancellationToken ct)
    {
        var cat = await db.ProductCategories.FindAsync([id], ct);
        if (cat is null) return NotFound();
        cat.CategoryName = req.CategoryName;
        cat.CategoryCode = req.CategoryCode;
        cat.CategoryDesc = req.CategoryDesc;
        await db.SaveChangesAsync(ct);
        return NoContent();
    }

    [HttpDelete("categories/{id:int}")]
    public async Task<IActionResult> DeleteCategory(int id, CancellationToken ct)
    {
        var cat = await db.ProductCategories.FindAsync([id], ct);
        if (cat is null) return NotFound();
        db.ProductCategories.Remove(cat);
        await db.SaveChangesAsync(ct);
        return NoContent();
    }

    // ── Inventory sub-resource (modInventory calculations) ───────────────────

    [HttpGet("{productId:int}/inventory")]
    public async Task<ActionResult<ProductInventoryDto>> GetInventory(int productId, CancellationToken ct)
    {
        try
        {
            var inv = await inventory.GetInventoryAsync(productId, ct);
            return Ok(new ProductInventoryDto(
                inv.ProductId, inv.LastStockTakeDate, inv.LastStockTakeQuantity,
                inv.QuantityAvailable, inv.QuantityAllocated, inv.QuantityOnOrder,
                inv.QuantityNoStock, inv.QuantityToSell, inv.SuggestedReorderQuantity));
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
    }

    // ── Orders sub-resource (orders containing this product) ─────────────────

    [HttpGet("{productId:int}/orders")]
    public async Task<ActionResult<PagedResult<OrderDto>>> GetProductOrders(
        int productId,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 25,
        CancellationToken ct = default)
    {
        var query = db.Orders
            .Include(o => o.Customer)
            .Include(o => o.Employee)
            .Where(o => o.OrderDetails.Any(d => d.ProductId == productId))
            .AsNoTracking();

        var total = await query.CountAsync(ct);
        var items = await query
            .OrderByDescending(o => o.OrderDate)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .Select(o => new OrderDto(
                o.OrderId, o.CustomerId,
                o.Customer != null ? o.Customer.CompanyName : null,
                o.EmployeeId,
                o.Employee != null
                    ? (o.Employee.FirstName + " " + o.Employee.LastName).Trim()
                    : null,
                o.OrderStatusId, o.OrderDate, o.ShippedDate, o.ShippingFee, null, o.Notes,
                new List<OrderDetailDto>()))
            .ToListAsync(ct);

        return Ok(new PagedResult<OrderDto>(items, total, page, pageSize));
    }

    // ── Purchase Orders sub-resource (POs containing this product) ───────────

    [HttpGet("{productId:int}/purchase-orders")]
    public async Task<ActionResult<PagedResult<PurchaseOrderDto>>> GetProductPurchaseOrders(
        int productId,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 25,
        CancellationToken ct = default)
    {
        var query = db.PurchaseOrders
            .Include(po => po.Vendor)
            .Include(po => po.SubmittedBy)
            .Include(po => po.Status)
            .Where(po => po.PurchaseOrderDetails.Any(d => d.ProductId == productId))
            .AsNoTracking();

        var total = await query.CountAsync(ct);
        var items = await query
            .OrderByDescending(po => po.SubmittedDate)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .Select(po => new PurchaseOrderDto(
                po.PurchaseOrderId,
                po.VendorId,
                po.Vendor != null ? po.Vendor.CompanyName : null,
                po.SubmittedById,
                po.SubmittedBy != null
                    ? (po.SubmittedBy.FirstName + " " + po.SubmittedBy.LastName).Trim()
                    : null,
                po.SubmittedDate, po.ApprovedById,
                po.ApprovedBy != null
                    ? (po.ApprovedBy.FirstName + " " + po.ApprovedBy.LastName).Trim()
                    : null,
                po.ApprovedDate, po.StatusId,
                po.Status != null ? po.Status.StatusName : null,
                po.ReceivedDate, po.ShippingFee, po.TaxAmount,
                po.PaymentDate, po.PaymentAmount, po.PaymentMethod,
                po.Notes, po.AddedOn, po.ModifiedOn,
                new List<PurchaseOrderDetailDto>()))
            .ToListAsync(ct);

        return Ok(new PagedResult<PurchaseOrderDto>(items, total, page, pageSize));
    }
}
