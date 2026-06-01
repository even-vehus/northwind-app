namespace Northwind.Domain.Entities;

// Lookup table (DB table "States", PK column "StateAbbrev").
// Companies.StateAbbrev is a FK to this table, so only seeded values are valid.
public class State
{
    public string StateAbbrev { get; set; } = "";
    public string? StateName { get; set; }
}
