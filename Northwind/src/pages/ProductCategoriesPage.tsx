import { useState } from "react";
import {
  Box, Button, CircularProgress, Dialog, DialogActions, DialogContent,
  DialogTitle, IconButton, Table, TableBody, TableCell, TableHead,
  TableRow, TextField, Typography,
} from "@mui/material";
import AddIcon from "@mui/icons-material/Add";
import DeleteIcon from "@mui/icons-material/Delete";
import EditIcon from "@mui/icons-material/Edit";
import {
  useProductCategoriesFull,
  useCreateProductCategory,
  useUpdateProductCategory,
  useDeleteProductCategory,
} from "../api/hooks";
import type { ProductCategory } from "../api/types";

type CategoryForm = { categoryName: string; categoryCode: string; categoryDesc: string };

export default function ProductCategoriesPage() {
  const { data, isLoading } = useProductCategoriesFull();
  const createCategory = useCreateProductCategory();
  const updateCategory = useUpdateProductCategory();
  const deleteCategory = useDeleteProductCategory();

  const [dialogOpen, setDialogOpen] = useState(false);
  const [editTarget, setEditTarget] = useState<ProductCategory | null>(null);
  const [form, setForm] = useState<CategoryForm>({ categoryName: "", categoryCode: "", categoryDesc: "" });

  const openNew = () => {
    setEditTarget(null);
    setForm({ categoryName: "", categoryCode: "", categoryDesc: "" });
    setDialogOpen(true);
  };

  const openEdit = (cat: ProductCategory) => {
    setEditTarget(cat);
    setForm({
      categoryName: cat.categoryName ?? "",
      categoryCode: cat.categoryCode ?? "",
      categoryDesc: cat.categoryDesc ?? "",
    });
    setDialogOpen(true);
  };

  const handleSave = async () => {
    const payload = {
      categoryName: form.categoryName || undefined,
      categoryCode: form.categoryCode || undefined,
      categoryDesc: form.categoryDesc || undefined,
    };
    if (editTarget) {
      await updateCategory.mutateAsync({ id: editTarget.categoryId, data: payload });
    } else {
      await createCategory.mutateAsync(payload);
    }
    setDialogOpen(false);
  };

  const handleDelete = (cat: ProductCategory) => {
    if (!window.confirm(`Delete category "${cat.categoryName}"?`)) return;
    deleteCategory.mutate(cat.categoryId);
  };

  if (isLoading) return <CircularProgress />;

  return (
    <Box>
      <Box sx={{ display: "flex", alignItems: "center", justifyContent: "space-between", mb: 2 }}>
        <Typography variant="h5">Product Categories</Typography>
        <Button variant="contained" startIcon={<AddIcon />} onClick={openNew}>
          New Category
        </Button>
      </Box>

      <Table size="small">
        <TableHead>
          <TableRow>
            <TableCell>Name</TableCell>
            <TableCell>Code</TableCell>
            <TableCell>Description</TableCell>
            <TableCell align="right">Products</TableCell>
            <TableCell />
          </TableRow>
        </TableHead>
        <TableBody>
          {(data as ProductCategory[] | undefined)?.map((cat) => (
            <TableRow key={cat.categoryId}>
              <TableCell>{cat.categoryName ?? "—"}</TableCell>
              <TableCell>{cat.categoryCode ?? "—"}</TableCell>
              <TableCell sx={{ maxWidth: 300, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                {cat.categoryDesc ?? "—"}
              </TableCell>
              <TableCell align="right">{cat.productCount}</TableCell>
              <TableCell align="right">
                <IconButton size="small" onClick={() => openEdit(cat)}><EditIcon fontSize="small" /></IconButton>
                <IconButton size="small" color="error" onClick={() => handleDelete(cat)}><DeleteIcon fontSize="small" /></IconButton>
              </TableCell>
            </TableRow>
          ))}
          {(data as ProductCategory[] | undefined)?.length === 0 && (
            <TableRow>
              <TableCell colSpan={5} sx={{ color: "text.secondary" }}>No categories</TableCell>
            </TableRow>
          )}
        </TableBody>
      </Table>

      <Dialog open={dialogOpen} onClose={() => setDialogOpen(false)} maxWidth="sm" fullWidth>
        <DialogTitle>{editTarget ? "Edit Category" : "New Category"}</DialogTitle>
        <DialogContent sx={{ display: "flex", flexDirection: "column", gap: 2, pt: 2 }}>
          <TextField
            label="Name"
            value={form.categoryName}
            onChange={(e) => setForm((f) => ({ ...f, categoryName: e.target.value }))}
            fullWidth size="small"
          />
          <TextField
            label="Code"
            value={form.categoryCode}
            onChange={(e) => setForm((f) => ({ ...f, categoryCode: e.target.value }))}
            fullWidth size="small"
          />
          <TextField
            label="Description"
            value={form.categoryDesc}
            onChange={(e) => setForm((f) => ({ ...f, categoryDesc: e.target.value }))}
            multiline rows={3}
            fullWidth size="small"
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setDialogOpen(false)}>Cancel</Button>
          <Button variant="contained" onClick={handleSave}>Save</Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
}
