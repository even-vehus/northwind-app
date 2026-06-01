import { useState } from "react";
import {
  Box, Button, Table, TableBody, TableCell, TableHead, TableRow,
  TextField, Typography,
} from "@mui/material";
import { useSystemSettings, useUpdateSystemSetting } from "../api/hooks";

export default function AdminPage() {
  const { data: settings, isLoading } = useSystemSettings();
  const updateSetting = useUpdateSystemSetting();
  const [editId, setEditId] = useState<number | null>(null);
  const [editValue, setEditValue] = useState("");

  const startEdit = (id: number, current: string | null) => {
    setEditId(id);
    setEditValue(current ?? "");
  };

  const saveEdit = async () => {
    if (editId == null) return;
    await updateSetting.mutateAsync({ id: editId, settingValue: editValue });
    setEditId(null);
  };

  return (
    <Box sx={{ p: 3, maxWidth: 700 }}>
      <Typography variant="h5" sx={{ mb: 3 }}>Admin — System Settings</Typography>

      <Table size="small">
        <TableHead>
          <TableRow>
            <TableCell>Setting</TableCell>
            <TableCell>Value</TableCell>
            <TableCell>Notes</TableCell>
            <TableCell />
          </TableRow>
        </TableHead>
        <TableBody>
          {isLoading && (
            <TableRow><TableCell colSpan={4}>Loading…</TableCell></TableRow>
          )}
          {settings?.map((s) => (
            <TableRow key={s.settingId}>
              <TableCell><strong>{s.settingName}</strong></TableCell>
              <TableCell>
                {editId === s.settingId ? (
                  <TextField
                    size="small"
                    value={editValue}
                    onChange={(e) => setEditValue(e.target.value)}
                    autoFocus
                    sx={{ minWidth: 200 }}
                  />
                ) : (
                  s.settingValue ?? "—"
                )}
              </TableCell>
              <TableCell sx={{ color: "text.secondary", fontSize: "0.8rem" }}>{s.notes}</TableCell>
              <TableCell>
                {editId === s.settingId ? (
                  <Box sx={{ display: "flex", gap: 1 }}>
                    <Button size="small" variant="contained" onClick={saveEdit} disabled={updateSetting.isPending}>Save</Button>
                    <Button size="small" onClick={() => setEditId(null)}>Cancel</Button>
                  </Box>
                ) : (
                  <Button size="small" onClick={() => startEdit(s.settingId, s.settingValue)}>Edit</Button>
                )}
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </Box>
  );
}
