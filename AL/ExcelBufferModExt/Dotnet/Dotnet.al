dotnet
{
    assembly(Microsoft.Dynamics.Nav.OpenXml)
    {
        type(Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.CellFormatManager; CellFormatManager) { }
    }
    assembly(DocumentFormat.OpenXml)
    {
        type(DocumentFormat.OpenXml.Spreadsheet.BorderStyleValues; BorderStyleValues) { }
    }
}