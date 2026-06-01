namespace Northwind.Domain.Entities;

// Lookup table for employee salutations (DB table "Titles", PK column "Title").
// Employees.Title is a FK to this table, so only seeded values are valid.
public class Title
{
    public string Name { get; set; } = "";   // DB column: Title
}
