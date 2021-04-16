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

                PurchasesPayablesSetup.Get(''); //?
                FileName := ExcelTemplate.OpenTemplate(PurchasesPayablesSetup."Vendor Agreement Template Code");
                ExcelBuffer.OpenBook(FileName, 'Sheet Name'); //?

                RowNo := 5;
                ExcelBuffer.EnterCell(ExcelBuffer, 1, 1, 'Разбивка по литерам', true, false, false); //?
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
                //ExcelBuffer.InsertString(CurRow);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 1, Format("Building Turn All"), false, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 2, Format("Project Code"), false, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 3, Format("Cost Code"), false, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 4, Format("Global Dimension 1 Code"), false, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 5, Format("Global Dimension 2 Code"), false, false, false);

                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 6, Format("Cost Type"), false, false, false);
                ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 7, Format(Description), false, false, false);
                //ExcelBuffer.EnterCell(ExcelBuffer, RowNo, 8, Format((VendAgrDetForm.CalcGActuals("Project Code",                       //?
                //                                                                                 "Project Line No.",
                //                                                                                 "Agreement No.",
                //                                                                                 "Global Dimension 1 Code",
                //                                                                                 "Global Dimension 2 Code",
                //                                                                                 "Cost Type", true),
                //                                                     0, '<Precision,2:2><Standard Format,1>')), false, false, false);
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
    //VendAgrDetForm: Page "Vendor Agreement Details"; //?
}