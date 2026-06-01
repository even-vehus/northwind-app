namespace Northwind.Infrastructure.Services;

/// <summary>
/// Thrown when a ported business rule (status transition, guard, etc.) is violated.
/// Mapped to HTTP 409 Conflict by BusinessRuleExceptionFilter. The message is the
/// user-facing text (sourced from the Access Strings table where one exists).
/// </summary>
public class BusinessRuleException(string message) : Exception(message);
