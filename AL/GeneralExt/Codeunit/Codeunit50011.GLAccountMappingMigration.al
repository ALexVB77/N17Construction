codeunit 50011 "G\L Account Mapping Migration"
{
    trigger OnRun()
    begin
        ServerFileName := FileManagement.UploadFile(Text001, ExcelExt);
        if ServerFileName = '' then
            exit;
        SheetName := ExcelBuffer.SelectSheetsName(ServerFileName);
        if SheetName = '' then
            exit;
        ExcelBuffer.LockTable();
        ExcelBuffer.OpenBook(ServerFileName, SheetName);
        ExcelBuffer.ReadSheet();
    end;

    var
        ServerFileName: Text;
        FileManagement: Codeunit "File Management";
        SheetName: Text;
        ExcelBuffer: Record "Excel Buffer Mod";
        Text001: Label 'Import G\L Account Mapping';
        ExcelExt: Label '*.xlsx';
}