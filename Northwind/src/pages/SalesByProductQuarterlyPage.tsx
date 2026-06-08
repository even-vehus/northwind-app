import { useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  Box, FormControl, InputLabel, MenuItem, Select, Table, TableBody,
  TableCell, TableHead, TableRow, Typography,
} from "@mui/material";
import { useSalesByProductQuarterly } from "../api/hooks";

const currentYear = new Date().getFullYear();
const years = Array.from({ length: 6 }, (_, i) => currentYear - i);

export default function SalesByProductQuarterlyPage() {
  const navigate = useNavigate();
  const [year, setYear] = useState<number>(currentYear);
  const { data, isLoading } = useSalesByProductQuarterly(year);

  const fmt = (v: number | null | undefined) =>
    v != null ? v.toLocaleString("en-US", { style: "currency", currency: "USD", maximumFractionDigits: 0 }) : "—";

  // Pivot: productName → { Q1, Q2, Q3, Q4 }
  type QuarterMap = { [q: number]: number | null };
  const pivot = new Map<string, QuarterMap>();
  for (const row of data ?? []) {
    const key = `${row.productId}__${row.productName}`;
    if (!pivot.has(key)) pivot.set(key, {});
    pivot.get(key)![row.quarter] = row.revenue;
  }

  return (
    <Box sx={{ p: 3 }}>
      <Box sx={{ display: "flex", alignItems: "center", gap: 2, mb: 3 }}>
        <Typography variant="h5" sx={{ flex: 1 }}>Quarterly Sales by Product — {year}</Typography>
        <FormControl size="small" sx={{ minWidth: 120 }}>
          <InputLabel>Year</InputLabel>
          <Select value={year} label="Year" onChange={(e) => setYear(Number(e.target.value))}>
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
            <TableCell align="right">Q1</TableCell>
            <TableCell align="right">Q2</TableCell>
            <TableCell align="right">Q3</TableCell>
            <TableCell align="right">Q4</TableCell>
            <TableCell align="right">Total</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {isLoading && <TableRow><TableCell colSpan={6}>Loading…</TableCell></TableRow>}
          {[...pivot.entries()].map(([key, quarters]) => {
            const name = key.split("__")[1];
            const total = [1, 2, 3, 4].reduce((s, q) => s + (quarters[q] ?? 0), 0);
            return (
              <TableRow key={key}>
                <TableCell>{name || "—"}</TableCell>
                {[1, 2, 3, 4].map((q) => (
                  <TableCell key={q} align="right">{fmt(quarters[q])}</TableCell>
                ))}
                <TableCell align="right"><strong>{fmt(total)}</strong></TableCell>
              </TableRow>
            );
          })}
          {!isLoading && pivot.size === 0 && (
            <TableRow><TableCell colSpan={6} sx={{ color: "text.secondary" }}>No data for {year}</TableCell></TableRow>
          )}
        </TableBody>
      </Table>
    </Box>
  );
}
