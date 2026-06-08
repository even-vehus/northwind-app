import { useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  Box, Button, Paper, Table, TableBody, TableCell,
  TableContainer, TableHead, TableRow, TextField, Typography,
} from "@mui/material";
import AddIcon from "@mui/icons-material/Add";
import { useCompanies } from "../api/hooks";

export default function CompaniesPage() {
  const [search, setSearch] = useState("");
  const [page, setPage] = useState(1);
  const navigate = useNavigate();

  const { data, isLoading, isError } = useCompanies({ search, page, pageSize: 25 });

  return (
    <Box>
      <Box sx={{ display: "flex", justifyContent: "space-between", mb: 2 }}>
        <Typography variant="h5">Companies</Typography>
        <Button variant="contained" startIcon={<AddIcon />} onClick={() => navigate("/companies/new")}>
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

      {isError && <Typography color="error">Failed to load companies.</Typography>}

      <TableContainer component={Paper}>
        <Table size="small">
          <TableHead>
            <TableRow>
              <TableCell>Name</TableCell>
              <TableCell>Type</TableCell>
              <TableCell>City</TableCell>
              <TableCell>Phone</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {isLoading ? (
              <TableRow><TableCell colSpan={4}>Loading…</TableCell></TableRow>
            ) : (
              data?.items.map((c) => (
                <TableRow
                  key={c.companyId}
                  hover
                  sx={{ cursor: "pointer" }}
                  onClick={() => navigate(`/companies/${c.companyId}`)}
                >
                  <TableCell>{c.companyName}</TableCell>
                  <TableCell>{c.companyTypeName}</TableCell>
                  <TableCell>{c.city}</TableCell>
                  <TableCell>{c.businessPhone}</TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </TableContainer>

      <Box sx={{ mt: 1, display: "flex", gap: 1 }}>
        <Button disabled={page <= 1} onClick={() => setPage((p) => p - 1)}>Previous</Button>
        <Typography sx={{ alignSelf: "center" }}>
          Page {page} / {Math.ceil((data?.totalCount ?? 0) / 25)}
        </Typography>
        <Button
          disabled={!data || page * 25 >= data.totalCount}
          onClick={() => setPage((p) => p + 1)}
        >
          Next
        </Button>
      </Box>
    </Box>
  );
}
