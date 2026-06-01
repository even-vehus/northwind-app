import { useMsal } from "@azure/msal-react";
import { loginRequest, isAuthConfigured } from "./msalConfig";

export function useAuthToken(): () => Promise<string> {
  const { instance, accounts } = useMsal();

  return async () => {
    if (!isAuthConfigured) return "";

    const account = accounts[0];
    if (!account) throw new Error("No authenticated account found");

    const result = await instance.acquireTokenSilent({
      ...loginRequest,
      account,
    });
    return result.accessToken;
  };
}
