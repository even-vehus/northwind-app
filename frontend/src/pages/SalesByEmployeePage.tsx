import { useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  Box, FormControl, InputLabel, MenuItem, Select, Table, TableBody,
  TableCell, TableHead, TableRow, Typography,
} from "@mui/material";
import { useSalesByEmployee } from "../api/hooks";

const currentYear = new Date().getFullYear();
const years = Array.from({ length: 6 }, (_, i) => currentYear - i);

export default function SalesByEmployeePage() {
  const navigate = useNavigate();
  const [year, setYear] = useState<number | "">(currentYear);
  const { data, isLoading } = useSalesByEmployee(year || undefined);

  const fmt = (v: number | null | undefined) =>
    v != null ? v.toLocaleString("en-US", { style: "currency", currency: "USD", maximumFractionDigits: 0 }) : "—";

  return (
    <Box sx={{ p: 3, maxWidth: 700 }}>
      <Box sx={{ display: "flex", alignItems: "center", gap: 2, mb: 3 }}>
        <Typography variant="h5" sx={{ flex: 1 }}>Sales by Employee</Typography>
        <FormControl size="small" sx={{ minWidth: 120 }}>
          <InputLabel>Year</InputLabel>
          <Select value={year} label="Year" onChange={(e) => setYear(e.target.value as number | "")}>
            <MenuItem value=""><em>All time</em></MenuItem>
            {years.map((y) => <MenuItem key={y} value={y}>{y}</MenuItem>)}
          </Select>
        </FormControl>
        <Typography
          variant="body2"
          color="primary"
          sx={{ cursor: "pointer" }}
          onClick={() => navigate("/reports")}
        >
          ← Reports
        </Typography>
      </Box>

      <Table size="small">
        <TableHead>
          <TableRow>
            <TableCell>Employee</TableCell>
            <TableCell align="right">Orders</TableCell>
            <TableCell align="right">Revenue</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {isLoading && <TableRow><TableCell colSpan={3}>Loading…</TableCell></TableRow>}
          {data?.map((row) => (
            <TableRow key={row.employeeId ?? "none"}>
              <TableCell>{row.employeeName || "—"}</TableCell>
              <TableCell align="right">{row.orderCount}</TableCell>
              <TableCell align="right">{fmt(row.revenue)}</TableCell>
            </TableRow>
          ))}
          {data?.length === 0 && (
            <TableRow><TableCell colSpan={3} sx={{ color: "text.secondary" }}>No data for selected year</TableCell></TableRow>
          )}
        </TableBody>
      </Table>
    </Box>
  );
}
