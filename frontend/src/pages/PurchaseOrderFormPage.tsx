import { useParams, useNavigate } from "react-router-dom";
import {
  Box, Button, CircularProgress, Divider, Table, TableBody,
  TableCell, TableFooter, TableHead, TableRow, Typography,
} from "@mui/material";
import PrintIcon from "@mui/icons-material/Print";
import { usePurchaseOrderForm } from "../api/hooks";

export default function PurchaseOrderFormPage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const purchaseOrderId = Number(id);
  const { data: po, isLoading, isError } = usePurchaseOrderForm(purchaseOrderId);

  if (isLoading) return <CircularProgress />;
  if (isError || !po) return <Typography color="error">Purchase order not found.</Typography>;

  const fmt = (v: number | null | undefined) =>
    v != null ? v.toLocaleString("en-US", { style: "currency", currency: "USD" }) : "—";

  const fmtDate = (v: string | null | undefined) =>
    v ? new Date(v).toLocaleDateString() : "—";

  const total = (po.subtotal ?? 0) + (po.shippingFee ?? 0) + (po.taxAmount ?? 0);

  return (
    <Box sx={{ p: 4, maxWidth: 800, mx: "auto" }}>
      <Box sx={{ display: "flex", justifyContent: "space-between", mb: 2, displayPrint: "none" }}>
        <Button onClick={() => navigate(`/purchase-orders/${purchaseOrderId}`)}>
          ← Purchase Order {purchaseOrderId}
        </Button>
        <Button startIcon={<PrintIcon />} variant="outlined" onClick={() => window.print()}>Print</Button>
      </Box>

      {/* Header */}
      <Box sx={{ display: "flex", justifyContent: "space-between", mb: 3 }}>
        <Box>
          <Typography variant="h4" sx={{ fontWeight: "bold" }}>PURCHASE ORDER</Typography>
          <Typography variant="h6">#{po.purchaseOrderId}</Typography>
          {po.statusName && (
            <Typography color="text.secondary">Status: {po.statusName}</Typography>
          )}
        </Box>
        <Box sx={{ textAlign: "right" }}>
          <Typography sx={{ fontWeight: "bold" }}>Vendor:</Typography>
          <Typography>{po.vendorName}</Typography>
          {po.vendorAddress && <Typography variant="body2">{po.vendorAddress}</Typography>}
          {(po.vendorCity || po.vendorState || po.vendorZip) && (
            <Typography variant="body2">
              {[po.vendorCity, po.vendorState, po.vendorZip].filter(Boolean).join(", ")}
            </Typography>
          )}
        </Box>
      </Box>

      {/* Meta row */}
      <Box sx={{ display: "flex", gap: 4, flexWrap: "wrap", mb: 2 }}>
        <Box>
          <Typography variant="caption" color="text.secondary">Submitted</Typography>
          <Typography variant="body2">{fmtDate(po.submittedDate)}{po.submittedByName ? ` by ${po.submittedByName}` : ""}</Typography>
        </Box>
        <Box>
          <Typography variant="caption" color="text.secondary">Approved</Typography>
          <Typography variant="body2">{fmtDate(po.approvedDate)}{po.approvedByName ? ` by ${po.approvedByName}` : ""}</Typography>
        </Box>
        <Box>
          <Typography variant="caption" color="text.secondary">Received</Typography>
          <Typography variant="body2">{fmtDate(po.receivedDate)}</Typography>
        </Box>
        {po.paymentMethod && (
          <Box>
            <Typography variant="caption" color="text.secondary">Payment Method</Typography>
            <Typography variant="body2">{po.paymentMethod}</Typography>
          </Box>
        )}
      </Box>

      <Divider sx={{ mb: 2 }} />

      {/* Line items */}
      <Table size="small">
        <TableHead>
          <TableRow>
            <TableCell>Product</TableCell>
            <TableCell>Code</TableCell>
            <TableCell align="right">Qty</TableCell>
            <TableCell align="right">Unit Cost</TableCell>
            <TableCell align="right">Amount</TableCell>
            <TableCell>Received</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {po.lines.map((line, i) => (
            <TableRow key={i}>
              <TableCell>{line.productName}</TableCell>
              <TableCell sx={{ color: "text.secondary" }}>{line.productCode}</TableCell>
              <TableCell align="right">{line.quantity}</TableCell>
              <TableCell align="right">{fmt(line.unitCost)}</TableCell>
              <TableCell align="right">{fmt(line.extendedCost)}</TableCell>
              <TableCell>{fmtDate(line.receivedDate)}</TableCell>
            </TableRow>
          ))}
        </TableBody>
        <TableFooter>
          <TableRow>
            <TableCell colSpan={4} align="right">Subtotal</TableCell>
            <TableCell align="right">{fmt(po.subtotal)}</TableCell>
            <TableCell />
          </TableRow>
          {po.shippingFee != null && (
            <TableRow>
              <TableCell colSpan={4} align="right">Shipping</TableCell>
              <TableCell align="right">{fmt(po.shippingFee)}</TableCell>
              <TableCell />
            </TableRow>
          )}
          {po.taxAmount != null && (
            <TableRow>
              <TableCell colSpan={4} align="right">Tax</TableCell>
              <TableCell align="right">{fmt(po.taxAmount)}</TableCell>
              <TableCell />
            </TableRow>
          )}
          <TableRow>
            <TableCell colSpan={4} align="right" sx={{ fontWeight: "bold", fontSize: "1.05rem" }}>
              Total
            </TableCell>
            <TableCell align="right" sx={{ fontWeight: "bold", fontSize: "1.05rem" }}>
              {fmt(total)}
            </TableCell>
            <TableCell />
          </TableRow>
        </TableFooter>
      </Table>

      {po.notes && (
        <Box sx={{ mt: 3 }}>
          <Typography variant="subtitle2">Notes</Typography>
          <Typography variant="body2" color="text.secondary">{po.notes}</Typography>
        </Box>
      )}
    </Box>
  );
}
