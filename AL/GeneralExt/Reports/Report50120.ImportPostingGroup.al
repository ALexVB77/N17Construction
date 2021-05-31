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
        GenProductPostingGroup: Record "Gen. Product Posting Group";
        VATProductPostingGroup: Record "VAT Product Posting Group";
        VATBusinessPostingGroup: Record "VAT Business Posting Group";
        GeneralPostingSetup: Record "General Posting Setup";
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

        case GetValueAtCell(1, 1) of
            'Учетные группы клиента':
                begin
                    for RowNo := 3 to GetLastRow do
                        if not CustomerPostingGroup.Get(GetValueAtCell(RowNo, 1)) then begin
                            CustomerPostingGroup.Init();
                            CustomerPostingGroup.Code := GetValueAtCell(RowNo, 1);
                            CustomerPostingGroup.Description := GetValueAtCell(RowNo, 2);
                            //CustomerPostingGroup."Apply Cust. Post. Group" := GetValueAtCell(RowNo, 3);
                            CustomerPostingGroup."Receivables Account" := GetValueAtCell(RowNo, 4);
                            CustomerPostingGroup."Prepayment Account" := GetValueAtCell(RowNo, 5);
                            CustomerPostingGroup."Debit Rounding Account" := GetValueAtCell(RowNo, 14);
                            CustomerPostingGroup."Credit Rounding Account" := GetValueAtCell(RowNo, 15);
                            //CustomerPostingGroup."Skip Posting" := GetValueAtCell(RowNo, 18);
                            CustomerPostingGroup.Insert(true);
                        end;
                end;
            'Учетные группы поставщика':
                begin
                    for RowNo := 3 to GetLastRow do
                        if not VondorPostingGroup.Get(GetValueAtCell(RowNo, 1)) then begin
                            VondorPostingGroup.Init();
                            VondorPostingGroup.Code := GetValueAtCell(RowNo, 1);
                            VondorPostingGroup.Description := GetValueAtCell(RowNo, 2);
                            VondorPostingGroup."Payables Account" := GetValueAtCell(RowNo, 3);
                            VondorPostingGroup."Prepayment Account" := GetValueAtCell(RowNo, 4);
                            VondorPostingGroup."Debit Curr. Appln. Rndg. Acc." := GetValueAtCell(RowNo, 5);
                            VondorPostingGroup."Credit Curr. Appln. Rndg. Acc." := GetValueAtCell(RowNo, 6);
                            VondorPostingGroup."Debit Rounding Account" := GetValueAtCell(RowNo, 7);
                            VondorPostingGroup."Credit Rounding Account" := GetValueAtCell(RowNo, 8);
                            VondorPostingGroup.Insert(true);
                        end;
                end;
            'Учетные группы товаров':
                begin
                    for RowNo := 3 to GetLastRow do
                        if not InventoryPostingGroup.Get(GetValueAtCell(RowNo, 1)) then begin
                            InventoryPostingGroup.Init();
                            InventoryPostingGroup.Code := GetValueAtCell(RowNo, 1);
                            InventoryPostingGroup.Description := GetValueAtCell(RowNo, 2);
                            //InventoryPostingGroup."?" := GetValueAtCell(RowNo, 3);
                            //InventoryPostingGroup."Purch. Amt. Diff. Alloc. Type" := GetValueAtCell(RowNo, 4);
                            InventoryPostingGroup."Purch. PD Charge FCY (Item)" := GetValueAtCell(RowNo, 5);
                            InventoryPostingGroup."Purch. PD Charge Conv. (Item)" := GetValueAtCell(RowNo, 6);
                            InventoryPostingGroup."Sales PD Charge FCY (Item)" := GetValueAtCell(RowNo, 7);
                            InventoryPostingGroup."Sales PD Charge Conv. (Item)" := GetValueAtCell(RowNo, 8);
                            InventoryPostingGroup.Insert(true);
                        end;
                end;
            'Учетные группы ОС':
                begin
                    for RowNo := 3 to GetLastRow do
                        if not FAPostingGroup.Get(GetValueAtCell(RowNo, 1)) then begin
                            FAPostingGroup.Init();
                            FAPostingGroup.Code := GetValueAtCell(RowNo, 1);
                            FAPostingGroup.Description := GetValueAtCell(RowNo, 2);
                            FAPostingGroup."Acquisition Cost Account" := GetValueAtCell(RowNo, 3);
                            FAPostingGroup."Accum. Depreciation Account" := GetValueAtCell(RowNo, 4);
                            FAPostingGroup."Write-Down Account" := GetValueAtCell(RowNo, 5);
                            FAPostingGroup."Write-Down Acc. on Disposal" := GetValueAtCell(RowNo, 6);
                            //FAPostingGroup."Disposal Expense Account" := GetValueAtCell(RowNo, 7);
                            FAPostingGroup."Acquisition Cost Bal. Acc." := GetValueAtCell(RowNo, 8);
                            FAPostingGroup."Sales Bal. Acc." := GetValueAtCell(RowNo, 9);
                            FAPostingGroup."Acq. Cost Acc. on Disposal" := GetValueAtCell(RowNo, 10);
                            FAPostingGroup."Accum. Depr. Acc. on Disposal" := GetValueAtCell(RowNo, 11);
                            FAPostingGroup."Gains Acc. on Disposal" := GetValueAtCell(RowNo, 12);
                            FAPostingGroup."Losses Acc. on Disposal" := GetValueAtCell(RowNo, 13);
                            FAPostingGroup."Depreciation Expense Acc." := GetValueAtCell(RowNo, 14);
                            FAPostingGroup."Disposal Expense Account" := GetValueAtCell(RowNo, 15);
                            FAPostingGroup.Insert(true);
                        end;
                end;
            'Общие бизнес-группы':
                begin
                    for RowNo := 3 to GetLastRow do
                        if not GenBusinessPostingGroup.Get(GetValueAtCell(RowNo, 1)) then begin
                            GenBusinessPostingGroup.Init();
                            GenBusinessPostingGroup.Code := GetValueAtCell(RowNo, 1);
                            GenBusinessPostingGroup.Description := GetValueAtCell(RowNo, 2);
                            GenBusinessPostingGroup.Insert(true);
                        end;
                end;
            'Общие товарные группы':
                begin
                    for RowNo := 3 to GetLastRow do
                        if not GenProductPostingGroup.Get(GetValueAtCell(RowNo, 1)) then begin
                            GenProductPostingGroup.Init();
                            GenProductPostingGroup.Code := GetValueAtCell(RowNo, 1);
                            GenProductPostingGroup.Description := GetValueAtCell(RowNo, 2);
                            GenProductPostingGroup."Def. VAT Prod. Posting Group" := GetValueAtCell(RowNo, 3);
                            GenProductPostingGroup."Auto Insert Default" := GetValueAtBool(RowNo, 4);
                            GenProductPostingGroup.Insert(true);
                        end;
                end;
            'НДС Товарные Группы':
                begin
                    for RowNo := 3 to GetLastRow do
                        if not VATProductPostingGroup.Get(GetValueAtCell(RowNo, 1)) then begin
                            VATProductPostingGroup.Init();
                            VATProductPostingGroup.Code := GetValueAtCell(RowNo, 1);
                            VATProductPostingGroup.Description := GetValueAtCell(RowNo, 2);
                            VATProductPostingGroup.Insert(true);
                        end;
                end;
            'НДС бизнес-группы':
                begin
                    for RowNo := 3 to GetLastRow do
                        if not VATBusinessPostingGroup.Get(GetValueAtCell(RowNo, 1)) then begin
                            VATBusinessPostingGroup.Init();
                            VATBusinessPostingGroup.Code := GetValueAtCell(RowNo, 1);
                            VATBusinessPostingGroup.Description := GetValueAtCell(RowNo, 2);
                            VATBusinessPostingGroup.Insert(true);
                        end;
                end;
            'Общая настройка учета':
                begin
                    for RowNo := 3 to GetLastRow do
                        if not GeneralPostingSetup.Get(GetValueAtCell(RowNo, 1), GetValueAtCell(RowNo, 2)) then begin
                            GeneralPostingSetup.Init();
                            GeneralPostingSetup."Gen. Bus. Posting Group" := GetValueAtCell(RowNo, 1);
                            GeneralPostingSetup."Gen. Prod. Posting Group" := GetValueAtCell(RowNo, 2);
                            GeneralPostingSetup."Sales Account" := GetValueAtCell(RowNo, 3);
                            GeneralPostingSetup."Sales Credit Memo Account" := GetValueAtCell(RowNo, 4);
                            GeneralPostingSetup."Sales Line Disc. Account" := GetValueAtCell(RowNo, 5);
                            GeneralPostingSetup."Sales Inv. Disc. Account" := GetValueAtCell(RowNo, 6);
                            GeneralPostingSetup."Purch. Account" := GetValueAtCell(RowNo, 13);
                            GeneralPostingSetup."Purch. Credit Memo Account" := GetValueAtCell(RowNo, 14);
                            GeneralPostingSetup."Purch. Line Disc. Account" := GetValueAtCell(RowNo, 15);
                            GeneralPostingSetup."COGS Account" := GetValueAtCell(RowNo, 22);
                            GeneralPostingSetup."Inventory Adjmt. Account" := GetValueAtCell(RowNo, 24);
                            GeneralPostingSetup."Direct Cost Applied Account" := GetValueAtCell(RowNo, 28);
                            GeneralPostingSetup."Overhead Applied Account" := GetValueAtCell(RowNo, 29);
                            GeneralPostingSetup."Purchase Variance Account" := GetValueAtCell(RowNo, 30);
                            GeneralPostingSetup.Insert(true);
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

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text

    begin
        if ExcelBuffer.Get(RowNo, ColNo) then
            exit(ExcelBuffer."Cell Value as Text");
    end;

    local procedure GetValueAtBool(RowNo: Integer; ColNo: Integer): Boolean

    begin
        if ExcelBuffer.Get(RowNo, ColNo) then
            if (ExcelBuffer."Cell Value as Text" = 'Да') then
                exit(true)
            else
                exit(false);
    end;
}