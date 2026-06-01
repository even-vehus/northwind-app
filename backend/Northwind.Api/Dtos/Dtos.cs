namespace Northwind.Api.Dtos;

// ── Company ──────────────────────────────────────────────────────────────────

public record CompanyDto(
    int CompanyId,
    string? CompanyName,
    int? CompanyTypeId,
    string? CompanyTypeName,
    string? BusinessPhone,
    string? Address,
    string? City,
    string? StateAbbrev,
    string? Zip,
    string? Website,
    string? Notes,
    DateTime? AddedOn,
    DateTime? ModifiedOn
);

public record CreateCompanyRequest(
    string? CompanyName,
    int? CompanyTypeId,
    string? BusinessPhone,
    string? Address,
    string? City,
    string? StateAbbrev,
    string? Zip,
    string? Website,
    string? Notes
);

public record UpdateCompanyRequest(
    string? CompanyName,
    int? CompanyTypeId,
    string? BusinessPhone,
    string? Address,
    string? City,
    string? StateAbbrev,
    string? Zip,
    string? Website,
    string? Notes
);

// ── Contact ──────────────────────────────────────────────────────────────────

public record ContactDto(
    int ContactId,
    int? CompanyId,
    string? CompanyName,
    string? FirstName,
    string? LastName,
    string? EmailAddress,
    string? JobTitle,
    string? PrimaryPhone,
    string? SecondaryPhone,
    string? Notes
);

public record CreateContactRequest(
    int? CompanyId,
    string? FirstName,
    string? LastName,
    string? EmailAddress,
    string? JobTitle,
    string? PrimaryPhone,
    string? SecondaryPhone,
    string? Notes
);

public record UpdateContactRequest(
    int? CompanyId,
    string? FirstName,
    string? LastName,
    string? EmailAddress,
    string? JobTitle,
    string? PrimaryPhone,
    string? SecondaryPhone,
    string? Notes
);

// ── Product ──────────────────────────────────────────────────────────────────

public record ProductDto(
    int ProductId,
    string? ProductName,
    string? ProductCode,
    int? ProductCategoryId,
    string? CategoryName,
    string? Description,
    decimal? ListPrice,
    decimal? StandardCost,
    bool? Discontinued
);

public record CreateProductRequest(
    string? ProductName,
    string? ProductCode,
    int? ProductCategoryId,
    string? Description,
    decimal? ListPrice,
    decimal? StandardCost,
    bool? Discontinued
);

public record UpdateProductRequest(
    string? ProductName,
    string? ProductCode,
    int? ProductCategoryId,
    string? Description,
    decimal? ListPrice,
    decimal? StandardCost,
    bool? Discontinued
);

// ── Order ────────────────────────────────────────────────────────────────────

public record OrderDto(
    int OrderId,
    int? CustomerId,
    string? CustomerName,
    int? EmployeeId,
    string? EmployeeName,
    int? OrderStatusId,
    DateTime? OrderDate,
    DateTime? ShippedDate,
    decimal? ShippingFee,
    decimal? Taxes,
    string? Notes,
    IReadOnlyList<OrderDetailDto> OrderDetails
);

public record CreateOrderRequest(
    int? CustomerId,
    int? EmployeeId,
    DateTime? OrderDate,
    string? Notes,
    IReadOnlyList<CreateOrderDetailRequest> OrderDetails
);

public record UpdateOrderRequest(
    int? CustomerId,
    int? EmployeeId,
    int? OrderStatusId,
    DateTime? OrderDate,
    DateTime? ShippedDate,
    decimal? ShippingFee,
    string? Notes
);

// ── Lookups ──────────────────────────────────────────────────────────────────

public record CompanyTypeLookupDto(int CompanyTypeId, string? CompanyType);
public record ProductCategoryLookupDto(int CategoryId, string? CategoryName, string? CategoryCode);
public record EmployeeLookupDto(int EmployeeId, string? FullName);
public record CompanyLookupDto(int CompanyId, string? CompanyName);

// ── Employee ─────────────────────────────────────────────────────────────────

public record EmployeeDto(
    int EmployeeId,
    string? FirstName,
    string? LastName,
    string? FullName,
    string? EmailAddress,
    string? JobTitle,
    string? PrimaryPhone,
    string? SecondaryPhone,
    string? Title,
    string? Notes,
    int? SupervisorId,
    string? SupervisorName,
    string? WindowsUserName,
    DateTime? AddedOn,
    DateTime? ModifiedOn
);

public record CreateEmployeeRequest(
    string? FirstName,
    string? LastName,
    string? EmailAddress,
    string? JobTitle,
    string? PrimaryPhone,
    string? SecondaryPhone,
    string? Title,
    string? Notes,
    int? SupervisorId,
    string? WindowsUserName
);

public record UpdateEmployeeRequest(
    string? FirstName,
    string? LastName,
    string? EmailAddress,
    string? JobTitle,
    string? PrimaryPhone,
    string? SecondaryPhone,
    string? Title,
    string? Notes,
    int? SupervisorId,
    string? WindowsUserName
);

// ── OrderDetail ──────────────────────────────────────────────────────────────

public record OrderDetailDto(
    int OrderDetailId,
    int? ProductId,
    string? ProductName,
    decimal? UnitPrice,
    int? Quantity,
    double? Discount
);

public record CreateOrderDetailRequest(
    int ProductId,
    decimal UnitPrice,
    int Quantity,
    double Discount = 0
);

// ── Paging ───────────────────────────────────────────────────────────────────

public record PagedResult<T>(
    IReadOnlyList<T> Items,
    int TotalCount,
    int Page,
    int PageSize
);

// ── PurchaseOrder ─────────────────────────────────────────────────────────────

public record PurchaseOrderDto(
    int PurchaseOrderId,
    int? VendorId,
    string? VendorName,
    int? SubmittedById,
    string? SubmittedByName,
    DateTime? SubmittedDate,
    int? ApprovedById,
    string? ApprovedByName,
    DateTime? ApprovedDate,
    int? StatusId,
    string? StatusName,
    DateTime? ReceivedDate,
    decimal? ShippingFee,
    decimal? TaxAmount,
    DateTime? PaymentDate,
    decimal? PaymentAmount,
    string? PaymentMethod,
    string? Notes,
    DateTime? AddedOn,
    DateTime? ModifiedOn,
    IReadOnlyList<PurchaseOrderDetailDto> PurchaseOrderDetails
);

public record CreatePurchaseOrderRequest(
    int? VendorId,
    int? SubmittedById,
    DateTime? SubmittedDate,
    int? StatusId,
    string? Notes,
    IReadOnlyList<CreatePurchaseOrderDetailRequest> PurchaseOrderDetails
);

public record UpdatePurchaseOrderRequest(
    int? VendorId,
    int? SubmittedById,
    DateTime? SubmittedDate,
    int? ApprovedById,
    DateTime? ApprovedDate,
    int? StatusId,
    DateTime? ReceivedDate,
    decimal? ShippingFee,
    decimal? TaxAmount,
    DateTime? PaymentDate,
    decimal? PaymentAmount,
    string? PaymentMethod,
    string? Notes
);

public record PurchaseOrderDetailDto(
    int PurchaseOrderDetailId,
    int? ProductId,
    string? ProductName,
    int? Quantity,
    decimal? UnitCost,
    DateTime? ReceivedDate
);

public record CreatePurchaseOrderDetailRequest(
    int ProductId,
    int Quantity,
    decimal UnitCost
);

// ── ProductVendor ─────────────────────────────────────────────────────────────

public record ProductVendorDto(
    int ProductVendorId,
    int? ProductId,
    string? ProductName,
    int? VendorId,
    string? VendorName
);

public record CreateProductVendorRequest(int VendorId);

// ── StockTake ─────────────────────────────────────────────────────────────────

public record StockTakeDto(
    int StockTakeId,
    int? ProductId,
    string? ProductName,
    DateTime? StockTakeDate,
    int? QuantityOnHand,
    int? ExpectedQuantity,
    DateTime? AddedOn
);

public record CreateStockTakeRequest(
    DateTime? StockTakeDate,
    int? QuantityOnHand,
    int? ExpectedQuantity
);

public record UpdateStockTakeRequest(
    DateTime? StockTakeDate,
    int? QuantityOnHand,
    int? ExpectedQuantity
);

// ── Lookup extras ─────────────────────────────────────────────────────────────

public record OrderDetailStatusDto(int OrderDetailStatusId, string? OrderDetailStatusName);
public record OrderStatusDto(int OrderStatusId, string? OrderStatusCode, string? OrderStatusName);
public record TaxStatusDto(int TaxStatusId, string? TaxStatusName);
public record PrivilegeDto(int PrivilegeId, string? PrivilegeName);
public record PurchaseOrderStatusDto(int StatusId, string? StatusName);

public record EmployeePrivilegeDto(
    int EmployeePrivilegeId,
    int? EmployeeId,
    int? PrivilegeId,
    string? PrivilegeName
);

public record SystemSettingDto(
    int SettingId,
    string? SettingName,
    string? SettingValue,
    string? Notes
);

public record UpdateSystemSettingRequest(string? SettingValue);

// ── Reports ───────────────────────────────────────────────────────────────────

public record SalesByEmployeeRow(
    int? EmployeeId,
    string? EmployeeName,
    int OrderCount,
    decimal? Revenue
);

public record SalesByProductRow(
    int? ProductId,
    string? ProductName,
    string? CategoryName,
    decimal? QuantitySold,
    decimal? Revenue
);

public record SalesByProductQuarterlyRow(
    int? ProductId,
    string? ProductName,
    int Quarter,
    decimal? Revenue
);

public record EmployeeDirectoryRow(
    int EmployeeId,
    string? Title,
    string? FirstName,
    string? LastName,
    string? JobTitle,
    string? EmailAddress,
    string? PrimaryPhone,
    string? SecondaryPhone
);

public record ProductCatalogRow(
    int ProductId,
    string? ProductCode,
    string? ProductName,
    string? CategoryName,
    string? Description,
    decimal? ListPrice,
    decimal? StandardCost
);

public record CustomerListRow(
    int CompanyId,
    string? CompanyName,
    string? BusinessPhone,
    string? Address,
    string? City,
    string? StateAbbrev,
    string? Zip,
    string? Website
);

public record InvoiceLineDto(
    string? ProductName,
    string? ProductCode,
    decimal? Quantity,
    decimal? UnitPrice,
    double? Discount,
    decimal? ExtendedPrice
);

public record InvoiceDto(
    int OrderId,
    DateTime? InvoiceDate,
    string? CustomerName,
    string? CustomerAddress,
    string? CustomerCity,
    string? CustomerState,
    string? CustomerZip,
    string? EmployeeName,
    decimal? ShippingFee,
    double? TaxRate,
    decimal? Subtotal,
    IReadOnlyList<InvoiceLineDto> Lines
);

// ── Product Category (full CRUD) ──────────────────────────────────────────────

public record ProductCategoryDto(
    int CategoryId,
    string? CategoryName,
    string? CategoryCode,
    string? CategoryDesc,
    int ProductCount
);

public record CreateProductCategoryRequest(
    string? CategoryName,
    string? CategoryCode,
    string? CategoryDesc
);

public record UpdateProductCategoryRequest(
    string? CategoryName,
    string? CategoryCode,
    string? CategoryDesc
);

// ── Purchase Order print form ─────────────────────────────────────────────────

public record PurchaseOrderFormLineDto(
    string? ProductName,
    string? ProductCode,
    decimal? Quantity,
    decimal? UnitCost,
    decimal? ExtendedCost,
    DateTime? ReceivedDate
);

public record PurchaseOrderFormDto(
    int PurchaseOrderId,
    DateTime? SubmittedDate,
    DateTime? ApprovedDate,
    DateTime? ReceivedDate,
    string? VendorName,
    string? VendorAddress,
    string? VendorCity,
    string? VendorState,
    string? VendorZip,
    string? SubmittedByName,
    string? ApprovedByName,
    string? StatusName,
    decimal? ShippingFee,
    decimal? TaxAmount,
    string? PaymentMethod,
    decimal? Subtotal,
    string? Notes,
    IReadOnlyList<PurchaseOrderFormLineDto> Lines
);

// ── Inventory (ported from modInventory) ─────────────────────────────────────

public record ProductInventoryDto(
    int ProductId,
    DateTime LastStockTakeDate,
    int LastStockTakeQuantity,
    int QuantityAvailable,
    int QuantityAllocated,
    int QuantityOnOrder,
    int QuantityNoStock,
    int QuantityToSell,
    int SuggestedReorderQuantity
);


