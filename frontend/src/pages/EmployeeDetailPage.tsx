import { useState, useEffect } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { useForm, Controller } from "react-hook-form";
import {
  Box, Button, CircularProgress, Divider, FormControl, Grid,
  IconButton, InputLabel, MenuItem, Select, Tab, Table, TableBody,
  TableCell, TableHead, TableRow, Tabs, TextField, Typography,
} from "@mui/material";
import AddIcon from "@mui/icons-material/Add";
import ArrowBackIcon from "@mui/icons-material/ArrowBack";
import CancelIcon from "@mui/icons-material/Cancel";
import DeleteIcon from "@mui/icons-material/Delete";
import EditIcon from "@mui/icons-material/Edit";
import SaveIcon from "@mui/icons-material/Save";
import {
  useEmployee, useCreateEmployee, useUpdateEmployee, useDeleteEmployee,
  useEmployees, useEmployeePrivileges, useAddEmployeePrivilege,
  useRemoveEmployeePrivilege, usePrivileges, useEmployeeOrders, useTitles,
} from "../api/hooks";

type EmployeeForm = {
  firstName: string;
  lastName: string;
  title: string;
  jobTitle: string;
  emailAddress: string;
  primaryPhone: string;
  secondaryPhone: string;
  supervisorId: string;
  windowsUserName: string;
  notes: string;
};

export default function EmployeeDetailPage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const isNew = id === "new";
  const employeeId = isNew ? 0 : Number(id);

  const [editing, setEditing] = useState(isNew);
  const [tab, setTab] = useState(0);

  const { data, isLoading, isError } = useEmployee(employeeId);
  const { data: privileges } = useEmployeePrivileges(employeeId);
  const { data: allPrivileges } = usePrivileges();
  const { data: employeeOrders } = useEmployeeOrders(employeeId);
  const addPrivilege = useAddEmployeePrivilege();
  const removePrivilege = useRemoveEmployeePrivilege();
  const { data: allEmployees } = useEmployees({ pageSize: 100 });
  const { data: titles } = useTitles();
  const createEmployee = useCreateEmployee();
  const updateEmployee = useUpdateEmployee();
  const deleteEmployee = useDeleteEmployee();

  const { register, handleSubmit, reset, control } = useForm<EmployeeForm>();

  useEffect(() => {
    if (data) {
      reset({
        firstName: data.firstName ?? "",
        lastName: data.lastName ?? "",
        title: data.title ?? "",
        jobTitle: data.jobTitle ?? "",
        emailAddress: data.emailAddress ?? "",
        primaryPhone: data.primaryPhone ?? "",
        secondaryPhone: data.secondaryPhone ?? "",
        supervisorId: String(data.supervisorId ?? ""),
        windowsUserName: data.windowsUserName ?? "",
        notes: data.notes ?? "",
      });
    }
  }, [data, reset]);

  const onSubmit = async (values: EmployeeForm) => {
    const payload = {
      firstName: values.firstName || null,
      lastName: values.lastName || null,
      title: values.title || null,
      jobTitle: values.jobTitle || null,
      emailAddress: values.emailAddress || null,
      primaryPhone: values.primaryPhone || null,
      secondaryPhone: values.secondaryPhone || null,
      supervisorId: values.supervisorId ? Number(values.supervisorId) : null,
      windowsUserName: values.windowsUserName || null,
      notes: values.notes || null,
    };
    if (isNew) {
      const created = await createEmployee.mutateAsync(payload);
      navigate(`/employees/${created.employeeId}`, { replace: true });
    } else {
      await updateEmployee.mutateAsync({ id: employeeId, data: payload });
      setEditing(false);
    }
  };

  const handleDelete = async () => {
    if (!window.confirm("Delete this employee?")) return;
    await deleteEmployee.mutateAsync(employeeId);
    navigate("/employees");
  };

  if (!isNew && isLoading) return <CircularProgress />;
  if (!isNew && (isError || !data)) return <Typography color="error">Employee not found.</Typography>;

  const supervisorOptions = allEmployees?.items.filter((e) => e.employeeId !== employeeId) ?? [];

  return (
    <Box>
      <Box sx={{ display: "flex", alignItems: "center", gap: 1, mb: 2, flexWrap: "wrap" }}>
        <Button startIcon={<ArrowBackIcon />} onClick={() => navigate("/employees")}>
          Employees
        </Button>
        <Typography variant="h5" sx={{ flex: 1 }}>
          {isNew ? "New Employee" : (data?.fullName ?? "Employee")}
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

      {/* View mode */}
      {!editing && data && (
        <>
          <Divider sx={{ mb: 2 }} />
          <Grid container spacing={2}>
            {([
              ["Title", data.title],
              ["Job Title", data.jobTitle],
              ["Email", data.emailAddress],
              ["Primary Phone", data.primaryPhone],
              ["Secondary Phone", data.secondaryPhone],
              ["Windows Username", data.windowsUserName],
              ["Notes", data.notes],
            ] as [string, string | null | undefined][]).map(([label, value]) => (
              <Grid key={label} size={{ xs: 12, sm: 6 }}>
                <Typography variant="caption" color="text.secondary">{label}</Typography>
                <Typography>{value || "—"}</Typography>
              </Grid>
            ))}
          </Grid>
        </>
      )}

      {/* Edit / New form */}
      {editing && (
        <Grid container spacing={2} component="form" onSubmit={handleSubmit(onSubmit)}>
          <Grid size={{ xs: 3, sm: 2 }}>
            <Controller
              name="title"
              control={control}
              render={({ field }) => (
                <FormControl fullWidth size="small">
                  <InputLabel>Title</InputLabel>
                  <Select {...field} value={field.value ?? ""} label="Title">
                    <MenuItem value=""><em>—</em></MenuItem>
                    {titles?.filter((t) => t !== "").map((t) => (
                      <MenuItem key={t} value={t}>{t}</MenuItem>
                    ))}
                  </Select>
                </FormControl>
              )}
            />
          </Grid>
          <Grid size={{ xs: 9, sm: 4 }}>
            <TextField label="First Name" {...register("firstName")} fullWidth size="small" />
          </Grid>
          <Grid size={{ xs: 12, sm: 6 }}>
            <TextField label="Last Name" {...register("lastName")} fullWidth size="small" />
          </Grid>
          <Grid size={{ xs: 12, sm: 6 }}>
            <TextField label="Job Title" {...register("jobTitle")} fullWidth size="small" />
          </Grid>
          <Grid size={{ xs: 12, sm: 6 }}>
            <TextField label="Email" type="email" {...register("emailAddress")} fullWidth size="small" />
          </Grid>
          <Grid size={{ xs: 6 }}>
            <TextField label="Primary Phone" {...register("primaryPhone")} fullWidth size="small" />
          </Grid>
          <Grid size={{ xs: 6 }}>
            <TextField label="Secondary Phone" {...register("secondaryPhone")} fullWidth size="small" />
          </Grid>
          <Grid size={{ xs: 12, sm: 6 }}>
            <Controller
              name="supervisorId"
              control={control}
              render={({ field }) => (
                <FormControl fullWidth size="small">
                  <InputLabel>Supervisor</InputLabel>
                  <Select {...field} label="Supervisor">
                    <MenuItem value=""><em>—</em></MenuItem>
                    {supervisorOptions.map((e) => (
                      <MenuItem key={e.employeeId} value={String(e.employeeId)}>
                        {e.fullName}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
              )}
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 6 }}>
            <TextField label="Windows Username" {...register("windowsUserName")} fullWidth size="small" />
          </Grid>
          <Grid size={{ xs: 12 }}>
            <TextField label="Notes" {...register("notes")} multiline rows={3} fullWidth size="small" />
          </Grid>
        </Grid>
      )}

      {/* Privileges tab (existing employees only) */}
      {!isNew && (
        <Box sx={{ mt: 3 }}>
          <Tabs value={tab} onChange={(_, v: number) => setTab(v)}>
            <Tab label={`Privileges (${privileges?.length ?? 0})`} />
            <Tab label={`Recent Orders (${employeeOrders?.totalCount ?? 0})`} />
          </Tabs>
          <Divider />
          {tab === 0 && (
            <Box sx={{ pt: 2 }}>
              <Box sx={{ display: "flex", gap: 1, mb: 1, flexWrap: "wrap" }}>
                {allPrivileges
                  ?.filter((p) => !privileges?.some((ep) => ep.privilegeId === p.privilegeId))
                  .map((p) => (
                    <Button
                      key={p.privilegeId}
                      size="small"
                      variant="outlined"
                      startIcon={<AddIcon />}
                      onClick={() => addPrivilege.mutate({ employeeId, privilegeId: p.privilegeId })}
                    >
                      {p.privilegeName}
                    </Button>
                  ))}
              </Box>
              <Table size="small">
                <TableHead>
                  <TableRow>
                    <TableCell>Privilege</TableCell>
                    <TableCell />
                  </TableRow>
                </TableHead>
                <TableBody>
                  {privileges?.map((ep) => (
                    <TableRow key={ep.employeePrivilegeId}>
                      <TableCell>{ep.privilegeName}</TableCell>
                      <TableCell align="right">
                        <IconButton
                          size="small"
                          color="error"
                          onClick={() => removePrivilege.mutate({ employeeId, privilegeId: ep.privilegeId! })}
                        >
                          <DeleteIcon fontSize="small" />
                        </IconButton>
                      </TableCell>
                    </TableRow>
                  ))}
                  {privileges?.length === 0 && (
                    <TableRow>
                      <TableCell colSpan={2} sx={{ color: "text.secondary" }}>No privileges assigned</TableCell>
                    </TableRow>
                  )}
                </TableBody>
              </Table>
            </Box>
          )}

          {/* Recent Orders tab */}
          {tab === 1 && (
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
                  {employeeOrders?.items.map((o) => (
                    <TableRow key={o.orderId} hover sx={{ cursor: "pointer" }}
                      onClick={() => navigate(`/orders/${o.orderId}`)}>
                      <TableCell>{o.orderId}</TableCell>
                      <TableCell>{o.orderDate ? new Date(o.orderDate).toLocaleDateString() : "—"}</TableCell>
                      <TableCell>{o.customerName ?? "—"}</TableCell>
                      <TableCell>{o.orderStatusId ?? "—"}</TableCell>
                    </TableRow>
                  ))}
                  {(employeeOrders?.items.length ?? 0) === 0 && (
                    <TableRow>
                      <TableCell colSpan={4} sx={{ color: "text.secondary" }}>No orders</TableCell>
                    </TableRow>
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
