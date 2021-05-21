page 70261 "Purchase Order Act Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Purchase Line";
    SourceTableView = WHERE("Document Type" = FILTER(Order));

    layout
    {
        area(content)
        {
            repeater(PurchDetailLine)
            {
                field(FilteredTypeField; TypeAsText)
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    Editable = CurrPageIsEditable;
                    LookupPageID = "Option Lookup List";
                    TableRelation = "Option Lookup Buffer"."Option Caption" WHERE("Lookup Type" = CONST(Purchases));

                    trigger OnValidate()
                    var
                        OldTypeValue: Enum "Purchase Document Type";
                    begin
                        OldTypeValue := Rec."Type";

                        TempOptionLookupBuffer.SetCurrentType(Type.AsInteger());
                        if TempOptionLookupBuffer.AutoCompleteOption(TypeAsText, TempOptionLookupBuffer."Lookup Type"::Purchases) then
                            Validate(Type, TempOptionLookupBuffer.ID);
                        TempOptionLookupBuffer.ValidateOption(TypeAsText);

                        IF OldTypeValue <> Rec."Type" THEN
                            IF Type = Type::Item THEN BEGIN
                                grInventorySetup.GET;
                                grInventorySetup.TESTFIELD("Temp Item Code");
                                VALIDATE("No.", grInventorySetup."Temp Item Code");
                                NoOnAfterValidate();
                            END;

                        UpdateEditableOnRow();
                        UpdateTypeText();
                        DeltaUpdateTotals();
                    end;
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    ShowMandatory = Type <> Type::" ";

                    trigger OnValidate()
                    begin
                        ShowShortcutDimCode(ShortcutDimCode);
                        NoOnAfterValidate();
                        UpdateTypeText();
                        DeltaUpdateTotals();
                    end;
                }
                field(Description; "Full Description")
                {
                    ApplicationArea = All;
                    Caption = 'Description/Comment';
                    ShowMandatory = Type <> Type::" ";

                    trigger OnValidate()
                    begin
                        UpdateEditableOnRow();

                        if "No." = xRec."No." then
                            exit;

                        ShowShortcutDimCode(ShortcutDimCode);
                        NoOnAfterValidate();

                        UpdateTypeText();
                        DeltaUpdateTotals();
                    end;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                    Editable = NOT IsBlankNumber;
                    Enabled = NOT IsBlankNumber;
                    ShowMandatory = (NOT IsCommentLine) AND ("No." <> '');

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        IF gcERPC.LookUpLocationCode("Location Code") THEN BEGIN
                            VALIDATE("Location Code");
                            DeltaUpdateTotals();
                        END;
                    end;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Editable = NOT IsBlankNumber;
                    Enabled = NOT IsBlankNumber;
                    ShowMandatory = (NOT IsCommentLine) AND ("No." <> '');

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = All;
                    Editable = UnitofMeasureCodeIsChangeable;
                    Enabled = UnitofMeasureCodeIsChangeable;
                    ShowMandatory = (NOT IsCommentLine) AND ("No." <> '');

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }
                field("Direct Unit Cost"; "Direct Unit Cost")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Editable = NOT IsBlankNumber;
                    Enabled = NOT IsBlankNumber;
                    ShowMandatory = (NOT IsCommentLine) AND ("No." <> '');

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }
                field("Not VAT"; "Not VAT")
                {
                    ApplicationArea = All;
                    Editable = NOT IsBlankNumber;
                    Enabled = NOT IsBlankNumber;

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }
                field("Line Amount"; "Line Amount")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    // Editable = NOT IsBlankNumber;
                    Editable = false;
                    Enabled = NOT IsBlankNumber;

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ShowMandatory = (NOT IsCommentLine) AND ("No." <> '');
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ShowMandatory = (NOT IsCommentLine) AND ("No." <> '');
                }
            }  // repeater end

            group(LineTotals)
            {
                ShowCaption = false;
                fixed(DefiningFixedControl)
                {
                    group(AmountTotals)
                    {
                        Caption = 'Excluding VAT';
                        field(AmountExclVAT; TotalPurchaseLine."Amount")
                        {
                            ApplicationArea = Basic, Suite;
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            Caption = 'Amount';
                            Editable = false;
                        }
                        field(AmountExclVATLCY; TotalPurchaseLine."Amount (LCY)")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Amount (LCY)';
                            Editable = false;
                        }
                    }
                    group(VATTotals)
                    {
                        Caption = 'VAT';
                        field(VATAmount; TotalPurchaseLine."Amount Including VAT" - TotalPurchaseLine."Amount")
                        {
                            ApplicationArea = Basic, Suite;
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            //Caption = 'VAT Amount';
                            Editable = false;
                        }
                        field(VATAmountLCY; TotalPurchaseLine."Amount Including VAT (LCY)" - TotalPurchaseLine."Amount (LCY)")
                        {
                            ApplicationArea = Basic, Suite;
                            //Caption = 'VAT Amount (LCY)';
                            Editable = false;
                        }
                    }
                    group(AmtIncVATTotals)
                    {
                        Caption = 'Including VAT';
                        field(AmountIncVAT; TotalPurchaseLine."Amount Including VAT")
                        {
                            ApplicationArea = Basic, Suite;
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            //Caption = 'Amount Including VAT';
                            Editable = false;
                        }
                        field(AmountIncVATLCY; TotalPurchaseLine."Amount Including VAT (LCY)")
                        {
                            ApplicationArea = Basic, Suite;
                            //Caption = 'Amount Including VAT (LCY)';
                            Editable = false;
                        }
                    }
                }
            }



        }
    }

    trigger OnOpenPage()
    var
        ServerSetting: Codeunit "Server Setting";
    begin
        IsSaaSExcelAddinEnabled := ServerSetting.GetIsSaasExcelAddinEnabled();
        SuppressTotals := CurrentClientType() = ClientType::ODataV4;

        // see later
        //SetDimensionsVisibility();
        //SetItemReferenceVisibility();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        GetTotalPurchHeader();
        CalculateTotals();
        UpdateEditableOnRow();
        UpdateTypeText();
        //SetItemChargeFieldsStyle();
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        DocumentTotals.PurchaseDocTotalsNotUpToDate();
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        DocumentTotals.PurchaseCheckAndClearTotals(Rec, xRec, TotalPurchaseLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
        exit(Find(Which));
    end;

    trigger OnInit()
    begin
        PurchasesSetup.Get();
        Currency.InitRoundingPrecision();
        TempOptionLookupBuffer.FillBuffer(TempOptionLookupBuffer."Lookup Type"::Purchases);
        //IsFoundation := ApplicationAreaMgmtFacade.IsFoundationEnabled();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        UpdateTypeText();
        SetApprover();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        DocumentTotals.PurchaseCheckIfDocumentChanged(Rec, xRec);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        grInventorySetup: Record "Inventory Setup";
    begin
        InitType();
        SetDefaultType();

        Clear(ShortcutDimCode);
        UpdateTypeText();

        "Forecast Entry" := 0;
        IF NOT PurchaseHeader.GET("Document Type", "Document No.") then
            PurchaseHeader.INIT;
        IF Type = Type::Item THEN BEGIN
            "Location Code" := PurchaseHeader."Location Code";
            IF NOT PurchaseHeader."Location Document" THEN BEGIN
                grInventorySetup.GET;
                grInventorySetup.TESTFIELD("Temp Item Code");
                VALIDATE("No.", grInventorySetup."Temp Item Code");
            END;
            SetApprover();
        END;
    end;

    var
        Currency: Record Currency;
        PurchasesSetup: Record "Purchases & Payables Setup";
        TotalPurchaseHeader: Record "Purchase Header";
        PurchaseHeader: Record "Purchase Header";
        grInventorySetup: Record "Inventory Setup";
        TempOptionLookupBuffer: Record "Option Lookup Buffer" temporary;
        TotalPurchaseLine: Record "Purchase Line";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        DocumentTotals: Codeunit "Document Totals";
        gcERPC: Codeunit "ERPC Funtions";
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
        IsCommentLine: Boolean;
        IsBlankNumber: Boolean;
        UnitofMeasureCodeIsChangeable: Boolean;
        TypeAsText: Text[30];
        CurrPageIsEditable: Boolean;
        IsSaaSExcelAddinEnabled: Boolean;
        SuppressTotals: Boolean;
        ShortcutDimCode: array[8] of Code[20];
        VATAmount: Decimal;
        InvoiceDiscountAmount: Decimal;
        InvoiceDiscountPct: Decimal;


    procedure NoOnAfterValidate()
    begin
        UpdateEditableOnRow();
        InsertExtendedText(false);
        if (Type = Type::"Charge (Item)") and ("No." <> xRec."No.") and
           (xRec."No." <> '')
        then
            CurrPage.SaveRecord();
    end;

    procedure UpdateEditableOnRow()
    begin
        IsCommentLine := Type = Type::" ";
        IsBlankNumber := IsCommentLine;
        UnitofMeasureCodeIsChangeable := Type <> Type::" ";
        CurrPageIsEditable := CurrPage.Editable;
    end;

    procedure InsertExtendedText(Unconditionally: Boolean)
    begin
        if TransferExtendedText.PurchCheckIfAnyExtText(Rec, Unconditionally) then begin
            CurrPage.SaveRecord();
            TransferExtendedText.InsertPurchExtText(Rec);
        end;
        if TransferExtendedText.MakeUpdate then
            CurrPage.Update(TRUE);
    end;

    procedure UpdateTypeText()
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Rec);
        TypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.Field(FieldNo(Type)));
    end;

    procedure DeltaUpdateTotals()
    begin
        if SuppressTotals then
            exit;
        DocumentTotals.PurchaseDeltaUpdateTotals(Rec, xRec, TotalPurchaseLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
        //CheckSendLineInvoiceDiscountResetNotification();
    end;

    local procedure GetTotalPurchHeader()
    begin
        DocumentTotals.GetTotalPurchaseHeaderAndCurrency(Rec, TotalPurchaseHeader, Currency);
    end;

    local procedure CalculateTotals()
    begin
        if SuppressTotals then
            exit;

        DocumentTotals.PurchaseCheckIfDocumentChanged(Rec, xRec);
        DocumentTotals.CalculatePurchaseSubPageTotals(
          TotalPurchaseHeader, TotalPurchaseLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
        DocumentTotals.RefreshPurchaseLine(Rec);
    end;

    local procedure SetDefaultType()
    begin
        if ApplicationAreaMgmtFacade.IsFoundationEnabled() then
            if xRec."Document No." = '' then
                Type := Type::Item;
    end;

    local procedure SetApprover()
    var
        DimSetEntry: Record "Dimension Set Entry";
        DimValue: Record "Dimension Value";
        UserSetup: Record "User Setup";
    begin
        IF ("Dimension Set ID" = 0) or (Approver <> '') then
            EXIT;
        IF "Dimension Set ID" <> 0 THEN begin
            PurchasesSetup.GET;
            PurchasesSetup.TestField("Cost Place Dimension");
            IF DimSetEntry.GET("Dimension Set ID", PurchasesSetup."Cost Place Dimension") THEN
                IF DimValue.GET(DimSetEntry."Dimension Code", DimSetEntry."Dimension Value Code") then
                    IF DimValue."Cost Holder" <> '' THEN BEGIN
                        UserSetup.GET(DimValue."Cost Holder");
                        IF UserSetup.Absents AND (UserSetup.Substitute <> '') THEN
                            Approver := UserSetup.Substitute
                        ELSE
                            Approver := UserSetup."User ID";
                    END;
        END;
    end;

}