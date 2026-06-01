namespace Northwind.Infrastructure.Services;

/// <summary>Fields applied when closing a PO (mirrors the form's close-required fields).</summary>
public record ClosePurchaseOrderArgs(decimal? ShippingFee, string? PaymentMethod);

/// <summary>
/// Purchase-order lifecycle: New → Submitted → Approved → Received → Closed, with the guards
/// from Access frmPurchaseOrderDetails. Receiving posts to inventory (sets ReceivedDate on the
/// PO and all lines, then re-allocates each product). Ported in Phase 3 (see VBA_PORT_LOG.md).
/// </summary>
public interface IPurchaseOrderWorkflowService
{
    /// <summary>New → Submitted.</summary>
    Task SubmitAsync(int purchaseOrderId, CancellationToken ct = default);

    /// <summary>Submitted → Approved. (The Access "Approve PO" privilege check is stubbed while auth is bypassed.)</summary>
    Task ApproveAsync(int purchaseOrderId, CancellationToken ct = default);

    /// <summary>Approved → Received. Stamps ReceivedDate on the PO and every line, then re-allocates inventory.</summary>
    Task ReceiveAsync(int purchaseOrderId, CancellationToken ct = default);

    /// <summary>Received → Closed. Applies supplied close fields first; requires ShippingFee + PaymentMethod.</summary>
    Task CloseAsync(int purchaseOrderId, ClosePurchaseOrderArgs args, CancellationToken ct = default);

    /// <summary>Delete a PO (allowed only while New or Submitted).</summary>
    Task DeleteAsync(int purchaseOrderId, CancellationToken ct = default);

    /// <summary>
    /// Add a line to a PO, or — if a line for the product already exists — add to its quantity.
    /// Port of modPurchaseOrders.AddPurchaseOrderDetail. Returns the line id.
    /// </summary>
    Task<int> AddOrMergeDetailAsync(int purchaseOrderId, int productId, int quantity, decimal unitCost, CancellationToken ct = default);

    /// <summary>
    /// Create a new (New-status) PO for a vendor and add a line for the product.
    /// Port of modPurchaseOrders.ReorderProduct. Returns the new PO id.
    /// </summary>
    Task<int> ReorderProductAsync(int productId, int vendorId, int quantity, decimal unitCost, CancellationToken ct = default);
}
