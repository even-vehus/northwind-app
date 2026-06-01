using Microsoft.EntityFrameworkCore;
using Northwind.Domain.Entities;
using Northwind.Domain.Enums;
using Northwind.Infrastructure.Data;
using Northwind.Infrastructure.Services;

namespace Northwind.Tests;

public class OrderWorkflowServiceTests
{
    private static NorthwindDbContext NewContext() =>
        new(new DbContextOptionsBuilder<NorthwindDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .Options);

    private static OrderWorkflowService Workflow(NorthwindDbContext db) =>
        new(db, new InventoryService(db));

    /// <summary>Seeds one order with a single line item in the given statuses.</summary>
    private static void SeedOrder(
        NorthwindDbContext db,
        OrderStatusId orderStatus,
        OrderDetailStatusId lineStatus,
        decimal? shippingFee = 10m)
    {
        db.Orders.Add(new Order
        {
            OrderId = 1,
            OrderStatusId = (int)orderStatus,
            ShippingFee = shippingFee,
        });
        db.OrderDetails.Add(new OrderDetail
        {
            OrderDetailId = 1,
            OrderId = 1,
            ProductId = 1,
            Quantity = 5,
            StatusId = (int)lineStatus,
        });
        db.SaveChanges();
    }

    // ── Invoice ──────────────────────────────────────────────────────────────

    [Fact]
    public async Task Invoice_FromNew_WithAllocatedLineAndFee_Succeeds()
    {
        using var db = NewContext();
        SeedOrder(db, OrderStatusId.New, OrderDetailStatusId.Allocated);

        await Workflow(db).InvoiceAsync(1);

        var order = db.Orders.Single();
        Assert.Equal((int)OrderStatusId.Invoiced, order.OrderStatusId);
        Assert.NotNull(order.InvoiceDate);
        Assert.Equal((int)OrderDetailStatusId.Invoiced, db.OrderDetails.Single().StatusId);
    }

    [Fact]
    public async Task Invoice_WhenNotNew_Throws()
    {
        using var db = NewContext();
        SeedOrder(db, OrderStatusId.Invoiced, OrderDetailStatusId.Allocated);
        await Assert.ThrowsAsync<BusinessRuleException>(() => Workflow(db).InvoiceAsync(1));
    }

    [Fact]
    public async Task Invoice_WhenLineNotAllocated_Throws()
    {
        using var db = NewContext();
        SeedOrder(db, OrderStatusId.New, OrderDetailStatusId.NoStock);
        await Assert.ThrowsAsync<BusinessRuleException>(() => Workflow(db).InvoiceAsync(1));
    }

    [Fact]
    public async Task Invoice_WhenNoShippingFee_Throws()
    {
        using var db = NewContext();
        SeedOrder(db, OrderStatusId.New, OrderDetailStatusId.Allocated, shippingFee: null);
        await Assert.ThrowsAsync<BusinessRuleException>(() => Workflow(db).InvoiceAsync(1));
    }

    [Fact]
    public async Task Invoice_WhenNoLines_Throws()
    {
        using var db = NewContext();
        db.Orders.Add(new Order { OrderId = 1, OrderStatusId = (int)OrderStatusId.New, ShippingFee = 10m });
        db.SaveChanges();
        await Assert.ThrowsAsync<BusinessRuleException>(() => Workflow(db).InvoiceAsync(1));
    }

    // ── Ship ─────────────────────────────────────────────────────────────────

    [Fact]
    public async Task Ship_FromInvoiced_WithFieldsSupplied_Succeeds()
    {
        using var db = NewContext();
        SeedOrder(db, OrderStatusId.Invoiced, OrderDetailStatusId.Invoiced);

        await Workflow(db).ShipAsync(1, new ShipOrderArgs(new DateTime(2026, 1, 1), ShipperId: 9, ShippingFee: 10m));

        var order = db.Orders.Single();
        Assert.Equal((int)OrderStatusId.Shipped, order.OrderStatusId);
        Assert.Equal(9, order.ShipperId);
        Assert.Equal((int)OrderDetailStatusId.Shipped, db.OrderDetails.Single().StatusId);
    }

    [Fact]
    public async Task Ship_WhenMissingShippingFields_Throws()
    {
        using var db = NewContext();
        SeedOrder(db, OrderStatusId.Invoiced, OrderDetailStatusId.Invoiced);
        // No ShipperId / ShippedDate supplied or persisted.
        await Assert.ThrowsAsync<BusinessRuleException>(
            () => Workflow(db).ShipAsync(1, new ShipOrderArgs(null, null, 10m)));
    }

    [Fact]
    public async Task Ship_WhenNotInvoiced_Throws()
    {
        using var db = NewContext();
        SeedOrder(db, OrderStatusId.New, OrderDetailStatusId.Allocated);
        await Assert.ThrowsAsync<BusinessRuleException>(
            () => Workflow(db).ShipAsync(1, new ShipOrderArgs(new DateTime(2026, 1, 1), 9, 10m)));
    }

    // ── Pay / Close ──────────────────────────────────────────────────────────

    [Fact]
    public async Task Pay_FromShipped_WithFields_Succeeds()
    {
        using var db = NewContext();
        SeedOrder(db, OrderStatusId.Shipped, OrderDetailStatusId.Shipped);

        await Workflow(db).PayAsync(1, new PayOrderArgs("Card", new DateTime(2026, 1, 2)));

        Assert.Equal((int)OrderStatusId.Paid, db.Orders.Single().OrderStatusId);
    }

    [Fact]
    public async Task Pay_WhenNotShipped_Throws()
    {
        using var db = NewContext();
        SeedOrder(db, OrderStatusId.Invoiced, OrderDetailStatusId.Invoiced);
        await Assert.ThrowsAsync<BusinessRuleException>(
            () => Workflow(db).PayAsync(1, new PayOrderArgs("Card", new DateTime(2026, 1, 2))));
    }

    [Fact]
    public async Task Close_FromPaid_Succeeds()
    {
        using var db = NewContext();
        SeedOrder(db, OrderStatusId.Paid, OrderDetailStatusId.Shipped);

        await Workflow(db).CloseAsync(1);

        Assert.Equal((int)OrderStatusId.Closed, db.Orders.Single().OrderStatusId);
    }

    [Fact]
    public async Task Close_WhenNotPaid_Throws()
    {
        using var db = NewContext();
        SeedOrder(db, OrderStatusId.Shipped, OrderDetailStatusId.Shipped);
        await Assert.ThrowsAsync<BusinessRuleException>(() => Workflow(db).CloseAsync(1));
    }

    // ── Delete ───────────────────────────────────────────────────────────────

    [Fact]
    public async Task Delete_WhenNew_RemovesOrder()
    {
        using var db = NewContext();
        db.Products.Add(new Product { ProductId = 1, AddedOn = new DateTime(2022, 11, 1) });
        SeedOrder(db, OrderStatusId.New, OrderDetailStatusId.Allocated);

        await Workflow(db).DeleteAsync(1);

        Assert.Empty(db.Orders);
        Assert.Empty(db.OrderDetails);
    }

    [Fact]
    public async Task Delete_WhenShipped_Throws()
    {
        using var db = NewContext();
        SeedOrder(db, OrderStatusId.Shipped, OrderDetailStatusId.Shipped);
        await Assert.ThrowsAsync<BusinessRuleException>(() => Workflow(db).DeleteAsync(1));
        Assert.Single(db.Orders); // unchanged
    }

    [Fact]
    public async Task Invoice_UnknownOrder_ThrowsKeyNotFound()
    {
        using var db = NewContext();
        await Assert.ThrowsAsync<KeyNotFoundException>(() => Workflow(db).InvoiceAsync(999));
    }
}
