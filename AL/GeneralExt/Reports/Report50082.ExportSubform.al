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
                CurStartRow := 0;
                TemplateRowStart := 6;

                PurchasesPayablesSetup.Get('');
                FileName := ExcelTemplate.OpenTemplate(PurchasesPayablesSetup."Vendor Agreement Template Code");

                RowNo := 5;
                ExcelBuffer.EnterCell(ExcelBuffer, 1, 1, Text001, true, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, 2, 3, VendorNo, true, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, 3, 3, DocumentNo, true, false, false);
            end;

            trigger OnAfterGetRecord()
            var
                CurRow: Integer;
            begin
                Sleep(1);
                RowNo += 1;
                CurRow := CurStartRow + RowNo;
                //ExcelBuffer.InsertString(CurRow); //?

                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 1, Format("Building Turn All"), false, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 2, Format("Project Code"), false, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 3, Format("Cost Code"), false, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 4, Format("Global Dimension 1 Code"), false, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 5, Format("Global Dimension 2 Code"), false, false, false);

                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 6, Format("Cost Type"), false, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 7, Format(Description), false, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 8, Format(VendAgrDetails.CalcGActuals(false,
                                                                                                "Project Code",
                                                                                                "Project Line No.",
                                                                                                "Agreement No.",
                                                                                                "Global Dimension 1 Code",
                                                                                                "Global Dimension 2 Code",
                                                                                                "Cost Type", true), 0, '<Precision,2:2><Standard Format,1>'), false, false, false);

                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 9, DelChr(Format(Amount, 0, '<Precision,2:2><Standard Format,1>')), false, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 10, Format(VendAgrDetails.CalcPostedInvoice2("Vendor No.",
                                                                                                       "Agreement No.",
                                                                                                       "Global Dimension 1 Code",
                                                                                                       "Global Dimension 2 Code",
                                                                                                       "Cost Type"), 0, '<Precision,2:2><Standard Format,1>'), false, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 11, Format(VendAgrDetails.GetCommited("Agreement No.",
                                                                                                "Global Dimension 1 Code",
                                                                                                "Global Dimension 2 Code"), 0, '<Precision,2:2><Standard Format,1>'), false, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 12, Format(Amount - VendAgrDetails.GetCommited("Agreement No.",
                                                                                                         "Global Dimension 1 Code",
                                                                                                         "Global Dimension 2 Code"), 0, '<Precision,2:2><Standard Format,1>'), false, false, false);
            end;

            trigger OnPostDataItem()
            begin
                ExcelBuffer.UpdateBook(FileName, Text001);
                ExcelBuffer.WriteSheet('', CompanyName, UserId);
                //ExcelBuffer.DeleteString(RowNo-1); //?
            end;
        }

        dataitem(ProjectsBudgetEntry; "Projects Budget Entry")
        {
            trigger OnPreDataItem()
            begin
                RowNo := 5;
                SetRange("Agreement No.", CopyStr(DocumentNo, 1, 20));

                ExcelBuffer.CloseBook();
                ExcelBuffer.DeleteAll();

                ExcelBuffer.EnterCell(ExcelBuffer, 1, 1, Text002, true, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, 2, 3, VendorNo, true, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, 3, 3, DocumentNo, true, false, false);
            end;

            trigger OnAfterGetRecord()
            var
                CurRow: Integer;
            begin
                RowNo += 1;
                CurRow := CurStartRow + RowNo;
                //ExcelBuffer.InsertString(CurRow);         //?

                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 1, Format("Entry No."), false, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 2, Format(Date), false, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 3, Format("Date Plan"), false, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 4, Format("Building Turn"), false, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 5, Format("Cost Code"), false, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 6, Format("Transaction Type"), false, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 7, Format("Without VAT", 0, '<Precision,2:2><Standard Format,1>'), false, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 8, Format("Without VAT (LCY)", 0, '<Precision,2:2><Standard Format,0>'), false, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 9, Format(Curency), false, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 10, Format(Description), false, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 11, Format("Description 2"), false, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 12, Format(GetInvoiceNo), false, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 13, Format(GetInvoiceDate), false, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 14, Format("Payment Doc. No."), false, false, false);
            end;

            trigger OnPostDataItem()
            begin
                //ExcelBuffer.DeleteString(RowNo-1);  //?
                ExcelBuffer.UpdateBook(FileName, Text002);
                ExcelBuffer.WriteSheet('', CompanyName, UserId);
                ExcelBuffer.CloseBook();
                ExcelBuffer.DownloadAndOpenExcel();
            end;
        }
    }

    var
        DocumentNo: Code[100];
        CurStartRow: Integer;
        TemplateRowStart: Integer;
        FileName: Text[1024];
        ExcelTemplate: Record "Excel Template";
        ExcelBuffer: Record "Excel Buffer Mod";
        RowNo: Integer;
        VendorNo: Code[100];
        Text001: Label 'Разбивка по литерам';
        Text002: Label 'График платежей';
        VendAgrDetails: Record "Vendor Agreement Details";

    procedure SetDocNo(DocNo: Code[10]; VendNo: Code[10])
    begin
        DocumentNo := DocNo;
        VendorNo := VendNo;
    end;
}