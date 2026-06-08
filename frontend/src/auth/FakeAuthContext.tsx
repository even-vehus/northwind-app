import { createContext, useContext, useState, type ReactNode } from "react";

/**
 * POC-only fake auth: any email "signs in". No real authentication — this only gates the
 * UI. Active only when Entra is not configured (see isAuthConfigured in msalConfig.ts).
 * The backend runs allow-all in this mode, so no token is involved.
 */
const STORAGE_KEY = "northwind.fakeUser";

interface FakeAuthContextValue {
  user: string | null;
  signIn: (email: string) => void;
  signOut: () => void;
}

const FakeAuthContext = createContext<FakeAuthContextValue | undefined>(undefined);

export function FakeAuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<string | null>(() => localStorage.getItem(STORAGE_KEY));

  const signIn = (email: string) => {
    localStorage.setItem(STORAGE_KEY, email);
    setUser(email);
  };

  const signOut = () => {
    localStorage.removeItem(STORAGE_KEY);
    setUser(null);
  };

  return (
    <FakeAuthContext.Provider value={{ user, signIn, signOut }}>
      {children}
    </FakeAuthContext.Provider>
  );
}

export function useFakeAuth(): FakeAuthContextValue {
  const ctx = useContext(FakeAuthContext);
  if (!ctx) throw new Error("useFakeAuth must be used within a FakeAuthProvider");
  return ctx;
}
