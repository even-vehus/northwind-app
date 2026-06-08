import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useMsal } from "@azure/msal-react";
import { Box, Button, TextField, Typography } from "@mui/material";
import { loginRequest, isAuthConfigured } from "../auth/msalConfig";
import { useFakeAuth } from "../auth/FakeAuthContext";

export default function LoginPage() {
  const { instance } = useMsal();
  const { signIn } = useFakeAuth();
  const navigate = useNavigate();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState(false);

  // Entra configured → real Microsoft sign-in (unchanged behaviour).
  if (isAuthConfigured) {
    return (
      <Box sx={{ display: "flex", flexDirection: "column", alignItems: "center", mt: 12, gap: 3 }}>
        <Typography variant="h4">Northwind</Typography>
        <Typography color="text.secondary">Sign in with your Microsoft account to continue.</Typography>
        <Button variant="contained" size="large" onClick={() => instance.loginRedirect(loginRequest)}>
          Sign in
        </Button>
      </Box>
    );
  }

  // POC demo sign-in — any email is accepted (password is ignored).
  const onSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!email.includes("@")) {
      setError(true);
      return;
    }
    signIn(email.trim());
    navigate("/");
  };

  return (
    <Box sx={{ display: "flex", justifyContent: "center", mt: 12 }}>
      <Box
        component="form"
        onSubmit={onSubmit}
        sx={{ display: "flex", flexDirection: "column", gap: 2, width: 320 }}
      >
        <Typography variant="h4" align="center">Northwind</Typography>
        <Typography color="text.secondary" align="center" sx={{ mb: 1 }}>
          Sign in to continue.
        </Typography>
        <TextField
          label="Email"
          type="email"
          value={email}
          onChange={(e) => { setEmail(e.target.value); setError(false); }}
          error={error}
          helperText={error ? "Enter a valid email address." : undefined}
          autoFocus
          fullWidth
        />
        <TextField
          label="Password"
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          fullWidth
        />
        <Button type="submit" variant="contained" size="large">Sign in</Button>
        <Typography variant="caption" color="text.secondary" align="center">
          Demo sign-in — any email is accepted.
        </Typography>
      </Box>
    </Box>
  );
}
