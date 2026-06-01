import { useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  Box, Button, Paper, Table, TableBody, TableCell, TableContainer,
  TableHead, TableRow, TextField, Typography,
} from "@mui/material";
import AddIcon from "@mui/icons-material/Add";
import { useEmployees } from "../api/hooks";

export default function EmployeesPage() {
  const [search, setSearch] = useState("");
  const [page, setPage] = useState(1);
  const navigate = useNavigate();
  const { data, isLoading, isError } = useEmployees({ search, page, pageSize: 25 });

  return (
    <Box>
      <Box sx={{ display: "flex", justifyContent: "space-between", mb: 2 }}>
        <Typography variant="h5">Employees</Typography>
        <Button variant="contained" startIcon={<AddIcon />} onClick={() => navigate("/employees/new")}>
          New
        </Button>
      </Box>

      <TextField
        label="Search"
        value={search}
        onChange={(e) => { setSearch(e.target.value); setPage(1); }}
        size="small"
        sx={{ mb: 2, width: 320 }}
      />

      {isError && <Typography color="error">Failed to load employees.</Typography>}

      <TableContainer component={Paper}>
        <Table size="small">
          <TableHead>
            <TableRow>
              <TableCell>Name</TableCell>
              <TableCell>Job Title</TableCell>
              <TableCell>Email</TableCell>
              <TableCell>Phone</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {isLoading ? (
              <TableRow><TableCell colSpan={4}>Loading…</TableCell></TableRow>
            ) : (
              data?.items.map((e) => (
                <TableRow
                  key={e.employeeId}
                  hover
                  sx={{ cursor: "pointer" }}
                  onClick={() => navigate(`/employees/${e.employeeId}`)}
                >
                  <TableCell>{e.fullName}</TableCell>
                  <TableCell>{e.jobTitle}</TableCell>
                  <TableCell>{e.emailAddress}</TableCell>
                  <TableCell>{e.primaryPhone}</TableCell>
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
