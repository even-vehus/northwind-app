using Microsoft.EntityFrameworkCore;
using Northwind.Domain.Entities;
using Northwind.Domain.Enums;
using Northwind.Infrastructure.Data;
using Northwind.Infrastructure.Services;

namespace Northwind.Tests;

public class InventoryServiceTests
{
    private static NorthwindDbContext NewContext() =>
        new(new DbContextOptionsBuilder<NorthwindDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .Options);

    private static readonly DateTime StockTakeDate = new(2024, 1, 1);

    // Builds a product with a 100-unit stock take, 50 bought (received), 30 on an approved PO,
    // 40 sold (invoiced), 25 allocated, and 200 in no-stock.
    private static void SeedStandardProduct(NorthwindDbContext db)
    {
        db.Products.Add(new Product { ProductId = 1, ProductName = "Widget", AddedOn = new DateTime(2022, 11, 1), TargetLevel = 50, MinimumReorderQuantity = 10 });
        db.StockTakes.Add(new StockTake { StockTakeId = 1, ProductId = 1, StockTakeDate = StockTakeDate, QuantityOnHand = 100 });

        // Bought: a Received PO line with ReceivedDate after the stock take.
        var receivedPo = new PurchaseOrder { PurchaseOrderId = 1, StatusId = (int)PurchaseOrderStatusId.Received };
        db.PurchaseOrders.Add(receivedPo);
        db.PurchaseOrderDetails.Add(new PurchaseOrderDetail { PurchaseOrderDetailId = 1, PurchaseOrderId = 1, PurchaseOrder = receivedPo, ProductId = 1, Quantity = 50, ReceivedDate = new DateTime(2024, 2, 1) });

        // On order: an Approved PO line, not yet received.
        var approvedPo = new PurchaseOrder { PurchaseOrderId = 2, StatusId = (int)PurchaseOrderStatusId.Approved };
        db.PurchaseOrders.Add(approvedPo);
        db.PurchaseOrderDetails.Add(new PurchaseOrderDetail { PurchaseOrderDetailId = 2, PurchaseOrderId = 2, PurchaseOrder = approvedPo, ProductId = 1, Quantity = 30, ReceivedDate = null });

        // Sold: an invoiced order line (counts toward "sold").
        var invoicedOrder = new Order { OrderId = 1, InvoiceDate = new DateTime(2024, 3, 1), OrderStatusId = (int)OrderStatusId.Invoiced };
        db.Orders.Add(invoicedOrder);
        db.OrderDetails.Add(new OrderDetail { OrderDetailId = 1, OrderId = 1, Order = invoicedOrder, ProductId = 1, Quantity = 40, StatusId = (int)OrderDetailStatusId.Invoiced });

        // Allocated: a not-yet-invoiced order line.
        var allocatedOrder = new Order { OrderId = 2, OrderDate = new DateTime(2024, 4, 1), OrderStatusId = (int)OrderStatusId.New };
        db.Orders.Add(allocatedOrder);
        db.OrderDetails.Add(new OrderDetail { OrderDetailId = 2, OrderId = 2, Order = allocatedOrder, ProductId = 1, Quantity = 25, StatusId = (int)OrderDetailStatusId.Allocated });

        // No stock: a line that cannot be fulfilled.
        var noStockOrder = new Order { OrderId = 3, OrderDate = new DateTime(2024, 5, 1), OrderStatusId = (int)OrderStatusId.New };
        db.Orders.Add(noStockOrder);
        db.OrderDetails.Add(new OrderDetail { OrderDetailId = 3, OrderId = 3, Order = noStockOrder, ProductId = 1, Quantity = 200, StatusId = (int)OrderDetailStatusId.NoStock });

        db.SaveChanges();
    }

    [Fact]
    public async Task GetInventory_ComputesAllMetrics()
    {
        using var db = NewContext();
        SeedStandardProduct(db);
        var svc = new InventoryService(db);

        var inv = await svc.GetInventoryAsync(1);

        Assert.Equal(StockTakeDate, inv.LastStockTakeDate);
        Assert.Equal(100, inv.LastStockTakeQuantity);
        Assert.Equal(110, inv.QuantityAvailable);   // 100 + 50 bought - 40 sold
        Assert.Equal(25, inv.QuantityAllocated);
        Assert.Equal(30, inv.QuantityOnOrder);       // approved PO only
        Assert.Equal(200, inv.QuantityNoStock);
        Assert.Equal(85, inv.QuantityToSell);        // 110 - 25
        // (toSell 85 + onOrder 30) = 115 < (noStock 200 + target 50) = 250 -> reorder 135
        Assert.Equal(135, inv.SuggestedReorderQuantity);
    }

    [Fact]
    public async Task GetInventory_NoStockTake_FallsBackToZeroBaseline()
    {
        using var db = NewContext();
        db.Products.Add(new Product { ProductId = 5, ProductName = "Fresh", AddedOn = new DateTime(2023, 6, 1) });
        db.SaveChanges();
        var svc = new InventoryService(db);

        var inv = await svc.GetInventoryAsync(5);

        Assert.Equal(new DateTime(2023, 6, 1), inv.LastStockTakeDate);
        Assert.Equal(0, inv.LastStockTakeQuantity);
        Assert.Equal(0, inv.QuantityAvailable);
    }

    [Fact]
    public async Task GetInventory_UnknownProduct_Throws()
    {
        using var db = NewContext();
        var svc = new InventoryService(db);
        await Assert.ThrowsAsync<KeyNotFoundException>(() => svc.GetInventoryAsync(999));
    }

    [Fact]
    public async Task AllocateInventory_AssignsStatusesByOrderAge()
    {
        using var db = NewContext();
        // 100 physical on hand + 60 on an approved PO => can promise up to 160.
        db.Products.Add(new Product { ProductId = 2, ProductName = "Gadget", AddedOn = new DateTime(2022, 11, 1) });
        db.StockTakes.Add(new StockTake { StockTakeId = 1, ProductId = 2, StockTakeDate = StockTakeDate, QuantityOnHand = 100 });
        var approvedPo = new PurchaseOrder { PurchaseOrderId = 1, StatusId = (int)PurchaseOrderStatusId.Approved };
        db.PurchaseOrders.Add(approvedPo);
        db.PurchaseOrderDetails.Add(new PurchaseOrderDetail { PurchaseOrderDetailId = 1, PurchaseOrderId = 1, PurchaseOrder = approvedPo, ProductId = 2, Quantity = 60 });

        // Three open (NoStock) lines, oldest first. All start NoStock to prove re-allocation.
        void AddLine(int id, DateTime date, decimal qty)
        {
            var o = new Order { OrderId = id, OrderDate = date, OrderStatusId = (int)OrderStatusId.New };
            db.Orders.Add(o);
            db.OrderDetails.Add(new OrderDetail { OrderDetailId = id, OrderId = id, Order = o, ProductId = 2, Quantity = qty, StatusId = (int)OrderDetailStatusId.NoStock });
        }
        AddLine(1, new DateTime(2024, 1, 1), 70);   // <= 100 available  -> Allocated
        AddLine(2, new DateTime(2024, 2, 1), 50);   // 30 left, but <= onOrder pool -> OnOrder
        AddLine(3, new DateTime(2024, 3, 1), 60);   // exceeds remaining pool -> NoStock
        db.SaveChanges();

        var svc = new InventoryService(db);
        await svc.AllocateInventoryAsync(2);

        Assert.Equal((int)OrderDetailStatusId.Allocated, db.OrderDetails.Single(d => d.OrderDetailId == 1).StatusId);
        Assert.Equal((int)OrderDetailStatusId.OnOrder, db.OrderDetails.Single(d => d.OrderDetailId == 2).StatusId);
        Assert.Equal((int)OrderDetailStatusId.NoStock, db.OrderDetails.Single(d => d.OrderDetailId == 3).StatusId);
    }
}
