using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Northwind.Domain.Entities;

namespace Northwind.Infrastructure.Data.Configurations;

public class CompanyConfiguration : IEntityTypeConfiguration<Company>
{
    public void Configure(EntityTypeBuilder<Company> b)
    {
        b.ToTable("Companies");
        b.HasKey(e => e.CompanyId);
        b.Property(e => e.CompanyId).HasColumnName("CompanyID");
        b.Property(e => e.CompanyTypeId).HasColumnName("CompanyTypeID");
        b.Property(e => e.StandardTaxStatusId).HasColumnName("StandardTaxStatusID");
        b.Property(e => e.CompanyName).HasMaxLength(50);
        b.Property(e => e.BusinessPhone).HasMaxLength(20);
        b.Property(e => e.StateAbbrev).HasMaxLength(2);
        b.Property(e => e.Zip).HasMaxLength(10);

        b.HasOne(e => e.CompanyType)
            .WithMany(ct => ct.Companies)
            .HasForeignKey(e => e.CompanyTypeId);
    }
}

public class ContactConfiguration : IEntityTypeConfiguration<Contact>
{
    public void Configure(EntityTypeBuilder<Contact> b)
    {
        b.ToTable("Contacts");
        b.HasKey(e => e.ContactId);
        b.Property(e => e.ContactId).HasColumnName("ContactID");
        b.Property(e => e.CompanyId).HasColumnName("CompanyID");
        b.Property(e => e.LastName).HasMaxLength(30);
        b.Property(e => e.FirstName).HasMaxLength(20);
        b.Property(e => e.EmailAddress).HasMaxLength(255);
        b.Property(e => e.JobTitle).HasMaxLength(50);
        b.Property(e => e.PrimaryPhone).HasMaxLength(20);
        b.Property(e => e.SecondaryPhone).HasMaxLength(20);

        b.HasOne(e => e.Company)
            .WithMany(c => c.Contacts)
            .HasForeignKey(e => e.CompanyId);
    }
}

public class CompanyTypeConfiguration : IEntityTypeConfiguration<CompanyType>
{
    public void Configure(EntityTypeBuilder<CompanyType> b)
    {
        b.ToTable("CompanyTypes");
        b.HasKey(e => e.CompanyTypeId);
        b.Property(e => e.CompanyTypeId).HasColumnName("CompanyTypeID");
        b.Property(e => e.CompanyType1).HasColumnName("CompanyType").HasMaxLength(50);
    }
}

public class ProductConfiguration : IEntityTypeConfiguration<Product>
{
    public void Configure(EntityTypeBuilder<Product> b)
    {
        b.ToTable("Products");
        b.HasKey(e => e.ProductId);
        b.Property(e => e.ProductId).HasColumnName("ProductID");
        b.Property(e => e.ProductCategoryId).HasColumnName("ProductCategoryID");
        b.Property(e => e.ProductName).HasMaxLength(50);
        b.Property(e => e.ProductCode).HasMaxLength(25);
        b.Property(e => e.Description).HasColumnName("ProductDescription");
        b.Property(e => e.ListPrice).HasColumnName("UnitPrice").HasColumnType("decimal(18,4)");
        b.Property(e => e.StandardCost).HasColumnName("StandardUnitCost").HasColumnType("decimal(18,4)");

        b.HasOne(e => e.ProductCategory)
            .WithMany(pc => pc.Products)
            .HasForeignKey(e => e.ProductCategoryId);
    }
}

public class ProductCategoryConfiguration : IEntityTypeConfiguration<ProductCategory>
{
    public void Configure(EntityTypeBuilder<ProductCategory> b)
    {
        b.ToTable("ProductCategories");
        b.HasKey(e => e.CategoryId);
        b.Property(e => e.CategoryId).HasColumnName("ProductCategoryID");
        b.Property(e => e.CategoryName).HasColumnName("ProductCategoryName").HasMaxLength(50);
        b.Property(e => e.CategoryCode).HasColumnName("ProductCategoryCode").HasMaxLength(15);
        b.Property(e => e.CategoryDesc).HasColumnName("ProductCategoryDesc");
        b.Property(e => e.CategoryImage).HasColumnName("ProductCategoryImage");
    }
}

public class OrderConfiguration : IEntityTypeConfiguration<Order>
{
    public void Configure(EntityTypeBuilder<Order> b)
    {
        b.ToTable("Orders");
        b.HasKey(e => e.OrderId);
        b.Property(e => e.OrderId).HasColumnName("OrderID");
        b.Property(e => e.EmployeeId).HasColumnName("EmployeeID");
        b.Property(e => e.CustomerId).HasColumnName("CustomerID");
        b.Property(e => e.ShippingFee).HasColumnType("decimal(18,4)");

        b.HasOne(e => e.Customer)
            .WithMany(c => c.Orders)
            .HasForeignKey(e => e.CustomerId)
            .OnDelete(DeleteBehavior.SetNull);

        b.HasOne(e => e.Employee)
            .WithMany(em => em.Orders)
            .HasForeignKey(e => e.EmployeeId)
            .OnDelete(DeleteBehavior.SetNull);
    }
}

public class OrderDetailConfiguration : IEntityTypeConfiguration<OrderDetail>
{
    public void Configure(EntityTypeBuilder<OrderDetail> b)
    {
        b.ToTable("OrderDetails");
        b.HasKey(e => e.OrderDetailId);
        b.Property(e => e.OrderDetailId).HasColumnName("OrderDetailID");
        b.Property(e => e.OrderId).HasColumnName("OrderID");
        b.Property(e => e.ProductId).HasColumnName("ProductID");
        b.Property(e => e.StatusId).HasColumnName("OrderDetailStatusID");
        b.Property(e => e.UnitPrice).HasColumnType("decimal(18,4)");
        // Quantity is INT in the source schema — let EF map by convention.

        // Properties with no corresponding column in the source schema.
        b.Ignore(e => e.DateAllocated);
        b.Ignore(e => e.PurchaseOrderId);
        b.Ignore(e => e.InventoryId);

        b.HasOne(e => e.Order)
            .WithMany(o => o.OrderDetails)
            .HasForeignKey(e => e.OrderId);

        b.HasOne(e => e.Product)
            .WithMany(p => p.OrderDetails)
            .HasForeignKey(e => e.ProductId);
    }
}

public class EmployeeConfiguration : IEntityTypeConfiguration<Employee>
{
    public void Configure(EntityTypeBuilder<Employee> b)
    {
        b.ToTable("Employees");
        b.HasKey(e => e.EmployeeId);
        b.Property(e => e.EmployeeId).HasColumnName("EmployeeID");
        b.Property(e => e.FirstName).HasMaxLength(20);
        b.Property(e => e.LastName).HasMaxLength(30);
        b.Property(e => e.EmailAddress).HasMaxLength(255);
        b.Property(e => e.JobTitle).HasMaxLength(50);
        b.Property(e => e.PrimaryPhone).HasMaxLength(20);
        b.Property(e => e.SecondaryPhone).HasMaxLength(20);
        b.Property(e => e.Title).HasMaxLength(20);
        b.Property(e => e.SupervisorId).HasColumnName("SupervisorID");
        b.Property(e => e.WindowsUserName).HasMaxLength(50);
    }
}

public class PurchaseOrderConfiguration : IEntityTypeConfiguration<PurchaseOrder>
{
    public void Configure(EntityTypeBuilder<PurchaseOrder> b)
    {
        b.ToTable("PurchaseOrders");
        b.HasKey(e => e.PurchaseOrderId);
        b.Property(e => e.PurchaseOrderId).HasColumnName("PurchaseOrderID");
        b.Property(e => e.VendorId).HasColumnName("VendorID");
        b.Property(e => e.SubmittedById).HasColumnName("SubmittedByID");
        b.Property(e => e.ApprovedById).HasColumnName("ApprovedByID");
        b.Property(e => e.StatusId).HasColumnName("StatusID");
        b.Property(e => e.ShippingFee).HasColumnType("decimal(18,4)");
        b.Property(e => e.TaxAmount).HasColumnType("decimal(18,4)");
        b.Property(e => e.PaymentAmount).HasColumnType("decimal(18,4)");

        b.HasOne(e => e.Vendor)
            .WithMany()
            .HasForeignKey(e => e.VendorId)
            .OnDelete(DeleteBehavior.SetNull);

        b.HasOne(e => e.SubmittedBy)
            .WithMany(em => em.SubmittedPurchaseOrders)
            .HasForeignKey(e => e.SubmittedById)
            .OnDelete(DeleteBehavior.SetNull);

        b.HasOne(e => e.ApprovedBy)
            .WithMany(em => em.ApprovedPurchaseOrders)
            .HasForeignKey(e => e.ApprovedById)
            .OnDelete(DeleteBehavior.SetNull);

        b.HasOne(e => e.Status)
            .WithMany(s => s.PurchaseOrders)
            .HasForeignKey(e => e.StatusId)
            .OnDelete(DeleteBehavior.SetNull);
    }
}

public class PurchaseOrderDetailConfiguration : IEntityTypeConfiguration<PurchaseOrderDetail>
{
    public void Configure(EntityTypeBuilder<PurchaseOrderDetail> b)
    {
        b.ToTable("PurchaseOrderDetails");
        b.HasKey(e => e.PurchaseOrderDetailId);
        b.Property(e => e.PurchaseOrderDetailId).HasColumnName("PurchaseOrderDetailID");
        b.Property(e => e.PurchaseOrderId).HasColumnName("PurchaseOrderID");
        b.Property(e => e.ProductId).HasColumnName("ProductID");
        b.Property(e => e.UnitCost).HasColumnType("decimal(18,4)");

        b.HasOne(e => e.PurchaseOrder)
            .WithMany(po => po.PurchaseOrderDetails)
            .HasForeignKey(e => e.PurchaseOrderId);

        b.HasOne(e => e.Product)
            .WithMany(p => p.PurchaseOrderDetails)
            .HasForeignKey(e => e.ProductId);
    }
}

public class PurchaseOrderStatusConfiguration : IEntityTypeConfiguration<PurchaseOrderStatus>
{
    public void Configure(EntityTypeBuilder<PurchaseOrderStatus> b)
    {
        b.ToTable("PurchaseOrderStatus");
        b.HasKey(e => e.StatusId);
        b.Property(e => e.StatusId).HasColumnName("StatusID");
        b.Property(e => e.StatusName).HasMaxLength(50);
    }
}

public class ProductVendorConfiguration : IEntityTypeConfiguration<ProductVendor>
{
    public void Configure(EntityTypeBuilder<ProductVendor> b)
    {
        b.ToTable("ProductVendors");
        b.HasKey(e => e.ProductVendorId);
        b.Property(e => e.ProductVendorId).HasColumnName("ProductVendorID");
        b.Property(e => e.ProductId).HasColumnName("ProductID");
        b.Property(e => e.VendorId).HasColumnName("VendorID");

        b.HasOne(e => e.Product)
            .WithMany(p => p.ProductVendors)
            .HasForeignKey(e => e.ProductId);

        b.HasOne(e => e.Vendor)
            .WithMany()
            .HasForeignKey(e => e.VendorId)
            .OnDelete(DeleteBehavior.SetNull);
    }
}

public class StockTakeConfiguration : IEntityTypeConfiguration<StockTake>
{
    public void Configure(EntityTypeBuilder<StockTake> b)
    {
        b.ToTable("StockTake");
        b.HasKey(e => e.StockTakeId);
        b.Property(e => e.StockTakeId).HasColumnName("StockTakeID");
        b.Property(e => e.ProductId).HasColumnName("ProductID");

        b.HasOne(e => e.Product)
            .WithMany(p => p.StockTakes)
            .HasForeignKey(e => e.ProductId);
    }
}

public class OrderDetailStatusConfiguration : IEntityTypeConfiguration<OrderDetailStatus>
{
    public void Configure(EntityTypeBuilder<OrderDetailStatus> b)
    {
        b.ToTable("OrderDetailStatus");
        b.HasKey(e => e.OrderDetailStatusId);
        b.Property(e => e.OrderDetailStatusId).HasColumnName("OrderDetailStatusID");
        b.Property(e => e.OrderDetailStatusName).HasMaxLength(50);
    }
}

public class TaxStatusConfiguration : IEntityTypeConfiguration<TaxStatus>
{
    public void Configure(EntityTypeBuilder<TaxStatus> b)
    {
        b.ToTable("TaxStatus");
        b.HasKey(e => e.TaxStatusId);
        b.Property(e => e.TaxStatusId).HasColumnName("TaxStatusID");
        b.Property(e => e.TaxStatusName).HasColumnName("TaxStatus").HasMaxLength(50);
    }
}

public class PrivilegeConfiguration : IEntityTypeConfiguration<Privilege>
{
    public void Configure(EntityTypeBuilder<Privilege> b)
    {
        b.ToTable("Privileges");
        b.HasKey(e => e.PrivilegeId);
        b.Property(e => e.PrivilegeId).HasColumnName("PrivilegeID");
        b.Property(e => e.PrivilegeName).HasMaxLength(50);
    }
}

public class EmployeePrivilegeConfiguration : IEntityTypeConfiguration<EmployeePrivilege>
{
    public void Configure(EntityTypeBuilder<EmployeePrivilege> b)
    {
        b.ToTable("EmployeePrivileges");
        b.HasKey(e => e.EmployeePrivilegeId);
        b.Property(e => e.EmployeePrivilegeId).HasColumnName("EmployeePrivilegeID");
        b.Property(e => e.EmployeeId).HasColumnName("EmployeeID");
        b.Property(e => e.PrivilegeId).HasColumnName("PrivilegeID");

        b.HasOne(e => e.Employee)
            .WithMany(em => em.EmployeePrivileges)
            .HasForeignKey(e => e.EmployeeId);

        b.HasOne(e => e.Privilege)
            .WithMany(p => p.EmployeePrivileges)
            .HasForeignKey(e => e.PrivilegeId);
    }
}

public class OrderStatusConfiguration : IEntityTypeConfiguration<OrderStatus>
{
    public void Configure(EntityTypeBuilder<OrderStatus> b)
    {
        b.ToTable("OrderStatus");
        b.HasKey(e => e.OrderStatusId);
        b.Property(e => e.OrderStatusId).HasColumnName("OrderStatusID");
        b.Property(e => e.OrderStatusCode).HasMaxLength(5);
        b.Property(e => e.OrderStatusName).HasMaxLength(50);
    }
}

public class SystemSettingConfiguration : IEntityTypeConfiguration<SystemSetting>
{
    public void Configure(EntityTypeBuilder<SystemSetting> b)
    {
        b.ToTable("SystemSettings");
        b.HasKey(e => e.SettingId);
        b.Property(e => e.SettingId).HasColumnName("SettingID");
        b.Property(e => e.SettingName).HasMaxLength(50);
        b.Property(e => e.SettingValue).HasMaxLength(255);
        b.Property(e => e.Notes).HasMaxLength(255);
    }
}
