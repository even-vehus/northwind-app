# northwind-app

Modern replacement for the NorthwindStarterED Access application.

**Stack:** React 19 + Vite + TypeScript + Material UI v9 | ASP.NET Core 10 Web API + EF Core + Fabric SQL | Entra ID auth

---

## Prerequisites

| Tool | Version |
|------|---------|
| .NET SDK | 10.0+ |
| Node.js | 22+ |
| Docker Desktop | 4.x+ |
| Azure CLI (`az`) | for local dev with Fabric SQL |

---

## Quick Start (Docker)

```powershell
# 1. Create .env from template and fill in your values
Copy-Item .env.example .env

# 2. Build & start API + frontend
docker compose up --build

# Frontend: http://localhost:5173
# API:      http://localhost:5000
# OpenAPI:  http://localhost:5000/openapi/v1.json
```

---

## Local Development (without Docker)

### Backend

```powershell
# Sign in to Azure so DefaultAzureCredential can reach Fabric SQL
az login

# Set dev config (add your values)
cd backend/Northwind.Api
copy appsettings.json appsettings.Development.json
# Edit appsettings.Development.json — fill AzureAd + ConnectionStrings

dotnet run
# API: https://localhost:5001  (HTTP: http://localhost:5000)
```

### Frontend

```powershell
cd frontend
Copy-Item .env.example .env.local   # fill VITE_* vars
npm run dev
# http://localhost:5173
```

---

## Project Structure

```
northwind-app/
├── backend/
│   ├── Northwind.Api/          ASP.NET Core Web API (controllers, auth, OpenAPI)
│   ├── Northwind.Domain/       Domain entities
│   ├── Northwind.Infrastructure/ EF Core DbContext + Fabric SQL config + Services/ (VBA-ported domain logic)
│   └── Northwind.Tests/        xUnit tests
├── frontend/
│   └── src/
│       ├── api/                TanStack Query hooks + axios client
│       ├── auth/               MSAL config + token helper
│       ├── components/         Shared MUI components (Layout, …)
│       └── pages/              One file per route
├── VBA_PORT_LOG.md             Status of each VBA module → C# port
├── CLAUDE.md                   Detailed project guide (routes, controllers, patterns)
├── migration_output/           Baseline schema + seed SQL from the migration tooling
└── docker-compose.yml
```

---

## Authentication

- Frontend: `@azure/msal-react` — acquires tokens via Entra ID (browser popup / redirect)
- Backend: `Microsoft.Identity.Web` — validates JWT Bearer tokens from Entra ID
- Required app registrations: one for the API, one for the SPA (see `docker-compose.yml` / `.env` for the variable names)
- **POC dummy sign-in**: the frontend currently wraps the app in a `FakeAuthProvider` (`src/auth/FakeAuthContext.tsx`) so you can sign in without a real Entra tenant. Backend auth is also bypassed in dev when `AzureAd:ClientId` is absent. Remove/disable both when wiring up real Entra ID.

---

## Database

Schema is owned by the `access-to-sql-migration` tooling repo.  
The baseline SQL is in `migration_output/NorthwindStarterED/`.  
Future app-specific schema changes should be managed as EF Core migrations in this repo.

To scaffold EF entities from an existing Fabric SQL database:

```powershell
cd backend
dotnet ef dbcontext scaffold $env:CONNECTIONSTRINGS__FABRICSQL `
  Microsoft.EntityFrameworkCore.SqlServer `
  --project Northwind.Infrastructure `
  --startup-project Northwind.Api `
  --output-dir Data/Scaffolded `
  --context ScaffoldedContext `
  --no-onconfiguring
```

---

## VBA Port Status

See [VBA_PORT_LOG.md](VBA_PORT_LOG.md) for module-by-module porting status.

---

## Scope

All major Access forms and reports have been ported. Implemented areas:

- **Companies** & **Contacts** — list, detail, CRUD; company sub-tabs (contacts, orders, shipper orders, vendor POs)
- **Products** — list, detail, CRUD; categories, vendors, stock-takes
- **Orders** — list, detail, line items, printable invoice
- **Purchase Orders** — list, detail, line items, printable order form
- **Employees** — list, detail, privileges
- **Admin** — system settings + lookup tables
- **Reports** — dashboard + 6 reports (sales by employee/product, directory, catalog, customer list)
- **VBA domain logic** — inventory, order/PO workflow state machines, referential guards (see [VBA_PORT_LOG.md](VBA_PORT_LOG.md))

Remaining gaps are low-value/deferred items (e.g. `frmEmployeeTitles` CRUD, Access dev utilities, privilege *enforcement* pending real auth). See [CLAUDE.md](CLAUDE.md) for the full breakdown.
