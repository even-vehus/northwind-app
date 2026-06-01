namespace Northwind.Domain.Entities;

public class SystemSetting
{
    public int SettingId { get; set; }
    public string? SettingName { get; set; }
    public string? SettingValue { get; set; }
    public string? Notes { get; set; }
}
