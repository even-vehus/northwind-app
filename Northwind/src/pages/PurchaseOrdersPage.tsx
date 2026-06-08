import { useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  Box, Button, Chip, Table, TableBody, TableCell, TableHead, TableRow,
  TextField, ToggleButton, ToggleButtonGroup, Typography,
} from "@mui/material";
import AddIcon from "@mui/icons-material/Add";
import { usePurchaseOrders, usePurchaseOrderStatuses } from "../api/hooks";

const STATUS_COLORS: Record<string, "default" | "warning" | "info" | "success" | "error"> = {
  New: "info",
  Submitted: "warning",
  Approved: "success",
  Received: "success",
  Closed: "default",
};

export default function PurchaseOrdersPage() {
  const navigate = useNavigate();
  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState<number | null>(null);
  const [page, setPage] = useState(1);
  const pageSize = 25;

  const { data, isLoading, isError } = usePurchaseOrders({
    statusId: statusFilter ?? undefined,
    page,
    pageSize,
  });
  const { data: statuses } = usePurchaseOrderStatuses();

  const filtered = data?.items.filter((po) => {
    if (!search) return true;
    const s = search.toLowerCase();
    return (
      po.vendorName?.toLowerCase().includes(s) ||
      po.purchaseOrderId.toString().includes(s)
    );
  }) ?? [];

  return (
    <Box sx={{ p: 3 }}>
      <Box sx={{ display: "flex", justifyContent: "space-between", mb: 2 }}>
        <Typography variant="h5">Purchase Orders</Typography>
        <Button variant="contained" startIcon={<AddIcon />} onClick={() => navigate("/purchase-orders/new")}>
          New
        </Button>
      </Box>

      <Box sx={{ display: "flex", gap: 2, mb: 2, flexWrap: "wrap" }}>
        <TextField
          label="Search"
          size="small"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          sx={{ width: 240 }}
        />
        <ToggleButtonGroup
          size="small"
          exclusive
          value={statusFilter}
          onChange={(_, v) => { setStatusFilter(v); setPage(1); }}
        >
          <ToggleButton value={null as unknown as number}>All</ToggleButton>
          {statuses?.map((s) => (
            <ToggleButton key={s.statusId} value={s.statusId}>{s.statusName}</ToggleButton>
          ))}
        </ToggleButtonGroup>
      </Box>

      <Table size="small">
        <TableHead>
          <TableRow>
            <TableCell>#</TableCell>
            <TableCell>Vendor</TableCell>
            <TableCell>Submitted</TableCell>
            <TableCell>Submitted By</TableCell>
            <TableCell>Status</TableCell>
            <TableCell align="right">Items</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {isLoading && <TableRow><TableCell colSpan={6}>Loading…</TableCell></TableRow>}
          {isError && <TableRow><TableCell colSpan={6}>Failed to load purchase orders.</TableCell></TableRow>}
          {filtered.map((po) => (
            <TableRow
              key={po.purchaseOrderId}
              hover
              sx={{ cursor: "pointer" }}
              onClick={() => navigate(`/purchase-orders/${po.purchaseOrderId}`)}
            >
              <TableCell>{po.purchaseOrderId}</TableCell>
              <TableCell>{po.vendorName ?? "—"}</TableCell>
              <TableCell>
                {po.submittedDate ? new Date(po.submittedDate).toLocaleDateString() : "—"}
              </TableCell>
              <TableCell>{po.submittedByName ?? "—"}</TableCell>
              <TableCell>
                <Chip
                  size="small"
                  label={po.statusName ?? "—"}
                  color={STATUS_COLORS[po.statusName ?? ""] ?? "default"}
                />
              </TableCell>
              <TableCell align="right">{po.purchaseOrderDetails.length}</TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>

      <Box sx={{ display: "flex", alignItems: "center", gap: 2, mt: 2 }}>
        <Button disabled={page === 1} onClick={() => setPage((p) => p - 1)}>Previous</Button>
        <Typography>Page {page} / {data ? Math.max(1, Math.ceil(data.totalCount / pageSize)) : 0}</Typography>
        <Button disabled={!data || page * pageSize >= data.totalCount} onClick={() => setPage((p) => p + 1)}>Next</Button>
      </Box>
    </Box>
  );
}
