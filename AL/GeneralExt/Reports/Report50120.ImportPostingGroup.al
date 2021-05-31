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
        InventoryPostingGroup: Record "Inventory Posting Group";
        FAPostingGroup: Record "FA Posting Group";
        GenBusinessPostingGroup: Record "Gen. Business Posting Group";
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
            'Учетные группы товаров':
                begin
                    for RowNo := 3 to GetLastRow do
                        if not InventoryPostingGroup.Get(GetValueAtCall(RowNo, 1)) then begin
                            InventoryPostingGroup.Init();
                            InventoryPostingGroup.Code := GetValueAtCall(RowNo, 1);
                            InventoryPostingGroup.Description := GetValueAtCall(RowNo, 2);
                            //InventoryPostingGroup."?" := GetValueAtCall(RowNo, 3);
                            //InventoryPostingGroup."Purch. Amt. Diff. Alloc. Type" := GetValueAtCall(RowNo, 4);
                            InventoryPostingGroup."Purch. PD Charge FCY (Item)" := GetValueAtCall(RowNo, 5);
                            InventoryPostingGroup."Purch. PD Charge Conv. (Item)" := GetValueAtCall(RowNo, 6);
                            InventoryPostingGroup."Sales PD Charge FCY (Item)" := GetValueAtCall(RowNo, 7);
                            InventoryPostingGroup."Sales PD Charge Conv. (Item)" := GetValueAtCall(RowNo, 8);
                            InventoryPostingGroup.Insert(true);
                        end;
                end;
            'Учетные группы ОС':
                begin
                    for RowNo := 3 to GetLastRow do
                        if not FAPostingGroup.Get(GetValueAtCall(RowNo, 1)) then begin
                            FAPostingGroup.Init();
                            FAPostingGroup.Code := GetValueAtCall(RowNo, 1);
                            FAPostingGroup.Description := GetValueAtCall(RowNo, 2);
                            FAPostingGroup."Acquisition Cost Account" := GetValueAtCall(RowNo, 3);
                            FAPostingGroup."Accum. Depreciation Account" := GetValueAtCall(RowNo, 4);
                            FAPostingGroup."Write-Down Account" := GetValueAtCall(RowNo, 5);
                            FAPostingGroup."Write-Down Acc. on Disposal" := GetValueAtCall(RowNo, 6);
                            //FAPostingGroup."Disposal Expense Account" := GetValueAtCall(RowNo, 7);
                            FAPostingGroup."Acquisition Cost Bal. Acc." := GetValueAtCall(RowNo, 8);
                            FAPostingGroup."Sales Bal. Acc." := GetValueAtCall(RowNo, 9);
                            FAPostingGroup."Acq. Cost Acc. on Disposal" := GetValueAtCall(RowNo, 10);
                            FAPostingGroup."Accum. Depr. Acc. on Disposal" := GetValueAtCall(RowNo, 11);
                            FAPostingGroup."Gains Acc. on Disposal" := GetValueAtCall(RowNo, 12);
                            FAPostingGroup."Losses Acc. on Disposal" := GetValueAtCall(RowNo, 13);
                            FAPostingGroup."Depreciation Expense Acc." := GetValueAtCall(RowNo, 14);
                            FAPostingGroup."Disposal Expense Account" := GetValueAtCall(RowNo, 15);
                            FAPostingGroup.Insert(true);
                        end;
                end;
            'НДС Товарные Группы':
                begin
                    for RowNo := 3 to GetLastRow do
                        if not GenBusinessPostingGroup.Get(GetValueAtCall(RowNo, 1)) then begin
                            GenBusinessPostingGroup.Init();
                            GenBusinessPostingGroup.Code := GetValueAtCall(RowNo, 1);
                            GenBusinessPostingGroup.Description := GetValueAtCall(RowNo, 2);
                            GenBusinessPostingGroup.Insert(true);
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