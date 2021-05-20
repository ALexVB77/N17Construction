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
                    Editable = AllApproverEditable;
                }
                field("Pre-Approver"; Rec."Pre-Approver")
                {
                    ApplicationArea = All;
                    Editable = Rec.PreApprover AND AllApproverEditable;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        PreApproveOnLookup();
                    end;
                }
                field("Approver"; Rec."Approver")
                {
                    ApplicationArea = All;
                    Editable = AllApproverEditable;

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
                    Editable = ReceiveAccountEditable;
                }
            }
            part(PurchaseOrderActLines; "Purchase Order Act Subform")
            {
                ApplicationArea = All;
                Editable = "Buy-from Vendor No." <> '';
                Enabled = "Buy-from Vendor No." <> '';
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
            group("Payment Request")
            {
                Caption = 'Payment Request';
                field("Vendor Bank Account"; Rec."Vendor Bank Account")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    var
                        VendorBankAccount: Record "Vendor Bank Account";
                    begin
                        VendorBankAccount.SETRANGE("Vendor No.", Rec."Pay-to Vendor No.");
                        IF Page.RUNMODAL(0, VendorBankAccount) = ACTION::LookupOK THEN BEGIN
                            Rec."Vendor Bank Account" := VendorBankAccount.BIC;
                            Rec."Vendor Bank Account No." := VendorBankAccount."Bank Account No.";
                        END;
                    end;
                }
                field("Vendor Bank Account Name"; GetVendorBankAccountName)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Vendor Bank Account Name';
                }
                field("Vendor Bank Account No."; rec."Vendor Bank Account No.")
                {
                    ApplicationArea = All;
                }
                field("Payment Details"; rec."Payment Details")
                {
                    ApplicationArea = All;
                }
                field("OKATO Code"; rec."OKATO Code")
                {
                    ApplicationArea = All;
                }
                field("KBK Code"; rec."KBK Code")
                {
                    ApplicationArea = All;
                }
            }
            group("Details")
            {
                Caption = 'Details';
                field("Buy-from Contact No."; "Buy-from Contact No.")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Vendor Name Dtld"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Address"; "Buy-from Address")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Post Code"; "Buy-from Post Code")
                {
                    ApplicationArea = All;
                }
                field("Buy-from City"; "Buy-from City")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Contact"; "Buy-from Contact")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if UserMgt.GetPurchasesFilter <> '' then begin
            FilterGroup(2);
            SetRange("Responsibility Center", UserMgt.GetPurchasesFilter);
            FilterGroup(0);
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Responsibility Center" := UserMgt.GetPurchasesFilter;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UserSetup.GET(UserId);

        ActTypeEditable := Rec."Problem Document" AND (Rec."Status App Act" = Rec."Status App Act"::Controller);
        EstimatorEnable := NOT ("Act Type" = "Act Type"::Act);

        case true of
            "Problem Document" and ("Problem Type" = "Problem Type"::" "):
                ProblemType := Rec."Problem Type Txt";
            "Problem Document" and ("Problem Type" <> "Problem Type"::" "):
                ProblemType := FORMAT(Rec."Problem Type");
            else
                ProblemType := '';
        end;
        AppButtonEnabled :=
            NOT ((UPPERCASE("Process User") <> UPPERCASE(USERID)) AND (UserSetup."Status App Act" <> Rec."Status App Act"));
        IF "Status App Act" = "Status App Act"::Approve THEN BEGIN
            ApprovalEntry.SETRANGE("Table ID", 38);
            ApprovalEntry.SETRANGE("Document Type", ApprovalEntry."Document Type"::Order);
            ApprovalEntry.SETRANGE("Document No.", "No.");
            ApprovalEntry.SETRANGE("Approver ID", USERID);
            IF ApprovalEntry.FINDSET THEN
                AppButtonEnabled := NOT ApprovalEntry.IsEmpty;
        END;

        AllApproverEditable := "Status App" = "Status App"::Checker;

        IF ("Status App Act" = "Status App Act"::Accountant) THEN
            CurrPage.EDITABLE := FALSE
        ELSE
            IF ("Status App Act" = "Status App Act"::Estimator) THEN
                CurrPage.EDITABLE := FALSE
            ELSE
                CurrPage.EDITABLE := TRUE;
        IF "Problem Type" = "Problem Type"::"Act error" THEN
            CurrPage.EDITABLE := FALSE;
        IF UserSetup."Status App Act" = UserSetup."Status App Act"::"сontroller" THEN BEGIN
            CurrPage.EDITABLE := TRUE;
            ReceiveAccountEditable := TRUE;
        END;
        IF "Location Document" THEN
            CurrPage.EDITABLE := NOT ("Status App Act" IN ["Status App Act"::Approve, "Status App Act"::Signing, "Status App Act"::Accountant]);

        // check later
        ///CurrForm.PurchLines.FORM.SetEditableForEstimator(); //SWC875 KAE 010816   
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord;
        exit(ConfirmDeletion);
    end;

    var
        UserSetup: Record "User Setup";
        ApprovalEntry: Record "Approval Entry";
        gcERPC: Codeunit "ERPC Funtions";
        UserMgt: Codeunit "User Setup Management";
        ActTypeEditable: Boolean;
        EstimatorEnable: Boolean;
        ProblemType: text;
        AppButtonEnabled: Boolean;
        AllApproverEditable: Boolean;
        ReceiveAccountEditable: Boolean;

    local procedure GetVendorBankAccountName(): text
    var
        VendorBankAccount: Record "Vendor Bank Account";
    begin
        if Rec."Vendor Bank Account No." <> '' then
            if VendorBankAccount.get("Vendor Bank Account No.") then
                exit(VendorBankAccount.Name + VendorBankAccount."Name 2");
    end;

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

    end;
}