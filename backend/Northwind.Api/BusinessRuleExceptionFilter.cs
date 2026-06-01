using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Northwind.Infrastructure.Services;

namespace Northwind.Api;

/// <summary>
/// Maps ported business-rule violations to HTTP 409 Conflict, and missing aggregates
/// (KeyNotFoundException) to 404, with a ProblemDetails body carrying the message.
/// </summary>
public class BusinessRuleExceptionFilter : IExceptionFilter
{
    public void OnException(ExceptionContext context)
    {
        switch (context.Exception)
        {
            case BusinessRuleException bre:
                context.Result = new ConflictObjectResult(new ProblemDetails
                {
                    Title = "Business rule violation",
                    Detail = bre.Message,
                    Status = StatusCodes.Status409Conflict,
                });
                context.ExceptionHandled = true;
                break;

            case KeyNotFoundException knf:
                context.Result = new NotFoundObjectResult(new ProblemDetails
                {
                    Title = "Not found",
                    Detail = knf.Message,
                    Status = StatusCodes.Status404NotFound,
                });
                context.ExceptionHandled = true;
                break;
        }
    }
}
