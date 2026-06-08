import { useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  Box, Button, Chip, Paper, Table, TableBody, TableCell,
  TableContainer, TableHead, TableRow, ToggleButton, ToggleButtonGroup, Typography,
} from "@mui/material";
import AddIcon from "@mui/icons-material/Add";
import { useOrders } from "../api/hooks";
import { ORDER_STATUSES } from "../api/types";

export default function OrdersPage() {
  const [page, setPage] = useState(1);
  const [statusId, setStatusId] = useState<number | null>(null);
  const navigate = useNavigate();
  const { data, isLoading, isError } = useOrders({ statusId: statusId ?? undefined, page, pageSize: 25 });

  return (
    <Box>
      <Box sx={{ display: "flex", justifyContent: "space-between", mb: 2 }}>
        <Typography variant="h5">Orders</Typography>
        <Button variant="contained" startIcon={<AddIcon />} onClick={() => navigate("/orders/new")}>
          New
        </Button>
      </Box>
      <ToggleButtonGroup
        value={statusId ?? "all"}
        exclusive
        onChange={(_, v) => { setStatusId(v === "all" || v == null ? null : (v as number)); setPage(1); }}
        size="small"
        sx={{ mb: 2 }}
      >
        <ToggleButton value="all">All</ToggleButton>
        {ORDER_STATUSES.map((s) => (
          <ToggleButton key={s.id} value={s.id}>{s.name}</ToggleButton>
        ))}
      </ToggleButtonGroup>
      {isError && <Typography color="error">Failed to load orders.</Typography>}
      <TableContainer component={Paper}>
        <Table size="small">
          <TableHead>
            <TableRow>
              <TableCell>#</TableCell>
              <TableCell>Customer</TableCell>
              <TableCell>Employee</TableCell>
              <TableCell>Order Date</TableCell>
              <TableCell>Status</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {isLoading ? (
              <TableRow><TableCell colSpan={5}>Loading…</TableCell></TableRow>
            ) : (
              data?.items.map((o) => (
                <TableRow
                  key={o.orderId}
                  hover
                  sx={{ cursor: "pointer" }}
                  onClick={() => navigate(`/orders/${o.orderId}`)}
                >
                  <TableCell>{o.orderId}</TableCell>
                  <TableCell>{o.customerName}</TableCell>
                  <TableCell>{o.employeeName}</TableCell>
                  <TableCell>
                    {o.orderDate ? new Date(o.orderDate).toLocaleDateString() : "—"}
                  </TableCell>
                  <TableCell>
                    <Chip
                      label={ORDER_STATUSES.find((s) => s.id === o.orderStatusId)?.name ?? (o.orderStatusId ?? "—")}
                      size="small"
                      variant="outlined"
                    />
                  </TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </TableContainer>

      <Box sx={{ mt: 1, display: "flex", gap: 1 }}>
        <button disabled={page <= 1} onClick={() => setPage((p) => p - 1)}>Previous</button>
        <Typography sx={{ alignSelf: "center" }}>Page {page}</Typography>
        <button
          disabled={!data || page * 25 >= data.totalCount}
          onClick={() => setPage((p) => p + 1)}
        >
          Next
        </button>
      </Box>
    </Box>
  );
}
