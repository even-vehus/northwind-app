import { useState, useEffect } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { useForm, Controller } from "react-hook-form";
import {
  Alert, Box, Button, Chip, CircularProgress, Dialog, DialogActions,
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
  useCompaniesLookup, useEmployeesLookup, useProducts, useShippers,
  useInvoiceOrder, useShipOrder, usePayOrder, useCloseOrder,
} from "../api/hooks";
import type { Order } from "../api/types";
import { ORDER_STATUSES } from "../api/types";

/** Pull the ProblemDetails message out of a 409/4xx axios error. */
function actionErrorMessage(e: unknown): string {
  const detail = (e as { response?: { data?: { detail?: string } } })?.response?.data?.detail;
  return typeof detail === "string" ? detail : "The action could not be completed.";
}

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

function ShipDialog({
  open, order, onClose, onError,
}: { open: boolean; order: Order; onClose: () => void; onError: (m: string) => void }) {
  const ship = useShipOrder();
  const { data: shippers } = useShippers();
  const [shippedDate, setShippedDate] = useState("");
  const [shipperId, setShipperId] = useState("");
  const [shippingFee, setShippingFee] = useState("");

  useEffect(() => {
    if (open) {
      setShippedDate(new Date().toISOString().slice(0, 10));
      setShipperId("");
      setShippingFee(order.shippingFee != null ? String(order.shippingFee) : "");
    }
  }, [open, order]);

  const submit = async () => {
    try {
      await ship.mutateAsync({
        id: order.orderId,
        data: {
          shippedDate: shippedDate || null,
          shipperId: shipperId ? Number(shipperId) : null,
          shippingFee: shippingFee ? Number(shippingFee) : null,
        },
      });
      onClose();
    } catch (e) { onError(actionErrorMessage(e)); }
  };

  return (
    <Dialog open={open} onClose={onClose} maxWidth="xs" fullWidth>
      <DialogTitle>Ship Order</DialogTitle>
      <DialogContent sx={{ display: "flex", flexDirection: "column", gap: 2, pt: 1 }}>
        <TextField label="Shipped Date" type="date" value={shippedDate}
          onChange={(e) => setShippedDate(e.target.value)} size="small"
          slotProps={{ inputLabel: { shrink: true } }} />
        <FormControl size="small" fullWidth>
          <InputLabel>Ship Via</InputLabel>
          <Select value={shipperId} label="Ship Via" onChange={(e) => setShipperId(e.target.value)}>
            <MenuItem value=""><em>—</em></MenuItem>
            {shippers?.map((s) => (
              <MenuItem key={s.companyId} value={String(s.companyId)}>{s.companyName}</MenuItem>
            ))}
          </Select>
        </FormControl>
        <TextField label="Shipping Fee" type="number" value={shippingFee}
          onChange={(e) => setShippingFee(e.target.value)} size="small"
          slotProps={{ input: { startAdornment: <InputAdornment position="start">$</InputAdornment> } }} />
      </DialogContent>
      <DialogActions>
        <Button onClick={onClose}>Cancel</Button>
        <Button variant="contained" onClick={submit} disabled={ship.isPending}>Ship</Button>
      </DialogActions>
    </Dialog>
  );
}

function PayDialog({
  open, order, onClose, onError,
}: { open: boolean; order: Order; onClose: () => void; onError: (m: string) => void }) {
  const pay = usePayOrder();
  const [paymentMethod, setPaymentMethod] = useState("");
  const [paidDate, setPaidDate] = useState("");

  useEffect(() => {
    if (open) {
      setPaymentMethod("");
      setPaidDate(new Date().toISOString().slice(0, 10));
    }
  }, [open]);

  const submit = async () => {
    try {
      await pay.mutateAsync({
        id: order.orderId,
        data: { paymentMethod: paymentMethod || null, paidDate: paidDate || null },
      });
      onClose();
    } catch (e) { onError(actionErrorMessage(e)); }
  };

  return (
    <Dialog open={open} onClose={onClose} maxWidth="xs" fullWidth>
      <DialogTitle>Record Payment</DialogTitle>
      <DialogContent sx={{ display: "flex", flexDirection: "column", gap: 2, pt: 1 }}>
        <FormControl size="small" fullWidth>
          <InputLabel>Payment Method</InputLabel>
          <Select value={paymentMethod} label="Payment Method" onChange={(e) => setPaymentMethod(e.target.value)}>
            <MenuItem value=""><em>—</em></MenuItem>
            {["Cash", "Check", "Credit Card"].map((m) => <MenuItem key={m} value={m}>{m}</MenuItem>)}
          </Select>
        </FormControl>
        <TextField label="Paid Date" type="date" value={paidDate}
          onChange={(e) => setPaidDate(e.target.value)} size="small"
          slotProps={{ inputLabel: { shrink: true } }} />
      </DialogContent>
      <DialogActions>
        <Button onClick={onClose}>Cancel</Button>
        <Button variant="contained" onClick={submit} disabled={pay.isPending}>Record Payment</Button>
      </DialogActions>
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
  const invoiceOrder = useInvoiceOrder();
  const closeOrder = useCloseOrder();

  const [shipOpen, setShipOpen] = useState(false);
  const [payOpen, setPayOpen] = useState(false);
  const [actionError, setActionError] = useState<string | null>(null);

  const runAction = async (fn: () => Promise<unknown>) => {
    setActionError(null);
    try { await fn(); } catch (e) { setActionError(actionErrorMessage(e)); }
  };

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

      {/* Workflow actions (ported from frmOrderDetails) */}
      {!isNew && !editing && data && (
        <Box sx={{ mb: 3 }}>
          {actionError && (
            <Alert severity="error" onClose={() => setActionError(null)} sx={{ mb: 1 }}>{actionError}</Alert>
          )}
          <Box sx={{ display: "flex", gap: 1, alignItems: "center", flexWrap: "wrap" }}>
            <Typography variant="body2" color="text.secondary">Workflow:</Typography>
            {statusId === 3 && (
              <Button variant="contained" disabled={invoiceOrder.isPending}
                onClick={() => runAction(() => invoiceOrder.mutateAsync(orderId))}>
                Create Invoice
              </Button>
            )}
            {statusId === 2 && (
              <Button variant="contained" onClick={() => { setActionError(null); setShipOpen(true); }}>
                Ship Order
              </Button>
            )}
            {statusId === 4 && (
              <Button variant="contained" onClick={() => { setActionError(null); setPayOpen(true); }}>
                Record Payment
              </Button>
            )}
            {statusId === 5 && (
              <Button variant="contained" disabled={closeOrder.isPending}
                onClick={() => runAction(() => closeOrder.mutateAsync(orderId))}>
                Close Order
              </Button>
            )}
            {statusId === 1 && <Typography variant="body2" color="text.secondary">This order is closed.</Typography>}
          </Box>
        </Box>
      )}

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
          {data && (
            <>
              <ShipDialog open={shipOpen} order={data} onClose={() => setShipOpen(false)} onError={setActionError} />
              <PayDialog open={payOpen} order={data} onClose={() => setPayOpen(false)} onError={setActionError} />
            </>
          )}
        </>
      )}
    </Box>
  );
}
