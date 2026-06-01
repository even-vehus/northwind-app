namespace Northwind.Infrastructure.Services;

/// <summary>
/// Referential guards for companies, ported from Access frmCompanyDetail.
/// A company is "active" if it has customer orders, shipper orders, or vendor POs.
/// </summary>
public interface ICompanyGuardService
{
    /// <summary>
    /// Delete a company. Blocked (409) if it is active. Otherwise cascades its Contacts and
    /// ProductVendors first (the only other references), then removes the company.
    /// </summary>
    Task DeleteAsync(int companyId, CancellationToken ct = default);

    /// <summary>
    /// Throw (409) if the company's type may not change — i.e. it is active or is a vendor with
    /// products. Call only when the type is actually changing.
    /// </summary>
    Task EnsureCanChangeTypeAsync(int companyId, CancellationToken ct = default);
}
