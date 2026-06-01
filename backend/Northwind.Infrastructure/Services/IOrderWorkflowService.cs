namespace Northwind.Infrastructure.Services;

/// <summary>Fields applied when shipping an order (mirrors the form's shipping fields).</summary>
public record ShipOrderArgs(DateTime? ShippedDate, int? ShipperId, decimal? ShippingFee);

/// <summary>Fields applied when recording payment.</summary>
public record PayOrderArgs(string? PaymentMethod, DateTime? PaidDate);

/// <summary>
/// Order lifecycle: New → Invoiced → Shipped → Paid → Closed, with the guards from
/// Access frmOrderDetails. Ported in Phase 2 (see VBA_PORT_LOG.md).
/// Throws <see cref="BusinessRuleException"/> (→ 409) when a transition is not allowed,
/// and <see cref="KeyNotFoundException"/> (→ 404) when the order does not exist.
/// </summary>
public interface IOrderWorkflowService
{
    /// <summary>New → Invoiced. Requires ≥1 line, all lines Allocated, and a shipping fee.</summary>
    Task InvoiceAsync(int orderId, CancellationToken ct = default);

    /// <summary>Invoiced → Shipped. Applies any supplied shipping fields first; all must be set.</summary>
    Task ShipAsync(int orderId, ShipOrderArgs args, CancellationToken ct = default);

    /// <summary>Shipped → Paid. Applies any supplied payment fields first; all must be set.</summary>
    Task PayAsync(int orderId, PayOrderArgs args, CancellationToken ct = default);

    /// <summary>Paid → Closed.</summary>
    Task CloseAsync(int orderId, CancellationToken ct = default);

    /// <summary>Delete an order (allowed only while New or Invoiced) and re-allocate inventory
    /// for every product that was on it.</summary>
    Task DeleteAsync(int orderId, CancellationToken ct = default);
}
