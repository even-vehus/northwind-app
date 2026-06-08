import { useIsAuthenticated, useMsal } from "@azure/msal-react";
import { Routes, Route, Navigate } from "react-router-dom";
import { useEffect } from "react";
import { loginRequest, isAuthConfigured } from "./auth/msalConfig";
import { setAuthTokenProvider } from "./api/client";
import { useAuthToken } from "./auth/useAuthToken";
import { useFakeAuth } from "./auth/FakeAuthContext";
import Layout from "./components/Layout";
import DashboardPage from "./pages/DashboardPage";
import CompaniesPage from "./pages/CompaniesPage";
import CompanyDetailPage from "./pages/CompanyDetailPage";
import ContactsPage from "./pages/ContactsPage";
import ProductsPage from "./pages/ProductsPage";
import ProductDetailPage from "./pages/ProductDetailPage";
import OrdersPage from "./pages/OrdersPage";
import OrderDetailPage from "./pages/OrderDetailPage";
import EmployeesPage from "./pages/EmployeesPage";
import EmployeeDetailPage from "./pages/EmployeeDetailPage";
import PurchaseOrdersPage from "./pages/PurchaseOrdersPage";
import PurchaseOrderDetailPage from "./pages/PurchaseOrderDetailPage";
import AdminPage from "./pages/AdminPage";
import ReportsPage from "./pages/ReportsPage";
import SalesByEmployeePage from "./pages/SalesByEmployeePage";
import SalesByProductPage from "./pages/SalesByProductPage";
import SalesByProductQuarterlyPage from "./pages/SalesByProductQuarterlyPage";
import EmployeeDirectoryPage from "./pages/EmployeeDirectoryPage";
import ProductCatalogPage from "./pages/ProductCatalogPage";
import CustomerListPage from "./pages/CustomerListPage";
import InvoicePage from "./pages/InvoicePage";
import ProductCategoriesPage from "./pages/ProductCategoriesPage";
import PurchaseOrderFormPage from "./pages/PurchaseOrderFormPage";
import LoginPage from "./pages/LoginPage";

function AuthGuard({ children }: { children: React.ReactNode }) {
  const isAuthenticated = useIsAuthenticated();
  const { user } = useFakeAuth();
  // POC: when Entra isn't configured, gate on the fake session instead of allowing all.
  if (!isAuthConfigured) return user ? <>{children}</> : <Navigate to="/login" replace />;
  return isAuthenticated ? <>{children}</> : <Navigate to="/login" replace />;
}

function TokenInitializer() {
  const getToken = useAuthToken();
  useEffect(() => {
    setAuthTokenProvider(getToken);
  }, [getToken]);
  return null;
}

export default function App() {
  const { instance } = useMsal();
  const isAuthenticated = useIsAuthenticated();

  useEffect(() => {
    if (!isAuthConfigured) return;
    if (!isAuthenticated) {
      instance.loginRedirect(loginRequest).catch(() => null);
    }
  }, [instance, isAuthenticated]);

  return (
    <>
      {isAuthenticated && isAuthConfigured && <TokenInitializer />}
      <Routes>
        <Route path="/login" element={<LoginPage />} />
        <Route
          path="/"
          element={
            <AuthGuard>
              <Layout />
            </AuthGuard>
          }
        >
          <Route index element={<DashboardPage />} />
          <Route path="companies" element={<CompaniesPage />} />
          <Route path="companies/:id" element={<CompanyDetailPage />} />
          <Route path="contacts" element={<ContactsPage />} />
          <Route path="products" element={<ProductsPage />} />
          <Route path="product-categories" element={<ProductCategoriesPage />} />
          <Route path="products/:id" element={<ProductDetailPage />} />
          <Route path="orders" element={<OrdersPage />} />
          <Route path="orders/:id" element={<OrderDetailPage />} />
          <Route path="employees" element={<EmployeesPage />} />
          <Route path="employees/:id" element={<EmployeeDetailPage />} />
          <Route path="purchase-orders" element={<PurchaseOrdersPage />} />
          <Route path="purchase-orders/:id" element={<PurchaseOrderDetailPage />} />
          <Route path="purchase-orders/:id/print" element={<PurchaseOrderFormPage />} />
          <Route path="admin" element={<AdminPage />} />
          <Route path="reports" element={<ReportsPage />} />
          <Route path="reports/sales-by-employee" element={<SalesByEmployeePage />} />
          <Route path="reports/sales-by-product" element={<SalesByProductPage />} />
          <Route path="reports/sales-by-product-quarterly" element={<SalesByProductQuarterlyPage />} />
          <Route path="reports/employee-directory" element={<EmployeeDirectoryPage />} />
          <Route path="reports/product-catalog" element={<ProductCatalogPage />} />
          <Route path="reports/customer-list" element={<CustomerListPage />} />
          <Route path="orders/:id/invoice" element={<InvoicePage />} />
        </Route>
      </Routes>
    </>
  );
}
