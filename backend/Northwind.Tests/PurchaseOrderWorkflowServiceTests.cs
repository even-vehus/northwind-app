using Microsoft.EntityFrameworkCore;
using Northwind.Domain.Entities;
using Northwind.Domain.Enums;
using Northwind.Infrastructure.Data;
using Northwind.Infrastructure.Services;

namespace Northwind.Tests;

public class PurchaseOrderWorkflowServiceTests
{
    private static NorthwindDbContext NewContext() =>
        new(new DbContextOptionsBuilder<NorthwindDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .Options);

    private static PurchaseOrderWorkflowService Workflow(NorthwindDbContext db) =>
        new(db, new InventoryService(db));

    private static void SeedPo(
        NorthwindDbContext db, PurchaseOrderStatusId status,
        decimal? shippingFee = null, string? paymentMethod = null)
    {
        db.PurchaseOrders.Add(new PurchaseOrder
        {
            PurchaseOrderId = 1,
            StatusId = (int)status,
            ShippingFee = shippingFee,
            PaymentMethod = paymentMethod,
        });
        db.PurchaseOrderDetails.Add(new PurchaseOrderDetail
        {
            PurchaseOrderDetailId = 1,
            PurchaseOrderId = 1,
            ProductId = 1,
            Quantity = 50,
        });
        db.SaveChanges();
    }

    [Fact]
    public async Task Submit_FromNew_Succeeds()
    {
        using var db = NewContext();
        SeedPo(db, PurchaseOrderStatusId.New);
        await Workflow(db).SubmitAsync(1);
        Assert.Equal((int)PurchaseOrderStatusId.Submitted, db.PurchaseOrders.Single().StatusId);
    }

    [Fact]
    public async Task Submit_WhenNotNew_Throws()
    {
        using var db = NewContext();
        SeedPo(db, PurchaseOrderStatusId.Submitted);
        await Assert.ThrowsAsync<BusinessRuleException>(() => Workflow(db).SubmitAsync(1));
    }

    [Fact]
    public async Task Approve_FromSubmitted_Succeeds()
    {
        using var db = NewContext();
        SeedPo(db, PurchaseOrderStatusId.Submitted);
        await Workflow(db).ApproveAsync(1);
        var po = db.PurchaseOrders.Single();
        Assert.Equal((int)PurchaseOrderStatusId.Approved, po.StatusId);
        Assert.NotNull(po.ApprovedDate);
    }

    [Fact]
    public async Task Approve_WhenNotSubmitted_Throws()
    {
        using var db = NewContext();
        SeedPo(db, PurchaseOrderStatusId.New);
        await Assert.ThrowsAsync<BusinessRuleException>(() => Workflow(db).ApproveAsync(1));
    }

    [Fact]
    public async Task Receive_FromApproved_StampsDatesAndAllocatesWaitingOrders()
    {
        using var db = NewContext();
        db.Products.Add(new Product { ProductId = 1, AddedOn = new DateTime(2022, 11, 1) });
        db.StockTakes.Add(new StockTake { StockTakeId = 1, ProductId = 1, StockTakeDate = new DateTime(2024, 1, 1), QuantityOnHand = 0 });
        SeedPo(db, PurchaseOrderStatusId.Approved);   // PO line: product 1, qty 50
        // An order line waiting (NoStock) for product 1.
        db.Orders.Add(new Order { OrderId = 1, OrderDate = new DateTime(2024, 2, 1), OrderStatusId = (int)OrderStatusId.New });
        db.OrderDetails.Add(new OrderDetail { OrderDetailId = 1, OrderId = 1, ProductId = 1, Quantity = 30, StatusId = (int)OrderDetailStatusId.NoStock });
        db.SaveChanges();

        await Workflow(db).ReceiveAsync(1);

        var po = db.PurchaseOrders.Single();
        Assert.Equal((int)PurchaseOrderStatusId.Received, po.StatusId);
        Assert.NotNull(po.ReceivedDate);
        Assert.NotNull(db.PurchaseOrderDetails.Single().ReceivedDate);   // line stamped too
        // 50 received covers the 30 waiting → that order line is now Allocated.
        Assert.Equal((int)OrderDetailStatusId.Allocated, db.OrderDetails.Single().StatusId);
    }

    [Fact]
    public async Task Receive_WhenNotApproved_Throws()
    {
        using var db = NewContext();
        SeedPo(db, PurchaseOrderStatusId.Submitted);
        await Assert.ThrowsAsync<BusinessRuleException>(() => Workflow(db).ReceiveAsync(1));
    }

    [Fact]
    public async Task Close_FromReceived_WithFields_Succeeds()
    {
        using var db = NewContext();
        SeedPo(db, PurchaseOrderStatusId.Received);
        await Workflow(db).CloseAsync(1, new ClosePurchaseOrderArgs(12.5m, "Card"));
        Assert.Equal((int)PurchaseOrderStatusId.Closed, db.PurchaseOrders.Single().StatusId);
    }

    [Fact]
    public async Task Close_WhenMissingFields_Throws()
    {
        using var db = NewContext();
        SeedPo(db, PurchaseOrderStatusId.Received);
        await Assert.ThrowsAsync<BusinessRuleException>(
            () => Workflow(db).CloseAsync(1, new ClosePurchaseOrderArgs(null, null)));
    }

    [Fact]
    public async Task Close_WhenNotReceived_Throws()
    {
        using var db = NewContext();
        SeedPo(db, PurchaseOrderStatusId.Approved);
        await Assert.ThrowsAsync<BusinessRuleException>(
            () => Workflow(db).CloseAsync(1, new ClosePurchaseOrderArgs(12.5m, "Card")));
    }

    [Fact]
    public async Task Delete_WhenNew_Succeeds()
    {
        using var db = NewContext();
        SeedPo(db, PurchaseOrderStatusId.New);
        await Workflow(db).DeleteAsync(1);
        Assert.Empty(db.PurchaseOrders);
    }

    [Fact]
    public async Task Delete_WhenApproved_Throws()
    {
        using var db = NewContext();
        SeedPo(db, PurchaseOrderStatusId.Approved);
        await Assert.ThrowsAsync<BusinessRuleException>(() => Workflow(db).DeleteAsync(1));
        Assert.Single(db.PurchaseOrders);
    }

    [Fact]
    public async Task Reorder_CreatesNewPurchaseOrderWithLine()
    {
        using var db = NewContext();

        var poId = await Workflow(db).ReorderProductAsync(productId: 7, vendorId: 9, quantity: 25, unitCost: 3.5m);

        var po = db.PurchaseOrders.Single();
        Assert.Equal(poId, po.PurchaseOrderId);
        Assert.Equal((int)PurchaseOrderStatusId.New, po.StatusId);
        Assert.Equal(9, po.VendorId);
        var line = db.PurchaseOrderDetails.Single();
        Assert.Equal(7, line.ProductId);
        Assert.Equal(25, line.Quantity);
        Assert.Equal(3.5m, line.UnitCost);
    }

    [Fact]
    public async Task AddOrMergeDetail_MergesQuantityForExistingProduct()
    {
        using var db = NewContext();
        SeedPo(db, PurchaseOrderStatusId.New);   // PO 1 has a line: product 1, qty 50

        var lineId = await Workflow(db).AddOrMergeDetailAsync(1, productId: 1, quantity: 20, unitCost: 1m);

        Assert.Single(db.PurchaseOrderDetails);                 // merged, not a second line
        Assert.Equal(70, db.PurchaseOrderDetails.Single().Quantity);
        Assert.Equal(1, lineId);
    }

    [Fact]
    public async Task AddOrMergeDetail_AddsLineForDifferentProduct()
    {
        using var db = NewContext();
        SeedPo(db, PurchaseOrderStatusId.New);   // line for product 1

        await Workflow(db).AddOrMergeDetailAsync(1, productId: 2, quantity: 10, unitCost: 1m);

        Assert.Equal(2, db.PurchaseOrderDetails.Count());
    }
}
