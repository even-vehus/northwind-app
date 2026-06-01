using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Northwind.Api.Dtos;
using Northwind.Domain.Entities;
using Northwind.Domain.Enums;
using Northwind.Infrastructure.Data;
using Northwind.Infrastructure.Services;

namespace Northwind.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class OrdersController(NorthwindDbContext db, IOrderWorkflowService workflow) : ControllerBase
{
    [HttpGet]
    public async Task<ActionResult<PagedResult<OrderDto>>> GetAll(
        [FromQuery] int? customerId,
        [FromQuery] int? employeeId,
        [FromQuery] int? statusId,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 25,
        CancellationToken ct = default)
    {
        var query = db.Orders
            .Include(o => o.Customer)
            .Include(o => o.Employee)
            .AsNoTracking();

        if (customerId.HasValue) query = query.Where(o => o.CustomerId == customerId);
        if (employeeId.HasValue) query = query.Where(o => o.EmployeeId == employeeId);
        if (statusId.HasValue) query = query.Where(o => o.OrderStatusId == statusId);

        var total = await query.CountAsync(ct);
        var items = await query
            .OrderByDescending(o => o.OrderDate)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .Select(o => ToSummaryDto(o))
            .ToListAsync(ct);

        return Ok(new PagedResult<OrderDto>(items, total, page, pageSize));
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<OrderDto>> GetById(int id, CancellationToken ct)
    {
        var order = await db.Orders
            .Include(o => o.Customer)
            .Include(o => o.Employee)
            .Include(o => o.OrderDetails)
                .ThenInclude(od => od.Product)
            .AsNoTracking()
            .FirstOrDefaultAsync(o => o.OrderId == id, ct);

        return order is null ? NotFound() : Ok(ToDetailDto(order));
    }

    [HttpPost]
    public async Task<ActionResult<OrderDto>> Create([FromBody] CreateOrderRequest req, CancellationToken ct)
    {
        var order = new Order
        {
            CustomerId = req.CustomerId,
            EmployeeId = req.EmployeeId,
            OrderDate = req.OrderDate ?? DateTime.UtcNow,
            Notes = req.Notes,
            OrderStatusId = (int)OrderStatusId.New,
            AddedBy = User.Identity?.Name,
            AddedOn = DateTime.UtcNow,
        };

        // Default tax status from the customer (frmOrderDetails.CustomerID_AfterUpdate).
        if (req.CustomerId is not null)
        {
            order.TaxStatusId = await db.Companies
                .Where(c => c.CompanyId == req.CustomerId)
                .Select(c => c.StandardTaxStatusId)
                .FirstOrDefaultAsync(ct);
        }

        foreach (var detail in req.OrderDetails ?? [])
        {
            order.OrderDetails.Add(new OrderDetail
            {
                ProductId = detail.ProductId,
                UnitPrice = detail.UnitPrice,
                Quantity = detail.Quantity,
                Discount = detail.Discount,
                AddedBy = User.Identity?.Name,
                AddedOn = DateTime.UtcNow,
            });
        }

        db.Orders.Add(order);
        await db.SaveChangesAsync(ct);
        return CreatedAtAction(nameof(GetById), new { id = order.OrderId }, ToSummaryDto(order));
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] UpdateOrderRequest req, CancellationToken ct)
    {
        var order = await db.Orders.FindAsync([id], ct);
        if (order is null) return NotFound();

        order.CustomerId = req.CustomerId;
        order.EmployeeId = req.EmployeeId;
        order.OrderStatusId = req.OrderStatusId;
        order.OrderDate = req.OrderDate;
        order.ShippedDate = req.ShippedDate;
        order.ShippingFee = req.ShippingFee;
        order.Notes = req.Notes;
        order.ModifiedBy = User.Identity?.Name;
        order.ModifiedOn = DateTime.UtcNow;

        await db.SaveChangesAsync(ct);
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id, CancellationToken ct)
    {
        // Guard (New/Invoiced only) + inventory re-allocation handled by the workflow service.
        await workflow.DeleteAsync(id, ct);
        return NoContent();
    }

    // ── Workflow transitions (ported from frmOrderDetails) ───────────────────

    [HttpPost("{id:int}/invoice")]
    public async Task<IActionResult> Invoice(int id, CancellationToken ct)
    {
        await workflow.InvoiceAsync(id, ct);
        return NoContent();
    }

    [HttpPost("{id:int}/ship")]
    public async Task<IActionResult> Ship(int id, [FromBody] ShipOrderRequest? req, CancellationToken ct)
    {
        await workflow.ShipAsync(id, new ShipOrderArgs(req?.ShippedDate, req?.ShipperId, req?.ShippingFee), ct);
        return NoContent();
    }

    [HttpPost("{id:int}/pay")]
    public async Task<IActionResult> Pay(int id, [FromBody] PayOrderRequest? req, CancellationToken ct)
    {
        await workflow.PayAsync(id, new PayOrderArgs(req?.PaymentMethod, req?.PaidDate), ct);
        return NoContent();
    }

    [HttpPost("{id:int}/close")]
    public async Task<IActionResult> Close(int id, CancellationToken ct)
    {
        await workflow.CloseAsync(id, ct);
        return NoContent();
    }

    // ── OrderDetails sub-resource ────────────────────────────────────────────

    [HttpGet("{orderId:int}/details")]
    public async Task<ActionResult<IReadOnlyList<OrderDetailDto>>> GetDetails(int orderId, CancellationToken ct)
    {
        var details = await db.OrderDetails
            .Include(od => od.Product)
            .AsNoTracking()
            .Where(od => od.OrderId == orderId)
            .Select(od => ToDetailItemDto(od))
            .ToListAsync(ct);

        return Ok(details);
    }

    [HttpPost("{orderId:int}/details")]
    public async Task<ActionResult<OrderDetailDto>> AddDetail(
        int orderId,
        [FromBody] CreateOrderDetailRequest req,
        CancellationToken ct)
    {
        var orderExists = await db.Orders.AnyAsync(o => o.OrderId == orderId, ct);
        if (!orderExists) return NotFound();

        var detail = new OrderDetail
        {
            OrderId = orderId,
            ProductId = req.ProductId,
            UnitPrice = req.UnitPrice,
            Quantity = req.Quantity,
            Discount = req.Discount,
            AddedBy = User.Identity?.Name,
            AddedOn = DateTime.UtcNow,
        };

        db.OrderDetails.Add(detail);
        await db.SaveChangesAsync(ct);
        return CreatedAtAction(nameof(GetDetails), new { orderId }, ToDetailItemDto(detail));
    }

    [HttpDelete("{orderId:int}/details/{detailId:int}")]
    public async Task<IActionResult> RemoveDetail(int orderId, int detailId, CancellationToken ct)
    {
        var detail = await db.OrderDetails
            .FirstOrDefaultAsync(od => od.OrderDetailId == detailId && od.OrderId == orderId, ct);

        if (detail is null) return NotFound();
        db.OrderDetails.Remove(detail);
        await db.SaveChangesAsync(ct);
        return NoContent();
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

    private static OrderDto ToSummaryDto(Order o) => new(
        o.OrderId,
        o.CustomerId,
        o.Customer?.CompanyName,
        o.EmployeeId,
        o.Employee is null ? null : $"{o.Employee.FirstName} {o.Employee.LastName}",
        o.OrderStatusId,
        o.OrderDate,
        o.ShippedDate,
        o.ShippingFee,
        null, // Taxes column not present in this DB
        o.Notes,
        []
    );

    private static OrderDto ToDetailDto(Order o) => new(
        o.OrderId,
        o.CustomerId,
        o.Customer?.CompanyName,
        o.EmployeeId,
        o.Employee is null ? null : $"{o.Employee.FirstName} {o.Employee.LastName}",
        o.OrderStatusId,
        o.OrderDate,
        o.ShippedDate,
        o.ShippingFee,
        null, // Taxes column not present in this DB
        o.Notes,
        o.OrderDetails.Select(ToDetailItemDto).ToList()
    );

    private static OrderDetailDto ToDetailItemDto(OrderDetail od) => new(
        od.OrderDetailId,
        od.ProductId,
        od.Product?.ProductName,
        od.UnitPrice,
        od.Quantity,
        od.Discount
    );
}
