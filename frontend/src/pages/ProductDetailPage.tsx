import { useState, useEffect } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { useForm, Controller } from "react-hook-form";
import {
  Box, Button, Checkbox, Chip, CircularProgress, Divider,
  FormControl, FormControlLabel, Grid, IconButton, InputAdornment, InputLabel,
  MenuItem, Paper, Select, Tab, Table, TableBody, TableCell, TableHead, TableRow,
  Tabs, TextField, Typography,
} from "@mui/material";
import ArrowBackIcon from "@mui/icons-material/ArrowBack";
import AddIcon from "@mui/icons-material/Add";
import CancelIcon from "@mui/icons-material/Cancel";
import DeleteIcon from "@mui/icons-material/Delete";
import EditIcon from "@mui/icons-material/Edit";
import SaveIcon from "@mui/icons-material/Save";
import {
  useProduct, useCreateProduct, useUpdateProduct, useDeleteProduct,
  useProductCategories, useProductVendors, useAddProductVendor, useRemoveProductVendor,
  useStockTakes, useAddStockTake, useDeleteStockTake, useCompaniesLookup,
  useProductOrders, useProductPurchaseOrders, useProductInventory,
} from "../api/hooks";

type ProductForm = {
  productName: string;
  productCode: string;
  productCategoryId: string;
  listPrice: string;
  standardCost: string;
  description: string;
  discontinued: boolean;
};

export default function ProductDetailPage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const isNew = id === "new";
  const productId = isNew ? 0 : Number(id);

  const [editing, setEditing] = useState(isNew);
  const [tab, setTab] = useState(0);
  const [newVendorId, setNewVendorId] = useState("");
  const [showStockTakeForm, setShowStockTakeForm] = useState(false);
  const [newStockDate, setNewStockDate] = useState("");
  const [newStockQty, setNewStockQty] = useState("");
  const [newStockExpected, setNewStockExpected] = useState("");

  const { data, isLoading, isError } = useProduct(productId);
  const { data: categories } = useProductCategories();
  const { data: vendors } = useProductVendors(productId);
  const { data: companies } = useCompaniesLookup();
  const { data: stockTakes } = useStockTakes(productId);
  const { data: productOrders } = useProductOrders(productId);
  const { data: productPOs } = useProductPurchaseOrders(productId);
  const { data: inventory } = useProductInventory(productId);
  const addVendor = useAddProductVendor();
  const removeVendor = useRemoveProductVendor();
  const addStockTake = useAddStockTake();
  const deleteStockTake = useDeleteStockTake();
  const createProduct = useCreateProduct();
  const updateProduct = useUpdateProduct();
  const deleteProduct = useDeleteProduct();

  const { register, handleSubmit, reset, control } = useForm<ProductForm>();

  useEffect(() => {
    if (data) {
      reset({
        productName: data.productName ?? "",
        productCode: data.productCode ?? "",
        productCategoryId: String(data.productCategoryId ?? ""),
        listPrice: data.listPrice != null ? String(data.listPrice) : "",
        standardCost: data.standardCost != null ? String(data.standardCost) : "",
        description: data.description ?? "",
        discontinued: data.discontinued ?? false,
      });
    }
  }, [data, reset]);

  const onSubmit = async (values: ProductForm) => {
    const payload = {
      productName: values.productName || null,
      productCode: values.productCode || null,
      productCategoryId: values.productCategoryId ? Number(values.productCategoryId) : null,
      listPrice: values.listPrice ? Number(values.listPrice) : null,
      standardCost: values.standardCost ? Number(values.standardCost) : null,
      description: values.description || null,
      discontinued: values.discontinued,
    };
    if (isNew) {
      const created = await createProduct.mutateAsync(payload);
      navigate(`/products/${created.productId}`, { replace: true });
    } else {
      await updateProduct.mutateAsync({ id: productId, data: payload });
      setEditing(false);
    }
  };

  const handleDelete = async () => {
    if (!window.confirm("Delete this product?")) return;
    await deleteProduct.mutateAsync(productId);
    navigate("/products");
  };

  if (!isNew && isLoading) return <CircularProgress />;
  if (!isNew && (isError || !data)) return <Typography color="error">Product not found.</Typography>;

  return (
    <Box>
      <Box sx={{ display: "flex", alignItems: "center", gap: 1, mb: 2, flexWrap: "wrap" }}>
        <Button startIcon={<ArrowBackIcon />} onClick={() => navigate("/products")}>
          Products
        </Button>
        <Box sx={{ display: "flex", alignItems: "center", gap: 1, flex: 1 }}>
          <Typography variant="h5">
            {isNew ? "New Product" : (data?.productName ?? "Product")}
          </Typography>
          {!isNew && !editing && (
            data?.discontinued
              ? <Chip label="Discontinued" color="default" size="small" />
              : <Chip label="Active" color="success" size="small" />
          )}
        </Box>
        {!isNew && !editing && (
          <>
            <Button startIcon={<EditIcon />} variant="outlined" onClick={() => setEditing(true)}>
              Edit
            </Button>
            <Button startIcon={<DeleteIcon />} color="error" onClick={handleDelete}>
              Delete
            </Button>
          </>
        )}
        {editing && (
          <>
            <Button startIcon={<SaveIcon />} variant="contained" onClick={handleSubmit(onSubmit)}>
              Save
            </Button>
            {!isNew && (
              <Button startIcon={<CancelIcon />} onClick={() => { setEditing(false); reset(); }}>
                Cancel
              </Button>
            )}
          </>
        )}
      </Box>

      {/* View mode */}
      {!editing && data && (
        <>
          <Divider sx={{ mb: 2 }} />
          <Grid container spacing={2}>
            {([
              ["Product Code", data.productCode],
              ["Category", data.categoryName],
              ["List Price", data.listPrice != null ? `$${Number(data.listPrice).toFixed(2)}` : null],
              ["Standard Cost", data.standardCost != null ? `$${Number(data.standardCost).toFixed(2)}` : null],
            ] as [string, string | null | undefined][]).map(([label, value]) => (
              <Grid key={label} size={{ xs: 12, sm: 6 }}>
                <Typography variant="caption" color="text.secondary">{label}</Typography>
                <Typography>{value || "—"}</Typography>
              </Grid>
            ))}
            {data.description && (
              <Grid size={{ xs: 12 }}>
                <Typography variant="caption" color="text.secondary">Description</Typography>
                <Typography
                  dangerouslySetInnerHTML={{ __html: data.description }}
                  sx={{ "& *": { fontFamily: "inherit" } }}
                />
              </Grid>
            )}
          </Grid>
        </>
      )}

      {/* Edit / New form */}
      {editing && (
        <Grid container spacing={2} component="form" onSubmit={handleSubmit(onSubmit)}>
          <Grid size={{ xs: 12, sm: 8 }}>
            <TextField label="Product Name" {...register("productName")} fullWidth size="small" />
          </Grid>
          <Grid size={{ xs: 12, sm: 4 }}>
            <TextField label="Product Code" {...register("productCode")} fullWidth size="small" />
          </Grid>
          <Grid size={{ xs: 12, sm: 6 }}>
            <Controller
              name="productCategoryId"
              control={control}
              render={({ field }) => (
                <FormControl fullWidth size="small">
                  <InputLabel>Category</InputLabel>
                  <Select {...field} label="Category">
                    <MenuItem value=""><em>—</em></MenuItem>
                    {categories?.map((c) => (
                      <MenuItem key={c.categoryId} value={String(c.categoryId)}>
                        {c.categoryName}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
              )}
            />
          </Grid>
          <Grid size={{ xs: 6, sm: 3 }}>
            <TextField
              label="List Price"
              {...register("listPrice")}
              fullWidth size="small"
              type="number"
              slotProps={{ input: { startAdornment: <InputAdornment position="start">$</InputAdornment> } }}
            />
          </Grid>
          <Grid size={{ xs: 6, sm: 3 }}>
            <TextField
              label="Standard Cost"
              {...register("standardCost")}
              fullWidth size="small"
              type="number"
              slotProps={{ input: { startAdornment: <InputAdornment position="start">$</InputAdornment> } }}
            />
          </Grid>
          <Grid size={{ xs: 12 }}>
            <TextField
              label="Description"
              {...register("description")}
              multiline rows={4}
              fullWidth size="small"
            />
          </Grid>
          <Grid size={{ xs: 12 }}>
            <Controller
              name="discontinued"
              control={control}
              render={({ field }) => (
                <FormControlLabel
                  control={<Checkbox checked={field.value} onChange={field.onChange} />}
                  label="Discontinued"
                />
              )}
            />
          </Grid>
        </Grid>
      )}

      {/* Inventory snapshot (ported from modInventory) */}
      {!isNew && inventory && (
        <Box sx={{ mt: 3 }}>
          <Typography variant="h6" gutterBottom>Inventory</Typography>
          <Grid container spacing={2}>
            {([
              { label: "Available", value: inventory.quantityAvailable },
              { label: "To Sell", value: inventory.quantityToSell, warnIfNegative: true },
              { label: "Allocated", value: inventory.quantityAllocated },
              { label: "On Order", value: inventory.quantityOnOrder },
              { label: "No Stock", value: inventory.quantityNoStock, warnIfPositive: true },
            ] as { label: string; value: number; warnIfNegative?: boolean; warnIfPositive?: boolean }[]).map((stat) => {
              const isWarn =
                (stat.warnIfNegative === true && stat.value < 0) ||
                (stat.warnIfPositive === true && stat.value > 0);
              return (
                <Grid size={{ xs: 6, sm: 4, md: 2.4 }} key={stat.label}>
                  <Paper variant="outlined" sx={{ p: 1.5, textAlign: "center" }}>
                    <Typography variant="h5" color={isWarn ? "error.main" : "text.primary"}>
                      {stat.value}
                    </Typography>
                    <Typography variant="caption" color="text.secondary">{stat.label}</Typography>
                  </Paper>
                </Grid>
              );
            })}
          </Grid>
          <Typography variant="body2" sx={{ mt: 1.5 }} color="text.secondary">
            Suggested reorder quantity: <b>{inventory.suggestedReorderQuantity}</b>
            {" · "}Last stock take:{" "}
            {inventory.lastStockTakeDate
              ? `${new Date(inventory.lastStockTakeDate).toLocaleDateString()} (${inventory.lastStockTakeQuantity} on hand)`
              : "none"}
          </Typography>
        </Box>
      )}

      {/* Sub-resource tabs (existing products only) */}
      {!isNew && (
        <Box sx={{ mt: 3 }}>
          <Tabs value={tab} onChange={(_, v: number) => setTab(v)}>
            <Tab label={`Vendors (${vendors?.length ?? 0})`} />
            <Tab label={`Stock Takes (${stockTakes?.length ?? 0})`} />
            <Tab label={`Orders (${productOrders?.totalCount ?? 0})`} />
            <Tab label={`Purchase Orders (${productPOs?.totalCount ?? 0})`} />
          </Tabs>
          <Divider />

          {/* Vendors tab */}
          {tab === 0 && (
            <Box sx={{ pt: 2 }}>
              <Box sx={{ display: "flex", gap: 1, mb: 1, alignItems: "center" }}>
                <Select
                  size="small"
                  value={newVendorId}
                  onChange={(e) => setNewVendorId(e.target.value as string)}
                  displayEmpty
                  sx={{ minWidth: 200 }}
                >
                  <MenuItem value=""><em>Select vendor…</em></MenuItem>
                  {companies
                    ?.filter((c) => !vendors?.some((v) => v.vendorId === c.companyId))
                    .map((c) => <MenuItem key={c.companyId} value={String(c.companyId)}>{c.companyName}</MenuItem>)}
                </Select>
                <Button
                  variant="outlined" size="small" startIcon={<AddIcon />}
                  disabled={!newVendorId}
                  onClick={() => {
                    if (!newVendorId) return;
                    addVendor.mutate({ productId, vendorId: Number(newVendorId) });
                    setNewVendorId("");
                  }}
                >
                  Add
                </Button>
              </Box>
              <Table size="small">
                <TableHead>
                  <TableRow>
                    <TableCell>Vendor</TableCell>
                    <TableCell />
                  </TableRow>
                </TableHead>
                <TableBody>
                  {vendors?.map((v) => (
                    <TableRow key={v.productVendorId}>
                      <TableCell>{v.vendorName}</TableCell>
                      <TableCell align="right">
                        <IconButton size="small" color="error"
                          onClick={() => removeVendor.mutate({ productId, productVendorId: v.productVendorId })}>
                          <DeleteIcon fontSize="small" />
                        </IconButton>
                      </TableCell>
                    </TableRow>
                  ))}
                  {vendors?.length === 0 && (
                    <TableRow><TableCell colSpan={2} sx={{ color: "text.secondary" }}>No vendors</TableCell></TableRow>
                  )}
                </TableBody>
              </Table>
            </Box>
          )}

          {/* Stock Takes tab */}
          {tab === 1 && (
            <Box sx={{ pt: 2 }}>
              {!showStockTakeForm && (
                <Button size="small" variant="outlined" startIcon={<AddIcon />}
                  sx={{ mb: 1 }} onClick={() => setShowStockTakeForm(true)}>
                  Record Stock Take
                </Button>
              )}
              {showStockTakeForm && (
                <Box sx={{ display: "flex", gap: 1, mb: 2, flexWrap: "wrap", alignItems: "flex-end" }}>
                  <TextField label="Date" type="date" size="small" value={newStockDate}
                    onChange={(e) => setNewStockDate(e.target.value)}
                    slotProps={{ inputLabel: { shrink: true } }} />
                  <TextField label="Qty On Hand" type="number" size="small" value={newStockQty}
                    onChange={(e) => setNewStockQty(e.target.value)} sx={{ width: 120 }} />
                  <TextField label="Expected" type="number" size="small" value={newStockExpected}
                    onChange={(e) => setNewStockExpected(e.target.value)} sx={{ width: 120 }} />
                  <Button variant="contained" size="small" onClick={async () => {
                    await addStockTake.mutate({
                      productId,
                      data: {
                        stockTakeDate: newStockDate || undefined,
                        quantityOnHand: newStockQty ? Number(newStockQty) : undefined,
                        expectedQuantity: newStockExpected ? Number(newStockExpected) : undefined,
                      },
                    });
                    setShowStockTakeForm(false);
                    setNewStockDate(""); setNewStockQty(""); setNewStockExpected("");
                  }}>
                    Save
                  </Button>
                  <Button size="small" onClick={() => setShowStockTakeForm(false)}>Cancel</Button>
                </Box>
              )}
              <Table size="small">
                <TableHead>
                  <TableRow>
                    <TableCell>Date</TableCell>
                    <TableCell>Qty On Hand</TableCell>
                    <TableCell>Expected</TableCell>
                    <TableCell />
                  </TableRow>
                </TableHead>
                <TableBody>
                  {stockTakes?.map((s) => (
                    <TableRow key={s.stockTakeId}>
                      <TableCell>{s.stockTakeDate ? new Date(s.stockTakeDate).toLocaleDateString() : "—"}</TableCell>
                      <TableCell>{s.quantityOnHand ?? "—"}</TableCell>
                      <TableCell>{s.expectedQuantity ?? "—"}</TableCell>
                      <TableCell align="right">
                        <IconButton size="small" color="error"
                          onClick={() => deleteStockTake.mutate({ productId, stockTakeId: s.stockTakeId })}>
                          <DeleteIcon fontSize="small" />
                        </IconButton>
                      </TableCell>
                    </TableRow>
                  ))}
                  {stockTakes?.length === 0 && (
                    <TableRow><TableCell colSpan={4} sx={{ color: "text.secondary" }}>No stock takes recorded</TableCell></TableRow>
                  )}
                </TableBody>
              </Table>
            </Box>
          )}

          {/* Orders tab */}
          {tab === 2 && (
            <Box sx={{ pt: 2 }}>
              <Table size="small">
                <TableHead>
                  <TableRow>
                    <TableCell>Order #</TableCell>
                    <TableCell>Date</TableCell>
                    <TableCell>Customer</TableCell>
                    <TableCell>Status</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {productOrders?.items.map((o) => (
                    <TableRow key={o.orderId} hover sx={{ cursor: "pointer" }}
                      onClick={() => navigate(`/orders/${o.orderId}`)}>
                      <TableCell>{o.orderId}</TableCell>
                      <TableCell>{o.orderDate ? new Date(o.orderDate).toLocaleDateString() : "—"}</TableCell>
                      <TableCell>{o.customerName ?? "—"}</TableCell>
                      <TableCell>{o.orderStatusId ?? "—"}</TableCell>
                    </TableRow>
                  ))}
                  {(productOrders?.items.length ?? 0) === 0 && (
                    <TableRow><TableCell colSpan={4} sx={{ color: "text.secondary" }}>No orders</TableCell></TableRow>
                  )}
                </TableBody>
              </Table>
            </Box>
          )}

          {/* Purchase Orders tab */}
          {tab === 3 && (
            <Box sx={{ pt: 2 }}>
              <Table size="small">
                <TableHead>
                  <TableRow>
                    <TableCell>PO #</TableCell>
                    <TableCell>Submitted</TableCell>
                    <TableCell>Vendor</TableCell>
                    <TableCell>Status</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {productPOs?.items.map((p) => (
                    <TableRow key={p.purchaseOrderId} hover sx={{ cursor: "pointer" }}
                      onClick={() => navigate(`/purchase-orders/${p.purchaseOrderId}`)}>
                      <TableCell>{p.purchaseOrderId}</TableCell>
                      <TableCell>{p.submittedDate ? new Date(p.submittedDate).toLocaleDateString() : "—"}</TableCell>
                      <TableCell>{p.vendorName ?? "—"}</TableCell>
                      <TableCell>{p.statusName ?? "—"}</TableCell>
                    </TableRow>
                  ))}
                  {(productPOs?.items.length ?? 0) === 0 && (
                    <TableRow><TableCell colSpan={4} sx={{ color: "text.secondary" }}>No purchase orders</TableCell></TableRow>
                  )}
                </TableBody>
              </Table>
            </Box>
          )}
        </Box>
      )}
    </Box>
  );
}
