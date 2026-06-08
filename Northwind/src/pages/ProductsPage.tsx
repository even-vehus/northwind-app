import { useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  Box, Button, Chip, Paper, Table, TableBody, TableCell, TableContainer,
  TableHead, TableRow, TextField, Typography,
} from "@mui/material";
import AddIcon from "@mui/icons-material/Add";
import { useProducts } from "../api/hooks";

export default function ProductsPage() {
  const [search, setSearch] = useState("");
  const [page, setPage] = useState(1);
  const navigate = useNavigate();
  const { data, isLoading, isError } = useProducts({ search, page, pageSize: 25 });

  return (
    <Box>
      <Box sx={{ display: "flex", justifyContent: "space-between", mb: 2 }}>
        <Typography variant="h5">Products</Typography>
        <Box sx={{ display: "flex", gap: 1 }}>
          <Button variant="outlined" onClick={() => navigate("/product-categories")}>
            Categories
          </Button>
          <Button variant="contained" startIcon={<AddIcon />} onClick={() => navigate("/products/new")}>
            New
          </Button>
        </Box>
      </Box>
      <TextField
        label="Search"
        value={search}
        onChange={(e) => { setSearch(e.target.value); setPage(1); }}
        size="small"
        sx={{ mb: 2, width: 320 }}
      />
      {isError && <Typography color="error">Failed to load products.</Typography>}
      <TableContainer component={Paper}>
        <Table size="small">
          <TableHead>
            <TableRow>
              <TableCell>Code</TableCell>
              <TableCell>Name</TableCell>
              <TableCell>Category</TableCell>
              <TableCell align="right">List Price</TableCell>
              <TableCell>Status</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {isLoading ? (
              <TableRow><TableCell colSpan={5}>Loading…</TableCell></TableRow>
            ) : (
              data?.items.map((p) => (
                <TableRow
                  key={p.productId}
                  hover
                  sx={{ cursor: "pointer" }}
                  onClick={() => navigate(`/products/${p.productId}`)}
                >
                  <TableCell>{p.productCode}</TableCell>
                  <TableCell>{p.productName}</TableCell>
                  <TableCell>{p.categoryName}</TableCell>
                  <TableCell align="right">
                    {p.listPrice != null ? `$${p.listPrice.toFixed(2)}` : "—"}
                  </TableCell>
                  <TableCell>
                    {p.discontinued ? (
                      <Chip label="Discontinued" size="small" color="default" />
                    ) : (
                      <Chip label="Active" size="small" color="success" />
                    )}
                  </TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </TableContainer>
    </Box>
  );
}
