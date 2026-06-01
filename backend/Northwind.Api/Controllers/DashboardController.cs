using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Northwind.Api.Dtos;
using Northwind.Domain.Enums;
using Northwind.Infrastructure.Data;

namespace Northwind.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class DashboardController(NorthwindDbContext db) : ControllerBase
{
    [HttpGet("summary")]
    public async Task<ActionResult<DashboardSummaryDto>> GetSummary(CancellationToken ct)
    {
        var totalOrders = await db.Orders.CountAsync(ct);
        var totalCompanies = await db.Companies.CountAsync(ct);
        var totalProducts = await db.Products.CountAsync(ct);
        var openPurchaseOrders = await db.PurchaseOrders
            .CountAsync(po => po.StatusId != (int)PurchaseOrderStatusId.Closed, ct);

        // Distinct products with order lines that aren't yet fulfillable (No Stock / On Order).
        var productsAwaitingStock = await db.OrderDetails
            .Where(d => d.StatusId == (int)OrderDetailStatusId.NoStock
                     || d.StatusId == (int)OrderDetailStatusId.OnOrder)
            .Select(d => d.ProductId)
            .Distinct()
            .CountAsync(ct);

        // Invoiced sales: extended price over all invoiced order lines (small data set → compute in memory).
        var salesLines = await db.OrderDetails
            .Where(d => d.Order!.InvoiceDate != null)
            .Select(d => new { d.UnitPrice, d.Quantity, d.Discount })
            .ToListAsync(ct);
        var invoicedSales = salesLines.Sum(l =>
            (l.UnitPrice ?? 0) * (l.Quantity ?? 0) * (decimal)(1 - (l.Discount ?? 0)));

        // Order pipeline: counts per status, in the canonical sort order.
        var statuses = await db.OrderStatuses.AsNoTracking()
            .OrderBy(s => s.SortOrder)
            .Select(s => new { s.OrderStatusId, s.OrderStatusName })
            .ToListAsync(ct);
        var counts = (await db.Orders
            .GroupBy(o => o.OrderStatusId)
            .Select(g => new { Id = g.Key, Count = g.Count() })
            .ToListAsync(ct))
            .ToDictionary(x => x.Id ?? 0, x => x.Count);
        var ordersByStatus = statuses
            .Select(s => new StatusCountDto(s.OrderStatusName ?? "—", counts.GetValueOrDefault(s.OrderStatusId)))
            .ToList();

        var recentRaw = await db.Orders
            .OrderByDescending(o => o.OrderDate)
            .Take(5)
            .Select(o => new
            {
                o.OrderId,
                CustomerName = o.Customer != null ? o.Customer.CompanyName : null,
                o.OrderDate,
                o.OrderStatusId,
            })
            .ToListAsync(ct);
        var statusName = statuses.ToDictionary(s => s.OrderStatusId, s => s.OrderStatusName);
        var recentOrders = recentRaw
            .Select(o => new RecentOrderDto(
                o.OrderId, o.CustomerName, o.OrderDate,
                o.OrderStatusId is int id ? statusName.GetValueOrDefault(id) : null))
            .ToList();

        return Ok(new DashboardSummaryDto(
            totalOrders, totalCompanies, totalProducts, openPurchaseOrders,
            productsAwaitingStock, invoicedSales, ordersByStatus, recentOrders));
    }
}
