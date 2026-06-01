using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Northwind.Api.Dtos;
using Northwind.Domain.Entities;
using Northwind.Infrastructure.Data;
using Northwind.Infrastructure.Services;

namespace Northwind.Api.Controllers;

[ApiController]
[Route("api/purchase-orders")]
public class PurchaseOrdersController(NorthwindDbContext db, IPurchaseOrderWorkflowService workflow) : ControllerBase
{
    [HttpGet]
    public async Task<ActionResult<PagedResult<PurchaseOrderDto>>> GetAll(
        int? vendorId, int? statusId, int page = 1, int pageSize = 25,
        CancellationToken ct = default)
    {
        var q = db.PurchaseOrders
            .Include(po => po.Vendor)
            .Include(po => po.SubmittedBy)
            .Include(po => po.ApprovedBy)
            .Include(po => po.Status)
            .Include(po => po.PurchaseOrderDetails)
                .ThenInclude(d => d.Product)
            .AsQueryable();

        if (vendorId.HasValue) q = q.Where(po => po.VendorId == vendorId);
        if (statusId.HasValue) q = q.Where(po => po.StatusId == statusId);

        var total = await q.CountAsync(ct);
        var items = await q
            .OrderByDescending(po => po.SubmittedDate ?? po.AddedOn)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync(ct);

        return Ok(new PagedResult<PurchaseOrderDto>(
            items.Select(ToDto).ToList(), total, page, pageSize));
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<PurchaseOrderDto>> GetById(int id, CancellationToken ct)
    {
        var po = await db.PurchaseOrders
            .Include(po => po.Vendor)
            .Include(po => po.SubmittedBy)
            .Include(po => po.ApprovedBy)
            .Include(po => po.Status)
            .Include(po => po.PurchaseOrderDetails)
                .ThenInclude(d => d.Product)
            .FirstOrDefaultAsync(po => po.PurchaseOrderId == id, ct);

        return po is null ? NotFound() : Ok(ToDto(po));
    }

    [HttpPost]
    public async Task<ActionResult<PurchaseOrderDto>> Create(
        [FromBody] CreatePurchaseOrderRequest req, CancellationToken ct)
    {
        var po = new PurchaseOrder
        {
            VendorId = req.VendorId,
            SubmittedById = req.SubmittedById,
            SubmittedDate = req.SubmittedDate ?? DateTime.UtcNow,
            StatusId = req.StatusId ?? 3, // New
            Notes = req.Notes,
            AddedOn = DateTime.UtcNow,
            ModifiedOn = DateTime.UtcNow
        };

        foreach (var d in req.PurchaseOrderDetails ?? [])
        {
            po.PurchaseOrderDetails.Add(new PurchaseOrderDetail
            {
                ProductId = d.ProductId,
                Quantity = d.Quantity,
                UnitCost = d.UnitCost,
                AddedOn = DateTime.UtcNow
            });
        }

        db.PurchaseOrders.Add(po);
        await db.SaveChangesAsync(ct);

        await db.Entry(po).Reference(x => x.Vendor).LoadAsync(ct);
        await db.Entry(po).Reference(x => x.SubmittedBy).LoadAsync(ct);
        await db.Entry(po).Reference(x => x.Status).LoadAsync(ct);

        return CreatedAtAction(nameof(GetById), new { id = po.PurchaseOrderId }, ToDto(po));
    }

    [HttpPut("{id:int}")]
    public async Task<ActionResult<PurchaseOrderDto>> Update(
        int id, [FromBody] UpdatePurchaseOrderRequest req, CancellationToken ct)
    {
        var po = await db.PurchaseOrders
            .Include(po => po.Vendor)
            .Include(po => po.SubmittedBy)
            .Include(po => po.ApprovedBy)
            .Include(po => po.Status)
            .Include(po => po.PurchaseOrderDetails).ThenInclude(d => d.Product)
            .FirstOrDefaultAsync(po => po.PurchaseOrderId == id, ct);

        if (po is null) return NotFound();

        po.VendorId = req.VendorId;
        po.SubmittedById = req.SubmittedById;
        po.SubmittedDate = req.SubmittedDate;
        po.ApprovedById = req.ApprovedById;
        po.ApprovedDate = req.ApprovedDate;
        po.StatusId = req.StatusId;
        po.ReceivedDate = req.ReceivedDate;
        po.ShippingFee = req.ShippingFee;
        po.TaxAmount = req.TaxAmount;
        po.PaymentDate = req.PaymentDate;
        po.PaymentAmount = req.PaymentAmount;
        po.PaymentMethod = req.PaymentMethod;
        po.Notes = req.Notes;
        po.ModifiedOn = DateTime.UtcNow;

        await db.SaveChangesAsync(ct);
        return Ok(ToDto(po));
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id, CancellationToken ct)
    {
        // Guard (New/Submitted only) handled by the workflow service.
        await workflow.DeleteAsync(id, ct);
        return NoContent();
    }

    // ── Workflow transitions (ported from frmPurchaseOrderDetails) ───────────

    [HttpPost("{id:int}/submit")]
    public async Task<IActionResult> Submit(int id, CancellationToken ct)
    {
        await workflow.SubmitAsync(id, ct);
        return NoContent();
    }

    [HttpPost("{id:int}/approve")]
    public async Task<IActionResult> Approve(int id, CancellationToken ct)
    {
        await workflow.ApproveAsync(id, ct);
        return NoContent();
    }

    [HttpPost("{id:int}/receive")]
    public async Task<IActionResult> Receive(int id, CancellationToken ct)
    {
        await workflow.ReceiveAsync(id, ct);
        return NoContent();
    }

    [HttpPost("{id:int}/close")]
    public async Task<IActionResult> Close(int id, [FromBody] ClosePurchaseOrderRequest? req, CancellationToken ct)
    {
        await workflow.CloseAsync(id, new ClosePurchaseOrderArgs(req?.ShippingFee, req?.PaymentMethod), ct);
        return NoContent();
    }

    // ── Line Items ────────────────────────────────────────────────────────────

    [HttpGet("{purchaseOrderId:int}/details")]
    public async Task<ActionResult<IReadOnlyList<PurchaseOrderDetailDto>>> GetDetails(
        int purchaseOrderId, CancellationToken ct)
    {
        var details = await db.PurchaseOrderDetails
            .Include(d => d.Product)
            .Where(d => d.PurchaseOrderId == purchaseOrderId)
            .ToListAsync(ct);

        return Ok(details.Select(ToDetailDto).ToList());
    }

    [HttpPost("{purchaseOrderId:int}/details")]
    public async Task<ActionResult<PurchaseOrderDetailDto>> AddDetail(
        int purchaseOrderId, [FromBody] CreatePurchaseOrderDetailRequest req, CancellationToken ct)
    {
        var exists = await db.PurchaseOrders.AnyAsync(po => po.PurchaseOrderId == purchaseOrderId, ct);
        if (!exists) return NotFound();

        var detail = new PurchaseOrderDetail
        {
            PurchaseOrderId = purchaseOrderId,
            ProductId = req.ProductId,
            Quantity = req.Quantity,
            UnitCost = req.UnitCost,
            AddedOn = DateTime.UtcNow
        };

        db.PurchaseOrderDetails.Add(detail);
        await db.SaveChangesAsync(ct);
        await db.Entry(detail).Reference(d => d.Product).LoadAsync(ct);

        return CreatedAtAction(nameof(GetDetails),
            new { purchaseOrderId }, ToDetailDto(detail));
    }

    [HttpDelete("{purchaseOrderId:int}/details/{detailId:int}")]
    public async Task<IActionResult> DeleteDetail(
        int purchaseOrderId, int detailId, CancellationToken ct)
    {
        var detail = await db.PurchaseOrderDetails
            .FirstOrDefaultAsync(d => d.PurchaseOrderDetailId == detailId
                && d.PurchaseOrderId == purchaseOrderId, ct);

        if (detail is null) return NotFound();

        db.PurchaseOrderDetails.Remove(detail);
        await db.SaveChangesAsync(ct);
        return NoContent();
    }

    // ── Mapping ───────────────────────────────────────────────────────────────

    private static PurchaseOrderDto ToDto(PurchaseOrder po) => new(
        po.PurchaseOrderId,
        po.VendorId,
        po.Vendor?.CompanyName,
        po.SubmittedById,
        po.SubmittedBy is null ? null : $"{po.SubmittedBy.FirstName} {po.SubmittedBy.LastName}".Trim(),
        po.SubmittedDate,
        po.ApprovedById,
        po.ApprovedBy is null ? null : $"{po.ApprovedBy.FirstName} {po.ApprovedBy.LastName}".Trim(),
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
        po.PurchaseOrderDetails.Select(ToDetailDto).ToList()
    );

    private static PurchaseOrderDetailDto ToDetailDto(PurchaseOrderDetail d) => new(
        d.PurchaseOrderDetailId,
        d.ProductId,
        d.Product?.ProductName,
        d.Quantity,
        d.UnitCost,
        d.ReceivedDate
    );
}
