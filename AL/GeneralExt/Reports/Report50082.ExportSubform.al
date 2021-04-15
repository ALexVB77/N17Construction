report 50082 ExportSubform
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ShowPrintStatus = true;
    ProcessingOnly = true;

    dataset
    {
        dataitem(VendorAgreementDetails; "Vendor Agreement Details")
        {
            trigger OnPreDataItem()
            begin
                SetRange("Agreement No.", CopyStr(DocumentNo, 1, 20));
                CurStartRow := 0;
                TemplateRowStart := 6;
                //FileName := ExcelTemplate.OpenTemplate()
            end;
        }
    }

    var
        DocumentNo: Code[100];
        CurStartRow: Integer;
        TemplateRowStart: Integer;
        FileName: Text[1024];
        ExcelTemplate: Record "Excel Template";
}