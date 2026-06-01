using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.Identity.Web;
using Northwind.Infrastructure.Data;
using Northwind.Infrastructure.Services;

var builder = WebApplication.CreateBuilder(args);

// ── Database ─────────────────────────────────────────────────────────────────
var connectionString = builder.Configuration.GetConnectionString("FabricSql");

if (string.IsNullOrWhiteSpace(connectionString))
{
    if (builder.Environment.IsDevelopment())
    {
        Console.WriteLine("[DEV] No FabricSql connection string found — using in-memory database.");
        builder.Services.AddDbContext<NorthwindDbContext>(options =>
            options.UseInMemoryDatabase("NorthwindDev"));
    }
    else
    {
        throw new InvalidOperationException(
            "Connection string 'FabricSql' not found. Set CONNECTIONSTRINGS__FABRICSQL env var.");
    }
}
else
{
    builder.Services.AddDbContext<NorthwindDbContext>(options =>
        options.UseSqlServer(connectionString, sql =>
            sql.EnableRetryOnFailure(3)));
}

// ── Authentication / Authorisation ───────────────────────────────────────────
var clientId = builder.Configuration["AzureAd:ClientId"];
var isAuthConfigured = !string.IsNullOrWhiteSpace(clientId);

if (isAuthConfigured)
{
    builder.Services
        .AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
        .AddMicrosoftIdentityWebApi(builder.Configuration.GetSection("AzureAd"));
    builder.Services.AddAuthorization();
}
else
{
    Console.WriteLine("[DEV] AzureAd:ClientId not configured — authentication disabled.");
    builder.Services.AddAuthentication();
    builder.Services.AddAuthorization(options =>
    {
        // Allow everything: both [Authorize]-decorated endpoints (DefaultPolicy)
        // and unannotated endpoints (FallbackPolicy).
        var allowAll = new Microsoft.AspNetCore.Authorization.AuthorizationPolicyBuilder()
            .RequireAssertion(_ => true)
            .Build();
        options.DefaultPolicy = allowAll;
        options.FallbackPolicy = allowAll;
    });
}

// ── Business logic services (ported from Access VBA) ─────────────────────────
builder.Services.AddScoped<IInventoryService, InventoryService>();
builder.Services.AddScoped<IOrderWorkflowService, OrderWorkflowService>();
builder.Services.AddScoped<IPurchaseOrderWorkflowService, PurchaseOrderWorkflowService>();
builder.Services.AddScoped<ICompanyGuardService, CompanyGuardService>();

// ── Controllers + OpenAPI ────────────────────────────────────────────────────
builder.Services.AddControllers(options =>
    options.Filters.Add<Northwind.Api.BusinessRuleExceptionFilter>());
builder.Services.AddOpenApi();

// ── Health checks ────────────────────────────────────────────────────────────
builder.Services.AddHealthChecks()
    .AddDbContextCheck<NorthwindDbContext>("database");

// ── CORS ─────────────────────────────────────────────────────────────────────
var allowedOrigins = builder.Configuration.GetSection("AllowedOrigins").Get<string[]>()
    ?? ["http://localhost:5173", "http://localhost:5174"];

builder.Services.AddCors(options =>
    options.AddPolicy("Frontend", policy =>
        policy.WithOrigins(allowedOrigins)
              .AllowAnyHeader()
              .AllowAnyMethod()));

// ─────────────────────────────────────────────────────────────────────────────
var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();
app.UseCors("Frontend");
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();
app.MapHealthChecks("/health");

app.Run();
