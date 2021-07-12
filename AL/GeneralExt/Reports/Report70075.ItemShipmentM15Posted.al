report 70075 "Item Shipment M-15 Posted"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Item Shipment M-15 Posted';

    dataset
    {
        dataitem(TransferReceiptHeader; "Transfer Receipt Header")
        {
            DataItemTableView = sorting("No.");

            dataitem(TransferReceiptLine; "Transfer Receipt Line")
            {
                DataItemTableView = sorting("Document No.", "Line No.");
                DataItemLink = "Document No." = field("No.");

                trigger OnPreDataItem()
                begin
                    i := 0;
                end;

                trigger OnAfterGetRecord()
                var
                    ILE: Record "Item Ledger Entry";
                begin
                    i += 1;

                    BalAccount := '';
                    InvPostingSetup.Reset();
                    InvPostingSetup.SetRange("Location Code", "Transfer-from Code");
                    InvPostingSetup.SetRange("Invt. Posting Group Code", "Inventory Posting Group");
                    if InvPostingSetup.FindSet() then
                        BalAccount := InvPostingSetup."Inventory Account";

                    if not UnitOfMeasure.Get("Unit of Measure Code") then
                        Clear(UnitOfMeasure);

                    ItemDescription := Description + "Description 2";

                    if ILE.Get("Item Rcpt. Entry No.") then begin
                        ILE.CalcFields("Cost Amount (Actual)");
                        UnitCostTxt := Format(Abs(ILE."Cost Amount (Actual)" / ILE.Quantity), 0, '<Precision,2:2><Standard Format,0>');
                        AmountTxt := Format(Abs(ILE."Cost Amount (Actual)"), 0, '<Precision,2:2><Standard Format,0>');
                        TotalAmount += Abs(ILE."Cost Amount (Actual)");
                    end;

                    if not PrintPrice then begin
                        UnitCostTxt := '-';
                        AmountTxt := '-';
                    end;

                    Qty1Txt := Format(Quantity);
                    Qty2Txt := Format(Quantity);

                    txtItemNo := "Item No.";
                    if "Variant Code" <> '' then
                        txtItemNo := txtItemNo + '(' + "Variant Code" + ')';
                end;
            }

            dataitem(Integer; Integer)
            {
                DataItemTableView = sorting(Number);

                trigger OnAfterGetRecord()
                begin
                    TotalAmountTxt := LocalManagement.Amount2Text('', TotalAmount);
                    TotalVATAmountTxt := LocalManagement.Amount2Text('', VATAmount);
                    if not PrintPrice then begin
                        TotalAmountTxt := '-';
                        TotalVATAmountTxt := '-';
                    end;
                end;
            }

            trigger OnPreDataItem()
            begin
                if GetFilters() = '' then
                    CurrReport.Break();
            end;

            trigger OnAfterGetRecord()
            var
                ConsignorTmp: Text;
                TransferRcptLine: Record "Transfer Receipt Line";
                Bin: Record "Bin";
            begin
                Consignor := "Transfer-from Code";
                if Location.Get(Consignor) then
                    Consignor := Consignor + ' ' + Location.Name + ', ' + Location.Address + ' ' + Location."Address 2";

                Consignee := "Transfer-to Code";
                if Location.Get(Consignee) then
                    Consignee := Consignee + ' ' + Location.Name + ', ' + Location.Address + ' ' + Location."Address 2";

                TransferRcptLine.Reset();
                TransferRcptLine.SetRange("Document No.", "No.");
                TransferRcptLine.SetFilter("Transfer-To Bin Code", '<>%1', '');

                if TransferRcptLine.FindFirst() then begin
                    Bin.Get(TransferRcptLine."Transfer-to Code", TransferRcptLine."Transfer-To Bin Code");
                    Consignee := Bin.Code;
                    if Bin.Description <> '' then
                        Consignee := Bin.Description;
                end;

                if Vendor.Get("No.") then begin
                    Consignee := Vendor.Name;
                    if VendorAgreement.Get("Vendor No.", "Agreement No.") then
                        ReasonName3 := StrSubstNo(Text12401, VendorAgreement."External Agreement No.");
                end;

                FillHeader("No.", "Posting Date");
            end;
        }

        dataitem(TransferHeader; "Transfer Header")
        {
            DataItemTableView = sorting("No.");

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(Name; PrintPrice)
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        Consignor: Text;
        Location: Record "Location";
        Consignee: Text;
        Vendor: Record "Vendor";
        VendorAgreement: Record "Vendor Agreement";
        ReasonName3: Text;
        Text12401: Label 'By agreement %1';
        ExportToExcel: Boolean;
        ExcelBuf: Record "Excel Buffer Mod" temporary;
        LocRepMgt: Codeunit "Local Report Management";
        CompanyInfo: Record "Company Information";
        PrintPrice: Boolean;
        i: Integer;
        BalAccount: Code[20];
        InvPostingSetup: Record "Inventory Posting Setup";
        UnitOfMeasure: Record "Unit of Measure";
        ItemDescription: Text;
        UnitCostTxt: Text;
        AmountTxt: Text;
        TotalAmount: Decimal;
        Qty1Txt: Text;
        Qty2Txt: Text;
        txtItemNo: Code[20];
        TotalAmountTxt: Text;
        TotalVATAmountTxt: Text;
        LocalManagement: Codeunit "Localisation Management";
        VATAmount: Decimal;

    procedure FillHeader(DocNo: Code[20]; PostingDate: Date)
    begin
        if ExportToExcel then begin
            ExcelBuf.EnterCell(ExcelBuf, 2, 70, DocNo, false, false, false);
            ExcelBuf.EnterCell(ExcelBuf, 5, 13, LocRepMgt.GetCompanyName(), false, false, false);
            ExcelBuf.EnterCell(ExcelBuf, 5, 132, CompanyInfo."OKPO Code", false, false, false);
            ExcelBuf.EnterCell(ExcelBuf, 9, 4, Format(PostingDate), false, false, false);
            ExcelBuf.EnterCell(ExcelBuf, 9, 26, GetCostCodeName(1, TransferHeader."Shortcut Dimension 1 Code"), false, false, false);
            ExcelBuf.EnterCell(ExcelBuf, 9, 71, GetCostCodeName(1, TransferHeader."New Shortcut Dimension 1 Code"), false, false, false);
            ExcelBuf.EnterCell(ExcelBuf, 11, 12, ReasonName3, false, false, false);
            ExcelBuf.EnterCell(ExcelBuf, 12, 7, Consignee, false, false, false);
        end;
    end;

    procedure GetCostCodeName(GlobalDimNo: Integer; GlobalDimCode: Code[20]): Text
    var
        DimensionValue: Record "Dimension Value";
    begin
        DimensionValue.SetRange("Global Dimension No.", 1);
        DimensionValue.SetRange(Code, GlobalDimCode);
        if DimensionValue.FindFirst() then
            exit(DimensionValue.Name);
        exit('');
    end;
}