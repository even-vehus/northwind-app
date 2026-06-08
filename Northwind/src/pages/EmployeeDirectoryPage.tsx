import { useNavigate } from "react-router-dom";
import {
  Box, Table, TableBody, TableCell, TableHead, TableRow, Typography,
} from "@mui/material";
import { useEmployeeDirectory } from "../api/hooks";

export default function EmployeeDirectoryPage() {
  const navigate = useNavigate();
  const { data, isLoading } = useEmployeeDirectory();

  return (
    <Box sx={{ p: 3 }}>
      <Box sx={{ display: "flex", alignItems: "center", gap: 2, mb: 3 }}>
        <Typography variant="h5" sx={{ flex: 1 }}>Employee Directory</Typography>
        <Typography variant="body2" color="primary" sx={{ cursor: "pointer" }} onClick={() => navigate("/reports")}>
          ← Reports
        </Typography>
      </Box>

      <Table size="small">
        <TableHead>
          <TableRow>
            <TableCell>Name</TableCell>
            <TableCell>Job Title</TableCell>
            <TableCell>Email</TableCell>
            <TableCell>Primary Phone</TableCell>
            <TableCell>Secondary Phone</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {isLoading && <TableRow><TableCell colSpan={5}>Loading…</TableCell></TableRow>}
          {data?.map((e) => (
            <TableRow
              key={e.employeeId}
              hover
              sx={{ cursor: "pointer" }}
              onClick={() => navigate(`/employees/${e.employeeId}`)}
            >
              <TableCell>
                {[e.title, e.firstName, e.lastName].filter(Boolean).join(" ") || "—"}
              </TableCell>
              <TableCell>{e.jobTitle || "—"}</TableCell>
              <TableCell>{e.emailAddress || "—"}</TableCell>
              <TableCell>{e.primaryPhone || "—"}</TableCell>
              <TableCell>{e.secondaryPhone || "—"}</TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </Box>
  );
}
