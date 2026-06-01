import { useState, useEffect } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { useForm, Controller } from "react-hook-form";
import {
  Box, Button, Chip, CircularProgress, Dialog, DialogActions,
  DialogContent, DialogTitle, Divider, FormControl, Grid,
  IconButton, InputAdornment, InputLabel, MenuItem, Paper, Select,
  Table, TableBody, TableCell, TableHead, TableRow, TextField, Typography,
} from "@mui/material";
import AddIcon from "@mui/icons-material/Add";
import ArrowBackIcon from "@mui/icons-material/ArrowBack";
import CancelIcon from "@mui/icons-material/Cancel";
import DeleteIcon from "@mui/icons-material/Delete";
import EditIcon from "@mui/icons-material/Edit";
import PrintIcon from "@mui/icons-material/Print";
import SaveIcon from "@mui/icons-material/Save";
import {
  useOrder, useCreateOrder, useUpdateOrder, useDeleteOrder,
  useAddOrderDetail, useDeleteOrderDetail,
  useCompaniesLookup, useEmployeesLookup, useProducts,
} from "../api/hooks";
import { ORDER_STATUSES } from "../api/types";

const STATUS_NAME: Record<number, string> = {
  1: "Closed", 2: "Invoiced", 3: "New", 4: "Shipped", 5: "Paid",
};
const STATUS_COLOR: Record<number, "default" | "info" | "warning" | "success" | "primary"> = {
  1: "default", 2: "info", 3: "warning", 4: "primary", 5: "success",
};

type OrderHeaderForm = {
  customerId: string;
  employeeId: string;
  orderStatusId: string;
  orderDate: string;
  shippedDate: string;
  shippingFee: string;
  notes: string;
};

type AddLineForm = {
  productId: string;
  unitPrice: string;
  quantity: string;
  discount: string;
};

function AddLineDialog({
  open, orderId, onClose,
}: { open: boolean; orderId: number; onClose: () => void }) {
  const addDetail = useAddOrderDetail();
  const { data: products } = useProducts({ pageSize: 100 });
  const { register, handleSubmit, reset, setValue } = useForm<AddLineForm>({
    defaultValues: { productId: "", unitPrice: "", quantity: "1", discount: "0" },
  });

  useEffect(() => { if (!open) reset(); }, [open, reset]);

  const onProductChange = (productId: string) => {
    const product = products?.items.find((p) => p.productId === Number(productId));
    if (product?.listPrice) setValue("unitPrice", String(product.listPrice));
  };

  const onSubmit = async (values: AddLineForm) => {
    await addDetail.mutateAsync({
      orderId,
      data: {
        productId: Number(values.productId),
        unitPrice: Number(values.unitPrice),
        quantity: Number(values.quantity),
        discount: Number(values.discount) / 100,
      },
    });
    onClose();
  };

  return (
    <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth>
      <DialogTitle>Add Line Item</DialogTitle>
      <form onSubmit={handleSubmit(onSubmit)}>
        <DialogContent>
          <Grid container spacing={2} sx={{ pt: 1 }}>
            <Grid size={{ xs: 12 }}>
              <TextField
                label="Product"
                {...register("productId")}
                select
                fullWidth size="small"
                onChange={(e) => {
                  register("productId").onChange(e);
                  onProductChange(e.target.value);
                }}
              >
                <MenuItem value=""><em>—</em></MenuItem>
                {products?.items.map((p) => (
                  <MenuItem key={p.productId} value={String(p.productId)}>
                    {p.productName}
                  </MenuItem>
                ))}
              </TextField>
            </Grid>
            <Grid size={{ xs: 4 }}>
              <TextField label="Unit Price" {...register("unitPrice")} type="number" fullWidth size="small"
                slotProps={{ input: { startAdornment: <InputAdornment position="start">$</InputAdornment> } }} />
            </Grid>
            <Grid size={{ xs: 4 }}>
              <TextField label="Qty" {...register("quantity")} type="number" fullWidth size="small" />
            </Grid>
            <Grid size={{ xs: 4 }}>
              <TextField label="Discount %" {...register("discount")} type="number" fullWidth size="small"
                slotProps={{ input: { endAdornment: <InputAdornment position="end">%</InputAdornment> } }} />
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions>
          <Button onClick={onClose}>Cancel</Button>
          <Button type="submit" variant="contained">Add</Button>
        </DialogActions>
      </form>
    </Dialog>
  );
}

export default function OrderDetailPage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const isNew = id === "new";
  const orderId = isNew ? 0 : Number(id);

  const [editing, setEditing] = useState(isNew);
  const [addLineOpen, setAddLineOpen] = useState(false);

  const { data, isLoading, isError } = useOrder(orderId);
  const { data: companies } = useCompaniesLookup();
  const { data: employees } = useEmployeesLookup();

  const createOrder = useCreateOrder();
  const updateOrder = useUpdateOrder();
  const deleteOrder = useDeleteOrder();
  const deleteDetail = useDeleteOrderDetail();

  const { register, handleSubmit, reset, control } = useForm<OrderHeaderForm>();

  useEffect(() => {
    if (data) {
      reset({
        customerId: String(data.customerId ?? ""),
        employeeId: String(data.employeeId ?? ""),
        orderStatusId: String(data.orderStatusId ?? "3"),
        orderDate: data.orderDate ? data.orderDate.slice(0, 10) : "",
        shippedDate: data.shippedDate ? data.shippedDate.slice(0, 10) : "",
        shippingFee: data.shippingFee != null ? String(data.shippingFee) : "",
        notes: data.notes ?? "",
      });
    } else if (isNew) {
      reset({
        customerId: "", employeeId: "", orderStatusId: "3",
        orderDate: new Date().toISOString().slice(0, 10),
        shippedDate: "", shippingFee: "", notes: "",
      });
    }
  }, [data, isNew, reset]);

  const onSubmit = async (values: OrderHeaderForm) => {
    const payload = {
      customerId: values.customerId ? Number(values.customerId) : null,
      employeeId: values.employeeId ? Number(values.employeeId) : null,
      orderStatusId: values.orderStatusId ? Number(values.orderStatusId) : null,
      orderDate: values.orderDate || null,
      shippedDate: values.shippedDate || null,
      shippingFee: values.shippingFee ? Number(values.shippingFee) : null,
      notes: values.notes || null,
    };
    if (isNew) {
      const created = await createOrder.mutateAsync({ ...payload, orderDetails: [] });
      navigate(`/orders/${created.orderId}`, { replace: true });
    } else {
      await updateOrder.mutateAsync({ id: orderId, data: payload });
      setEditing(false);
    }
  };

  const handleDelete = async () => {
    if (!window.confirm("Delete this order?")) return;
    await deleteOrder.mutateAsync(orderId);
    navigate("/orders");
  };

  const handleDeleteDetail = async (detailId: number) => {
    await deleteDetail.mutateAsync({ orderId, detailId });
  };

  if (!isNew && isLoading) return <CircularProgress />;
  if (!isNew && (isError || !data)) return <Typography color="error">Order not found.</Typography>;

  const subtotal = data?.orderDetails.reduce(
    (sum, d) => sum + (d.unitPrice ?? 0) * (d.quantity ?? 0) * (1 - (d.discount ?? 0)), 0,
  ) ?? 0;
  const statusId = data?.orderStatusId ?? 3;

  return (
    <Box>
      {/* Header */}
      <Box sx={{ display: "flex", alignItems: "center", gap: 1, mb: 2, flexWrap: "wrap" }}>
        <Button startIcon={<ArrowBackIcon />} onClick={() => navigate("/orders")}>
          Orders
        </Button>
        <Box sx={{ display: "flex", alignItems: "center", gap: 1, flex: 1 }}>
          <Typography variant="h5">
            {isNew ? "New Order" : `Order #${data?.orderId}`}
          </Typography>
          {!isNew && (
            <Chip
              label={STATUS_NAME[statusId] ?? statusId}
              color={STATUS_COLOR[statusId] ?? "default"}
              size="small"
            />
          )}
        </Box>
        {!isNew && !editing && (
          <>
            <Button startIcon={<EditIcon />} variant="outlined" onClick={() => setEditing(true)}>
              Edit
            </Button>
            <Button startIcon={<PrintIcon />} variant="outlined" onClick={() => navigate(`/orders/${data?.orderId}/invoice`)}>
              Invoice
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
        <Grid container spacing={2} sx={{ mb: 3 }}>
          {([
            ["Customer", data.customerName],
            ["Employee", data.employeeName],
            ["Order Date", data.orderDate ? new Date(data.orderDate).toLocaleDateString() : null],
            ["Shipped Date", data.shippedDate ? new Date(data.shippedDate).toLocaleDateString() : null],
            ["Shipping Fee", data.shippingFee != null ? `$${Number(data.shippingFee).toFixed(2)}` : null],
            ["Notes", data.notes],
          ] as [string, string | null | undefined][]).map(([label, value]) => (
            <Grid key={label} size={{ xs: 12, sm: 6, md: 4 }}>
              <Typography variant="caption" color="text.secondary">{label}</Typography>
              <Typography>{value ?? "—"}</Typography>
            </Grid>
          ))}
        </Grid>
      )}

      {/* Edit / New form */}
      {editing && (
        <Grid container spacing={2} component="form" onSubmit={handleSubmit(onSubmit)} sx={{ mb: 3 }}>
          <Grid size={{ xs: 12, sm: 6 }}>
            <Controller name="customerId" control={control}
              render={({ field }) => (
                <FormControl fullWidth size="small">
                  <InputLabel>Customer</InputLabel>
                  <Select {...field} label="Customer">
                    <MenuItem value=""><em>—</em></MenuItem>
                    {companies?.map((c) => (
                      <MenuItem key={c.companyId} value={String(c.companyId)}>{c.companyName}</MenuItem>
                    ))}
                  </Select>
                </FormControl>
              )}
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 6 }}>
            <Controller name="employeeId" control={control}
              render={({ field }) => (
                <FormControl fullWidth size="small">
                  <InputLabel>Employee</InputLabel>
                  <Select {...field} label="Employee">
                    <MenuItem value=""><em>—</em></MenuItem>
                    {employees?.map((e) => (
                      <MenuItem key={e.employeeId} value={String(e.employeeId)}>{e.fullName}</MenuItem>
                    ))}
                  </Select>
                </FormControl>
              )}
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 4 }}>
            <Controller name="orderStatusId" control={control}
              render={({ field }) => (
                <FormControl fullWidth size="small">
                  <InputLabel>Status</InputLabel>
                  <Select {...field} label="Status">
                    {ORDER_STATUSES.map((s) => (
                      <MenuItem key={s.id} value={String(s.id)}>{s.name}</MenuItem>
                    ))}
                  </Select>
                </FormControl>
              )}
            />
          </Grid>
          <Grid size={{ xs: 6, sm: 4 }}>
            <TextField label="Order Date" {...register("orderDate")} type="date"
              fullWidth size="small" slotProps={{ inputLabel: { shrink: true } }} />
          </Grid>
          <Grid size={{ xs: 6, sm: 4 }}>
            <TextField label="Shipped Date" {...register("shippedDate")} type="date"
              fullWidth size="small" slotProps={{ inputLabel: { shrink: true } }} />
          </Grid>
          <Grid size={{ xs: 6, sm: 4 }}>
            <TextField label="Shipping Fee" {...register("shippingFee")} type="number"
              fullWidth size="small"
              slotProps={{ input: { startAdornment: <InputAdornment position="start">$</InputAdornment> } }} />
          </Grid>
          <Grid size={{ xs: 12 }}>
            <TextField label="Notes" {...register("notes")} multiline rows={2} fullWidth size="small" />
          </Grid>
        </Grid>
      )}

      {/* Line items (only for existing orders) */}
      {!isNew && (
        <>
          <Divider sx={{ mb: 2 }} />
          <Box sx={{ display: "flex", justifyContent: "space-between", alignItems: "center", mb: 1 }}>
            <Typography variant="h6">Line Items</Typography>
            <Button startIcon={<AddIcon />} variant="outlined" size="small"
              onClick={() => setAddLineOpen(true)}>
              Add Item
            </Button>
          </Box>
          <Paper>
            <Table size="small">
              <TableHead>
                <TableRow>
                  <TableCell>Product</TableCell>
                  <TableCell align="right">Unit Price</TableCell>
                  <TableCell align="right">Qty</TableCell>
                  <TableCell align="right">Discount</TableCell>
                  <TableCell align="right">Line Total</TableCell>
                  <TableCell />
                </TableRow>
              </TableHead>
              <TableBody>
                {data?.orderDetails.map((d) => {
                  const lineTotal = (d.unitPrice ?? 0) * (d.quantity ?? 0) * (1 - (d.discount ?? 0));
                  return (
                    <TableRow key={d.orderDetailId}>
                      <TableCell>{d.productName}</TableCell>
                      <TableCell align="right">${Number(d.unitPrice ?? 0).toFixed(2)}</TableCell>
                      <TableCell align="right">{d.quantity}</TableCell>
                      <TableCell align="right">{((d.discount ?? 0) * 100).toFixed(0)}%</TableCell>
                      <TableCell align="right">${lineTotal.toFixed(2)}</TableCell>
                      <TableCell padding="none">
                        <IconButton size="small" color="error"
                          onClick={() => handleDeleteDetail(d.orderDetailId)}>
                          <DeleteIcon fontSize="small" />
                        </IconButton>
                      </TableCell>
                    </TableRow>
                  );
                })}
                <TableRow>
                  <TableCell colSpan={4} align="right"><strong>Subtotal</strong></TableCell>
                  <TableCell align="right"><strong>${subtotal.toFixed(2)}</strong></TableCell>
                  <TableCell />
                </TableRow>
              </TableBody>
            </Table>
          </Paper>

          <AddLineDialog
            open={addLineOpen}
            orderId={orderId}
            onClose={() => setAddLineOpen(false)}
          />
        </>
      )}
    </Box>
  );
}
