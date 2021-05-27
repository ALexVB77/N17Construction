page 70000 "Purchase Order App"
{
    Caption = 'Purchase Order App';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Act,Request Approval,Print/Send,Navigate';
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
                field("Prices Including VAT"; "Prices Including VAT")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                group(DocAmounts)
                {
                    Caption = 'Amounts';
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
                }
                field("Problem Document"; Rec."Problem Document")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Problem Type"; ProblemType)
                {
                    Caption = 'Problem Type';
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = ProblemTypeEnabled;
                }

                field("Payment to Person"; Rec."Payment to Person")
                {
                    ApplicationArea = All;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Payment Assignment"; Rec."Payment Assignment")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Editable = PaymentTypeEditable;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
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
                field("IW Planned Repayment Date"; Rec."IW Planned Repayment Date")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Controller"; Rec.Controller)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    ApplicationArea = All;

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

                    trigger OnValidate()
                    var
                        VendAgreement: Record "Vendor Agreement";
                    begin
                        if "Agreement No." <> '' then
                            if VendAgreement.Get(Rec."Buy-from Vendor No.", Rec."Agreement No.") then
                                Rec."Purchaser Code" := VendAgreement."Purchaser Code";
                    end;
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
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        Clear(ChangeExchangeRate);
                        if "Posting Date" <> 0D then
                            ChangeExchangeRate.SetParameter("Currency Code", "Currency Factor", "Posting Date")
                        else
                            ChangeExchangeRate.SetParameter("Currency Code", "Currency Factor", WorkDate);
                        if ChangeExchangeRate.RunModal = ACTION::OK then begin
                            Validate("Currency Factor", ChangeExchangeRate.GetParameter);
                            // NC AB: see later
                            // SaveInvoiceDiscountAmount;
                        end;
                        Clear(ChangeExchangeRate);
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord;
                        PurchCalcDiscByType.ApplyDefaultInvoiceDiscount(0, Rec);
                    end;
                }
                field("Status App"; Rec."Status App")
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
            }

            part(PurchaseOrderAppLines; "Purchase Order Subform App")
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
                    ShowMandatory = true;

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

    actions
    {
        area(navigation)
        {
            group(Order)
            {
                Caption = 'O&rder';
                Image = "Order";
                action(Statistics)
                {
                    ApplicationArea = All;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        CalcInvDiscForHeader;
                        Commit();
                        PAGE.RunModal(PAGE::"Purchase Statistics", Rec);
                        // check later
                        //PurchCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    RunObject = Page "Purch. Comment Sheet";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No."),
                                  "Document Line No." = CONST(0);
                }
                action(DocAttach)
                {
                    ApplicationArea = All;
                    Caption = 'Attachments';
                    Image = Attach;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Details";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RunModal;
                    end;
                }
                action(ChangeLog)
                {
                    ApplicationArea = All;
                    Caption = 'Change Log';
                    Image = ChangeLog;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        lrChangeLE: Record "Change Log Entry";
                    begin
                        lrChangeLE.SETCURRENTKEY("Table No.", "Primary Key Field 2 Value", "Date and Time");
                        lrChangeLE.SETRANGE("Table No.", Database::"Purchase Header");
                        lrChangeLE.SETRANGE("Primary Key Field 2 Value", Rec."No.");
                        IF NOT lrChangeLE.IsEmpty THEN
                            Page.RUNMODAL(Page::"Change Log Entries", lrChangeLE);
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(CopyDocument)
                {
                    ApplicationArea = Suite;
                    Caption = 'Copy Document';
                    Ellipsis = true;
                    Enabled = "No." <> '';
                    Image = CopyDocument;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CopyDocument();
                        if Get("Document Type", "No.") then;
                    end;
                }

                action("Archive Document")
                {
                    ApplicationArea = Suite;
                    Caption = 'Archi&ve Document';
                    Enabled = "No." <> '';
                    Image = Archive;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        ArchiveManagement.ArchivePurchDocument(Rec);
                        CurrPage.Update(false);
                    end;
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
        UserSetup.GET(USERID);

        CurrPage.EDITABLE("Status App" < "Status App"::Approve);
        IF "Status App" = "Status App"::Request THEN
            CurrPage.EDITABLE(TRUE);

        case true of
            "Problem Document" and ("Problem Type" = "Problem Type"::" "):
                ProblemType := Rec."Problem Type Txt";
            "Problem Document" and ("Problem Type" <> "Problem Type"::" "):
                ProblemType := FORMAT(Rec."Problem Type");
            else
                ProblemType := '';
        end;

        ProblemTypeEnabled := "Problem Document";

        PaymentTypeEditable := "Status App" < "Status App"::Checker;
        AppButtonEnabled :=
            NOT ((UPPERCASE("Process User") <> UPPERCASE(USERID)) AND (UserSetup."Status App Act" <> Rec."Status App Act"));

        IF "Status App Act" = "Status App Act"::Approve THEN BEGIN
            ApprovalEntry.SETRANGE("Table ID", Database::"Purchase Header");
            ApprovalEntry.SETRANGE("Document Type", ApprovalEntry."Document Type"::Order);
            ApprovalEntry.SETRANGE("Document No.", "No.");
            ApprovalEntry.SETRANGE("Approver ID", USERID);
            IF ApprovalEntry.FINDSET THEN
                AppButtonEnabled := NOT ApprovalEntry.IsEmpty;
        END;
        IF "Status App" = "Status App"::Request THEN
            AppButtonEnabled := TRUE;

        AllApproverEditable := "Status App" = "Status App"::Checker;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord;
        UserSetup.GET;
        IF not ((UserSetup."Status App" = UserSetup."Status App"::Controller) OR UserSetup."Administrator IW") THEN
            ERROR(TextDelError, Rec."No.");
        IF NOT gcERPC.DeleteInvoice(Rec) then
            ERROR('');
        exit(ConfirmDeletion);
    end;

    var
        UserSetup: Record "User Setup";
        ApprovalEntry: Record "Approval Entry";
        ChangeExchangeRate: Page "Change Exchange Rate";
        PurchCalcDiscByType: Codeunit "Purch - Calc Disc. By Type";
        ArchiveManagement: Codeunit ArchiveManagement;
        gcERPC: Codeunit "ERPC Funtions";
        UserMgt: Codeunit "User Setup Management";
        AllApproverEditable: Boolean;
        TextDelError: Label 'You cannot delete Purchase Order Act %1';
        ProblemType: text;
        PaymentTypeEditable: Boolean;
        AppButtonEnabled: Boolean;
        ProblemTypeEnabled: Boolean;

    local procedure GetVendorBankAccountName(): text
    var
        VendorBankAccount: Record "Vendor Bank Account";
    begin
        if Rec."Vendor Bank Account No." <> '' then
            if VendorBankAccount.get("Vendor Bank Account No.") then
                exit(VendorBankAccount.Name + VendorBankAccount."Name 2");
    end;

    local procedure PreApproveOnLookup()
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

    local procedure ApproveOnLookup()
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

    // SWC1002 DD 13.02.17 >>
    AddApp.SETRANGE("Approver ID",Approver);
    IF AddApp.FINDFIRST THEN;
    // SWC1002 DD 13.02.17 <<
    AddApp.SETFILTER("Approver ID",'<>%1',USERID);
    // SWC1002 DD 13.02.17 >>
    //IF AddApp.FINDFIRST THEN;
    // SWC1002 DD 13.02.17 <<

    IF FORM.RUNMODAL(70067,AddApp)=ACTION::LookupOK THEN
    BEGIN
    IF CurrForm.EDITABLE AND ("Status App"="Status App"::Checker) THEN
    BEGIN
    IF ("Pre-Approver"<>'') AND ("Pre-Approver"=AddApp."Approver ID") THEN ERROR(Text003);
    // SWC1002 DD 13.02.17 >>
    //IF CheckLinesCostPlace(AddApp."Shortcut Dimension 1 Code") THEN
    IF CheckLinesApprover(AddApp."Approver ID") THEN
    // SWC1002 DD 13.02.17 <<
        Approver:=AddApp."Approver ID";

    CurrForm.UPDATECONTROLS;
    END;
    END;
    END;
    */

    end;
}
