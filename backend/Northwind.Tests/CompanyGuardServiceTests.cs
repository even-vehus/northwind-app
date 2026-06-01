using Microsoft.EntityFrameworkCore;
using Northwind.Domain.Entities;
using Northwind.Infrastructure.Data;
using Northwind.Infrastructure.Services;

namespace Northwind.Tests;

public class CompanyGuardServiceTests
{
    private static NorthwindDbContext NewContext() =>
        new(new DbContextOptionsBuilder<NorthwindDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .Options);

    private static void AddCompany(NorthwindDbContext db, int id = 1) =>
        db.Companies.Add(new Company { CompanyId = id, CompanyName = "Acme", CompanyTypeId = 3 });

    [Fact]
    public async Task Delete_WhenHasCustomerOrders_Throws()
    {
        using var db = NewContext();
        AddCompany(db);
        db.Orders.Add(new Order { OrderId = 1, CustomerId = 1 });
        db.SaveChanges();

        await Assert.ThrowsAsync<BusinessRuleException>(() => new CompanyGuardService(db).DeleteAsync(1));
        Assert.Single(db.Companies);
    }

    [Fact]
    public async Task Delete_WhenHasShipperOrders_Throws()
    {
        using var db = NewContext();
        AddCompany(db);
        db.Orders.Add(new Order { OrderId = 1, ShipperId = 1 });
        db.SaveChanges();
        await Assert.ThrowsAsync<BusinessRuleException>(() => new CompanyGuardService(db).DeleteAsync(1));
    }

    [Fact]
    public async Task Delete_WhenHasVendorPurchaseOrders_Throws()
    {
        using var db = NewContext();
        AddCompany(db);
        db.PurchaseOrders.Add(new PurchaseOrder { PurchaseOrderId = 1, VendorId = 1 });
        db.SaveChanges();
        await Assert.ThrowsAsync<BusinessRuleException>(() => new CompanyGuardService(db).DeleteAsync(1));
    }

    [Fact]
    public async Task Delete_WhenOnlyContactsAndVendorProducts_CascadesAndRemoves()
    {
        using var db = NewContext();
        AddCompany(db);
        db.Contacts.Add(new Contact { ContactId = 1, CompanyId = 1 });
        db.ProductVendors.Add(new ProductVendor { ProductVendorId = 1, VendorId = 1, ProductId = 1 });
        db.SaveChanges();

        await new CompanyGuardService(db).DeleteAsync(1);

        Assert.Empty(db.Companies);
        Assert.Empty(db.Contacts);
        Assert.Empty(db.ProductVendors);
    }

    [Fact]
    public async Task Delete_UnknownCompany_ThrowsKeyNotFound()
    {
        using var db = NewContext();
        await Assert.ThrowsAsync<KeyNotFoundException>(() => new CompanyGuardService(db).DeleteAsync(99));
    }

    [Fact]
    public async Task EnsureCanChangeType_WhenActive_Throws()
    {
        using var db = NewContext();
        AddCompany(db);
        db.Orders.Add(new Order { OrderId = 1, CustomerId = 1 });
        db.SaveChanges();
        await Assert.ThrowsAsync<BusinessRuleException>(() => new CompanyGuardService(db).EnsureCanChangeTypeAsync(1));
    }

    [Fact]
    public async Task EnsureCanChangeType_WhenVendorWithProducts_Throws()
    {
        using var db = NewContext();
        AddCompany(db);
        db.ProductVendors.Add(new ProductVendor { ProductVendorId = 1, VendorId = 1, ProductId = 1 });
        db.SaveChanges();
        // Not active (no orders/POs) but is a vendor with products → still blocked.
        await Assert.ThrowsAsync<BusinessRuleException>(() => new CompanyGuardService(db).EnsureCanChangeTypeAsync(1));
    }

    [Fact]
    public async Task EnsureCanChangeType_WhenNoReferences_Allowed()
    {
        using var db = NewContext();
        AddCompany(db);
        db.SaveChanges();
        await new CompanyGuardService(db).EnsureCanChangeTypeAsync(1);   // does not throw
    }
}
