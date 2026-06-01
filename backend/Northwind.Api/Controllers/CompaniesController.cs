using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Northwind.Api.Dtos;
using Northwind.Domain.Entities;
using Northwind.Infrastructure.Data;

namespace Northwind.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class CompaniesController(NorthwindDbContext db) : ControllerBase
{
    [HttpGet]
    public async Task<ActionResult<PagedResult<CompanyDto>>> GetAll(
        [FromQuery] string? search,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 25,
        CancellationToken ct = default)
    {
        var query = db.Companies
            .Include(c => c.CompanyType)
            .AsNoTracking();

        if (!string.IsNullOrWhiteSpace(search))
            query = query.Where(c => c.CompanyName!.Contains(search) || c.City!.Contains(search));

        var total = await query.CountAsync(ct);
        var items = await query
            .OrderBy(c => c.CompanyName)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .Select(c => ToDto(c))
            .ToListAsync(ct);

        return Ok(new PagedResult<CompanyDto>(items, total, page, pageSize));
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<CompanyDto>> GetById(int id, CancellationToken ct)
    {
        var company = await db.Companies
            .Include(c => c.CompanyType)
            .Include(c => c.Contacts)
            .AsNoTracking()
            .FirstOrDefaultAsync(c => c.CompanyId == id, ct);

        return company is null ? NotFound() : Ok(ToDto(company));
    }

    [HttpPost]
    public async Task<ActionResult<CompanyDto>> Create(
        [FromBody] CreateCompanyRequest req,
        CancellationToken ct)
    {
        var company = new Company
        {
            CompanyName = req.CompanyName,
            CompanyTypeId = req.CompanyTypeId,
            BusinessPhone = req.BusinessPhone,
            Address = req.Address,
            City = req.City,
            StateAbbrev = req.StateAbbrev,
            Zip = req.Zip,
            Website = req.Website,
            Notes = req.Notes,
            AddedBy = User.Identity?.Name,
            AddedOn = DateTime.UtcNow,
        };
        db.Companies.Add(company);
        await db.SaveChangesAsync(ct);
        return CreatedAtAction(nameof(GetById), new { id = company.CompanyId }, ToDto(company));
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] UpdateCompanyRequest req, CancellationToken ct)
    {
        var company = await db.Companies.FindAsync([id], ct);
        if (company is null) return NotFound();

        company.CompanyName = req.CompanyName;
        company.CompanyTypeId = req.CompanyTypeId;
        company.BusinessPhone = req.BusinessPhone;
        company.Address = req.Address;
        company.City = req.City;
        company.StateAbbrev = req.StateAbbrev;
        company.Zip = req.Zip;
        company.Website = req.Website;
        company.Notes = req.Notes;
        company.ModifiedBy = User.Identity?.Name;
        company.ModifiedOn = DateTime.UtcNow;

        await db.SaveChangesAsync(ct);
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id, CancellationToken ct)
    {
        var company = await db.Companies.FindAsync([id], ct);
        if (company is null) return NotFound();
        db.Companies.Remove(company);
        await db.SaveChangesAsync(ct);
        return NoContent();
    }

    [HttpGet("types")]
    public async Task<ActionResult<IReadOnlyList<CompanyTypeLookupDto>>> GetTypes(CancellationToken ct)
    {
        var types = await db.CompanyTypes
            .AsNoTracking()
            .OrderBy(t => t.CompanyType1)
            .Select(t => new CompanyTypeLookupDto(t.CompanyTypeId, t.CompanyType1))
            .ToListAsync(ct);
        return Ok(types);
    }

    [HttpGet("lookup")]
    public async Task<ActionResult<IReadOnlyList<CompanyLookupDto>>> GetLookup(
        [FromQuery] int? companyTypeId,
        CancellationToken ct = default)
    {
        var query = db.Companies.AsNoTracking();

        if (companyTypeId is not null)
            query = query.Where(c => c.CompanyTypeId == companyTypeId);

        var companies = await query
            .OrderBy(c => c.CompanyName)
            .Select(c => new CompanyLookupDto(c.CompanyId, c.CompanyName))
            .ToListAsync(ct);
        return Ok(companies);
    }

    private static CompanyDto ToDto(Company c) => new(
        c.CompanyId,
        c.CompanyName,
        c.CompanyTypeId,
        c.CompanyType?.CompanyType1,
        c.BusinessPhone,
        c.Address,
        c.City,
        c.StateAbbrev,
        c.Zip,
        c.Website,
        c.Notes,
        c.AddedOn,
        c.ModifiedOn
    );

    // ── Orders by company (as shipper) ────────────────────────────────────────

    [HttpGet("{companyId:int}/shipper-orders")]
    public async Task<ActionResult<PagedResult<OrderDto>>> GetShipperOrders(
        int companyId, int page = 1, int pageSize = 25, CancellationToken ct = default)
    {
        var q = db.Orders
            .Include(o => o.Customer)
            .Include(o => o.Employee)
            .Include(o => o.OrderDetails)
            .Where(o => o.ShipperId == companyId);

        var total = await q.CountAsync(ct);
        var items = await q
            .OrderByDescending(o => o.OrderDate)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync(ct);

        return Ok(new PagedResult<OrderDto>(
            items.Select(o => new OrderDto(
                o.OrderId,
                o.CustomerId,
                o.Customer?.CompanyName,
                o.EmployeeId,
                o.Employee == null ? null : $"{o.Employee.FirstName} {o.Employee.LastName}".Trim(),
                o.OrderStatusId,
                o.OrderDate,
                o.ShippedDate,
                o.ShippingFee,
                null,
                o.Notes,
                []
            )).ToList(),
            total, page, pageSize));
    }

    // ── Purchase Orders by company (as vendor) ────────────────────────────────

    [HttpGet("{companyId:int}/purchase-orders")]
    public async Task<ActionResult<PagedResult<PurchaseOrderDto>>> GetVendorPurchaseOrders(
        int companyId, int page = 1, int pageSize = 25, CancellationToken ct = default)
    {
        var q = db.PurchaseOrders
            .Include(po => po.SubmittedBy)
            .Include(po => po.Status)
            .Include(po => po.PurchaseOrderDetails).ThenInclude(d => d.Product)
            .Where(po => po.VendorId == companyId);

        var total = await q.CountAsync(ct);
        var items = await q
            .OrderByDescending(po => po.SubmittedDate)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync(ct);

        return Ok(new PagedResult<PurchaseOrderDto>(
            items.Select(po => new PurchaseOrderDto(
                po.PurchaseOrderId,
                po.VendorId,
                null,
                po.SubmittedById,
                po.SubmittedBy == null ? null : $"{po.SubmittedBy.FirstName} {po.SubmittedBy.LastName}".Trim(),
                po.SubmittedDate,
                po.ApprovedById,
                null,
                po.ApprovedDate,
                po.StatusId,
                po.Status?.StatusName,
                po.ReceivedDate,
                po.ShippingFee,
                po.TaxAmount,
                po.PaymentDate,
                po.PaymentAmount,
                po.PaymentMethod,
                po.Notes,
                po.AddedOn,
                po.ModifiedOn,
                po.PurchaseOrderDetails.Select(d => new PurchaseOrderDetailDto(
                    d.PurchaseOrderDetailId, d.ProductId, d.Product?.ProductName,
                    d.Quantity, d.UnitCost, d.ReceivedDate)).ToList()
            )).ToList(),
            total, page, pageSize));
    }
}
