export interface PagedResult<T> {
  items: T[];
  totalCount: number;
  page: number;
  pageSize: number;
}

export interface Company {
  companyId: number;
  companyName: string | null;
  companyTypeId: number | null;
  companyTypeName: string | null;
  businessPhone: string | null;
  address: string | null;
  city: string | null;
  stateAbbrev: string | null;
  zip: string | null;
  website: string | null;
  notes: string | null;
  addedOn: string | null;
  modifiedOn: string | null;
}

export interface Contact {
  contactId: number;
  companyId: number | null;
  companyName: string | null;
  firstName: string | null;
  lastName: string | null;
  emailAddress: string | null;
  jobTitle: string | null;
  primaryPhone: string | null;
  secondaryPhone: string | null;
  notes: string | null;
}

export interface Product {
  productId: number;
  productName: string | null;
  productCode: string | null;
  productCategoryId: number | null;
  categoryName: string | null;
  description: string | null;
  listPrice: number | null;
  standardCost: number | null;
  discontinued: boolean | null;
}

export interface OrderDetail {
  orderDetailId: number;
  productId: number | null;
  productName: string | null;
  unitPrice: number | null;
  quantity: number | null;
  discount: number | null;
}

export interface Order {
  orderId: number;
  customerId: number | null;
  customerName: string | null;
  employeeId: number | null;
  employeeName: string | null;
  orderStatusId: number | null;
  orderDate: string | null;
  shippedDate: string | null;
  shippingFee: number | null;
  taxes: number | null;
  notes: string | null;
  orderDetails: OrderDetail[];
}

export interface Employee {
  employeeId: number;
  firstName: string | null;
  lastName: string | null;
  fullName: string | null;
  emailAddress: string | null;
  jobTitle: string | null;
  primaryPhone: string | null;
  secondaryPhone: string | null;
  title: string | null;
  notes: string | null;
  supervisorId: number | null;
  supervisorName: string | null;
  windowsUserName: string | null;
  addedOn: string | null;
  modifiedOn: string | null;
}

export interface CompanyTypeLookup {
  companyTypeId: number;
  companyType: string | null;
}

export interface ProductCategoryLookup {
  categoryId: number;
  categoryName: string | null;
  categoryCode: string | null;
}

export interface ProductCategory {
  categoryId: number;
  categoryName: string | null;
  categoryCode: string | null;
  categoryDesc: string | null;
  productCount: number;
}

export interface EmployeeLookup {
  employeeId: number;
  fullName: string | null;
}

export interface CompanyLookup {
  companyId: number;
  companyName: string | null;
}

export const ORDER_STATUSES = [
  { id: 1, name: "Closed" },
  { id: 2, name: "Invoiced" },
  { id: 3, name: "New" },
  { id: 4, name: "Shipped" },
  { id: 5, name: "Paid" },
] as const;

export type OrderStatusId = 1 | 2 | 3 | 4 | 5;

// ── Purchase Orders ───────────────────────────────────────────────────────────

export interface PurchaseOrderDetail {
  purchaseOrderDetailId: number;
  productId: number | null;
  productName: string | null;
  quantity: number | null;
  unitCost: number | null;
  receivedDate: string | null;
}

export interface PurchaseOrder {
  purchaseOrderId: number;
  vendorId: number | null;
  vendorName: string | null;
  submittedById: number | null;
  submittedByName: string | null;
  submittedDate: string | null;
  approvedById: number | null;
  approvedByName: string | null;
  approvedDate: string | null;
  statusId: number | null;
  statusName: string | null;
  receivedDate: string | null;
  shippingFee: number | null;
  taxAmount: number | null;
  paymentDate: string | null;
  paymentAmount: number | null;
  paymentMethod: string | null;
  notes: string | null;
  addedOn: string | null;
  modifiedOn: string | null;
  purchaseOrderDetails: PurchaseOrderDetail[];
}

// ── ProductVendor / StockTake ─────────────────────────────────────────────────

export interface ProductVendor {
  productVendorId: number;
  productId: number | null;
  productName: string | null;
  vendorId: number | null;
  vendorName: string | null;
}

export interface StockTake {
  stockTakeId: number;
  productId: number | null;
  productName: string | null;
  stockTakeDate: string | null;
  quantityOnHand: number | null;
  expectedQuantity: number | null;
  addedOn: string | null;
}

// ── EmployeePrivilege ─────────────────────────────────────────────────────────

export interface EmployeePrivilege {
  employeePrivilegeId: number;
  employeeId: number | null;
  privilegeId: number | null;
  privilegeName: string | null;
}

// ── Lookup extras ─────────────────────────────────────────────────────────────

export interface OrderStatusLookup {
  orderStatusId: number;
  orderStatusCode: string | null;
  orderStatusName: string | null;
}

export interface OrderDetailStatusLookup {
  orderDetailStatusId: number;
  orderDetailStatusName: string | null;
}

export interface PurchaseOrderStatusLookup {
  statusId: number;
  statusName: string | null;
}

export interface TaxStatusLookup {
  taxStatusId: number;
  taxStatusName: string | null;
}

export interface PrivilegeLookup {
  privilegeId: number;
  privilegeName: string | null;
}

export interface SystemSetting {
  settingId: number;
  settingName: string | null;
  settingValue: string | null;
  notes: string | null;
}

// ── Reports ───────────────────────────────────────────────────────────────────

export interface SalesByEmployeeRow {
  employeeId: number | null;
  employeeName: string | null;
  orderCount: number;
  revenue: number | null;
}

export interface SalesByProductRow {
  productId: number | null;
  productName: string | null;
  categoryName: string | null;
  quantitySold: number | null;
  revenue: number | null;
}

export interface SalesByProductQuarterlyRow {
  productId: number | null;
  productName: string | null;
  quarter: number;
  revenue: number | null;
}

export interface EmployeeDirectoryRow {
  employeeId: number;
  title: string | null;
  firstName: string | null;
  lastName: string | null;
  jobTitle: string | null;
  emailAddress: string | null;
  primaryPhone: string | null;
  secondaryPhone: string | null;
}

export interface ProductCatalogRow {
  productId: number;
  productCode: string | null;
  productName: string | null;
  categoryName: string | null;
  description: string | null;
  listPrice: number | null;
  standardCost: number | null;
}

export interface CustomerListRow {
  companyId: number;
  companyName: string | null;
  businessPhone: string | null;
  address: string | null;
  city: string | null;
  stateAbbrev: string | null;
  zip: string | null;
  website: string | null;
}

export interface InvoiceLine {
  productName: string | null;
  productCode: string | null;
  quantity: number | null;
  unitPrice: number | null;
  discount: number | null;
  extendedPrice: number | null;
}

export interface Invoice {
  orderId: number;
  invoiceDate: string | null;
  customerName: string | null;
  customerAddress: string | null;
  customerCity: string | null;
  customerState: string | null;
  customerZip: string | null;
  employeeName: string | null;
  shippingFee: number | null;
  taxRate: number | null;
  subtotal: number | null;
  lines: InvoiceLine[];
}

export interface PurchaseOrderFormLine {
  productName: string | null;
  productCode: string | null;
  quantity: number | null;
  unitCost: number | null;
  extendedCost: number | null;
  receivedDate: string | null;
}

export interface PurchaseOrderForm {
  purchaseOrderId: number;
  submittedDate: string | null;
  approvedDate: string | null;
  receivedDate: string | null;
  vendorName: string | null;
  vendorAddress: string | null;
  vendorCity: string | null;
  vendorState: string | null;
  vendorZip: string | null;
  submittedByName: string | null;
  approvedByName: string | null;
  statusName: string | null;
  shippingFee: number | null;
  taxAmount: number | null;
  paymentMethod: string | null;
  subtotal: number | null;
  notes: string | null;
  lines: PurchaseOrderFormLine[];
}

export interface ProductInventory {
  productId: number;
  lastStockTakeDate: string;
  lastStockTakeQuantity: number;
  quantityAvailable: number;
  quantityAllocated: number;
  quantityOnOrder: number;
  quantityNoStock: number;
  quantityToSell: number;
  suggestedReorderQuantity: number;
}


