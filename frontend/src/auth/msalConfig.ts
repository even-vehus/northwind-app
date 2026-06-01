import type { Configuration, PopupRequest } from "@azure/msal-browser";

const clientId = import.meta.env.VITE_ENTRA_CLIENT_ID as string;
const tenantId = import.meta.env.VITE_ENTRA_TENANT_ID as string;

export const isAuthConfigured = !!clientId && !!tenantId;

export const msalConfig: Configuration = {
  auth: {
    // MSAL requires a non-empty clientId at construction time.
    // Use a placeholder in dev so the app starts without Azure AD configured.
    clientId: clientId || "00000000-0000-0000-0000-000000000000",
    authority: `https://login.microsoftonline.com/${tenantId || "common"}`,
    redirectUri: window.location.origin,
  },
  cache: {
    cacheLocation: "sessionStorage",
  },
};

export const loginRequest: PopupRequest = {
  scopes: [`api://${clientId}/access_as_user`],
};

export const apiBaseUrl = import.meta.env.VITE_API_BASE_URL as string ?? "http://localhost:5000";
