using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Northwind.Api.Dtos;
using Northwind.Infrastructure.Data;

namespace Northwind.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ReportsController(NorthwindDbContext db) : ControllerBase
{
    // ── Sales by Employee ─────────────────────────────────────────────────────

    [HttpGet("sales-by-employee")]
    public async Task<ActionResult<IReadOnlyList<SalesByEmployeeRow>>> GetSalesByEmployee(
        [FromQuery] int? year, CancellationToken ct)
    {
        var query = db.OrderDetails
            .AsNoTracking()
            .Where(d => d.Order != null)
            .Where(d => year == null || (d.Order!.OrderDate != null && d.Order.OrderDate!.Value.Year == year));

        var rows = await query
            .GroupBy(d => new
            {
                d.Order!.EmployeeId,
                FirstName = d.Order.Employee != null ? d.Order.Employee.FirstName : null,
                LastName = d.Order.Employee != null ? d.Order.Employee.LastName : null,
            })
            .Select(g => new SalesByEmployeeRow(
                g.Key.EmployeeId,
                (g.Key.FirstName + " " + g.Key.LastName).Trim(),
                g.Count(),
                g.Sum(d => d.UnitPrice * d.Quantity * (decimal)(1.0 - (d.Discount ?? 0)))
            ))
            .OrderByDescending(r => r.Revenue)
            .ToListAsync(ct);

        return Ok(rows);
    }

    // ── Sales by Product ──────────────────────────────────────────────────────

    [HttpGet("sales-by-product")]
    public async Task<ActionResult<IReadOnlyList<SalesByProductRow>>> GetSalesByProduct(
        [FromQuery] int? year, CancellationToken ct)
    {
        var query = db.OrderDetails
            .AsNoTracking()
            .Where(d => d.Order != null)
            .Where(d => year == null || (d.Order!.OrderDate != null && d.Order.OrderDate!.Value.Year == year));

        var rows = await query
            .GroupBy(d => new
            {
                d.ProductId,
                ProductName = d.Product != null ? d.Product.ProductName : null,
                CategoryName = d.Product != null && d.Product.ProductCategory != null
                    ? d.Product.ProductCategory.CategoryName : null,
            })
            .Select(g => new SalesByProductRow(
                g.Key.ProductId,
                g.Key.ProductName,
                g.Key.CategoryName,
                g.Sum(d => d.Quantity),
                g.Sum(d => d.UnitPrice * d.Quantity * (decimal)(1.0 - (d.Discount ?? 0)))
            ))
            .OrderByDescending(r => r.Revenue)
            .ToListAsync(ct);

        return Ok(rows);
    }

    // ── Sales by Product (Quarterly) ──────────────────────────────────────────

    [HttpGet("sales-by-product-quarterly")]
    public async Task<ActionResult<IReadOnlyList<SalesByProductQuarterlyRow>>> GetSalesByProductQuarterly(
        [FromQuery] int? year, CancellationToken ct)
    {
        var targetYear = year ?? DateTime.UtcNow.Year;

        var rows = await db.OrderDetails
            .AsNoTracking()
            .Where(d => d.Order != null
                && d.Order.OrderDate != null
                && d.Order.OrderDate.Value.Year == targetYear)
            .Select(d => new
            {
                d.ProductId,
                ProductName = d.Product != null ? d.Product.ProductName : null,
                Quarter = (d.Order!.OrderDate!.Value.Month - 1) / 3 + 1,
                Revenue = d.UnitPrice * d.Quantity * (decimal)(1.0 - (d.Discount ?? 0)),
            })
            .GroupBy(x => new { x.ProductId, x.ProductName, x.Quarter })
            .Select(g => new SalesByProductQuarterlyRow(
                g.Key.ProductId,
                g.Key.ProductName,
                g.Key.Quarter,
                g.Sum(x => x.Revenue)
            ))
            .OrderBy(r => r.ProductName)
            .ThenBy(r => r.Quarter)
            .ToListAsync(ct);

        return Ok(rows);
    }

    // ── Employee Directory ────────────────────────────────────────────────────

    [HttpGet("employee-directory")]
    public async Task<ActionResult<IReadOnlyList<EmployeeDirectoryRow>>> GetEmployeeDirectory(
        CancellationToken ct)
    {
        var rows = await db.Employees
            .AsNoTracking()
            .OrderBy(e => e.LastName).ThenBy(e => e.FirstName)
            .Select(e => new EmployeeDirectoryRow(
                e.EmployeeId,
                e.Title,
                e.FirstName,
                e.LastName,
                e.JobTitle,
                e.EmailAddress,
                e.PrimaryPhone,
                e.SecondaryPhone
            ))
            .ToListAsync(ct);

        return Ok(rows);
    }

    // ── Product Catalog ───────────────────────────────────────────────────────

    [HttpGet("product-catalog")]
    public async Task<ActionResult<IReadOnlyList<ProductCatalogRow>>> GetProductCatalog(
        CancellationToken ct)
    {
        var rows = await db.Products
            .AsNoTracking()
            .Where(p => p.Discontinued != true)
            .OrderBy(p => p.ProductCategory != null ? p.ProductCategory.CategoryName : null)
            .ThenBy(p => p.ProductName)
            .Select(p => new ProductCatalogRow(
                p.ProductId,
                p.ProductCode,
                p.ProductName,
                p.ProductCategory != null ? p.ProductCategory.CategoryName : null,
                p.Description,
                p.ListPrice,
                p.StandardCost
            ))
            .ToListAsync(ct);

        return Ok(rows);
    }

    // ── Customer List ─────────────────────────────────────────────────────────

    [HttpGet("customer-list")]
    public async Task<ActionResult<IReadOnlyList<CustomerListRow>>> GetCustomerList(
        CancellationToken ct)
    {
        var rows = await db.Companies
            .AsNoTracking()
            .Where(c => c.CompanyTypeId == 1) // Customer type
            .OrderBy(c => c.CompanyName)
            .Select(c => new CustomerListRow(
                c.CompanyId,
                c.CompanyName,
                c.BusinessPhone,
                c.Address,
                c.City,
                c.StateAbbrev,
                c.Zip,
                c.Website
            ))
            .ToListAsync(ct);

        return Ok(rows);
    }

    // ── Invoice ───────────────────────────────────────────────────────────────

    [HttpGet("invoice/{orderId:int}")]
    public async Task<ActionResult<InvoiceDto>> GetInvoice(int orderId, CancellationToken ct)
    {
        var order = await db.Orders
            .AsNoTracking()
            .Include(o => o.Customer)
            .Include(o => o.Employee)
            .Include(o => o.OrderDetails).ThenInclude(d => d.Product)
            .FirstOrDefaultAsync(o => o.OrderId == orderId, ct);

        if (order is null) return NotFound();

        var lines = order.OrderDetails.Select(d => new InvoiceLineDto(
            d.Product?.ProductName,
            d.Product?.ProductCode,
            d.Quantity,
            d.UnitPrice,
            d.Discount,
            d.UnitPrice * d.Quantity * (decimal?)(1.0 - (d.Discount ?? 0))
        )).ToList();

        var subtotal = lines.Sum(l => l.ExtendedPrice);

        return Ok(new InvoiceDto(
            order.OrderId,
            order.InvoiceDate ?? order.OrderDate,
            order.Customer?.CompanyName,
            order.Customer?.Address,
            order.Customer?.City,
            order.Customer?.StateAbbrev,
            order.Customer?.Zip,
            order.Employee != null
                ? ((order.Employee.FirstName + " " + order.Employee.LastName).Trim())
                : null,
            order.ShippingFee,
            order.TaxRate,
            subtotal,
            lines
        ));
    }

    // ── Purchase Order Form ──────────────────────────────────────────────────────────────────

    [HttpGet("purchase-order/{purchaseOrderId:int}")]
    public async Task<ActionResult<PurchaseOrderFormDto>> GetPurchaseOrderForm(
        int purchaseOrderId, CancellationToken ct)
    {
        var po = await db.PurchaseOrders
            .AsNoTracking()
            .Include(p => p.Vendor)
            .Include(p => p.SubmittedBy)
            .Include(p => p.ApprovedBy)
            .Include(p => p.Status)
            .Include(p => p.PurchaseOrderDetails).ThenInclude(d => d.Product)
            .FirstOrDefaultAsync(p => p.PurchaseOrderId == purchaseOrderId, ct);

        if (po is null) return NotFound();

        var lines = po.PurchaseOrderDetails.Select(d => new PurchaseOrderFormLineDto(
            d.Product?.ProductName,
            d.Product?.ProductCode,
            d.Quantity,
            d.UnitCost,
            d.Quantity * d.UnitCost,
            d.ReceivedDate
        )).ToList();

        var subtotal = lines.Sum(l => l.ExtendedCost);

        return Ok(new PurchaseOrderFormDto(
            po.PurchaseOrderId,
            po.SubmittedDate,
            po.ApprovedDate,
            po.ReceivedDate,
            po.Vendor?.CompanyName,
            po.Vendor?.Address,
            po.Vendor?.City,
            po.Vendor?.StateAbbrev,
            po.Vendor?.Zip,
            po.SubmittedBy != null
                ? (po.SubmittedBy.FirstName + " " + po.SubmittedBy.LastName).Trim()
                : null,
            po.ApprovedBy != null
                ? (po.ApprovedBy.FirstName + " " + po.ApprovedBy.LastName).Trim()
                : null,
            po.Status?.StatusName,
            po.ShippingFee,
            po.TaxAmount,
            po.PaymentMethod,
            subtotal,
            po.Notes,
            lines
        ));
    }
}
