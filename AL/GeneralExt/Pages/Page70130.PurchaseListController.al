/*
page 70130 "Purchase List Controller"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Payment Register';
    DataCaptionFields = "Document Type";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    RefreshOnActivate = true;
    SourceTable = "Purchase Header";
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            group(Filters)
            {
                ShowCaption = false;
                field(Selection; Filter3)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Selection';
                    OptionCaption = 'Ready to pay,Paid,Payment,Overdue,All';
                    trigger OnValidate()
                    begin
                        SetRecFilters;
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                field("Sorting"; SortType1)
                {
                    ApplicationArea = All;
                    Caption = 'Sorting';
                    OptionCaption = 'Payment date,Payment date (Fact),Document No.,Vendor Name';
                    trigger OnValidate()
                    begin
                        SetSortType;
                        CurrPage.UPDATE(FALSE);
                    end;
                }
            }

            repeater(Repeater12370003)
            {
                Editable = false;
                field("Paid Date Fact"; Rec."Paid Date Fact")
                {
                    ApplicationArea = All;
                }
                field(Paid; Paid)
                {
                    ApplicationArea = All;
                }
                field("Payment Type"; "Payment Type")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Agreement No."; Rec."Agreement No.")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Vendor Invoice No."; Rec."Vendor Invoice No.")
                {
                    ApplicationArea = All;
                }
                field("Problem Document"; Rec."Problem Document")
                {
                    ApplicationArea = All;
                }
                field("Problem Type"; "Problem Type")
                {
                    ApplicationArea = All;
                }
                field("Invoice Amount Incl. VAT (LCY)"; Rec.GetInvoiceAmountsLCY(AmountType::"Include VAT"))
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Invoice Amount Incl. VAT (LCY)';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Status App"; Rec."Status App")
                {
                    ApplicationArea = All;
                    Caption = 'Approval Status';
                }
                field("Date Status App"; Rec."Date Status App")
                {
                    ApplicationArea = All;
                }
                field("Process User"; Rec."Process User")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        page.Runmodal(Page::"Purchase Order App", Rec);
                        CurrPage.Update(false);
                    end;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                }
                field(Controller; Controller)
                {
                    ApplicationArea = All;
                }
                field("Invoice Amount"; Rec."Invoice Amount Incl. VAT" - Rec."Invoice VAT Amount")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Invoice Amount';
                }
                field("Invoice Amount Incl. VAT"; "Invoice Amount Incl. VAT")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                }
                field("Invoice Amount (LCY)"; GetInvoiceAmountsLCY(AmountType::"Exclude VAT"))
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Invoice Amount (LCY)';
                }
                field("Exists Comment"; Rec."Comment")
                {
                    ApplicationArea = All;
                }
                field("Exists Attachment"; Rec."Exists Attachment")
                {
                    ApplicationArea = All;
                }
                field("Journal Batch Name", '')
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Invoice Amount';
                }














            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(NewOrderApp)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'New';
                Image = NewDocument;

                trigger OnAction()
                begin
                    PaymentOrderMgt.NewOrderApp(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(DocCard)
            {
                ApplicationArea = All;
                Caption = 'Edit';
                Enabled = EditEnabled;
                Image = Edit;
                RunObject = Page "Purchase Order App";
                                RunPageLink = "No." = field("No.");
            }
            action(ApproveButton)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Approve';
                Enabled = ApproveButtonEnabled;
                Image = Approve;

                trigger OnAction()
                begin
                    MessageIfPurchLinesNotExist;
                    if "Status App" in ["Status App"::" ", "Status App"::Payment] then
                        FieldError("Status App");
                    if "Status App" = "Status App"::Reception then begin
                        IF ApprovalsMgmt.CheckPurchaseApprovalPossible(Rec) THEN
                            ApprovalsMgmt.OnSendPurchaseDocForApproval(Rec);
                    end else
                        ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID);
                end;
            }
            action(RejectButton)
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Enabled = RejectButtonEnabled;
                Image = Reject;
                trigger OnAction()
                begin
                    if "Status App" in ["Status App"::" ", "Status App"::Reception, "Status App"::Payment] then
                        FieldError("Status App");
                    ApprovalsMgmtExt.RejectPurchActAndPayInvApprovalRequest(RECORDID);
                end;
            }
        }
        area(Navigation)
        {
            action("Co&mments")
            {
                ApplicationArea = All;
                Caption = 'Co&mments';
                Image = ViewComments;
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
        }
    }

    trigger OnOpenPage()
    begin
        grUserSetup.GET(USERID);

        // SWC968 DD 19.12.16 >>
        IF grUserSetup."Show All Pay Inv" AND (Filter1 = Filter1::mydoc) THEN
            Filter1 := Filter1::all;
        // SWC968 DD 19.12.16 <<

        FILTERGROUP(2);
        SETRANGE("IW Documents", TRUE);
        //SWC004 AKA 120514 >>
        SETFILTER("Act Type", '%1', "Act Type"::" ");
        //SWC004 AKA 120514 <<
        FILTERGROUP(0);

        SetSortType;
        SetRecFilters;

        //IF grUserSetup."Status App"<>grUserSetup."Status App"::Сontroller THEN //SWC318 AKA 151014
        IF grUserSetup."Status App" = grUserSetup."Status App"::Checker THEN      //SWC318 AKA 151014
            Filter1Enabled := FALSE;

        IF grUserSetup."Administrator IW" THEN
            Filter1Enabled := TRUE;
    end;

    trigger OnAfterGetRecord()
    begin
        ApproveButtonEnabled := FALSE;
        RejectButtonEnabled := FALSE;

        EditEnabled := Rec."No." <> '';

        if (UserId = Rec.Receptionist) and (Rec."Status App" = Rec."Status App"::Reception) then
            ApproveButtonEnabled := true;
        if ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId) then begin
            ApproveButtonEnabled := true;
            RejectButtonEnabled := true;
        end;
    end;

    var
        grUserSetup: Record "User Setup";
        PaymentOrderMgt: Codeunit "Payment Order Management";
        ApprovalsMgmtExt: Codeunit "Approvals Mgmt. (Ext)";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        Filter3: option Ready,Paid,Payment,Overdue,All;
        SortType1: option PayDate,PayDateFact,DocNo,Vendor;
        ApproveButtonEnabled: boolean;
        RejectButtonEnabled: boolean;
        EditEnabled: Boolean;
        AmountType: Enum "Amount Type";


    local procedure SetRecFilters()
    var
        AE: record "Approval Entry";
        PH: record "Purchase Header";
    begin
        FILTERGROUP(2);

        SETRANGE("Process User");
        SETRANGE("Status App");
        SETRANGE("Problem Document");
        SETRANGE(Paid);
        // SWC1075 DD 28.07.17 >>
        MARKEDONLY(FALSE);
        CLEARMARKS;
        // SWC1075 DD 28.07.17 <<

        SETFILTER("Status App", '<>%1&<>%2', "Status App"::Payment, "Status App"::Request);

        CASE Filter2 OF
            Filter2::InProc:
                SETFILTER("Status App", '<>%1', "Status App"::Payment);
            Filter2::Ready:
                BEGIN
                    SETRANGE("Status App", "Status App"::Payment);
                    SETRANGE(Paid, FALSE);
                END;
            Filter2::Pay:
                SETRANGE(Paid, TRUE);
            Filter2::Problem:
                SETRANGE("Problem Document", TRUE);
        END;

        CASE Filter1 OF
            Filter1::MyDoc:
                SETRANGE("Process User", USERID);
            // SWC1075 DD 28.07.17 >>
            Filter1::Approved:
                BEGIN
                    PH := Rec;
                    AE.SETCURRENTKEY("Approver ID", Status);
                    AE.SETRANGE("Approver ID", USERID);
                    AE.SETRANGE(Status, AE.Status::Approved);
                    IF AE.FINDSET THEN
                        REPEAT
                            IF GET(AE."Document Type", AE."Document No.") THEN
                                MARK(TRUE);
                        UNTIL AE.NEXT = 0;
                    Rec := PH;
                    MARKEDONLY(TRUE);
                END;
        // SWC1075 DD 28.07.17 <<
        END;

        FILTERGROUP(0);
    end;

    procedure SetSortType()
    begin
        //--
        CASE SortType OF
            SortType::DocNo:
                // SWC1075 DD 28.07.17 >>
                //SETCURRENTKEY("No.");
                SETCURRENTKEY("Document Type", "No.");
            // SWC1075 DD 28.07.17 <<
            SortType::PostDate:
                SETCURRENTKEY("Posting Date");
            SortType::Vendor:
                SETCURRENTKEY("Buy-from Vendor Name");
            SortType::StatusApp:
                SETCURRENTKEY("Status App");
            SortType::UserProc:
                SETCURRENTKEY("Process User");
        END;
    end;

}
*/