using Microsoft.EntityFrameworkCore;
using Northwind.Infrastructure.Data;

namespace Northwind.Infrastructure.Services;

/// <summary>Port of the company delete / type-change guards in Access frmCompanyDetail.</summary>
public class CompanyGuardService(NorthwindDbContext db) : ICompanyGuardService
{
    private record CompanyCounts(
        int CustomerOrders, int ShipperOrders, int VendorPurchaseOrders, int Contacts, int VendorProducts)
    {
        public bool IsActive => CustomerOrders + ShipperOrders + VendorPurchaseOrders > 0;
    }

    public async Task DeleteAsync(int companyId, CancellationToken ct = default)
    {
        var company = await db.Companies.FindAsync([companyId], ct)
            ?? throw new KeyNotFoundException($"Company {companyId} not found.");

        var counts = await CountsAsync(companyId, ct);
        if (counts.IsActive)
            throw new BusinessRuleException(BlockedMessage("delete the company", counts, includeVendorProducts: false));

        // Not active — safe to remove the only remaining references, then the company.
        if (counts.Contacts > 0)
            db.Contacts.RemoveRange(db.Contacts.Where(c => c.CompanyId == companyId));
        if (counts.VendorProducts > 0)
            db.ProductVendors.RemoveRange(db.ProductVendors.Where(pv => pv.VendorId == companyId));

        db.Companies.Remove(company);
        await db.SaveChangesAsync(ct);
    }

    public async Task EnsureCanChangeTypeAsync(int companyId, CancellationToken ct = default)
    {
        var counts = await CountsAsync(companyId, ct);
        if (counts.IsActive || counts.VendorProducts > 0)
            throw new BusinessRuleException(BlockedMessage("change the Company Type", counts, includeVendorProducts: true));
    }

    private async Task<CompanyCounts> CountsAsync(int companyId, CancellationToken ct) => new(
        CustomerOrders: await db.Orders.CountAsync(o => o.CustomerId == companyId, ct),
        ShipperOrders: await db.Orders.CountAsync(o => o.ShipperId == companyId, ct),
        VendorPurchaseOrders: await db.PurchaseOrders.CountAsync(po => po.VendorId == companyId, ct),
        Contacts: await db.Contacts.CountAsync(c => c.CompanyId == companyId, ct),
        VendorProducts: await db.ProductVendors.CountAsync(pv => pv.VendorId == companyId, ct));

    private static string BlockedMessage(string action, CompanyCounts c, bool includeVendorProducts)
    {
        var parts = new List<string>
        {
            $"Customer Orders ({c.CustomerOrders})",
            $"Shipper Orders ({c.ShipperOrders})",
            $"Vendor Purchase Orders ({c.VendorPurchaseOrders})",
        };
        if (includeVendorProducts)
            parts.Add($"Vendor Products ({c.VendorProducts})");
        return $"You can't {action} because it has " + string.Join(", ", parts) + ".";
    }
}
