import { useState } from "react";
import { Outlet, useNavigate, useLocation } from "react-router-dom";
import { useMsal } from "@azure/msal-react";
import {
  AppBar, Box, Button, Drawer, IconButton, List, ListItemButton,
  ListItemIcon, ListItemText, Toolbar, Typography,
} from "@mui/material";
import LogoutIcon from "@mui/icons-material/Logout";
import MenuIcon from "@mui/icons-material/Menu";
import { isAuthConfigured } from "../auth/msalConfig";
import { useFakeAuth } from "../auth/FakeAuthContext";
import DashboardIcon from "@mui/icons-material/Dashboard";
import BusinessIcon from "@mui/icons-material/Business";
import ContactsIcon from "@mui/icons-material/Contacts";
import InventoryIcon from "@mui/icons-material/Inventory";
import PeopleIcon from "@mui/icons-material/People";
import ShoppingCartIcon from "@mui/icons-material/ShoppingCart";
import ShoppingBagIcon from "@mui/icons-material/ShoppingBag";
import AdminPanelSettingsIcon from "@mui/icons-material/AdminPanelSettings";
import AssessmentIcon from "@mui/icons-material/Assessment";

const DRAWER_WIDTH = 220;

const NAV_ITEMS = [
  { label: "Dashboard", path: "/", icon: <DashboardIcon /> },
  { label: "Companies", path: "/companies", icon: <BusinessIcon /> },
  { label: "Contacts", path: "/contacts", icon: <ContactsIcon /> },
  { label: "Products", path: "/products", icon: <InventoryIcon /> },
  { label: "Orders", path: "/orders", icon: <ShoppingCartIcon /> },
  { label: "Purchase Orders", path: "/purchase-orders", icon: <ShoppingBagIcon /> },
  { label: "Employees", path: "/employees", icon: <PeopleIcon /> },
  { label: "Reports", path: "/reports", icon: <AssessmentIcon /> },
  { label: "Admin", path: "/admin", icon: <AdminPanelSettingsIcon /> },
];

export default function Layout() {
  const [open, setOpen] = useState(true);
  const navigate = useNavigate();
  const { pathname } = useLocation();
  const { instance, accounts } = useMsal();
  const { user, signOut } = useFakeAuth();

  const displayName = isAuthConfigured ? accounts[0]?.name ?? accounts[0]?.username : user;
  const onLogout = () => {
    if (isAuthConfigured) {
      instance.logoutRedirect();
    } else {
      signOut();
      navigate("/login");
    }
  };

  return (
    <Box sx={{ display: "flex" }}>
      <AppBar position="fixed" sx={{ zIndex: (t) => t.zIndex.drawer + 1 }}>
        <Toolbar>
          <IconButton color="inherit" edge="start" onClick={() => setOpen((o) => !o)} sx={{ mr: 2 }}>
            <MenuIcon />
          </IconButton>
          <Typography variant="h6" noWrap>
            Northwind
          </Typography>
          <Box sx={{ flexGrow: 1 }} />
          {displayName && (
            <Typography variant="body2" sx={{ mr: 2 }} noWrap>
              {displayName}
            </Typography>
          )}
          <Button color="inherit" startIcon={<LogoutIcon />} onClick={onLogout}>
            Logout
          </Button>
        </Toolbar>
      </AppBar>

      <Drawer
        variant="persistent"
        open={open}
        sx={{
          width: open ? DRAWER_WIDTH : 0,
          flexShrink: 0,
          "& .MuiDrawer-paper": { width: DRAWER_WIDTH, boxSizing: "border-box" },
        }}
      >
        <Toolbar />
        <List dense>
          {NAV_ITEMS.map((item) => (
            <ListItemButton
              key={item.path}
              selected={item.path === "/" ? pathname === "/" : pathname.startsWith(item.path)}
              onClick={() => navigate(item.path)}
            >
              <ListItemIcon>{item.icon}</ListItemIcon>
              <ListItemText primary={item.label} />
            </ListItemButton>
          ))}
        </List>
      </Drawer>

      <Box component="main" sx={{ flexGrow: 1, p: 3, mt: 8 }}>
        <Outlet />
      </Box>
    </Box>
  );
}
