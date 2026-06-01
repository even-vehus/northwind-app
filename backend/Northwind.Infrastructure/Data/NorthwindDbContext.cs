using Microsoft.EntityFrameworkCore;
using Northwind.Domain.Entities;

namespace Northwind.Infrastructure.Data;

public class NorthwindDbContext(DbContextOptions<NorthwindDbContext> options) : DbContext(options)
{
    public DbSet<Company> Companies => Set<Company>();
    public DbSet<CompanyType> CompanyTypes => Set<CompanyType>();
    public DbSet<Contact> Contacts => Set<Contact>();
    public DbSet<Product> Products => Set<Product>();
    public DbSet<ProductCategory> ProductCategories => Set<ProductCategory>();
    public DbSet<Order> Orders => Set<Order>();
    public DbSet<OrderDetail> OrderDetails => Set<OrderDetail>();
    public DbSet<OrderDetailStatus> OrderDetailStatuses => Set<OrderDetailStatus>();
    public DbSet<OrderStatus> OrderStatuses => Set<OrderStatus>();
    public DbSet<Employee> Employees => Set<Employee>();
    public DbSet<EmployeePrivilege> EmployeePrivileges => Set<EmployeePrivilege>();
    public DbSet<Privilege> Privileges => Set<Privilege>();
    public DbSet<PurchaseOrder> PurchaseOrders => Set<PurchaseOrder>();
    public DbSet<PurchaseOrderDetail> PurchaseOrderDetails => Set<PurchaseOrderDetail>();
    public DbSet<PurchaseOrderStatus> PurchaseOrderStatuses => Set<PurchaseOrderStatus>();
    public DbSet<ProductVendor> ProductVendors => Set<ProductVendor>();
    public DbSet<StockTake> StockTakes => Set<StockTake>();
    public DbSet<TaxStatus> TaxStatuses => Set<TaxStatus>();
    public DbSet<SystemSetting> SystemSettings => Set<SystemSetting>();
    public DbSet<Title> Titles => Set<Title>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(NorthwindDbContext).Assembly);
    }
}
