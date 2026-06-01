import { useState, useEffect } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { useForm, Controller } from "react-hook-form";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import {
  Alert, Box, Button, CircularProgress, Dialog, DialogActions, DialogContent,
  DialogTitle, Divider, FormControl, Grid, InputLabel, MenuItem, Paper,
  Select, Tab, Table, TableBody, TableCell, TableContainer, TableHead,
  TableRow, Tabs, TextField, Typography,
} from "@mui/material";
import AddIcon from "@mui/icons-material/Add";
import ArrowBackIcon from "@mui/icons-material/ArrowBack";
import CancelIcon from "@mui/icons-material/Cancel";
import DeleteIcon from "@mui/icons-material/Delete";
import EditIcon from "@mui/icons-material/Edit";
import SaveIcon from "@mui/icons-material/Save";
import {
  useCompany, useCreateCompany, useUpdateCompany, useDeleteCompany,
  useCompanyTypes, useCreateContact, useUpdateContact, useDeleteContact,
  useCompanyShipperOrders, useCompanyVendorPurchaseOrders, useStates,
} from "../api/hooks";
import { contactsApi, ordersApi } from "../api/endpoints";
import type { Contact } from "../api/types";

/** Pull the ProblemDetails message out of a 409/4xx axios error. */
function actionErrorMessage(e: unknown): string {
  const detail = (e as { response?: { data?: { detail?: string } } })?.response?.data?.detail;
  return typeof detail === "string" ? detail : "The action could not be completed.";
}

type CompanyForm = {
  companyName: string;
  companyTypeId: string;
  businessPhone: string;
  address: string;
  city: string;
  stateAbbrev: string;
  zip: string;
  website: string;
  notes: string;
};

type ContactForm = {
  firstName: string;
  lastName: string;
  emailAddress: string;
  jobTitle: string;
  primaryPhone: string;
  secondaryPhone: string;
  notes: string;
};

function ContactDialog({
  open, contact, companyId, onClose,
}: { open: boolean; contact: Contact | null; companyId: number; onClose: () => void }) {
  const createContact = useCreateContact();
  const updateContact = useUpdateContact();
  const deleteContact = useDeleteContact();
  const { register, handleSubmit, reset } = useForm<ContactForm>();

  useEffect(() => {
    if (open) {
      reset({
        firstName: contact?.firstName ?? "",
        lastName: contact?.lastName ?? "",
        emailAddress: contact?.emailAddress ?? "",
        jobTitle: contact?.jobTitle ?? "",
        primaryPhone: contact?.primaryPhone ?? "",
        secondaryPhone: contact?.secondaryPhone ?? "",
        notes: contact?.notes ?? "",
      });
    }
  }, [open, contact, reset]);

  const onSubmit = async (data: ContactForm) => {
    const payload = { ...data, companyId };
    if (contact) {
      await updateContact.mutateAsync({ id: contact.contactId, data: payload });
    } else {
      await createContact.mutateAsync(payload);
    }
    onClose();
  };

  const handleDelete = async () => {
    if (!contact || !window.confirm("Delete this contact?")) return;
    await deleteContact.mutateAsync(contact.contactId);
    onClose();
  };

  return (
    <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth>
      <DialogTitle>{contact ? "Edit Contact" : "New Contact"}</DialogTitle>
      <form onSubmit={handleSubmit(onSubmit)}>
        <DialogContent>
          <Grid container spacing={2} sx={{ pt: 1 }}>
            <Grid size={{ xs: 6 }}>
              <TextField label="First Name" {...register("firstName")} fullWidth size="small" />
            </Grid>
            <Grid size={{ xs: 6 }}>
              <TextField label="Last Name" {...register("lastName")} fullWidth size="small" />
            </Grid>
            <Grid size={{ xs: 12 }}>
              <TextField label="Job Title" {...register("jobTitle")} fullWidth size="small" />
            </Grid>
            <Grid size={{ xs: 12 }}>
              <TextField label="Email" type="email" {...register("emailAddress")} fullWidth size="small" />
            </Grid>
            <Grid size={{ xs: 6 }}>
              <TextField label="Primary Phone" {...register("primaryPhone")} fullWidth size="small" />
            </Grid>
            <Grid size={{ xs: 6 }}>
              <TextField label="Secondary Phone" {...register("secondaryPhone")} fullWidth size="small" />
            </Grid>
            <Grid size={{ xs: 12 }}>
              <TextField label="Notes" {...register("notes")} multiline rows={2} fullWidth size="small" />
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions>
          {contact && (
            <Button color="error" onClick={handleDelete} sx={{ mr: "auto" }}>
              Delete
            </Button>
          )}
          <Button onClick={onClose}>Cancel</Button>
          <Button type="submit" variant="contained">Save</Button>
        </DialogActions>
      </form>
    </Dialog>
  );
}

export default function CompanyDetailPage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const qc = useQueryClient();
  const isNew = id === "new";
  const companyId = isNew ? 0 : Number(id);

  const [editing, setEditing] = useState(isNew);
  const [tab, setTab] = useState(0);
  const [actionError, setActionError] = useState<string | null>(null);
  const [contactDialog, setContactDialog] = useState<{ open: boolean; contact: Contact | null }>({
    open: false, contact: null,
  });

  const { data, isLoading, isError } = useCompany(companyId);
  const { data: companyTypes } = useCompanyTypes();
  const { data: contacts } = useQuery({
    queryKey: ["contacts", { companyId }],
    queryFn: () => contactsApi.list({ companyId, pageSize: 100 }),
    enabled: !isNew,
  });
  const { data: orders } = useQuery({
    queryKey: ["orders", { customerId: companyId }],
    queryFn: () => ordersApi.list({ customerId: companyId, pageSize: 100 }),
    enabled: !isNew,
  });
  const { data: shipperOrders } = useCompanyShipperOrders(companyId);
  const { data: vendorPOs } = useCompanyVendorPurchaseOrders(companyId);

  const { data: states } = useStates();
  const createCompany = useCreateCompany();
  const updateCompany = useUpdateCompany();
  const deleteCompany = useDeleteCompany();

  const { register, handleSubmit, reset, control } = useForm<CompanyForm>();

  useEffect(() => {
    if (data) {
      reset({
        companyName: data.companyName ?? "",
        companyTypeId: String(data.companyTypeId ?? ""),
        businessPhone: data.businessPhone ?? "",
        address: data.address ?? "",
        city: data.city ?? "",
        stateAbbrev: data.stateAbbrev ?? "",
        zip: data.zip ?? "",
        website: data.website ?? "",
        notes: data.notes ?? "",
      });
    }
  }, [data, reset]);

  const onSubmit = async (values: CompanyForm) => {
    const payload = {
      companyName: values.companyName || null,
      companyTypeId: values.companyTypeId ? Number(values.companyTypeId) : null,
      businessPhone: values.businessPhone || null,
      address: values.address || null,
      city: values.city || null,
      stateAbbrev: values.stateAbbrev || null,
      zip: values.zip || null,
      website: values.website || null,
      notes: values.notes || null,
    };
    setActionError(null);
    try {
      if (isNew) {
        const created = await createCompany.mutateAsync(payload);
        navigate(`/companies/${created.companyId}`, { replace: true });
      } else {
        await updateCompany.mutateAsync({ id: companyId, data: payload });
        setEditing(false);
      }
    } catch (e) { setActionError(actionErrorMessage(e)); }
  };

  const handleDelete = async () => {
    if (!window.confirm("Delete this company?")) return;
    setActionError(null);
    try {
      await deleteCompany.mutateAsync(companyId);
      navigate("/companies");
    } catch (e) { setActionError(actionErrorMessage(e)); }
  };

  if (!isNew && isLoading) return <CircularProgress />;
  if (!isNew && (isError || !data)) return <Typography color="error">Company not found.</Typography>;

  return (
    <Box>
      {/* Header bar */}
      <Box sx={{ display: "flex", alignItems: "center", gap: 1, mb: 2, flexWrap: "wrap" }}>
        <Button startIcon={<ArrowBackIcon />} onClick={() => navigate("/companies")}>
          Companies
        </Button>
        <Typography variant="h5" sx={{ flex: 1 }}>
          {isNew ? "New Company" : (data?.companyName ?? "Company")}
        </Typography>
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

      {actionError && (
        <Alert severity="error" onClose={() => setActionError(null)} sx={{ mb: 2 }}>{actionError}</Alert>
      )}

      {/* View mode */}
      {!editing && data && (
        <Grid container spacing={2}>
          {([
            ["Type", data.companyTypeName],
            ["Phone", data.businessPhone],
            ["Address", data.address],
            ["City / State / Zip", [data.city, data.stateAbbrev, data.zip].filter(Boolean).join(", ")],
            ["Website", data.website],
            ["Notes", data.notes],
          ] as [string, string | null | undefined][]).map(([label, value]) => (
            <Grid key={label} size={{ xs: 12, sm: 6 }}>
              <Typography variant="caption" color="text.secondary">{label}</Typography>
              <Typography>{value || "—"}</Typography>
            </Grid>
          ))}
        </Grid>
      )}

      {/* Edit / New form */}
      {editing && (
        <Grid container spacing={2} component="form" onSubmit={handleSubmit(onSubmit)}>
          <Grid size={{ xs: 12, sm: 6 }}>
            <TextField label="Company Name" {...register("companyName")} fullWidth size="small" />
          </Grid>
          <Grid size={{ xs: 12, sm: 6 }}>
            <Controller
              name="companyTypeId"
              control={control}
              render={({ field }) => (
                <FormControl fullWidth size="small">
                  <InputLabel>Type</InputLabel>
                  <Select {...field} label="Type">
                    <MenuItem value=""><em>—</em></MenuItem>
                    {companyTypes?.map((t) => (
                      <MenuItem key={t.companyTypeId} value={String(t.companyTypeId)}>
                        {t.companyType}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
              )}
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 6 }}>
            <TextField label="Business Phone" {...register("businessPhone")} fullWidth size="small" />
          </Grid>
          <Grid size={{ xs: 12, sm: 6 }}>
            <TextField label="Website" {...register("website")} fullWidth size="small" />
          </Grid>
          <Grid size={{ xs: 12 }}>
            <TextField label="Address" {...register("address")} fullWidth size="small" />
          </Grid>
          <Grid size={{ xs: 6, sm: 5 }}>
            <TextField label="City" {...register("city")} fullWidth size="small" />
          </Grid>
          <Grid size={{ xs: 3, sm: 2 }}>
            <Controller
              name="stateAbbrev"
              control={control}
              render={({ field }) => (
                <FormControl fullWidth size="small">
                  <InputLabel>State</InputLabel>
                  <Select {...field} value={field.value ?? ""} label="State">
                    <MenuItem value=""><em>—</em></MenuItem>
                    {states?.map((s) => (
                      <MenuItem key={s.stateAbbrev} value={s.stateAbbrev}>
                        {s.stateAbbrev} — {s.stateName}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
              )}
            />
          </Grid>
          <Grid size={{ xs: 3, sm: 2 }}>
            <TextField label="Zip" {...register("zip")} fullWidth size="small" />
          </Grid>
          <Grid size={{ xs: 12 }}>
            <TextField label="Notes" {...register("notes")} multiline rows={3} fullWidth size="small" />
          </Grid>
        </Grid>
      )}

      {/* Sub-resource tabs (existing companies only) */}
      {!isNew && (
        <Box sx={{ mt: 3 }}>
          <Tabs value={tab} onChange={(_, v: number) => setTab(v)}>
            <Tab label={`Contacts (${contacts?.totalCount ?? 0})`} />
            <Tab label={`Orders (${orders?.totalCount ?? 0})`} />
            <Tab label={`Shipper Orders (${shipperOrders?.totalCount ?? 0})`} />
            <Tab label={`Vendor POs (${vendorPOs?.totalCount ?? 0})`} />
          </Tabs>
          <Divider />

          {tab === 0 && (
            <Box sx={{ pt: 2 }}>
              <Button
                startIcon={<AddIcon />}
                variant="outlined"
                size="small"
                sx={{ mb: 1 }}
                onClick={() => setContactDialog({ open: true, contact: null })}
              >
                Add Contact
              </Button>
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
                    {contacts?.items.map((c) => (
                      <TableRow key={c.contactId} hover sx={{ cursor: "pointer" }}
                        onClick={() => setContactDialog({ open: true, contact: c })}>
                        <TableCell>{`${c.firstName ?? ""} ${c.lastName ?? ""}`.trim()}</TableCell>
                        <TableCell>{c.jobTitle}</TableCell>
                        <TableCell>{c.emailAddress}</TableCell>
                        <TableCell>{c.primaryPhone}</TableCell>
                      </TableRow>
                    ))}
                    {contacts?.items.length === 0 && (
                      <TableRow>
                        <TableCell colSpan={4} sx={{ color: "text.secondary" }}>No contacts</TableCell>
                      </TableRow>
                    )}
                  </TableBody>
                </Table>
              </TableContainer>
            </Box>
          )}

          {tab === 1 && (
            <TableContainer component={Paper} sx={{ mt: 2 }}>
              <Table size="small">
                <TableHead>
                  <TableRow>
                    <TableCell>#</TableCell>
                    <TableCell>Order Date</TableCell>
                    <TableCell>Shipped Date</TableCell>
                    <TableCell>Employee</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {orders?.items.map((o) => (
                    <TableRow key={o.orderId} hover sx={{ cursor: "pointer" }}
                      onClick={() => navigate(`/orders/${o.orderId}`)}>
                      <TableCell>{o.orderId}</TableCell>
                      <TableCell>{o.orderDate ? new Date(o.orderDate).toLocaleDateString() : "—"}</TableCell>
                      <TableCell>{o.shippedDate ? new Date(o.shippedDate).toLocaleDateString() : "—"}</TableCell>
                      <TableCell>{o.employeeName}</TableCell>
                    </TableRow>
                  ))}
                  {orders?.items.length === 0 && (
                    <TableRow>
                      <TableCell colSpan={4} sx={{ color: "text.secondary" }}>No orders</TableCell>
                    </TableRow>
                  )}
                </TableBody>
              </Table>
            </TableContainer>
          )}

          {tab === 2 && (
            <TableContainer component={Paper} sx={{ mt: 2 }}>
              <Table size="small">
                <TableHead>
                  <TableRow>
                    <TableCell>#</TableCell>
                    <TableCell>Order Date</TableCell>
                    <TableCell>Shipped Date</TableCell>
                    <TableCell>Customer</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {shipperOrders?.items.map((o) => (
                    <TableRow key={o.orderId} hover sx={{ cursor: "pointer" }}
                      onClick={() => navigate(`/orders/${o.orderId}`)}>
                      <TableCell>{o.orderId}</TableCell>
                      <TableCell>{o.orderDate ? new Date(o.orderDate).toLocaleDateString() : "—"}</TableCell>
                      <TableCell>{o.shippedDate ? new Date(o.shippedDate).toLocaleDateString() : "—"}</TableCell>
                      <TableCell>{o.customerName}</TableCell>
                    </TableRow>
                  ))}
                  {shipperOrders?.items.length === 0 && (
                    <TableRow><TableCell colSpan={4} sx={{ color: "text.secondary" }}>No shipper orders</TableCell></TableRow>
                  )}
                </TableBody>
              </Table>
            </TableContainer>
          )}

          {tab === 3 && (
            <TableContainer component={Paper} sx={{ mt: 2 }}>
              <Table size="small">
                <TableHead>
                  <TableRow>
                    <TableCell>#</TableCell>
                    <TableCell>Submitted</TableCell>
                    <TableCell>Status</TableCell>
                    <TableCell>Notes</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {vendorPOs?.items.map((po) => (
                    <TableRow key={po.purchaseOrderId} hover sx={{ cursor: "pointer" }}
                      onClick={() => navigate(`/purchase-orders/${po.purchaseOrderId}`)}>
                      <TableCell>{po.purchaseOrderId}</TableCell>
                      <TableCell>{po.submittedDate ? new Date(po.submittedDate).toLocaleDateString() : "—"}</TableCell>
                      <TableCell>{po.statusName ?? "—"}</TableCell>
                      <TableCell>{po.notes}</TableCell>
                    </TableRow>
                  ))}
                  {vendorPOs?.items.length === 0 && (
                    <TableRow><TableCell colSpan={4} sx={{ color: "text.secondary" }}>No purchase orders</TableCell></TableRow>
                  )}
                </TableBody>
              </Table>
            </TableContainer>
          )}
        </Box>
      )}

      <ContactDialog
        open={contactDialog.open}
        contact={contactDialog.contact}
        companyId={companyId}
        onClose={() => {
          setContactDialog({ open: false, contact: null });
          qc.invalidateQueries({ queryKey: ["contacts", { companyId }] });
        }}
      />
    </Box>
  );
}
