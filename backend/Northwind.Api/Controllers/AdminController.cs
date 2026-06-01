using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Northwind.Api.Dtos;
using Northwind.Infrastructure.Data;

namespace Northwind.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AdminController(NorthwindDbContext db) : ControllerBase
{
    // ── System Settings ───────────────────────────────────────────────────────

    [HttpGet("settings")]
    public async Task<ActionResult<IReadOnlyList<SystemSettingDto>>> GetSettings(CancellationToken ct)
    {
        var settings = await db.SystemSettings
            .AsNoTracking()
            .OrderBy(s => s.SettingName)
            .Select(s => new SystemSettingDto(s.SettingId, s.SettingName, s.SettingValue, s.Notes))
            .ToListAsync(ct);
        return Ok(settings);
    }

    [HttpPut("settings/{id:int}")]
    public async Task<IActionResult> UpdateSetting(
        int id, [FromBody] UpdateSystemSettingRequest req, CancellationToken ct)
    {
        var setting = await db.SystemSettings.FindAsync([id], ct);
        if (setting is null) return NotFound();
        setting.SettingValue = req.SettingValue;
        await db.SaveChangesAsync(ct);
        return NoContent();
    }

    // ── Lookup Endpoints ──────────────────────────────────────────────────────

    [HttpGet("order-statuses")]
    public async Task<ActionResult<IReadOnlyList<OrderStatusDto>>> GetOrderStatuses(CancellationToken ct)
    {
        var statuses = await db.OrderStatuses
            .AsNoTracking()
            .OrderBy(s => s.SortOrder ?? s.OrderStatusId)
            .Select(s => new OrderStatusDto(s.OrderStatusId, s.OrderStatusCode, s.OrderStatusName))
            .ToListAsync(ct);
        return Ok(statuses);
    }

    [HttpGet("order-detail-statuses")]
    public async Task<ActionResult<IReadOnlyList<OrderDetailStatusDto>>> GetOrderDetailStatuses(CancellationToken ct)
    {
        var statuses = await db.OrderDetailStatuses
            .AsNoTracking()
            .OrderBy(s => s.SortOrder ?? s.OrderDetailStatusId)
            .Select(s => new OrderDetailStatusDto(s.OrderDetailStatusId, s.OrderDetailStatusName))
            .ToListAsync(ct);
        return Ok(statuses);
    }

    [HttpGet("purchase-order-statuses")]
    public async Task<ActionResult<IReadOnlyList<PurchaseOrderStatusDto>>> GetPurchaseOrderStatuses(CancellationToken ct)
    {
        var statuses = await db.PurchaseOrderStatuses
            .AsNoTracking()
            .OrderBy(s => s.SortOrder ?? s.StatusId)
            .Select(s => new PurchaseOrderStatusDto(s.StatusId, s.StatusName))
            .ToListAsync(ct);
        return Ok(statuses);
    }

    [HttpGet("tax-statuses")]
    public async Task<ActionResult<IReadOnlyList<TaxStatusDto>>> GetTaxStatuses(CancellationToken ct)
    {
        var statuses = await db.TaxStatuses
            .AsNoTracking()
            .OrderBy(s => s.TaxStatusId)
            .Select(s => new TaxStatusDto(s.TaxStatusId, s.TaxStatusName))
            .ToListAsync(ct);
        return Ok(statuses);
    }

    [HttpGet("privileges")]
    public async Task<ActionResult<IReadOnlyList<PrivilegeDto>>> GetPrivileges(CancellationToken ct)
    {
        var privileges = await db.Privileges
            .AsNoTracking()
            .OrderBy(p => p.PrivilegeName)
            .Select(p => new PrivilegeDto(p.PrivilegeId, p.PrivilegeName))
            .ToListAsync(ct);
        return Ok(privileges);
    }
}
