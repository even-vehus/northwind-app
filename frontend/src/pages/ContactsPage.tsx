import { useState, useEffect } from "react";
import { useForm } from "react-hook-form";
import {
  Box, Button, Dialog, DialogActions, DialogContent, DialogTitle,
  Grid, IconButton, MenuItem, Paper, Table, TableBody, TableCell, TableContainer,
  TableHead, TableRow, TextField, Typography,
} from "@mui/material";
import AddIcon from "@mui/icons-material/Add";
import DeleteIcon from "@mui/icons-material/Delete";
import EditIcon from "@mui/icons-material/Edit";
import { useContacts, useCreateContact, useUpdateContact, useDeleteContact, useCompaniesLookup } from "../api/hooks";
import type { Contact } from "../api/types";

type ContactForm = {
  companyId: string;
  firstName: string;
  lastName: string;
  emailAddress: string;
  jobTitle: string;
  primaryPhone: string;
  secondaryPhone: string;
  notes: string;
};

function ContactDialog({
  open, contact, onClose,
}: { open: boolean; contact: Contact | null; onClose: () => void }) {
  const createContact = useCreateContact();
  const updateContact = useUpdateContact();
  const deleteContact = useDeleteContact();
  const { data: companies } = useCompaniesLookup();
  const { register, handleSubmit, reset } = useForm<ContactForm>();

  useEffect(() => {
    if (open) {
      reset({
        companyId: contact?.companyId != null ? String(contact.companyId) : "",
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
    const payload = {
      companyId: data.companyId ? Number(data.companyId) : null,
      firstName: data.firstName || null,
      lastName: data.lastName || null,
      emailAddress: data.emailAddress || null,
      jobTitle: data.jobTitle || null,
      primaryPhone: data.primaryPhone || null,
      secondaryPhone: data.secondaryPhone || null,
      notes: data.notes || null,
    };
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
            <Grid size={{ xs: 12 }}>
              <TextField label="Company" {...register("companyId")} select fullWidth size="small">
                <MenuItem value="">—</MenuItem>
                {companies?.map((c) => (
                  <MenuItem key={c.companyId} value={String(c.companyId)}>{c.companyName}</MenuItem>
                ))}
              </TextField>
            </Grid>
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
            <Button color="error" onClick={handleDelete} startIcon={<DeleteIcon />} sx={{ mr: "auto" }}>
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

export default function ContactsPage() {
  const [search, setSearch] = useState("");
  const [page, setPage] = useState(1);
  const [dialog, setDialog] = useState<{ open: boolean; contact: Contact | null }>({
    open: false, contact: null,
  });
  const { data, isLoading, isError } = useContacts({ search, page, pageSize: 25 });

  return (
    <Box>
      <Box sx={{ display: "flex", justifyContent: "space-between", mb: 2 }}>
        <Typography variant="h5">Contacts</Typography>
        <Button variant="contained" startIcon={<AddIcon />}
          onClick={() => setDialog({ open: true, contact: null })}>
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
      {isError && <Typography color="error">Failed to load contacts.</Typography>}
      <TableContainer component={Paper}>
        <Table size="small">
          <TableHead>
            <TableRow>
              <TableCell>Name</TableCell>
              <TableCell>Company</TableCell>
              <TableCell>Job Title</TableCell>
              <TableCell>Email</TableCell>
              <TableCell>Phone</TableCell>
              <TableCell />
            </TableRow>
          </TableHead>
          <TableBody>
            {isLoading ? (
              <TableRow><TableCell colSpan={6}>Loading…</TableCell></TableRow>
            ) : (
              data?.items.map((c) => (
                <TableRow key={c.contactId} hover>
                  <TableCell>{`${c.firstName ?? ""} ${c.lastName ?? ""}`.trim()}</TableCell>
                  <TableCell>{c.companyName}</TableCell>
                  <TableCell>{c.jobTitle}</TableCell>
                  <TableCell>{c.emailAddress}</TableCell>
                  <TableCell>{c.primaryPhone}</TableCell>
                  <TableCell padding="none">
                    <IconButton size="small" onClick={() => setDialog({ open: true, contact: c })}>
                      <EditIcon fontSize="small" />
                    </IconButton>
                  </TableCell>
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

      <ContactDialog
        open={dialog.open}
        contact={dialog.contact}
        onClose={() => setDialog({ open: false, contact: null })}
      />
    </Box>
  );
}
