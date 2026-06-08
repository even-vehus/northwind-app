import { useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  Box, FormControl, InputLabel, MenuItem, Select, Table, TableBody,
  TableCell, TableHead, TableRow, Typography,
} from "@mui/material";
import { useSalesByProduct } from "../api/hooks";

const currentYear = new Date().getFullYear();
const years = Array.from({ length: 6 }, (_, i) => currentYear - i);

export default function SalesByProductPage() {
  const navigate = useNavigate();
  const [year, setYear] = useState<number | "">(currentYear);
  const { data, isLoading } = useSalesByProduct(year || undefined);

  const fmt = (v: number | null | undefined) =>
    v != null ? v.toLocaleString("en-US", { style: "currency", currency: "USD", maximumFractionDigits: 0 }) : "—";

  return (
    <Box sx={{ p: 3, maxWidth: 800 }}>
      <Box sx={{ display: "flex", alignItems: "center", gap: 2, mb: 3 }}>
        <Typography variant="h5" sx={{ flex: 1 }}>Sales by Product</Typography>
        <FormControl size="small" sx={{ minWidth: 120 }}>
          <InputLabel>Year</InputLabel>
          <Select value={year} label="Year" onChange={(e) => setYear(e.target.value as number | "")}>
            <MenuItem value=""><em>All time</em></MenuItem>
            {years.map((y) => <MenuItem key={y} value={y}>{y}</MenuItem>)}
          </Select>
        </FormControl>
        <Typography variant="body2" color="primary" sx={{ cursor: "pointer" }} onClick={() => navigate("/reports")}>
          ← Reports
        </Typography>
      </Box>

      <Table size="small">
        <TableHead>
          <TableRow>
            <TableCell>Product</TableCell>
            <TableCell>Category</TableCell>
            <TableCell align="right">Qty Sold</TableCell>
            <TableCell align="right">Revenue</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {isLoading && <TableRow><TableCell colSpan={4}>Loading…</TableCell></TableRow>}
          {data?.map((row) => (
            <TableRow key={row.productId ?? "none"}>
              <TableCell>{row.productName || "—"}</TableCell>
              <TableCell>{row.categoryName || "—"}</TableCell>
              <TableCell align="right">{row.quantitySold ?? "—"}</TableCell>
              <TableCell align="right">{fmt(row.revenue)}</TableCell>
            </TableRow>
          ))}
          {data?.length === 0 && (
            <TableRow><TableCell colSpan={4} sx={{ color: "text.secondary" }}>No data for selected year</TableCell></TableRow>
          )}
        </TableBody>
      </Table>
    </Box>
  );
}
