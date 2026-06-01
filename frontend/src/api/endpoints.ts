import { apiClient } from "./client";
import type {
  Company, CompanyLookup, CompanyTypeLookup,
  Contact, CustomerListRow, Employee, EmployeeDirectoryRow, EmployeeLookup, EmployeePrivilege,
  Invoice, Order, OrderDetailStatusLookup, OrderStatusLookup,
  PagedResult, PrivilegeLookup, Product, ProductCategory, ProductCatalogRow, ProductCategoryLookup,
  ProductInventory, ProductVendor, PurchaseOrder, PurchaseOrderForm, PurchaseOrderStatusLookup,
  SalesByEmployeeRow, SalesByProductQuarterlyRow, SalesByProductRow,
  StockTake, SystemSetting, TaxStatusLookup,
} from "./types";

// ── Companies ────────────────────────────────────────────────────────────────

export const companiesApi = {
  list: (params?: { search?: string; page?: number; pageSize?: number }) =>
    apiClient.get<PagedResult<Company>>("/api/companies", { params }).then((r) => r.data),
  get: (id: number) =>
    apiClient.get<Company>(`/api/companies/${id}`).then((r) => r.data),
  create: (data: Partial<Company>) =>
    apiClient.post<Company>("/api/companies", data).then((r) => r.data),
  update: (id: number, data: Partial<Company>) =>
    apiClient.put(`/api/companies/${id}`, data),
  delete: (id: number) =>
    apiClient.delete(`/api/companies/${id}`),
};

// ── Contacts ─────────────────────────────────────────────────────────────────

export const contactsApi = {
  list: (params?: { search?: string; companyId?: number; page?: number; pageSize?: number }) =>
    apiClient.get<PagedResult<Contact>>("/api/contacts", { params }).then((r) => r.data),
  get: (id: number) =>
    apiClient.get<Contact>(`/api/contacts/${id}`).then((r) => r.data),
  create: (data: Partial<Contact>) =>
    apiClient.post<Contact>("/api/contacts", data).then((r) => r.data),
  update: (id: number, data: Partial<Contact>) =>
    apiClient.put(`/api/contacts/${id}`, data),
  delete: (id: number) =>
    apiClient.delete(`/api/contacts/${id}`),
};

// ── Products ─────────────────────────────────────────────────────────────────

export const productsApi = {
  list: (params?: { search?: string; categoryId?: number; discontinued?: boolean; page?: number; pageSize?: number }) =>
    apiClient.get<PagedResult<Product>>("/api/products", { params }).then((r) => r.data),
  get: (id: number) =>
    apiClient.get<Product>(`/api/products/${id}`).then((r) => r.data),
  create: (data: Partial<Product>) =>
    apiClient.post<Product>("/api/products", data).then((r) => r.data),
  update: (id: number, data: Partial<Product>) =>
    apiClient.put(`/api/products/${id}`, data),
  delete: (id: number) =>
    apiClient.delete(`/api/products/${id}`),  // Orders / POs that contain this product
  orders: (productId: number, params?: { page?: number; pageSize?: number }) =>
    apiClient.get<PagedResult<Order>>(`/api/products/${productId}/orders`, { params }).then((r) => r.data),
  purchaseOrders: (productId: number, params?: { page?: number; pageSize?: number }) =>
    apiClient.get<PagedResult<PurchaseOrder>>(`/api/products/${productId}/purchase-orders`, { params }).then((r) => r.data),
  inventory: (productId: number) =>
    apiClient.get<ProductInventory>(`/api/products/${productId}/inventory`).then((r) => r.data),
};

// ── Product Categories ─────────────────────────────────────────────────────

export const productCategoriesApi = {
  list: () =>
    apiClient.get<ProductCategoryLookup[]>("/api/products/categories").then((r) => r.data),
  get: (id: number) =>
    apiClient.get<ProductCategory>(`/api/products/categories/${id}`).then((r) => r.data),
  create: (data: { categoryName?: string; categoryCode?: string; categoryDesc?: string }) =>
    apiClient.post<ProductCategory>("/api/products/categories", data).then((r) => r.data),
  update: (id: number, data: { categoryName?: string; categoryCode?: string; categoryDesc?: string }) =>
    apiClient.put(`/api/products/categories/${id}`, data),
  delete: (id: number) =>
    apiClient.delete(`/api/products/categories/${id}`),};

// ── Orders ───────────────────────────────────────────────────────────────────

export const ordersApi = {
  list: (params?: { customerId?: number; employeeId?: number; statusId?: number; page?: number; pageSize?: number }) =>
    apiClient.get<PagedResult<Order>>("/api/orders", { params }).then((r) => r.data),
  get: (id: number) =>
    apiClient.get<Order>(`/api/orders/${id}`).then((r) => r.data),
  create: (data: Partial<Order>) =>
    apiClient.post<Order>("/api/orders", data).then((r) => r.data),
  update: (id: number, data: Partial<Order>) =>
    apiClient.put(`/api/orders/${id}`, data),
  delete: (id: number) =>
    apiClient.delete(`/api/orders/${id}`),
  addDetail: (orderId: number, data: { productId?: number | null; unitPrice?: number | null; quantity?: number | null; discount?: number | null }) =>
    apiClient.post(`/api/orders/${orderId}/details`, data).then((r) => r.data),
  deleteDetail: (orderId: number, detailId: number) =>
    apiClient.delete(`/api/orders/${orderId}/details/${detailId}`),
  // Workflow transitions (ported from frmOrderDetails)
  invoice: (id: number) =>
    apiClient.post(`/api/orders/${id}/invoice`),
  ship: (id: number, data: { shippedDate?: string | null; shipperId?: number | null; shippingFee?: number | null }) =>
    apiClient.post(`/api/orders/${id}/ship`, data),
  pay: (id: number, data: { paymentMethod?: string | null; paidDate?: string | null }) =>
    apiClient.post(`/api/orders/${id}/pay`, data),
  close: (id: number) =>
    apiClient.post(`/api/orders/${id}/close`),
};

// ── Employees ───────────────────────────────────────────────────────────────────

export const employeesApi = {
  list: (params?: { search?: string; page?: number; pageSize?: number }) =>
    apiClient.get<PagedResult<Employee>>("/api/employees", { params }).then((r) => r.data),
  get: (id: number) =>
    apiClient.get<Employee>(`/api/employees/${id}`).then((r) => r.data),
  create: (data: Partial<Employee>) =>
    apiClient.post<Employee>("/api/employees", data).then((r) => r.data),
  update: (id: number, data: Partial<Employee>) =>
    apiClient.put(`/api/employees/${id}`, data),
  delete: (id: number) =>
    apiClient.delete(`/api/employees/${id}`),
  orders: (employeeId: number, params?: { page?: number; pageSize?: number }) =>
    apiClient.get<PagedResult<Order>>(`/api/employees/${employeeId}/orders`, { params }).then((r) => r.data),
  titles: () =>
    apiClient.get<string[]>("/api/employees/titles").then((r) => r.data),
};

// ── Lookups ───────────────────────────────────────────────────────────────────

export const lookupsApi = {
  companyTypes: () =>
    apiClient.get<CompanyTypeLookup[]>("/api/companies/types").then((r) => r.data),
  companiesLookup: (companyTypeId?: number) =>
    apiClient.get<CompanyLookup[]>("/api/companies/lookup", { params: { companyTypeId } }).then((r) => r.data),
  productCategories: () =>
    apiClient.get<ProductCategoryLookup[]>("/api/products/categories").then((r) => r.data),
  employeesLookup: () =>
    apiClient.get<EmployeeLookup[]>("/api/employees/lookup").then((r) => r.data),
  orderStatuses: () =>
    apiClient.get<OrderStatusLookup[]>("/api/admin/order-statuses").then((r) => r.data),
  orderDetailStatuses: () =>
    apiClient.get<OrderDetailStatusLookup[]>("/api/admin/order-detail-statuses").then((r) => r.data),
  purchaseOrderStatuses: () =>
    apiClient.get<PurchaseOrderStatusLookup[]>("/api/admin/purchase-order-statuses").then((r) => r.data),
  taxStatuses: () =>
    apiClient.get<TaxStatusLookup[]>("/api/admin/tax-statuses").then((r) => r.data),
  privileges: () =>
    apiClient.get<PrivilegeLookup[]>("/api/admin/privileges").then((r) => r.data),
};

// ── Purchase Orders ───────────────────────────────────────────────────────────

export const purchaseOrdersApi = {
  list: (params?: { vendorId?: number; statusId?: number; page?: number; pageSize?: number }) =>
    apiClient.get<PagedResult<PurchaseOrder>>("/api/purchase-orders", { params }).then((r) => r.data),
  get: (id: number) =>
    apiClient.get<PurchaseOrder>(`/api/purchase-orders/${id}`).then((r) => r.data),
  create: (data: Partial<PurchaseOrder>) =>
    apiClient.post<PurchaseOrder>("/api/purchase-orders", data).then((r) => r.data),
  update: (id: number, data: Partial<PurchaseOrder>) =>
    apiClient.put(`/api/purchase-orders/${id}`, data),
  delete: (id: number) =>
    apiClient.delete(`/api/purchase-orders/${id}`),
  addDetail: (purchaseOrderId: number, data: { productId: number; quantity: number; unitCost: number }) =>
    apiClient.post(`/api/purchase-orders/${purchaseOrderId}/details`, data).then((r) => r.data),
  deleteDetail: (purchaseOrderId: number, detailId: number) =>
    apiClient.delete(`/api/purchase-orders/${purchaseOrderId}/details/${detailId}`),
};

// ── Product Vendors / StockTake ───────────────────────────────────────────────

export const productVendorsApi = {
  list: (productId: number) =>
    apiClient.get<ProductVendor[]>(`/api/products/${productId}/vendors`).then((r) => r.data),
  add: (productId: number, vendorId: number) =>
    apiClient.post(`/api/products/${productId}/vendors`, { vendorId }),
  remove: (productId: number, productVendorId: number) =>
    apiClient.delete(`/api/products/${productId}/vendors/${productVendorId}`),
};

export const stockTakesApi = {
  list: (productId: number) =>
    apiClient.get<StockTake[]>(`/api/products/${productId}/stock-takes`).then((r) => r.data),
  add: (productId: number, data: { stockTakeDate?: string; quantityOnHand?: number; expectedQuantity?: number }) =>
    apiClient.post(`/api/products/${productId}/stock-takes`, data),
  update: (productId: number, stockTakeId: number, data: { stockTakeDate?: string; quantityOnHand?: number; expectedQuantity?: number }) =>
    apiClient.put(`/api/products/${productId}/stock-takes/${stockTakeId}`, data),
  delete: (productId: number, stockTakeId: number) =>
    apiClient.delete(`/api/products/${productId}/stock-takes/${stockTakeId}`),
};

// ── Employee Privileges ───────────────────────────────────────────────────────

export const employeePrivilegesApi = {
  list: (employeeId: number) =>
    apiClient.get<EmployeePrivilege[]>(`/api/employees/${employeeId}/privileges`).then((r) => r.data),
  add: (employeeId: number, privilegeId: number) =>
    apiClient.post(`/api/employees/${employeeId}/privileges`, privilegeId, {
      headers: { "Content-Type": "application/json" },
    }),
  remove: (employeeId: number, privilegeId: number) =>
    apiClient.delete(`/api/employees/${employeeId}/privileges/${privilegeId}`),
};

// ── Admin ─────────────────────────────────────────────────────────────────────

export const adminApi = {
  getSettings: () =>
    apiClient.get<SystemSetting[]>("/api/admin/settings").then((r) => r.data),
  updateSetting: (id: number, settingValue: string) =>
    apiClient.put(`/api/admin/settings/${id}`, { settingValue }),
};

// ── Company sub-resources ─────────────────────────────────────────────────────

export const companyOrdersApi = {
  shipperOrders: (companyId: number, params?: { page?: number; pageSize?: number }) =>
    apiClient.get<PagedResult<Order>>(`/api/companies/${companyId}/shipper-orders`, { params }).then((r) => r.data),
  vendorPurchaseOrders: (companyId: number, params?: { page?: number; pageSize?: number }) =>
    apiClient.get<PagedResult<PurchaseOrder>>(`/api/companies/${companyId}/purchase-orders`, { params }).then((r) => r.data),
};

// ── Reports ───────────────────────────────────────────────────────────────────

export const reportsApi = {
  salesByEmployee: (year?: number) =>
    apiClient.get<SalesByEmployeeRow[]>("/api/reports/sales-by-employee", { params: { year } }).then((r) => r.data),
  salesByProduct: (year?: number) =>
    apiClient.get<SalesByProductRow[]>("/api/reports/sales-by-product", { params: { year } }).then((r) => r.data),
  salesByProductQuarterly: (year?: number) =>
    apiClient.get<SalesByProductQuarterlyRow[]>("/api/reports/sales-by-product-quarterly", { params: { year } }).then((r) => r.data),
  employeeDirectory: () =>
    apiClient.get<EmployeeDirectoryRow[]>("/api/reports/employee-directory").then((r) => r.data),
  productCatalog: () =>
    apiClient.get<ProductCatalogRow[]>("/api/reports/product-catalog").then((r) => r.data),
  customerList: () =>
    apiClient.get<CustomerListRow[]>("/api/reports/customer-list").then((r) => r.data),
  invoice: (orderId: number) =>
    apiClient.get<Invoice>(`/api/reports/invoice/${orderId}`).then((r) => r.data),
  purchaseOrderForm: (purchaseOrderId: number) =>
    apiClient.get<PurchaseOrderForm>(`/api/reports/purchase-order/${purchaseOrderId}`).then((r) => r.data),
};
