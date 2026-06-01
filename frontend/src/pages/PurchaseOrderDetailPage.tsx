import { useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { Controller, useForm } from "react-hook-form";
import {
  Alert, Box, Button, Chip, Dialog, DialogActions, DialogContent, DialogTitle,
  Divider, FormControl, Grid, IconButton, InputLabel, MenuItem, Select, Table,
  TableBody, TableCell, TableHead, TableRow, TextField, Typography,
} from "@mui/material";
import AddIcon from "@mui/icons-material/Add";
import DeleteIcon from "@mui/icons-material/Delete";
import ArrowBackIcon from "@mui/icons-material/ArrowBack";
import {
  useAddPurchaseOrderDetail, useCompaniesLookup, useCreatePurchaseOrder,
  useDeletePurchaseOrder, useDeletePurchaseOrderDetail, useEmployeesLookup,
  usePurchaseOrder, usePurchaseOrderStatuses, useUpdatePurchaseOrder,
  useProducts, useSubmitPurchaseOrder, useApprovePurchaseOrder,
  useReceivePurchaseOrder, useClosePurchaseOrder,
} from "../api/hooks";

/** Pull the ProblemDetails message out of a 409/4xx axios error. */
function actionErrorMessage(e: unknown): string {
  const detail = (e as { response?: { data?: { detail?: string } } })?.response?.data?.detail;
  return typeof detail === "string" ? detail : "The action could not be completed.";
}

const STATUS_COLORS: Record<string, "default" | "warning" | "info" | "success" | "error"> = {
  New: "info", Submitted: "warning", Approved: "success", Received: "success", Closed: "default",
};

type HeaderForm = {
  vendorId: number | null;
  submittedById: number | null;
  submittedDate: string;
  approvedById: number | null;
  approvedDate: string;
  statusId: number | null;
  receivedDate: string;
  shippingFee: string;
  taxAmount: string;
  paymentDate: string;
  paymentAmount: string;
  paymentMethod: string;
  notes: string;
};

type LineForm = { productId: number | null; quantity: string; unitCost: string };

function AddLineDialog({ purchaseOrderId, onClose }: { purchaseOrderId: number; onClose: () => void }) {
  const { data: products } = useProducts({ pageSize: 100 });
  const addDetail = useAddPurchaseOrderDetail();
  const { register, handleSubmit, watch, setValue } = useForm<LineForm>({
    defaultValues: { productId: null, quantity: "1", unitCost: "0" },
  });
  const watchProduct = watch("productId");

  const onProductChange = (productId: number) => {
    const p = products?.items.find((x) => x.productId === productId);
    if (p?.standardCost) setValue("unitCost", String(p.standardCost));
  };

  const onSubmit = async (data: LineForm) => {
    if (!data.productId) return;
    await addDetail.mutateAsync({
      purchaseOrderId,
      data: {
        productId: Number(data.productId),
        quantity: Number(data.quantity),
        unitCost: Number(data.unitCost),
      },
    });
    onClose();
  };

  return (
    <Dialog open onClose={onClose} maxWidth="sm" fullWidth>
      <form onSubmit={handleSubmit(onSubmit)}>
        <DialogTitle>Add Line Item</DialogTitle>
        <DialogContent sx={{ display: "flex", flexDirection: "column", gap: 2, pt: 2 }}>
          <TextField
            select label="Product" size="small" required
            value={watchProduct ?? ""}
            onChange={(e) => {
              const v = Number(e.target.value);
              setValue("productId", v);
              onProductChange(v);
            }}
          >
            {products?.items.map((p) => (
              <MenuItem key={p.productId} value={p.productId}>{p.productName}</MenuItem>
            ))}
          </TextField>
          <TextField label="Quantity" size="small" type="number" slotProps={{ htmlInput: { min: 1 } }} {...register("quantity", { required: true })} />
          <TextField label="Unit Cost ($)" size="small" type="number" slotProps={{ htmlInput: { step: "0.0001" } }} {...register("unitCost", { required: true })} />
        </DialogContent>
        <DialogActions>
          <Button onClick={onClose}>Cancel</Button>
          <Button type="submit" variant="contained" disabled={addDetail.isPending}>Add</Button>
        </DialogActions>
      </form>
    </Dialog>
  );
}

export default function PurchaseOrderDetailPage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const isNew = id === "new";
  const numId = isNew ? 0 : Number(id);

  const { data: po, isLoading } = usePurchaseOrder(numId);
  const { data: vendors } = useCompaniesLookup();
  const { data: employees } = useEmployeesLookup();
  const { data: statuses } = usePurchaseOrderStatuses();

  const createPO = useCreatePurchaseOrder();
  const updatePO = useUpdatePurchaseOrder();
  const deletePO = useDeletePurchaseOrder();
  const deleteDetail = useDeletePurchaseOrderDetail();
  const submitPO = useSubmitPurchaseOrder();
  const approvePO = useApprovePurchaseOrder();
  const receivePO = useReceivePurchaseOrder();
  const closePO = useClosePurchaseOrder();

  const [editing, setEditing] = useState(isNew);
  const [showAddLine, setShowAddLine] = useState(false);
  const [closeOpen, setCloseOpen] = useState(false);
  const [closeFee, setCloseFee] = useState("");
  const [closeMethod, setCloseMethod] = useState("");
  const [actionError, setActionError] = useState<string | null>(null);

  const runAction = async (fn: () => Promise<unknown>) => {
    setActionError(null);
    try { await fn(); } catch (e) { setActionError(actionErrorMessage(e)); }
  };

  const onCloseConfirm = async () => {
    setActionError(null);
    try {
      await closePO.mutateAsync({
        id: numId,
        data: { shippingFee: closeFee ? Number(closeFee) : null, paymentMethod: closeMethod || null },
      });
      setCloseOpen(false);
    } catch (e) { setActionError(actionErrorMessage(e)); }
  };

  const openCloseDialog = () => {
    setActionError(null);
    setCloseFee(po?.shippingFee != null ? String(po.shippingFee) : "");
    setCloseMethod(po?.paymentMethod ?? "");
    setCloseOpen(true);
  };

  const { control, register, handleSubmit, reset } = useForm<HeaderForm>({
    values: po ? {
      vendorId: po.vendorId,
      submittedById: po.submittedById,
      submittedDate: po.submittedDate?.split("T")[0] ?? "",
      approvedById: po.approvedById,
      approvedDate: po.approvedDate?.split("T")[0] ?? "",
      statusId: po.statusId,
      receivedDate: po.receivedDate?.split("T")[0] ?? "",
      shippingFee: po.shippingFee?.toString() ?? "",
      taxAmount: po.taxAmount?.toString() ?? "",
      paymentDate: po.paymentDate?.split("T")[0] ?? "",
      paymentAmount: po.paymentAmount?.toString() ?? "",
      paymentMethod: po.paymentMethod ?? "",
      notes: po.notes ?? "",
    } : {
      vendorId: null, submittedById: null, submittedDate: new Date().toISOString().split("T")[0],
      approvedById: null, approvedDate: "", statusId: 3,
      receivedDate: "", shippingFee: "", taxAmount: "", paymentDate: "",
      paymentAmount: "", paymentMethod: "", notes: "",
    },
  });

  const onSave = handleSubmit(async (data) => {
    const payload = {
      vendorId: data.vendorId ? Number(data.vendorId) : null,
      submittedById: data.submittedById ? Number(data.submittedById) : null,
      submittedDate: data.submittedDate || null,
      approvedById: data.approvedById ? Number(data.approvedById) : null,
      approvedDate: data.approvedDate || null,
      statusId: data.statusId ? Number(data.statusId) : null,
      receivedDate: data.receivedDate || null,
      shippingFee: data.shippingFee ? Number(data.shippingFee) : null,
      taxAmount: data.taxAmount ? Number(data.taxAmount) : null,
      paymentDate: data.paymentDate || null,
      paymentAmount: data.paymentAmount ? Number(data.paymentAmount) : null,
      paymentMethod: data.paymentMethod || null,
      notes: data.notes || null,
    };

    if (isNew) {
      const created = await createPO.mutateAsync({ ...payload, purchaseOrderDetails: [] });
      navigate(`/purchase-orders/${created.purchaseOrderId}`, { replace: true });
    } else {
      await updatePO.mutateAsync({ id: numId, data: payload });
      setEditing(false);
    }
  });

  const onDelete = async () => {
    if (!window.confirm("Delete this purchase order?")) return;
    await deletePO.mutateAsync(numId);
    navigate("/purchase-orders");
  };

  const onDeleteLine = async (detailId: number) => {
    await deleteDetail.mutateAsync({ purchaseOrderId: numId, detailId });
  };

  if (!isNew && isLoading) return <Box sx={{ p: 3 }}>Loading…</Box>;
  if (!isNew && !po) return <Box sx={{ p: 3 }}>Not found.</Box>;

  const totalCost = po?.purchaseOrderDetails.reduce((sum, d) =>
    sum + (d.quantity ?? 0) * (d.unitCost ?? 0), 0) ?? 0;

  return (
    <Box sx={{ p: 3, maxWidth: 900 }}>
      <Box sx={{ display: "flex", justifyContent: "space-between", mb: 2, alignItems: "center" }}>
        <Box sx={{ display: "flex", alignItems: "center", gap: 1 }}>
          <IconButton onClick={() => navigate("/purchase-orders")}><ArrowBackIcon /></IconButton>
          <Typography variant="h5">
            {isNew ? "New Purchase Order" : `Purchase Order #${po?.purchaseOrderId}`}
          </Typography>
          {!isNew && po?.statusName && (
            <Chip size="small" label={po.statusName} color={STATUS_COLORS[po.statusName] ?? "default"} />
          )}
        </Box>
        <Box sx={{ display: "flex", gap: 1 }}>
          {!isNew && !editing && (
            <Button variant="outlined" onClick={() => navigate(`/purchase-orders/${numId}/print`)}>Print</Button>
          )}
          {!isNew && !editing && <Button variant="outlined" onClick={() => setEditing(true)}>Edit</Button>}
          {editing && !isNew && (
            <Button variant="outlined" onClick={() => { reset(); setEditing(false); }}>Cancel</Button>
          )}
          {editing && <Button variant="contained" onClick={onSave}>Save</Button>}
          {!isNew && !editing && (
            <Button variant="outlined" color="error" startIcon={<DeleteIcon />} onClick={onDelete}>
              Delete
            </Button>
          )}
        </Box>
      </Box>

      {/* Workflow actions (ported from frmPurchaseOrderDetails) */}
      {!isNew && !editing && po && (
        <Box sx={{ mb: 3 }}>
          {actionError && !closeOpen && (
            <Alert severity="error" onClose={() => setActionError(null)} sx={{ mb: 1 }}>{actionError}</Alert>
          )}
          <Box sx={{ display: "flex", gap: 1, alignItems: "center", flexWrap: "wrap" }}>
            <Typography variant="body2" color="text.secondary">Workflow:</Typography>
            {po.statusId === 3 && (
              <Button variant="contained" disabled={submitPO.isPending}
                onClick={() => runAction(() => submitPO.mutateAsync(numId))}>Submit</Button>
            )}
            {po.statusId === 4 && (
              <Button variant="contained" disabled={approvePO.isPending}
                onClick={() => runAction(() => approvePO.mutateAsync(numId))}>Approve</Button>
            )}
            {po.statusId === 1 && (
              <Button variant="contained" disabled={receivePO.isPending}
                onClick={() => runAction(() => receivePO.mutateAsync(numId))}>Receive (post to inventory)</Button>
            )}
            {po.statusId === 5 && (
              <Button variant="contained" onClick={openCloseDialog}>Close PO</Button>
            )}
            {po.statusId === 2 && (
              <Typography variant="body2" color="text.secondary">This purchase order is closed.</Typography>
            )}
          </Box>
        </Box>
      )}

      {/* Header fields */}
      <Grid container spacing={2} sx={{ mb: 3 }}>
        {editing ? (
          <>
            <Grid size={6}>
              <Controller control={control} name="vendorId" render={({ field }) => (
                <TextField select fullWidth size="small" label="Vendor"
                  value={field.value ?? ""} onChange={(e) => field.onChange(Number(e.target.value) || null)}>
                  <MenuItem value="">— None —</MenuItem>
                  {vendors?.map((v) => <MenuItem key={v.companyId} value={v.companyId}>{v.companyName}</MenuItem>)}
                </TextField>
              )} />
            </Grid>
            <Grid size={6}>
              <Controller control={control} name="statusId" render={({ field }) => (
                <TextField select fullWidth size="small" label="Status"
                  value={field.value ?? ""} onChange={(e) => field.onChange(Number(e.target.value) || null)}>
                  {statuses?.map((s) => <MenuItem key={s.statusId} value={s.statusId}>{s.statusName}</MenuItem>)}
                </TextField>
              )} />
            </Grid>
            <Grid size={6}>
              <Controller control={control} name="submittedById" render={({ field }) => (
                <TextField select fullWidth size="small" label="Submitted By"
                  value={field.value ?? ""} onChange={(e) => field.onChange(Number(e.target.value) || null)}>
                  <MenuItem value="">— None —</MenuItem>
                  {employees?.map((e) => <MenuItem key={e.employeeId} value={e.employeeId}>{e.fullName}</MenuItem>)}
                </TextField>
              )} />
            </Grid>
            <Grid size={6}>
              <TextField fullWidth size="small" label="Submitted Date" type="date"
                slotProps={{ inputLabel: { shrink: true } }} {...register("submittedDate")} />
            </Grid>
            <Grid size={6}>
              <Controller control={control} name="approvedById" render={({ field }) => (
                <TextField select fullWidth size="small" label="Approved By"
                  value={field.value ?? ""} onChange={(e) => field.onChange(Number(e.target.value) || null)}>
                  <MenuItem value="">— None —</MenuItem>
                  {employees?.map((e) => <MenuItem key={e.employeeId} value={e.employeeId}>{e.fullName}</MenuItem>)}
                </TextField>
              )} />
            </Grid>
            <Grid size={6}>
              <TextField fullWidth size="small" label="Approved Date" type="date"
                slotProps={{ inputLabel: { shrink: true } }} {...register("approvedDate")} />
            </Grid>
            <Grid size={4}>
              <TextField fullWidth size="small" label="Shipping Fee ($)" type="number" slotProps={{ htmlInput: { step: "0.01" } }} {...register("shippingFee")} />
            </Grid>
            <Grid size={4}>
              <TextField fullWidth size="small" label="Tax Amount ($)" type="number" slotProps={{ htmlInput: { step: "0.01" } }} {...register("taxAmount")} />
            </Grid>
            <Grid size={4}>
              <TextField fullWidth size="small" label="Payment Method" {...register("paymentMethod")} />
            </Grid>
            <Grid size={4}>
              <TextField fullWidth size="small" label="Payment Amount ($)" type="number" slotProps={{ htmlInput: { step: "0.01" } }} {...register("paymentAmount")} />
            </Grid>
            <Grid size={4}>
              <TextField fullWidth size="small" label="Payment Date" type="date"
                slotProps={{ inputLabel: { shrink: true } }} {...register("paymentDate")} />
            </Grid>
            <Grid size={4}>
              <TextField fullWidth size="small" label="Received Date" type="date"
                slotProps={{ inputLabel: { shrink: true } }} {...register("receivedDate")} />
            </Grid>
            <Grid size={12}>
              <TextField fullWidth size="small" label="Notes" multiline rows={2} {...register("notes")} />
            </Grid>
          </>
        ) : (
          <>
            {[
              ["Vendor", po?.vendorName],
              ["Status", po?.statusName],
              ["Submitted By", po?.submittedByName],
              ["Submitted Date", po?.submittedDate ? new Date(po.submittedDate).toLocaleDateString() : "—"],
              ["Approved By", po?.approvedByName],
              ["Approved Date", po?.approvedDate ? new Date(po.approvedDate).toLocaleDateString() : "—"],
              ["Shipping Fee", po?.shippingFee != null ? `$${po.shippingFee.toFixed(2)}` : "—"],
              ["Tax Amount", po?.taxAmount != null ? `$${po.taxAmount.toFixed(2)}` : "—"],
              ["Payment Method", po?.paymentMethod],
              ["Payment Amount", po?.paymentAmount != null ? `$${po.paymentAmount.toFixed(2)}` : "—"],
              ["Payment Date", po?.paymentDate ? new Date(po.paymentDate).toLocaleDateString() : "—"],
              ["Received Date", po?.receivedDate ? new Date(po.receivedDate).toLocaleDateString() : "—"],
            ].map(([label, value]) => (
              <Grid key={label as string} size={4}>
                <Typography variant="caption" color="text.secondary">{label}</Typography>
                <Typography>{value || "—"}</Typography>
              </Grid>
            ))}
            {po?.notes && (
              <Grid size={12}>
                <Typography variant="caption" color="text.secondary">Notes</Typography>
                <Typography>{po.notes}</Typography>
              </Grid>
            )}
          </>
        )}
      </Grid>

      <Divider sx={{ mb: 2 }} />

      {/* Line Items */}
      <Box sx={{ display: "flex", justifyContent: "space-between", mb: 1 }}>
        <Typography variant="h6">Line Items</Typography>
        {!isNew && (
          <Button size="small" startIcon={<AddIcon />} onClick={() => setShowAddLine(true)}>
            Add Item
          </Button>
        )}
      </Box>

      <Table size="small">
        <TableHead>
          <TableRow>
            <TableCell>Product</TableCell>
            <TableCell align="right">Qty</TableCell>
            <TableCell align="right">Unit Cost</TableCell>
            <TableCell align="right">Subtotal</TableCell>
            <TableCell>Received</TableCell>
            <TableCell />
          </TableRow>
        </TableHead>
        <TableBody>
          {po?.purchaseOrderDetails.map((d) => (
            <TableRow key={d.purchaseOrderDetailId}>
              <TableCell>{d.productName}</TableCell>
              <TableCell align="right">{d.quantity}</TableCell>
              <TableCell align="right">${(d.unitCost ?? 0).toFixed(2)}</TableCell>
              <TableCell align="right">${((d.quantity ?? 0) * (d.unitCost ?? 0)).toFixed(2)}</TableCell>
              <TableCell>{d.receivedDate ? new Date(d.receivedDate).toLocaleDateString() : "—"}</TableCell>
              <TableCell>
                <IconButton size="small" color="error" onClick={() => onDeleteLine(d.purchaseOrderDetailId)}>
                  <DeleteIcon fontSize="small" />
                </IconButton>
              </TableCell>
            </TableRow>
          ))}
          {(!po?.purchaseOrderDetails.length) && (
            <TableRow><TableCell colSpan={6} align="center" sx={{ color: "text.secondary" }}>No items</TableCell></TableRow>
          )}
          {!!totalCost && (
            <TableRow>
              <TableCell colSpan={3} />
              <TableCell align="right"><strong>${totalCost.toFixed(2)}</strong></TableCell>
              <TableCell colSpan={2} />
            </TableRow>
          )}
        </TableBody>
      </Table>

      {showAddLine && (
        <AddLineDialog purchaseOrderId={numId} onClose={() => setShowAddLine(false)} />
      )}

      {/* Close PO dialog (requires Shipping Fee + Payment Method) */}
      <Dialog open={closeOpen} onClose={() => setCloseOpen(false)} maxWidth="xs" fullWidth>
        <DialogTitle>Close Purchase Order</DialogTitle>
        <DialogContent sx={{ display: "flex", flexDirection: "column", gap: 2, pt: 1 }}>
          {actionError && <Alert severity="error">{actionError}</Alert>}
          <TextField label="Shipping Fee" type="number" size="small" value={closeFee}
            onChange={(e) => setCloseFee(e.target.value)} />
          <FormControl size="small" fullWidth>
            <InputLabel>Payment Method</InputLabel>
            <Select value={closeMethod} label="Payment Method" onChange={(e) => setCloseMethod(e.target.value)}>
              <MenuItem value=""><em>—</em></MenuItem>
              {["Cash", "Check", "Credit Card"].map((m) => <MenuItem key={m} value={m}>{m}</MenuItem>)}
            </Select>
          </FormControl>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setCloseOpen(false)}>Cancel</Button>
          <Button variant="contained" onClick={onCloseConfirm} disabled={closePO.isPending}>Close PO</Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
}
