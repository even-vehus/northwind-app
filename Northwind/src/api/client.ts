import axios from "axios";
import { apiBaseUrl } from "../auth/msalConfig";

export const apiClient = axios.create({
  baseURL: apiBaseUrl,
  headers: { "Content-Type": "application/json" },
});

// Inject Bearer token before each request.
// Call setAuthTokenProvider(getToken) once at app startup.
let _getToken: (() => Promise<string>) | null = null;

export function setAuthTokenProvider(fn: () => Promise<string>) {
  _getToken = fn;
}

apiClient.interceptors.request.use(async (config) => {
  if (_getToken) {
    const token = await _getToken();
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});
