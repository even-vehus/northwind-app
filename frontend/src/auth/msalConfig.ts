import type { Configuration, PopupRequest } from "@azure/msal-browser";

const clientId = import.meta.env.VITE_ENTRA_CLIENT_ID as string;
const tenantId = import.meta.env.VITE_ENTRA_TENANT_ID as string;

// The token must be requested for the *API* app registration's scope, not the SPA's,
// so its audience matches what the backend validates (AzureAd:Audience). Falls back to
// the SPA client id only if the API scope isn't configured.
const apiScope = (import.meta.env.VITE_ENTRA_API_SCOPE as string) || `api://${clientId}/access_as_user`;

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
  scopes: [apiScope],
};

export const apiBaseUrl = import.meta.env.VITE_API_BASE_URL as string ?? "http://localhost:5000";
