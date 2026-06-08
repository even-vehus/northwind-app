# northwind-app

Modern replacement for the NorthwindStarterED Access application.

**Stack:** React 18 + Vite + TypeScript + Material UI | ASP.NET Core 10 Web API + EF Core + Fabric SQL | Entra ID auth

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
cd Northwind
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
│   ├── Northwind.Domain/       Entities + domain services (ported from VBA)
│   ├── Northwind.Infrastructure/ EF Core DbContext + Fabric SQL config
│   └── Northwind.Tests/        xUnit tests
├── Northwind/
│   └── src/
│       ├── api/                TanStack Query hooks + axios client
│       ├── auth/               MSAL config + token helper
│       ├── components/         Shared MUI components (Layout, …)
│       └── pages/              One file per route
├── docs/
│   ├── ARCHITECTURE.md
│   ├── VBA_PORT_LOG.md         Status of each VBA module → C# port
│   └── ACCESS_FORMS_MAP.md     Access form → React route mapping
├── docker-compose.yml
└── .env.example
```

---

## Authentication

- Frontend: `@azure/msal-react` — acquires tokens via Entra ID (browser popup / redirect)
- Backend: `Microsoft.Identity.Web` — validates JWT Bearer tokens from Entra ID
- Required app registrations: one for the API, one for the SPA (see `.env.example` for variable names)

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

See [docs/VBA_PORT_LOG.md](docs/VBA_PORT_LOG.md) for module-by-module porting status.

---

## v1 Scope

Routes implemented: `/companies`, `/contacts`, `/products`, `/orders`  
Pending (v1.5+): Purchase Orders, Inventory, Admin, Reports
