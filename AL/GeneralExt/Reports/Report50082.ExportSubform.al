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
            var
                PurchasesPayablesSetup: Record "Purchases & Payables Setup";
            begin
                SetRange("Agreement No.", CopyStr(DocumentNo, 1, 20));

                PurchasesPayablesSetup.Get();
                FileName := ExcelTemplate.OpenTemplate(PurchasesPayablesSetup."Vendor Agreement Template Code");

                RowNo := 5;
                EnterCell(1, 1, ExcelTemplate."Sheet Name", true, ExcelBufferTmp."Cell Type"::Text, false);
                EnterCell(2, 3, VendorNo, true, ExcelBufferTmp."Cell Type"::Text, false);
                EnterCell(3, 3, DocumentNo, true, ExcelBufferTmp."Cell Type"::Text, false);
            end;

            trigger OnAfterGetRecord()
            var
                CurRow: Integer;
            begin
                Sleep(1);
                RowNo += 1;

                EnterCell(RowNo, 1, Format("Building Turn All"), true, ExcelBufferTmp."Cell Type"::Text, true);
                EnterCell(RowNo, 2, Format("Project Code"), true, ExcelBufferTmp."Cell Type"::Text, true);
                EnterCell(RowNo, 3, Format("Cost Code"), true, ExcelBufferTmp."Cell Type"::Text, true);
                EnterCell(RowNo, 4, Format("Global Dimension 1 Code"), true, ExcelBufferTmp."Cell Type"::Text, true);
                EnterCell(RowNo, 5, Format("Global Dimension 2 Code"), true, ExcelBufferTmp."Cell Type"::Text, true);
                EnterCell(RowNo, 6, Format("Cost Type"), true, ExcelBufferTmp."Cell Type"::Text, true);
                EnterCell(RowNo, 7, Format(Description), true, ExcelBufferTmp."Cell Type"::Text, true);
                EnterCell(RowNo, 8, Format(CalcGActuals(false,
                                                        "Project Code",
                                                        "Project Line No.",
                                                        "Agreement No.",
                                                        "Global Dimension 1 Code",
                                                        "Global Dimension 2 Code",
                                                        "Cost Type", true), 0, '<Precision,2:2><Standard Format,1>'), true, ExcelBufferTmp."Cell Type"::Text, true);
                EnterCell(RowNo, 9, DelChr(Format(Amount, 0, '<Precision,2:2><Standard Format,1>')), true, ExcelBufferTmp."Cell Type"::Text, true);
                EnterCell(RowNo, 10, Format(CalcPostedInvoice2("Vendor No.",
                                                               "Agreement No.",
                                                               "Global Dimension 1 Code",
                                                               "Global Dimension 2 Code",
                                                               "Cost Type"), 0, '<Precision,2:2><Standard Format,1>'), true, ExcelBufferTmp."Cell Type"::Text, true);
                EnterCell(RowNo, 11, Format(GetCommited("Agreement No.",
                                                        "Global Dimension 1 Code",
                                                        "Global Dimension 2 Code"), 0, '<Precision,2:2><Standard Format,1>'), true, ExcelBufferTmp."Cell Type"::Text, true);
                EnterCell(RowNo, 12, Format(Amount - GetCommited("Agreement No.",
                                                                 "Global Dimension 1 Code",
                                                                 "Global Dimension 2 Code"), 0, '<Precision,2:2><Standard Format,1>'), true, ExcelBufferTmp."Cell Type"::Text, true);
            end;

            trigger OnPostDataItem()
            begin
                ExcelBufferTmp.UpdateBook(FileName, Text001);
                ExcelBufferTmp.WriteSheet('', CompanyName, UserId);
            end;
        }

        dataitem(ProjectsBudgetEntry; "Projects Budget Entry")
        {
            trigger OnPreDataItem()
            begin
                RowNo := 5;
                SetRange("Agreement No.", CopyStr(DocumentNo, 1, 20));

                ExcelBufferTmp.CloseBook();
                ExcelBufferTmp.DeleteAll();

                EnterCell(1, 1, Text002, true, ExcelBufferTmp."Cell Type"::Text, false);
                EnterCell(2, 3, VendorNo, true, ExcelBufferTmp."Cell Type"::Text, false);
                EnterCell(3, 3, DocumentNo, true, ExcelBufferTmp."Cell Type"::Text, false);
            end;

            trigger OnAfterGetRecord()
            var
                CurRow: Integer;
            begin
                RowNo += 1;

                EnterCell(RowNo, 1, Format("Entry No."), true, ExcelBufferTmp."Cell Type"::Text, true);
                EnterCell(RowNo, 2, Format(Date), true, ExcelBufferTmp."Cell Type"::Text, true);
                EnterCell(RowNo, 3, Format("Date Plan"), true, ExcelBufferTmp."Cell Type"::Text, true);
                EnterCell(RowNo, 4, Format("Building Turn"), true, ExcelBufferTmp."Cell Type"::Text, true);
                EnterCell(RowNo, 5, Format("Cost Code"), true, ExcelBufferTmp."Cell Type"::Text, true);
                EnterCell(RowNo, 6, Format("Transaction Type"), true, ExcelBufferTmp."Cell Type"::Text, true);
                EnterCell(RowNo, 7, Format("Without VAT", 0, '<Precision,2:2><Standard Format,1>'), true, ExcelBufferTmp."Cell Type"::Text, true);
                EnterCell(RowNo, 8, Format("Without VAT (LCY)", 0, '<Precision,2:2><Standard Format,0>'), true, ExcelBufferTmp."Cell Type"::Text, true);
                EnterCell(RowNo, 9, Format(Curency), true, ExcelBufferTmp."Cell Type"::Text, true);
                EnterCell(RowNo, 10, Format(Description), true, ExcelBufferTmp."Cell Type"::Text, true);
                EnterCell(RowNo, 11, Format("Description 2"), true, ExcelBufferTmp."Cell Type"::Text, true);
                EnterCell(RowNo, 12, Format(GetInvoiceNo), true, ExcelBufferTmp."Cell Type"::Text, true);
                EnterCell(RowNo, 12, Format(GetInvoiceDate), true, ExcelBufferTmp."Cell Type"::Text, true);
                EnterCell(RowNo, 14, Format("Payment Doc. No."), true, ExcelBufferTmp."Cell Type"::Text, true);
            end;

            trigger OnPostDataItem()
            begin
                ExcelBufferTmp.UpdateBook(FileName, Text002);
                ExcelBufferTmp.WriteSheet('', CompanyName, UserId);
                ExcelBufferTmp.CloseBook();
                ExcelBufferTmp.DownloadAndOpenExcel();
            end;
        }
    }

    var
        DocumentNo: Code[100];
        FileName: Text[1024];
        ExcelTemplate: Record "Excel Template";
        ExcelBufferTmp: Record "Excel Buffer Mod" temporary;
        RowNo: Integer;
        VendorNo: Code[100];
        Text001: Label 'Разбивка по литерам';
        Text002: Label 'График платежей';

    procedure SetDocNo(DocNo: Code[10]; VendNo: Code[10])
    begin
        DocumentNo := DocNo;
        VendorNo := VendNo;
    end;

    local procedure EnterCell(RowNo: Integer; ColumnNo: Integer; CellValue: Text; Bold: Boolean; CellType: Integer; IsBorder: Boolean)
    begin
        ExcelBufferTmp.Init();
        ExcelBufferTmp.Validate("Row No.", RowNo);
        ExcelBufferTmp.Validate("Column No.", ColumnNo);
        ExcelBufferTmp."Cell Value as Text" := CellValue;
        ExcelBufferTmp.Formula := '';
        ExcelBufferTmp.Bold := Bold;
        ExcelBufferTmp."Cell Type" := CellType;
        if IsBorder then
            ExcelBufferTmp.SetBorder(true, true, true, true, false, "Border Style"::Thin);
        ExcelBufferTmp.Insert();
    end;
}