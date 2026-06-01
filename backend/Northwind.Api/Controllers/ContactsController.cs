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
public class ContactsController(NorthwindDbContext db) : ControllerBase
{
    [HttpGet]
    public async Task<ActionResult<PagedResult<ContactDto>>> GetAll(
        [FromQuery] string? search,
        [FromQuery] int? companyId,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 25,
        CancellationToken ct = default)
    {
        var query = db.Contacts
            .Include(c => c.Company)
            .AsNoTracking();

        if (!string.IsNullOrWhiteSpace(search))
            query = query.Where(c =>
                c.FirstName!.Contains(search) ||
                c.LastName!.Contains(search) ||
                c.EmailAddress!.Contains(search));

        if (companyId.HasValue)
            query = query.Where(c => c.CompanyId == companyId);

        var total = await query.CountAsync(ct);
        var items = await query
            .OrderBy(c => c.LastName).ThenBy(c => c.FirstName)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .Select(c => ToDto(c))
            .ToListAsync(ct);

        return Ok(new PagedResult<ContactDto>(items, total, page, pageSize));
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<ContactDto>> GetById(int id, CancellationToken ct)
    {
        var contact = await db.Contacts
            .Include(c => c.Company)
            .AsNoTracking()
            .FirstOrDefaultAsync(c => c.ContactId == id, ct);

        return contact is null ? NotFound() : Ok(ToDto(contact));
    }

    [HttpPost]
    public async Task<ActionResult<ContactDto>> Create([FromBody] CreateContactRequest req, CancellationToken ct)
    {
        var contact = new Contact
        {
            CompanyId = req.CompanyId,
            FirstName = req.FirstName,
            LastName = req.LastName,
            EmailAddress = req.EmailAddress,
            JobTitle = req.JobTitle,
            PrimaryPhone = req.PrimaryPhone,
            SecondaryPhone = req.SecondaryPhone,
            Notes = req.Notes,
            AddedBy = User.Identity?.Name,
            AddedOn = DateTime.UtcNow,
        };
        db.Contacts.Add(contact);
        await db.SaveChangesAsync(ct);
        return CreatedAtAction(nameof(GetById), new { id = contact.ContactId }, ToDto(contact));
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] UpdateContactRequest req, CancellationToken ct)
    {
        var contact = await db.Contacts.FindAsync([id], ct);
        if (contact is null) return NotFound();

        contact.CompanyId = req.CompanyId;
        contact.FirstName = req.FirstName;
        contact.LastName = req.LastName;
        contact.EmailAddress = req.EmailAddress;
        contact.JobTitle = req.JobTitle;
        contact.PrimaryPhone = req.PrimaryPhone;
        contact.SecondaryPhone = req.SecondaryPhone;
        contact.Notes = req.Notes;
        contact.ModifiedBy = User.Identity?.Name;
        contact.ModifiedOn = DateTime.UtcNow;

        await db.SaveChangesAsync(ct);
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id, CancellationToken ct)
    {
        var contact = await db.Contacts.FindAsync([id], ct);
        if (contact is null) return NotFound();
        db.Contacts.Remove(contact);
        await db.SaveChangesAsync(ct);
        return NoContent();
    }

    private static ContactDto ToDto(Contact c) => new(
        c.ContactId,
        c.CompanyId,
        c.Company?.CompanyName,
        c.FirstName,
        c.LastName,
        c.EmailAddress,
        c.JobTitle,
        c.PrimaryPhone,
        c.SecondaryPhone,
        c.Notes
    );
}
