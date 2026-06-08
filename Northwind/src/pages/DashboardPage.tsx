import { useNavigate } from "react-router-dom";
import {
  Box, CircularProgress, Divider, Grid, LinearProgress, Paper,
  Table, TableBody, TableCell, TableHead, TableRow, Typography,
} from "@mui/material";
import { useDashboardSummary } from "../api/hooks";

const fmtCurrency = (v: number) =>
  v.toLocaleString("en-US", { style: "currency", currency: "USD", maximumFractionDigits: 0 });

function KpiCard({ label, value }: { label: string; value: string | number }) {
  return (
    <Paper variant="outlined" sx={{ p: 2, height: "100%" }}>
      <Typography variant="h4" sx={{ fontWeight: 600, color: "primary.main" }}>{value}</Typography>
      <Typography variant="body2" color="text.secondary">{label}</Typography>
    </Paper>
  );
}

export default function DashboardPage() {
  const navigate = useNavigate();
  const { data, isLoading, isError } = useDashboardSummary();

  if (isLoading) return <CircularProgress />;
  if (isError || !data) return <Typography color="error">Failed to load dashboard.</Typography>;

  const pipelineMax = Math.max(1, ...data.ordersByStatus.map((s) => s.count));

  const kpis: { label: string; value: string | number }[] = [
    { label: "Orders", value: data.totalOrders },
    { label: "Companies", value: data.totalCompanies },
    { label: "Products", value: data.totalProducts },
    { label: "Open Purchase Orders", value: data.openPurchaseOrders },
    { label: "Products Awaiting Stock", value: data.productsAwaitingStock },
    { label: "Invoiced Sales", value: fmtCurrency(data.invoicedSales) },
  ];

  return (
    <Box>
      <Typography variant="h5" sx={{ mb: 3 }}>Dashboard</Typography>

      {/* KPI cards */}
      <Grid container spacing={2} sx={{ mb: 4 }}>
        {kpis.map((k) => (
          <Grid size={{ xs: 6, sm: 4, md: 2 }} key={k.label}>
            <KpiCard label={k.label} value={k.value} />
          </Grid>
        ))}
      </Grid>

      <Grid container spacing={3}>
        {/* Order pipeline */}
        <Grid size={{ xs: 12, md: 5 }}>
          <Paper variant="outlined" sx={{ p: 2 }}>
            <Typography variant="h6" gutterBottom>Order Pipeline</Typography>
            <Divider sx={{ mb: 2 }} />
            {data.ordersByStatus.map((s) => (
              <Box key={s.status} sx={{ mb: 1.5 }}>
                <Box sx={{ display: "flex", justifyContent: "space-between", mb: 0.5 }}>
                  <Typography variant="body2">{s.status}</Typography>
                  <Typography variant="body2" color="text.secondary">{s.count}</Typography>
                </Box>
                <LinearProgress
                  variant="determinate"
                  value={(s.count / pipelineMax) * 100}
                  sx={{ height: 8, borderRadius: 4 }}
                />
              </Box>
            ))}
          </Paper>
        </Grid>

        {/* Recent orders */}
        <Grid size={{ xs: 12, md: 7 }}>
          <Paper variant="outlined" sx={{ p: 2 }}>
            <Typography variant="h6" gutterBottom>Recent Orders</Typography>
            <Divider sx={{ mb: 1 }} />
            <Table size="small">
              <TableHead>
                <TableRow>
                  <TableCell>Order #</TableCell>
                  <TableCell>Customer</TableCell>
                  <TableCell>Date</TableCell>
                  <TableCell>Status</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {data.recentOrders.map((o) => (
                  <TableRow
                    key={o.orderId}
                    hover
                    sx={{ cursor: "pointer" }}
                    onClick={() => navigate(`/orders/${o.orderId}`)}
                  >
                    <TableCell>{o.orderId}</TableCell>
                    <TableCell>{o.customerName ?? "—"}</TableCell>
                    <TableCell>{o.orderDate ? new Date(o.orderDate).toLocaleDateString() : "—"}</TableCell>
                    <TableCell>{o.status ?? "—"}</TableCell>
                  </TableRow>
                ))}
                {data.recentOrders.length === 0 && (
                  <TableRow><TableCell colSpan={4} sx={{ color: "text.secondary" }}>No orders</TableCell></TableRow>
                )}
              </TableBody>
            </Table>
          </Paper>
        </Grid>
      </Grid>
    </Box>
  );
}
