import { useNavigate } from "react-router-dom";
import {
  Box, Table, TableBody, TableCell, TableHead, TableRow, Typography,
} from "@mui/material";
import { useCustomerList } from "../api/hooks";

export default function CustomerListPage() {
  const navigate = useNavigate();
  const { data, isLoading } = useCustomerList();

  return (
    <Box sx={{ p: 3 }}>
      <Box sx={{ display: "flex", alignItems: "center", gap: 2, mb: 3 }}>
        <Typography variant="h5" sx={{ flex: 1 }}>Customer List</Typography>
        <Typography variant="body2" color="primary" sx={{ cursor: "pointer" }} onClick={() => navigate("/reports")}>
          ← Reports
        </Typography>
      </Box>

      <Table size="small">
        <TableHead>
          <TableRow>
            <TableCell>Company</TableCell>
            <TableCell>Phone</TableCell>
            <TableCell>Address</TableCell>
            <TableCell>City</TableCell>
            <TableCell>State</TableCell>
            <TableCell>Zip</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {isLoading && <TableRow><TableCell colSpan={6}>Loading…</TableCell></TableRow>}
          {data?.map((c) => (
            <TableRow
              key={c.companyId}
              hover
              sx={{ cursor: "pointer" }}
              onClick={() => navigate(`/companies/${c.companyId}`)}
            >
              <TableCell>{c.companyName || "—"}</TableCell>
              <TableCell>{c.businessPhone || "—"}</TableCell>
              <TableCell>{c.address || "—"}</TableCell>
              <TableCell>{c.city || "—"}</TableCell>
              <TableCell>{c.stateAbbrev || "—"}</TableCell>
              <TableCell>{c.zip || "—"}</TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </Box>
  );
}
