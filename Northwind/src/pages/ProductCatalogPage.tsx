import { useNavigate } from "react-router-dom";
import {
  Box, Divider, Paper, Table, TableBody, TableCell, TableHead, TableRow, Typography,
} from "@mui/material";
import { useProductCatalog, useShippers } from "../api/hooks";

export default function ProductCatalogPage() {
  const navigate = useNavigate();
  const { data, isLoading } = useProductCatalog();
  const { data: shippers } = useShippers();

  const fmt = (v: number | null | undefined) =>
    v != null ? v.toLocaleString("en-US", { style: "currency", currency: "USD" }) : "—";

  let lastCategory = "";

  return (
    <Box sx={{ p: 3 }}>
      <Box sx={{ display: "flex", alignItems: "center", gap: 2, mb: 3 }}>
        <Typography variant="h5" sx={{ flex: 1 }}>Product Catalog</Typography>
        <Typography variant="body2" color="primary" sx={{ cursor: "pointer" }} onClick={() => navigate("/reports")}>
          ← Reports
        </Typography>
      </Box>

      <Table size="small">
        <TableHead>
          <TableRow>
            <TableCell>Code</TableCell>
            <TableCell>Product</TableCell>
            <TableCell>Description</TableCell>
            <TableCell align="right">List Price</TableCell>
            <TableCell align="right">Standard Cost</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {isLoading && <TableRow><TableCell colSpan={5}>Loading…</TableCell></TableRow>}
          {data?.map((p) => {
            const showCategory = p.categoryName !== lastCategory;
            lastCategory = p.categoryName ?? "";
            return [
              showCategory && (
                <TableRow key={`cat-${p.categoryName}`} sx={{ bgcolor: "action.hover" }}>
                  <TableCell colSpan={5} sx={{ fontWeight: "bold", pt: 1 }}>
                    {p.categoryName || "Uncategorized"}
                  </TableCell>
                </TableRow>
              ),
              <TableRow
                key={p.productId}
                hover
                sx={{ cursor: "pointer" }}
                onClick={() => navigate(`/products/${p.productId}`)}
              >
                <TableCell sx={{ color: "text.secondary" }}>{p.productCode}</TableCell>
                <TableCell>{p.productName}</TableCell>
                <TableCell sx={{ color: "text.secondary", fontSize: "0.8rem", maxWidth: 280, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                  {p.description}
                </TableCell>
                <TableCell align="right">{fmt(p.listPrice)}</TableCell>
                <TableCell align="right">{fmt(p.standardCost)}</TableCell>
              </TableRow>,
            ];
          })}
        </TableBody>
      </Table>

      {/* srptQuality — Commitment to Quality (from original catalog) */}
      <Paper variant="outlined" sx={{ p: 3, mt: 4 }}>
        <Typography variant="h6" gutterBottom>Commitment to Quality</Typography>
        <Typography variant="body2" color="text.secondary">
          Northwind Traders is committed to bringing you products of the highest quality
          from all over the world. If at any time you are not completely satisfied with any
          of our products, you may return them to us for a full refund.
        </Typography>
      </Paper>

      {/* srptShipVia — How to Order / Ship Via (shipper companies) */}
      <Paper variant="outlined" sx={{ p: 3, mt: 2 }}>
        <Typography variant="h6" gutterBottom>How to Order — Ship Via</Typography>
        <Typography variant="body2" color="text.secondary" sx={{ mb: 1 }}>
          Our sales representatives are ready to take your orders now. Orders can be shipped via
          any of our trusted carriers:
        </Typography>
        <Divider sx={{ mb: 1 }} />
        {shippers && shippers.length > 0 ? (
          <Box component="ul" sx={{ m: 0, pl: 3 }}>
            {shippers.map((s) => (
              <Typography component="li" variant="body2" key={s.companyId}>{s.companyName}</Typography>
            ))}
          </Box>
        ) : (
          <Typography variant="body2" color="text.secondary">No shippers on file.</Typography>
        )}
      </Paper>
    </Box>
  );
}
