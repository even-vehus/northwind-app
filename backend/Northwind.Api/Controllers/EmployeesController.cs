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
public class EmployeesController(NorthwindDbContext db) : ControllerBase
{
    [HttpGet]
    public async Task<ActionResult<PagedResult<EmployeeDto>>> GetAll(
        [FromQuery] string? search,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 25,
        CancellationToken ct = default)
    {
        var query = db.Employees.AsNoTracking();

        if (!string.IsNullOrWhiteSpace(search))
            query = query.Where(e =>
                e.FirstName!.Contains(search) ||
                e.LastName!.Contains(search) ||
                e.EmailAddress!.Contains(search));

        var total = await query.CountAsync(ct);
        var items = await query
            .OrderBy(e => e.LastName).ThenBy(e => e.FirstName)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .Select(e => ToDto(e))
            .ToListAsync(ct);

        return Ok(new PagedResult<EmployeeDto>(items, total, page, pageSize));
    }

    [HttpGet("lookup")]
    public async Task<ActionResult<IReadOnlyList<EmployeeLookupDto>>> GetLookup(CancellationToken ct)
    {
        var employees = await db.Employees
            .AsNoTracking()
            .OrderBy(e => e.LastName).ThenBy(e => e.FirstName)
            .Select(e => new EmployeeLookupDto(
                e.EmployeeId,
                (e.FirstName + " " + e.LastName).Trim()))
            .ToListAsync(ct);
        return Ok(employees);
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<EmployeeDto>> GetById(int id, CancellationToken ct)
    {
        var employee = await db.Employees
            .AsNoTracking()
            .FirstOrDefaultAsync(e => e.EmployeeId == id, ct);

        return employee is null ? NotFound() : Ok(ToDto(employee));
    }

    [HttpPost]
    public async Task<ActionResult<EmployeeDto>> Create([FromBody] CreateEmployeeRequest req, CancellationToken ct)
    {
        var employee = new Employee
        {
            FirstName = req.FirstName,
            LastName = req.LastName,
            EmailAddress = req.EmailAddress,
            JobTitle = req.JobTitle,
            PrimaryPhone = req.PrimaryPhone,
            SecondaryPhone = req.SecondaryPhone,
            Title = req.Title,
            Notes = req.Notes,
            SupervisorId = req.SupervisorId,
            WindowsUserName = req.WindowsUserName,
            AddedBy = User.Identity?.Name,
            AddedOn = DateTime.UtcNow,
        };
        db.Employees.Add(employee);
        await db.SaveChangesAsync(ct);
        return CreatedAtAction(nameof(GetById), new { id = employee.EmployeeId }, ToDto(employee));
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] UpdateEmployeeRequest req, CancellationToken ct)
    {
        var employee = await db.Employees.FindAsync([id], ct);
        if (employee is null) return NotFound();

        employee.FirstName = req.FirstName;
        employee.LastName = req.LastName;
        employee.EmailAddress = req.EmailAddress;
        employee.JobTitle = req.JobTitle;
        employee.PrimaryPhone = req.PrimaryPhone;
        employee.SecondaryPhone = req.SecondaryPhone;
        employee.Title = req.Title;
        employee.Notes = req.Notes;
        employee.SupervisorId = req.SupervisorId;
        employee.WindowsUserName = req.WindowsUserName;
        employee.ModifiedBy = User.Identity?.Name;
        employee.ModifiedOn = DateTime.UtcNow;

        await db.SaveChangesAsync(ct);
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id, CancellationToken ct)
    {
        var employee = await db.Employees.FindAsync([id], ct);
        if (employee is null) return NotFound();
        db.Employees.Remove(employee);
        await db.SaveChangesAsync(ct);
        return NoContent();
    }

    private static EmployeeDto ToDto(Employee e) => new(
        e.EmployeeId,
        e.FirstName,
        e.LastName,
        $"{e.FirstName} {e.LastName}".Trim(),
        e.EmailAddress,
        e.JobTitle,
        e.PrimaryPhone,
        e.SecondaryPhone,
        e.Title,
        e.Notes,
        e.SupervisorId,
        e.SupervisorId.HasValue ? null : null, // resolved by eager-load when needed
        e.WindowsUserName,
        e.AddedOn,
        e.ModifiedOn
    );

    // ── Privileges sub-resource ───────────────────────────────────────────────

    [HttpGet("{employeeId:int}/privileges")]
    public async Task<ActionResult<IReadOnlyList<EmployeePrivilegeDto>>> GetPrivileges(
        int employeeId, CancellationToken ct)
    {
        var privs = await db.EmployeePrivileges
            .Include(ep => ep.Privilege)
            .Where(ep => ep.EmployeeId == employeeId)
            .AsNoTracking()
            .ToListAsync(ct);
        return Ok(privs.Select(ep => new EmployeePrivilegeDto(
            ep.EmployeePrivilegeId, ep.EmployeeId, ep.PrivilegeId,
            ep.Privilege?.PrivilegeName)).ToList());
    }

    [HttpPost("{employeeId:int}/privileges")]
    public async Task<IActionResult> AddPrivilege(
        int employeeId, [FromBody] int privilegeId, CancellationToken ct)
    {
        var exists = await db.Employees.AnyAsync(e => e.EmployeeId == employeeId, ct);
        if (!exists) return NotFound();
        var already = await db.EmployeePrivileges
            .AnyAsync(ep => ep.EmployeeId == employeeId && ep.PrivilegeId == privilegeId, ct);
        if (already) return Conflict("Employee already has this privilege.");
        db.EmployeePrivileges.Add(new EmployeePrivilege
        {
            EmployeeId = employeeId,
            PrivilegeId = privilegeId,
            AddedOn = DateTime.UtcNow
        });
        await db.SaveChangesAsync(ct);
        return NoContent();
    }

    [HttpDelete("{employeeId:int}/privileges/{privilegeId:int}")]
    public async Task<IActionResult> RemovePrivilege(
        int employeeId, int privilegeId, CancellationToken ct)
    {
        var ep = await db.EmployeePrivileges
            .FirstOrDefaultAsync(x => x.EmployeeId == employeeId
                && x.EmployeePrivilegeId == privilegeId, ct);
        if (ep is null) return NotFound();
        db.EmployeePrivileges.Remove(ep);
        await db.SaveChangesAsync(ct);
        return NoContent();
    }

    // ── Recent Orders sub-resource ────────────────────────────────────────────

    [HttpGet("{employeeId:int}/orders")]
    public async Task<ActionResult<PagedResult<OrderDto>>> GetOrders(
        int employeeId,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 10,
        CancellationToken ct = default)
    {
        var query = db.Orders
            .Include(o => o.Customer)
            .Where(o => o.EmployeeId == employeeId)
            .AsNoTracking();

        var total = await query.CountAsync(ct);
        var items = await query
            .OrderByDescending(o => o.OrderDate)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .Select(o => new OrderDto(
                o.OrderId, o.CustomerId,
                o.Customer != null ? o.Customer.CompanyName : null,
                o.EmployeeId, null,
                o.OrderStatusId, o.OrderDate, o.ShippedDate, o.ShippingFee, null, o.Notes,
                new List<OrderDetailDto>()))
            .ToListAsync(ct);

        return Ok(new PagedResult<OrderDto>(items, total, page, pageSize));
    }
}
