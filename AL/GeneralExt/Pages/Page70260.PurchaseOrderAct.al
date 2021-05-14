page 70260 "Purchase Order Act"
{
    Caption = 'Purchase Order Act';
    PageType = Document;
    // PromotedActionCategories = 'New,Process,Report,Approve,Invoice,Posting,View,Request Approval,Incoming Document,Release,Navigate';
    RefreshOnActivate = true;
    SourceTable = "Purchase Header";
    SourceTableView = WHERE("Document Type" = FILTER(Order));
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Importance = Standard;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ShowMandatory = true;
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Exists Attachment"; Rec."Exists Attachment")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Invoice Amount Incl. VAT"; Rec."Invoice Amount Incl. VAT")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Invoice VAT Amount"; Rec."Invoice VAT Amount")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Invoice Amount"; Rec."Invoice Amount Incl. VAT" - Rec."Invoice VAT Amount")
                {
                    Caption = 'Invoice Amount';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Remaining Amount"; Rec."Invoice Amount Incl. VAT" - Rec."Payments Amount")
                {
                    Caption = 'Remaining Amount';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Problem Document"; Rec."Problem Document")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Act Type"; Rec."Act Type")
                {
                    ApplicationArea = All;
                    Editable = ActTypeEditable;

                    trigger OnValidate()
                    begin
                        IF xRec."Act Type" IN ["Act Type"::Act, "Act Type"::"Act (Production)"] THEN
                            IF NOT ("Act Type" IN ["Act Type"::Act, "Act Type"::"Act (Production)"]) THEN
                                FIELDERROR("Act Type");
                        IF xRec."Act Type" IN ["Act Type"::"KC-2", "Act Type"::"KC-2 (Production)"] THEN
                            IF NOT ("Act Type" IN ["Act Type"::"KC-2", "Act Type"::"KC-2 (Production)"]) THEN
                                FIELDERROR("Act Type");

                        EstimatorEnable := NOT ("Act Type" = "Act Type"::Act);
                    end;
                }
                field("Problem Type"; ProblemType)
                {
                    Caption = 'Problem Type';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        // NC AB: see later
                        // SaveInvoiceDiscountAmount;
                    end;
                }
                group("Warehouse Document")
                {
                    Caption = 'Warehouse Document';
                    field("Location Code"; Rec."Location Code")
                    {
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            LocationCode: code[10];
                        begin
                            IF gcERPC.LookUpLocationCode(LocationCode) THEN
                                VALIDATE("Location Code", LocationCode);
                        end;
                    }
                    field(Storekeeper; Rec.Storekeeper)
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("Location Document"; Rec."Location Document")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                }

                field("Estimator"; Rec."Estimator")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Enabled = EstimatorEnable;
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    ApplicationArea = All;
                    Caption = 'Checker';
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        // PurchaserCodeOnAfterValidate;
                        // = CurrPage.PurchLines.PAGE.UpdateForm(true);
                        // NA AB: check later
                    end;
                }
                field("PreApprover"; Rec."PreApprover")
                {
                    ApplicationArea = All;
                }
                field("Pre-Approver"; Rec."Pre-Approver")
                {
                    ApplicationArea = All;
                    Editable = Rec.PreApprover;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        PreApproveOnLookup();
                    end;
                }
                field("Approver"; Rec."Approver")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        ApproveOnLookup();
                    end;
                }

                field("Agreement No."; Rec."Agreement No.")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Vendor Invoice No."; Rec."Vendor Invoice No.")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                group("Payment Date")
                {
                    Caption = 'Payment Date';
                    field("Paid Date Plan"; Rec."Due Date")
                    {
                        ApplicationArea = All;
                        Caption = 'Plan';
                    }
                    field("Paid Date Fact"; Rec."Paid Date Fact")
                    {
                        ApplicationArea = All;
                        Caption = 'Fact';
                        Editable = false;
                    }
                }
                field("Status App Act"; Rec."Status App Act")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Date Status App"; Rec."Date Status App")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Process User"; Rec."Process User")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Receive Account"; Rec."Receive Account")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

            }
        }

    trigger OnAfterGetCurrRecord()
    begin
        ActTypeEditable := Rec."Problem Document" AND (Rec."Status App Act" = Rec."Status App Act"::Controller);
        EstimatorEnable := NOT ("Act Type" = "Act Type"::Act);

        case true of
            "Problem Document" and ("Problem Type" = "Problem Type"::" "):
                ProblemType := Rec."Problem Type Txt";
            "Problem Document" and ("Problem Type" <> "Problem Type"::" "):
                ProblemType := FORMAT(Rec."Problem Type");
            else
                ProblemType := '';
        end
    end;

    var
        gcERPC: Codeunit "ERPC Funtions";
        ActTypeEditable: Boolean;
        EstimatorEnable: Boolean;
        ProblemType: text;

    procedure PreApproveOnLookup()
    begin

        Message('Вызов PreApproveOnLookup');

        /*
        AT.RESET;
        AT.SETRANGE("Document Type",AT."Document Type"::Order);
        AT.SETRANGE("Table ID",DATABASE::"Purchase Header");
        AT.SETRANGE(Enabled,TRUE);
        IF AT.FINDFIRST THEN
        BEGIN
        AddApp.RESET;
        AddApp.SETCURRENTKEY("Approver ID","Shortcut Dimension 1 Code");
        AddApp.SETRANGE("Approval Code",AT."Approval Code");
        AddApp.SETRANGE("Approval Type",AT."Approval Type");
        AddApp.SETRANGE("Document Type",AT."Document Type");
        AddApp.SETRANGE("Limit Type",AT."Limit Type");
        IF AddApp.FIND('-') THEN
        REPEAT
        IF TempApp<>AddApp."Approver ID" THEN
        AddApp.MARK(TRUE);
        TempApp:=AddApp."Approver ID";
        UNTIL AddApp.NEXT=0;

        AddApp.MARKEDONLY(TRUE);
        AddApp.SETFILTER("Approver ID",'<>%1',USERID);
        IF AddApp.FINDFIRST THEN;

        IF FORM.RUNMODAL(70067,AddApp)=ACTION::LookupOK THEN
        BEGIN
        IF CurrForm.EDITABLE AND ("Status App"="Status App"::Checker) THEN
        BEGIN
        IF (Approver<>'') AND (Approver=AddApp."Approver ID") THEN ERROR(Text003);

        "Pre-Approver":=AddApp."Approver ID";
        CurrForm.UPDATECONTROLS;
        END;
        END;
        END;
        */

    end;

    procedure ApproveOnLookup()
    begin

        Message('Вызов ApproveOnLookup');

        /*
        AT.RESET;
        AT.SETRANGE("Document Type",AT."Document Type"::Order);
        AT.SETRANGE("Table ID",DATABASE::"Purchase Header");
        AT.SETRANGE(Enabled,TRUE);
        IF AT.FINDFIRST THEN
        BEGIN

        TempApp:='';
        AddApp.RESET;
        AddApp.SETCURRENTKEY("Approver ID","Shortcut Dimension 1 Code");
        AddApp.SETRANGE("Approval Code",AT."Approval Code");
        AddApp.SETRANGE("Approval Type",AT."Approval Type");
        AddApp.SETRANGE("Document Type",AT."Document Type");
        AddApp.SETRANGE("Limit Type",AT."Limit Type");
        IF AddApp.FIND('-') THEN
        REPEAT
        IF TempApp<>AddApp."Approver ID" THEN
        AddApp.MARK(TRUE);
        TempApp:=AddApp."Approver ID";
        UNTIL AddApp.NEXT=0;


        AddApp.MARKEDONLY(TRUE);

        AddApp.SETFILTER("Approver ID",'<>%1',USERID);
        IF AddApp.FINDFIRST THEN;

        IF FORM.RUNMODAL(70067,AddApp)=ACTION::LookupOK THEN
        BEGIN
        IF CurrForm.EDITABLE AND ("Status App"="Status App"::Checker) THEN
        BEGIN
        IF ("Pre-Approver"<>'') AND ("Pre-Approver"=AddApp."Approver ID") THEN ERROR(Text003);
        IF CheckLinesCostPlace(AddApp."Shortcut Dimension 1 Code") THEN
            Approver:=AddApp."Approver ID";

        CurrForm.UPDATECONTROLS;
        END;
        END;
        END;
        */

    }
}