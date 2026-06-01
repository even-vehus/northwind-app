import { useNavigate } from "react-router-dom";
import {
  Box, Card, CardActionArea, CardContent, Grid, Typography,
} from "@mui/material";
import AssessmentIcon from "@mui/icons-material/Assessment";
import BadgeIcon from "@mui/icons-material/Badge";
import CategoryIcon from "@mui/icons-material/Category";
import GroupIcon from "@mui/icons-material/Group";
import InventoryIcon from "@mui/icons-material/Inventory";
import PeopleIcon from "@mui/icons-material/People";
import TrendingUpIcon from "@mui/icons-material/TrendingUp";

const REPORTS = [
  {
    path: "/reports/sales-by-employee",
    icon: <PeopleIcon fontSize="large" />,
    title: "Sales by Employee",
    description: "Total revenue and order count per employee",
  },
  {
    path: "/reports/sales-by-product",
    icon: <InventoryIcon fontSize="large" />,
    title: "Sales by Product",
    description: "Revenue and quantity sold per product",
  },
  {
    path: "/reports/sales-by-product-quarterly",
    icon: <TrendingUpIcon fontSize="large" />,
    title: "Quarterly Sales",
    description: "Product sales broken down by quarter",
  },
  {
    path: "/reports/employee-directory",
    icon: <BadgeIcon fontSize="large" />,
    title: "Employee Directory",
    description: "Phone numbers, emails and job titles",
  },
  {
    path: "/reports/product-catalog",
    icon: <CategoryIcon fontSize="large" />,
    title: "Product Catalog",
    description: "Active products with prices, grouped by category",
  },
  {
    path: "/reports/customer-list",
    icon: <GroupIcon fontSize="large" />,
    title: "Customer List",
    description: "All customers with contact details",
  },
];

export default function ReportsPage() {
  const navigate = useNavigate();

  return (
    <Box sx={{ p: 3 }}>
      <Box sx={{ display: "flex", alignItems: "center", gap: 1, mb: 3 }}>
        <AssessmentIcon />
        <Typography variant="h5">Reports</Typography>
      </Box>

      <Grid container spacing={2}>
        {REPORTS.map((r) => (
          <Grid key={r.path} size={{ xs: 12, sm: 6, md: 4 }}>
            <Card variant="outlined">
              <CardActionArea onClick={() => navigate(r.path)} sx={{ p: 1 }}>
                <CardContent>
                  <Box sx={{ color: "primary.main", mb: 1 }}>{r.icon}</Box>
                  <Typography variant="h6">{r.title}</Typography>
                  <Typography variant="body2" color="text.secondary">{r.description}</Typography>
                </CardContent>
              </CardActionArea>
            </Card>
          </Grid>
        ))}
      </Grid>
    </Box>
  );
}
