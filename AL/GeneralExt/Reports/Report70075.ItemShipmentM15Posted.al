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
            dataitem(TransferLine; "Transfer Line")
            {
                DataItemTableView = sorting("Document No.", "Line No.") where("Derived From Line No." = const(0));
                DataItemLink = "Document No." = field("No.");

                trigger OnPreDataItem()
                begin
                    i := 0;
                end;

                trigger OnAfterGetRecord()
                var
                    TransferLineReserve: Codeunit "Transfer Line-Reserve";
                    ReservEntry: Record "Reservation Entry";
                    ILE: Record "Item Ledger Entry";
                    ILEQuantity: Decimal;
                    Amount: Decimal;
                    VATPostingSetup: Record "VAT Posting Setup";
                    VAT: Decimal;
                    AmountIncVAT: Decimal;
                    Direction: Enum "Transfer Direction";
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

                    Clear(UnitCostTxt);
                    Clear(AmountTxt);
                    Clear(VATAmountTxt);
                    Clear(IncVATAmountTxt);

                    TransferLine.SetReservationFilters(ReservEntry, Direction::Outbound);

                    if Quantity <> 0 then
                        if ReservEntry.FindFirst() then
                            if ReservEntry.Get(ReservEntry."Entry No.", not ReservEntry.Positive) then
                                if ILE.Get(ReservEntry."Source Ref. No.") then begin
                                    if ILE.Quantity = 0 then
                                        ILEQuantity := 1
                                    else
                                        ILEQuantity := ILE.Quantity;

                                    ILE.CalcFields(ILE."Cost Amount (Expected)", ILE."Cost Amount (Actual)");
                                    Amount := ILE."Cost Amount (Expected)" + ILE."Cost Amount (Actual)";
                                    Amount := Amount / ILEQuantity * Quantity;

                                    if Item.Get("Item No.") and Vendor.Get(TransferHeader."Vendor No.") then
                                        if VATPostingSetup.Get(Vendor."VAT Bus. Posting Group", Item."VAT Prod. Posting Group") then
                                            VAT := Round(Amount * VATPostingSetup."VAT %" / 100);

                                    AmountIncVAT := Amount + VAT;
                                    VATAmount += VAT;
                                    TotalAmount += AmountIncVAT;

                                    if Quantity <> 0 then
                                        UnitCostTxt := Format(Amount / Quantity, 0, '<Precision,2:2><Standard Format,0>');

                                    AmountTxt := Format(Amount, 0, '<Precision,2:2><Standard Format,0>');
                                    VATAmountTxt := Format(VAT, 0, '<Precision,2:2><Standard Format,0>');
                                    IncVATAmountTxt := Format(AmountIncVAT, 0, '<Precision,2:2><Standard Format,0>');

                                end;

                    if not PrintPrice then begin
                        UnitCostTxt := '-';
                        AmountTxt := '-';
                        VATAmountTxt := '-';
                        IncVATAmountTxt := '-';
                    end;

                    Qty1Txt := Format(Quantity);
                    Qty2Txt := Format(Quantity);

                    txtItemNo := "Item No.";

                    if "Variant Code" <> '' then
                        txtItemNo := txtItemNo + '(' + "Variant Code" + ')';

                    FillBody("Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Unit of Measure Code");
                end;

                trigger OnPostDataItem()
                begin
                    TotalAmountTxt := LocalManagement.Amount2Text('', TotalAmount);
                    TotalVATAmountTxt := LocalManagement.Amount2Text('', VATAmount);
                    if not PrintPrice then begin
                        TotalAmountTxt := '-';
                        TotalVATAmountTxt := '-';
                    end;

                    FillFooter();
                end;
            }


            trigger OnPreDataItem()
            begin
                if GetFilters = '' then
                    CurrReport.Break();
            end;

            trigger OnAfterGetRecord()
            var
                TransferLine: Record "Transfer Line";
                ConsignorTmp: Text;
                Bin: Record Bin;
            begin
                Consignor := "Transfer-from Code";
                if Location.Get(Consignor) then
                    Consignor := Consignor + ' ' + Location.Name + ', ' + Location.Address + ' ' + Location."Address 2";

                Consignee := "Transfer-to Code";
                if Location.Get(Consignee) then
                    Consignee := Consignee + ' ' + Location.Name + ', ' + Location.Address + ' ' + Location."Address 2";

                TransferLine.Reset();
                ;
                TransferLine.SetRange("Document No.", "No.");
                TransferLine.SetFilter("Transfer-To Bin Code", '<>%1', '');

                if TransferLine.FindFirst() then begin
                    Bin.Get(TransferLine."Transfer-to Code", TransferLine."Transfer-To Bin Code");
                    Consignee := Bin.Code;
                    if Bin.Description <> '' then
                        Consignee := Bin.Description;
                end;

                if Vendor.Get("Vendor No.") then begin
                    Consignee := Vendor.Name;
                    if VendorAgreement.Get("Vendor No.", "Agreement No.") then
                        ReasonName3 := STRSUBSTNO(Text12401, VendorAgreement."External Agreement No.");
                end;

                if Vendor.GET("Vendor No.") then
                    Consignee := Vendor."Full Name";

                FillHeader("No.", "Posting Date");
            end;
        }

        dataitem(ItemDocHeader; "Item Document Header")
        {
            DataItemTableView = sorting("Document Type", "No.") order(ascending) where("Document Type" = const(Shipment));
            dataitem(ItemDocLine; "Item Document Line")
            {
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.") order(ascending);
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");

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
                    InvPostingSetup.SetRange("Location Code", "Location Code");
                    InvPostingSetup.SetRange("Invt. Posting Group Code", "Inventory Posting Group");

                    if InvPostingSetup.FindSet() then
                        BalAccount := InvPostingSetup."Inventory Account";

                    if not UnitOfMeasure.Get("Unit of Measure Code") then
                        Clear(UnitOfMeasure);

                    ItemDescription := Description;

                    if ILE.Get("Applies-from Entry") then begin
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

                    FillBody("Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Unit of Measure Code");
                end;

                trigger OnPostDataItem()
                begin
                    TotalAmountTxt := LocalManagement.Amount2Text('', TotalAmount);
                    TotalVATAmountTxt := LocalManagement.Amount2Text('', VATAmount);
                    if not PrintPrice then begin
                        TotalAmountTxt := '-';
                        TotalVATAmountTxt := '-';
                    end;

                    FillFooter();
                end;
            }

            trigger OnPreDataItem()
            begin
                if GetFilters = '' then
                    CurrReport.Break();
            end;

            trigger OnAfterGetRecord()
            begin
                Consignor := "Location Code";
                if Vendor.Get("Vendor No.") then begin
                    Consignee := Vendor.Name;
                    if VendorAgreement.Get("Vendor No.", "Agreement No.") then
                        ReasonName3 := StrSubstNo(Text12401, VendorAgreement."External Agreement No.");
                end;

                if Location.Get(Consignor) then
                    Consignor := Consignor + ' ' + Location.Name + ', ' + Location.Address + ' ' + Location."Address 2";

                FillHeader("No.", "Posting Date");
            end;
        }

        dataitem(ItemShipmentHeader; "Item Shipment Header")
        {
            DataItemTableView = sorting("No.");
            dataitem(ItemShipmentLine; "Item Shipment Line")
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
                    InvPostingSetup.SetRange("Location Code", "Location Code");
                    InvPostingSetup.SetRange("Invt. Posting Group Code", "Inventory Posting Group");

                    if InvPostingSetup.FindSet() then
                        BalAccount := InvPostingSetup."Inventory Account";

                    if not UnitOfMeasure.Get("Unit of Measure Code") then
                        Clear(UnitOfMeasure);

                    ItemDescription := Description;

                    if ILE.Get("Item Shpt. Entry No.") then begin
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

                    FillBody("Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Unit of Measure Code");
                end;

                trigger OnPostDataItem()
                begin
                    TotalAmountTxt := LocalManagement.Amount2Text('', TotalAmount);
                    TotalVATAmountTxt := LocalManagement.Amount2Text('', VATAmount);
                    if not PrintPrice then begin
                        TotalAmountTxt := '-';
                        TotalVATAmountTxt := '-';
                    end;

                    FillFooter();
                end;
            }

            trigger OnPreDataItem()
            begin
                if GetFilters = '' then
                    CurrReport.Break();
            end;

            trigger OnAfterGetRecord()
            begin
                Consignor := "Location Code";

                if Vendor.Get("Vendor No.") then begin
                    Consignee := Vendor.Name;
                    if VendorAgreement.Get("Vendor No.", "Agreement No.") then
                        ReasonName3 := StrSubstNo(Text12401, VendorAgreement."External Agreement No.");
                end;

                if Location.Get(Consignor) then
                    Consignor := Consignor + ' ' + Location.Name + ', ' + Location.Address + ' ' + Location."Address 2";

                if Vendor.Get("Vendor No.") then begin
                    Consignee := Vendor.Name;
                    if VendorAgreement.Get("Vendor No.", "Agreement No.") then
                        ReasonName3 := StrSubstNo(Text12401, "Agreement No.");
                END;

                FillHeader("No.", "Posting Date");
            end;
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
        ExcelBufferTmp: Record "Excel Buffer Mod" temporary;
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
        VATAmountTxt: Text;
        IncVATAmountTxt: Text;
        Item: Record Item;
        RowNo: Integer;
        Employee2: Code[20];
        Employee3: Code[20];
        Employee4: Code[20];


    procedure FillHeader(DocNo: Code[20]; PostingDate: Date)
    begin
        if ExportToExcel then begin
            EnterCell(2, 70, Format(DocNo), false, ExcelBufferTmp."Cell Type"::Text, 9, false);
            EnterCell(5, 13, Format(LocRepMgt.GetCompanyName()), false, ExcelBufferTmp."Cell Type"::Text, 9, false);
            EnterCell(5, 132, Format(CompanyInfo."OKPO Code"), false, ExcelBufferTmp."Cell Type"::Text, 7, false);
            EnterCell(9, 4, Format(PostingDate), false, ExcelBufferTmp."Cell Type"::Text, 7, false);
            EnterCell(9, 26, Format(GetCostCodeName(1, TransferHeader."Shortcut Dimension 1 Code")), false, ExcelBufferTmp."Cell Type"::Text, 6, false);
            EnterCell(9, 71, Format(GetCostCodeName(1, TransferHeader."New Shortcut Dimension 1 Code")), false, ExcelBufferTmp."Cell Type"::Text, 6, false);
            EnterCell(11, 12, Format(ReasonName3), false, ExcelBufferTmp."Cell Type"::Text, 9, false);
            EnterCell(12, 7, Format(Consignee), false, ExcelBufferTmp."Cell Type"::Text, 9, false);
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

    procedure FillBody(ShortcutDimension1Code: Code[20]; ShortcutDimension2Code: Code[20]; UnitofMeasureCode: Code[20])
    var
        FontSize: Integer;
    begin
        if ExportToExcel then begin
            FontSize := 6;
            RowNo := 14;
            EnterCell(RowNo, 1, Format(BalAccount), false, ExcelBufferTmp."Cell Type"::Text, FontSize, false);
            EnterCell(RowNo, 11, Format(ItemDescription), false, ExcelBufferTmp."Cell Type"::Text, FontSize, false);
            EnterCell(RowNo, 39, Format(txtItemNo), false, ExcelBufferTmp."Cell Type"::Text, FontSize, false);
            EnterCell(RowNo, 49, Format(ShortcutDimension1Code), false, ExcelBufferTmp."Cell Type"::Text, FontSize, false);
            EnterCell(RowNo, 58, Format(ShortcutDimension2Code), false, ExcelBufferTmp."Cell Type"::Text, FontSize, false);
            EnterCell(RowNo, 64, Format(UnitOfMeasure."OKEI Code"), false, ExcelBufferTmp."Cell Type"::Text, FontSize, false);
            EnterCell(RowNo, 71, Format(UnitofMeasureCode), false, ExcelBufferTmp."Cell Type"::Text, FontSize, false);
            EnterCell(RowNo, 79, Format(Qty1Txt), false, ExcelBufferTmp."Cell Type"::Text, FontSize, false);
            EnterCell(RowNo, 87, Format(Qty2Txt), false, ExcelBufferTmp."Cell Type"::Text, FontSize, false);
            EnterCell(RowNo, 94, Format(UnitCostTxt), false, ExcelBufferTmp."Cell Type"::Text, FontSize, false);
            EnterCell(RowNo, 102, Format(AmountTxt), false, ExcelBufferTmp."Cell Type"::Text, FontSize, false);

            if VATAmountTxt = '' then
                EnterCell(RowNo, 111, '-', false, ExcelBufferTmp."Cell Type"::Text, FontSize, false)
            else
                EnterCell(RowNo, 111, VATAmountTxt, false, ExcelBufferTmp."Cell Type"::Text, FontSize, false);

            if IncVATAmountTxt = '' then
                EnterCell(RowNo, 119, '-', false, ExcelBufferTmp."Cell Type"::Text, FontSize, false)
            else
                EnterCell(RowNo, 119, IncVATAmountTxt, false, ExcelBufferTmp."Cell Type"::Text, FontSize, false);

            RowNo += 1;
        END;
    end;

    procedure FillFooter()
    begin
        if ExportToExcel then begin
            EnterCell(RowNo, 16, Format(LocalManagement.Integer2Text(i, 2, 'наименование', 'наименования', 'наименований')), false, ExcelBufferTmp."Cell Type"::Text, 7, false);

            RowNo += 2;
            EnterCell(RowNo, 10, TotalAmountTxt, false, ExcelBufferTmp."Cell Type"::Text, 7, false);
            EnterCell(RowNo, 114, TotalVATAmountTxt, false, ExcelBufferTmp."Cell Type"::Text, 7, false);

            RowNo += 3;
            EnterCell(RowNo, 17, LocRepMgt.GetEmpPosition(Employee2), false, ExcelBufferTmp."Cell Type"::Text, 7, false);
            EnterCell(RowNo, 39, LocRepMgt.GetEmpName(Employee2), false, ExcelBufferTmp."Cell Type"::Text, 7, false);
            EnterCell(RowNo, 105, LocRepMgt.GetEmpName(CompanyInfo."Accountant No."), false, ExcelBufferTmp."Cell Type"::Text, 7, false);

            RowNo += 3;
            EnterCell(RowNo, 10, LocRepMgt.GetEmpPosition(Employee3), false, ExcelBufferTmp."Cell Type"::Text, 7, false);
            EnterCell(RowNo, 30, LocRepMgt.GetEmpName(Employee3), false, ExcelBufferTmp."Cell Type"::Text, 7, false);
            EnterCell(RowNo, 83, LocRepMgt.GetEmpPosition(Employee4), false, ExcelBufferTmp."Cell Type"::Text, 7, false);
            EnterCell(RowNo, 105, LocRepMgt.GetEmpName(Employee4), false, ExcelBufferTmp."Cell Type"::Text, 7, false);
        end;
    end;

    local procedure EnterCell(RowNo: Integer; ColumnNo: Integer; CellValue: Text; Bold: Boolean; CellType: Integer; FontSize: Integer; IsBorder: Boolean)
    begin
        ExcelBufferTmp.Init();
        ExcelBufferTmp.Validate("Row No.", RowNo);
        ExcelBufferTmp.Validate("Column No.", ColumnNo);
        ExcelBufferTmp."Cell Value as Text" := CellValue;
        ExcelBufferTmp.Formula := '';
        ExcelBufferTmp.Bold := Bold;
        ExcelBufferTmp."Font Size" := FontSize;
        ExcelBufferTmp."Cell Type" := CellType;
        if IsBorder then
            ExcelBufferTmp.SetBorder(true, true, true, true, false, "Border Style"::Thin);
        ExcelBufferTmp.Insert();
    end;
}