import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  adminApi, companiesApi, companyOrdersApi, contactsApi, employeesApi,
  employeePrivilegesApi, lookupsApi, ordersApi, productsApi, productCategoriesApi,
  productVendorsApi, purchaseOrdersApi, reportsApi, stockTakesApi,
} from "./endpoints";

// ── Companies ────────────────────────────────────────────────────────────────

export const useCompanies = (params?: { search?: string; page?: number; pageSize?: number }) =>
  useQuery({ queryKey: ["companies", params], queryFn: () => companiesApi.list(params) });

export const useCompany = (id: number) =>
  useQuery({ queryKey: ["companies", id], queryFn: () => companiesApi.get(id), enabled: !!id });

export const useCreateCompany = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: companiesApi.create,
    onSuccess: () => qc.invalidateQueries({ queryKey: ["companies"] }),
  });
};

export const useUpdateCompany = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ id, data }: { id: number; data: Parameters<typeof companiesApi.update>[1] }) =>
      companiesApi.update(id, data),
    onSuccess: () => qc.invalidateQueries({ queryKey: ["companies"] }),
  });
};

export const useDeleteCompany = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: companiesApi.delete,
    onSuccess: () => qc.invalidateQueries({ queryKey: ["companies"] }),
  });
};

// ── Contacts ─────────────────────────────────────────────────────────────────

export const useContacts = (params?: Parameters<typeof contactsApi.list>[0]) =>
  useQuery({ queryKey: ["contacts", params], queryFn: () => contactsApi.list(params) });

export const useContact = (id: number) =>
  useQuery({ queryKey: ["contacts", id], queryFn: () => contactsApi.get(id), enabled: id > 0 });

export const useCreateContact = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: contactsApi.create,
    onSuccess: () => qc.invalidateQueries({ queryKey: ["contacts"] }),
  });
};

export const useUpdateContact = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ id, data }: { id: number; data: Parameters<typeof contactsApi.update>[1] }) =>
      contactsApi.update(id, data),
    onSuccess: () => qc.invalidateQueries({ queryKey: ["contacts"] }),
  });
};

export const useDeleteContact = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: contactsApi.delete,
    onSuccess: () => qc.invalidateQueries({ queryKey: ["contacts"] }),
  });
};

// ── Products ─────────────────────────────────────────────────────────────────

export const useProducts = (params?: Parameters<typeof productsApi.list>[0]) =>
  useQuery({ queryKey: ["products", params], queryFn: () => productsApi.list(params) });

export const useProduct = (id: number) =>
  useQuery({ queryKey: ["products", id], queryFn: () => productsApi.get(id), enabled: !!id });

export const useCreateProduct = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: productsApi.create,
    onSuccess: () => qc.invalidateQueries({ queryKey: ["products"] }),
  });
};

export const useUpdateProduct = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ id, data }: { id: number; data: Parameters<typeof productsApi.update>[1] }) =>
      productsApi.update(id, data),
    onSuccess: () => qc.invalidateQueries({ queryKey: ["products"] }),
  });
};

export const useDeleteProduct = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: productsApi.delete,
    onSuccess: () => qc.invalidateQueries({ queryKey: ["products"] }),
  });
};

// ── Orders ───────────────────────────────────────────────────────────────────

export const useOrders = (params?: Parameters<typeof ordersApi.list>[0]) =>
  useQuery({ queryKey: ["orders", params], queryFn: () => ordersApi.list(params) });

export const useOrder = (id: number) =>
  useQuery({ queryKey: ["orders", id], queryFn: () => ordersApi.get(id), enabled: !!id });

export const useCreateOrder = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ordersApi.create,
    onSuccess: () => qc.invalidateQueries({ queryKey: ["orders"] }),
  });
};

export const useUpdateOrder = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ id, data }: { id: number; data: Parameters<typeof ordersApi.update>[1] }) =>
      ordersApi.update(id, data),
    onSuccess: () => qc.invalidateQueries({ queryKey: ["orders"] }),
  });
};

export const useDeleteOrder = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ordersApi.delete,
    onSuccess: () => qc.invalidateQueries({ queryKey: ["orders"] }),
  });
};

export const useAddOrderDetail = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ orderId, data }: { orderId: number; data: Parameters<typeof ordersApi.addDetail>[1] }) =>
      ordersApi.addDetail(orderId, data),
    onSuccess: (_d, { orderId }) => qc.invalidateQueries({ queryKey: ["orders", orderId] }),
  });
};

export const useDeleteOrderDetail = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ orderId, detailId }: { orderId: number; detailId: number }) =>
      ordersApi.deleteDetail(orderId, detailId),
    onSuccess: (_d, { orderId }) => qc.invalidateQueries({ queryKey: ["orders", orderId] }),
  });
};

// ── Employees ─────────────────────────────────────────────────────────────────

export const useEmployees = (params?: Parameters<typeof employeesApi.list>[0]) =>
  useQuery({ queryKey: ["employees", params], queryFn: () => employeesApi.list(params) });

export const useEmployee = (id: number) =>
  useQuery({ queryKey: ["employees", id], queryFn: () => employeesApi.get(id), enabled: id > 0 });

export const useCreateEmployee = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: employeesApi.create,
    onSuccess: () => qc.invalidateQueries({ queryKey: ["employees"] }),
  });
};

export const useUpdateEmployee = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ id, data }: { id: number; data: Parameters<typeof employeesApi.update>[1] }) =>
      employeesApi.update(id, data),
    onSuccess: (_d, { id }) => qc.invalidateQueries({ queryKey: ["employees", id] }),
  });
};

export const useDeleteEmployee = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: employeesApi.delete,
    onSuccess: () => qc.invalidateQueries({ queryKey: ["employees"] }),
  });
};

// ── Lookups ─────────────────────────────────────────────────────────────────

export const useCompanyTypes = () =>
  useQuery({ queryKey: ["companyTypes"], queryFn: lookupsApi.companyTypes, staleTime: 5 * 60 * 1000 });

export const useProductCategories = () =>
  useQuery({ queryKey: ["productCategories"], queryFn: lookupsApi.productCategories, staleTime: 5 * 60 * 1000 });

export const useCompaniesLookup = () =>
  useQuery({ queryKey: ["companiesLookup"], queryFn: () => lookupsApi.companiesLookup(), staleTime: 5 * 60 * 1000 });

// Shipper = CompanyTypeID 2 (Customer=1, Shipper=2, Vendor=3, Northwind=4)
export const useShippers = () =>
  useQuery({ queryKey: ["companiesLookup", "shippers"], queryFn: () => lookupsApi.companiesLookup(2), staleTime: 5 * 60 * 1000 });

export const useEmployeesLookup = () =>
  useQuery({ queryKey: ["employeesLookup"], queryFn: lookupsApi.employeesLookup, staleTime: 5 * 60 * 1000 });

export const useOrderStatuses = () =>
  useQuery({ queryKey: ["orderStatuses"], queryFn: lookupsApi.orderStatuses, staleTime: 5 * 60 * 1000 });

export const useOrderDetailStatuses = () =>
  useQuery({ queryKey: ["orderDetailStatuses"], queryFn: lookupsApi.orderDetailStatuses, staleTime: 5 * 60 * 1000 });

export const usePurchaseOrderStatuses = () =>
  useQuery({ queryKey: ["purchaseOrderStatuses"], queryFn: lookupsApi.purchaseOrderStatuses, staleTime: 5 * 60 * 1000 });

export const useTaxStatuses = () =>
  useQuery({ queryKey: ["taxStatuses"], queryFn: lookupsApi.taxStatuses, staleTime: 5 * 60 * 1000 });

export const usePrivileges = () =>
  useQuery({ queryKey: ["privileges"], queryFn: lookupsApi.privileges, staleTime: 5 * 60 * 1000 });

// ── Purchase Orders ────────────────────────────────────────────────────────────

export const usePurchaseOrders = (params?: Parameters<typeof purchaseOrdersApi.list>[0]) =>
  useQuery({ queryKey: ["purchase-orders", params], queryFn: () => purchaseOrdersApi.list(params) });

export const usePurchaseOrder = (id: number) =>
  useQuery({ queryKey: ["purchase-orders", id], queryFn: () => purchaseOrdersApi.get(id), enabled: id > 0 });

export const useCreatePurchaseOrder = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: purchaseOrdersApi.create,
    onSuccess: () => qc.invalidateQueries({ queryKey: ["purchase-orders"] }),
  });
};

export const useUpdatePurchaseOrder = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ id, data }: { id: number; data: Parameters<typeof purchaseOrdersApi.update>[1] }) =>
      purchaseOrdersApi.update(id, data),
    onSuccess: (_d, { id }) => qc.invalidateQueries({ queryKey: ["purchase-orders", id] }),
  });
};

export const useDeletePurchaseOrder = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: purchaseOrdersApi.delete,
    onSuccess: () => qc.invalidateQueries({ queryKey: ["purchase-orders"] }),
  });
};

export const useAddPurchaseOrderDetail = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ purchaseOrderId, data }: { purchaseOrderId: number; data: Parameters<typeof purchaseOrdersApi.addDetail>[1] }) =>
      purchaseOrdersApi.addDetail(purchaseOrderId, data),
    onSuccess: (_d, { purchaseOrderId }) => qc.invalidateQueries({ queryKey: ["purchase-orders", purchaseOrderId] }),
  });
};

export const useDeletePurchaseOrderDetail = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ purchaseOrderId, detailId }: { purchaseOrderId: number; detailId: number }) =>
      purchaseOrdersApi.deleteDetail(purchaseOrderId, detailId),
    onSuccess: (_d, { purchaseOrderId }) => qc.invalidateQueries({ queryKey: ["purchase-orders", purchaseOrderId] }),
  });
};

// ── Product Vendors / StockTake ───────────────────────────────────────────────

export const useProductVendors = (productId: number) =>
  useQuery({ queryKey: ["product-vendors", productId], queryFn: () => productVendorsApi.list(productId), enabled: productId > 0 });

export const useAddProductVendor = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ productId, vendorId }: { productId: number; vendorId: number }) =>
      productVendorsApi.add(productId, vendorId),
    onSuccess: (_d, { productId }) => qc.invalidateQueries({ queryKey: ["product-vendors", productId] }),
  });
};

export const useRemoveProductVendor = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ productId, productVendorId }: { productId: number; productVendorId: number }) =>
      productVendorsApi.remove(productId, productVendorId),
    onSuccess: (_d, { productId }) => qc.invalidateQueries({ queryKey: ["product-vendors", productId] }),
  });
};

export const useStockTakes = (productId: number) =>
  useQuery({ queryKey: ["stock-takes", productId], queryFn: () => stockTakesApi.list(productId), enabled: productId > 0 });

export const useAddStockTake = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ productId, data }: { productId: number; data: Parameters<typeof stockTakesApi.add>[1] }) =>
      stockTakesApi.add(productId, data),
    onSuccess: (_d, { productId }) => qc.invalidateQueries({ queryKey: ["stock-takes", productId] }),
  });
};

export const useDeleteStockTake = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ productId, stockTakeId }: { productId: number; stockTakeId: number }) =>
      stockTakesApi.delete(productId, stockTakeId),
    onSuccess: (_d, { productId }) => qc.invalidateQueries({ queryKey: ["stock-takes", productId] }),
  });
};

// ── Employee Privileges ───────────────────────────────────────────────────────

export const useEmployeePrivileges = (employeeId: number) =>
  useQuery({ queryKey: ["employee-privileges", employeeId], queryFn: () => employeePrivilegesApi.list(employeeId), enabled: employeeId > 0 });

export const useAddEmployeePrivilege = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ employeeId, privilegeId }: { employeeId: number; privilegeId: number }) =>
      employeePrivilegesApi.add(employeeId, privilegeId),
    onSuccess: (_d, { employeeId }) => qc.invalidateQueries({ queryKey: ["employee-privileges", employeeId] }),
  });
};

export const useRemoveEmployeePrivilege = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ employeeId, privilegeId }: { employeeId: number; privilegeId: number }) =>
      employeePrivilegesApi.remove(employeeId, privilegeId),
    onSuccess: (_d, { employeeId }) => qc.invalidateQueries({ queryKey: ["employee-privileges", employeeId] }),
  });
};

// ── Company sub-resource hooks ────────────────────────────────────────────────

export const useCompanyShipperOrders = (companyId: number, params?: { page?: number; pageSize?: number }) =>
  useQuery({ queryKey: ["company-shipper-orders", companyId, params], queryFn: () => companyOrdersApi.shipperOrders(companyId, params), enabled: companyId > 0 });

export const useCompanyVendorPurchaseOrders = (companyId: number, params?: { page?: number; pageSize?: number }) =>
  useQuery({ queryKey: ["company-po", companyId, params], queryFn: () => companyOrdersApi.vendorPurchaseOrders(companyId, params), enabled: companyId > 0 });

// ── Admin ─────────────────────────────────────────────────────────────────────

export const useSystemSettings = () =>
  useQuery({ queryKey: ["system-settings"], queryFn: adminApi.getSettings });

export const useUpdateSystemSetting = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ id, settingValue }: { id: number; settingValue: string }) =>
      adminApi.updateSetting(id, settingValue),
    onSuccess: () => qc.invalidateQueries({ queryKey: ["system-settings"] }),
  });
};

// ── Reports ───────────────────────────────────────────────────────────────────

export const useSalesByEmployee = (year?: number) =>
  useQuery({ queryKey: ["report-sales-employee", year], queryFn: () => reportsApi.salesByEmployee(year) });

export const useSalesByProduct = (year?: number) =>
  useQuery({ queryKey: ["report-sales-product", year], queryFn: () => reportsApi.salesByProduct(year) });

export const useSalesByProductQuarterly = (year?: number) =>
  useQuery({ queryKey: ["report-sales-quarterly", year], queryFn: () => reportsApi.salesByProductQuarterly(year) });

export const useEmployeeDirectory = () =>
  useQuery({ queryKey: ["report-employee-directory"], queryFn: reportsApi.employeeDirectory });

export const useProductCatalog = () =>
  useQuery({ queryKey: ["report-product-catalog"], queryFn: reportsApi.productCatalog });

export const useCustomerList = () =>
  useQuery({ queryKey: ["report-customer-list"], queryFn: reportsApi.customerList });

export const useInvoice = (orderId: number) =>
  useQuery({ queryKey: ["invoice", orderId], queryFn: () => reportsApi.invoice(orderId), enabled: orderId > 0 });

export const usePurchaseOrderForm = (purchaseOrderId: number) =>
  useQuery({
    queryKey: ["purchase-order-form", purchaseOrderId],
    queryFn: () => reportsApi.purchaseOrderForm(purchaseOrderId),
    enabled: purchaseOrderId > 0,
  });

// ── Product Categories (full CRUD) ───────────────────────────────────────────

export const useProductCategoriesFull = () =>
  useQuery({ queryKey: ["product-categories-full"], queryFn: productCategoriesApi.list });

export const useProductCategoryDetail = (id: number) =>
  useQuery({ queryKey: ["product-category", id], queryFn: () => productCategoriesApi.get(id), enabled: id > 0 });

export const useCreateProductCategory = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (data: { categoryName?: string; categoryCode?: string; categoryDesc?: string }) =>
      productCategoriesApi.create(data),
    onSuccess: () => { qc.invalidateQueries({ queryKey: ["product-categories-full"] }); qc.invalidateQueries({ queryKey: ["product-categories"] }); },
  });
};

export const useUpdateProductCategory = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ id, data }: { id: number; data: { categoryName?: string; categoryCode?: string; categoryDesc?: string } }) =>
      productCategoriesApi.update(id, data),
    onSuccess: () => { qc.invalidateQueries({ queryKey: ["product-categories-full"] }); qc.invalidateQueries({ queryKey: ["product-categories"] }); },
  });
};

export const useDeleteProductCategory = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (id: number) => productCategoriesApi.delete(id),
    onSuccess: () => { qc.invalidateQueries({ queryKey: ["product-categories-full"] }); qc.invalidateQueries({ queryKey: ["product-categories"] }); },
  });
};

// ── Product sub-resources ────────────────────────────────────────────────────

export const useProductOrders = (productId: number, params?: { page?: number; pageSize?: number }) =>
  useQuery({
    queryKey: ["product-orders", productId, params],
    queryFn: () => productsApi.orders(productId, params),
    enabled: productId > 0,
  });

export const useProductPurchaseOrders = (productId: number, params?: { page?: number; pageSize?: number }) =>
  useQuery({
    queryKey: ["product-purchase-orders", productId, params],
    queryFn: () => productsApi.purchaseOrders(productId, params),
    enabled: productId > 0,
  });

export const useProductInventory = (productId: number) =>
  useQuery({
    queryKey: ["product-inventory", productId],
    queryFn: () => productsApi.inventory(productId),
    enabled: productId > 0,
  });

// ── Employee sub-resources ───────────────────────────────────────────────────

export const useEmployeeOrders = (employeeId: number, params?: { page?: number; pageSize?: number }) =>
  useQuery({
    queryKey: ["employee-orders", employeeId, params],
    queryFn: () => employeesApi.orders(employeeId, params),
    enabled: employeeId > 0,
  });
