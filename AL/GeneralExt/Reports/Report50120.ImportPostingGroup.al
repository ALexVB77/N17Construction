report 50120 "Import Posting Group"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Import Posting Group';
    ProcessingOnly = true;

    trigger OnPreReport()
    var
        ServerFileName: Text;
        FileManagement: Codeunit "File Management";
        SheetName: Text;
        Text001: Label 'Import Posting Group';
        ExcelExt: Label '*.xlsx';
        RowNo: Integer;
        CustomerPostingGroup: Record "Customer Posting Group";
        VondorPostingGroup: Record "Vendor Posting Group";
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

        case GetValueAtCall(1, 1) of
            'Учетные группы клиента':
                begin
                    for RowNo := 3 to GetLastRow do
                        if not CustomerPostingGroup.Get(GetValueAtCall(RowNo, 1)) then begin
                            CustomerPostingGroup.Init();
                            CustomerPostingGroup.Code := GetValueAtCall(RowNo, 1);
                            CustomerPostingGroup.Description := GetValueAtCall(RowNo, 2);
                            //CustomerPostingGroup."Apply Cust. Post. Group" := GetValueAtCall(RowNo, 3);
                            CustomerPostingGroup."Receivables Account" := GetValueAtCall(RowNo, 4);
                            CustomerPostingGroup."Prepayment Account" := GetValueAtCall(RowNo, 5);
                            CustomerPostingGroup."Debit Rounding Account" := GetValueAtCall(RowNo, 14);
                            CustomerPostingGroup."Credit Rounding Account" := GetValueAtCall(RowNo, 15);
                            //CustomerPostingGroup."Skip Posting" := GetValueAtCall(RowNo, 18);
                            CustomerPostingGroup.Insert(true);
                        end;
                end;
            'Учетные группы поставщика':
                begin
                    for RowNo := 3 to GetLastRow do
                        if not VondorPostingGroup.Get(GetValueAtCall(RowNo, 1)) then begin
                            VondorPostingGroup.Init();
                            VondorPostingGroup.Code := GetValueAtCall(RowNo, 1);
                            VondorPostingGroup.Description := GetValueAtCall(RowNo, 2);
                            VondorPostingGroup."Payables Account" := GetValueAtCall(RowNo, 3);
                            VondorPostingGroup."Prepayment Account" := GetValueAtCall(RowNo, 4);
                            VondorPostingGroup."Debit Curr. Appln. Rndg. Acc." := GetValueAtCall(RowNo, 5);
                            VondorPostingGroup."Credit Curr. Appln. Rndg. Acc." := GetValueAtCall(RowNo, 6);
                            VondorPostingGroup."Debit Rounding Account" := GetValueAtCall(RowNo, 7);
                            VondorPostingGroup."Credit Rounding Account" := GetValueAtCall(RowNo, 8);
                            VondorPostingGroup.Insert(true);
                        end;
                end;
        end;
    end;

    var
        ExcelBuffer: Record "Excel Buffer Mod" temporary;

    local procedure GetLastRow(): Integer

    begin
        if ExcelBuffer.FindLast() then
            exit(ExcelBuffer."Row No.");
    end;

    local procedure GetValueAtCall(RowNo: Integer; ColNo: Integer): Text

    begin
        if ExcelBuffer.Get(RowNo, ColNo) then
            exit(ExcelBuffer."Cell Value as Text");
    end;
}