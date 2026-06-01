import { useParams, useNavigate } from "react-router-dom";
import {
  Box, Button, CircularProgress, Divider, Table, TableBody,
  TableCell, TableFooter, TableHead, TableRow, Typography,
} from "@mui/material";
import PrintIcon from "@mui/icons-material/Print";
import { useInvoice } from "../api/hooks";

export default function InvoicePage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const orderId = Number(id);
  const { data: inv, isLoading, isError } = useInvoice(orderId);

  if (isLoading) return <CircularProgress />;
  if (isError || !inv) return <Typography color="error">Invoice not found.</Typography>;

  const fmt = (v: number | null | undefined) =>
    v != null ? v.toLocaleString("en-US", { style: "currency", currency: "USD" }) : "—";

  const tax = inv.subtotal != null && inv.taxRate != null
    ? inv.subtotal * (inv.taxRate / 100)
    : null;
  const total = (inv.subtotal ?? 0) + (inv.shippingFee ?? 0) + (tax ?? 0);

  return (
    <Box sx={{ p: 4, maxWidth: 800, mx: "auto" }}>
      <Box sx={{ display: "flex", justifyContent: "space-between", mb: 2, displayPrint: "none" }}>
        <Button onClick={() => navigate(`/orders/${orderId}`)}>← Order {orderId}</Button>
        <Button startIcon={<PrintIcon />} variant="outlined" onClick={() => window.print()}>Print</Button>
      </Box>

      {/* Header */}
      <Box sx={{ display: "flex", justifyContent: "space-between", mb: 3 }}>
        <Box>
          <Typography variant="h4" sx={{ fontWeight: "bold" }}>INVOICE</Typography>
          <Typography variant="h6">#{inv.orderId}</Typography>
          {inv.invoiceDate && (
            <Typography color="text.secondary">
              Date: {new Date(inv.invoiceDate).toLocaleDateString()}
            </Typography>
          )}
        </Box>
        <Box sx={{ textAlign: "right" }}>
          <Typography sx={{ fontWeight: "bold" }}>Bill To:</Typography>
          <Typography>{inv.customerName}</Typography>
          {inv.customerAddress && <Typography variant="body2">{inv.customerAddress}</Typography>}
          {(inv.customerCity || inv.customerState || inv.customerZip) && (
            <Typography variant="body2">
              {[inv.customerCity, inv.customerState, inv.customerZip].filter(Boolean).join(", ")}
            </Typography>
          )}
        </Box>
      </Box>

      {inv.employeeName && (
        <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
          Sales Representative: {inv.employeeName}
        </Typography>
      )}

      <Divider sx={{ mb: 2 }} />

      {/* Line items */}
      <Table size="small">
        <TableHead>
          <TableRow>
            <TableCell>Product</TableCell>
            <TableCell>Code</TableCell>
            <TableCell align="right">Qty</TableCell>
            <TableCell align="right">Unit Price</TableCell>
            <TableCell align="right">Discount</TableCell>
            <TableCell align="right">Amount</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {inv.lines.map((line, i) => (
            <TableRow key={i}>
              <TableCell>{line.productName}</TableCell>
              <TableCell sx={{ color: "text.secondary" }}>{line.productCode}</TableCell>
              <TableCell align="right">{line.quantity}</TableCell>
              <TableCell align="right">{fmt(line.unitPrice)}</TableCell>
              <TableCell align="right">
                {line.discount ? `${(line.discount * 100).toFixed(0)}%` : "—"}
              </TableCell>
              <TableCell align="right">{fmt(line.extendedPrice)}</TableCell>
            </TableRow>
          ))}
        </TableBody>
        <TableFooter>
          <TableRow>
            <TableCell colSpan={5} align="right">Subtotal</TableCell>
            <TableCell align="right">{fmt(inv.subtotal)}</TableCell>
          </TableRow>
          {inv.shippingFee != null && (
            <TableRow>
              <TableCell colSpan={5} align="right">Shipping</TableCell>
              <TableCell align="right">{fmt(inv.shippingFee)}</TableCell>
            </TableRow>
          )}
          {tax != null && (
            <TableRow>
              <TableCell colSpan={5} align="right">
                Tax ({inv.taxRate?.toFixed(1)}%)
              </TableCell>
              <TableCell align="right">{fmt(tax)}</TableCell>
            </TableRow>
          )}
          <TableRow>
            <TableCell colSpan={5} align="right" sx={{ fontWeight: "bold", fontSize: "1.05rem" }}>
              Total
            </TableCell>
            <TableCell align="right" sx={{ fontWeight: "bold", fontSize: "1.05rem" }}>
              {fmt(total)}
            </TableCell>
          </TableRow>
        </TableFooter>
      </Table>
    </Box>
  );
}
