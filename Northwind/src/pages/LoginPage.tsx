import { useMsal } from "@azure/msal-react";
import { Box, Button, Typography } from "@mui/material";
import { loginRequest } from "../auth/msalConfig";

export default function LoginPage() {
  const { instance } = useMsal();
  return (
    <Box sx={{ display: "flex", flexDirection: "column", alignItems: "center", mt: 12, gap: 3 }}>
      <Typography variant="h4">Northwind</Typography>
      <Typography color="text.secondary">Sign in with your Microsoft account to continue.</Typography>
      <Button
        variant="contained"
        size="large"
        onClick={() => instance.loginRedirect(loginRequest)}
      >
        Sign in
      </Button>
    </Box>
  );
}
