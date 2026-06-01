FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

COPY Northwind.slnx .
COPY Northwind.Api/Northwind.Api.csproj Northwind.Api/
COPY Northwind.Domain/Northwind.Domain.csproj Northwind.Domain/
COPY Northwind.Infrastructure/Northwind.Infrastructure.csproj Northwind.Infrastructure/
COPY Northwind.Tests/Northwind.Tests.csproj Northwind.Tests/
RUN dotnet restore

COPY . .
RUN dotnet publish Northwind.Api/Northwind.Api.csproj -c Release -o /app/publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "Northwind.Api.dll"]
