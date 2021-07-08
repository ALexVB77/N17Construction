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
                field("Journal Batch Name"; LinkedGenJnlLine."Journal Batch Name")
                {
                    ApplicationArea = All;
                    Caption = 'Journal Batch Name';
                }
                field("Journal Line No."; LinkedGenJnlLine."Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'Journal Line No.';
                }
                field("Additional Info"; Rec.GetAddTypeCommentText(CommentAddType::"Additional Info"))
                {
                    ApplicationArea = All;
                    Caption = 'Comment';
                }
                field(Reason; Rec.GetAddTypeCommentText(CommentAddType::Reason))
                {
                    ApplicationArea = All;
                    Caption = 'Reason';
                }
                field("Spec. Bank Account No."; "Spec. Bank Account No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ViewDoc)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'View';
                Image = View;

                trigger OnAction()
                var
                    GenJnlLine: Record "Gen. Journal Line";
                    PaymentRequestCard: Page "Payment Request Card";
                begin
                    GenJnlLine.SetRange("Journal Template Name", LinkedGenJnlLine."Journal Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", LinkedGenJnlLine."Journal Batch Name");
                    GenJnlLine.SetRange("Line No.", LinkedGenJnlLine."Line No.");
                    PaymentRequestCard.SetTableView(GenJnlLine);
                    PaymentRequestCard.SetRecord(GenJnlLine);
                    PaymentRequestCard.RunModal();
                end;
            }
            action(ResetProblemDoc)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Reset Problem from Doc.';
                Image = ResetStatus;

                trigger OnAction()
                var
                    PurchHeader: Record "Purchase Header";
                begin
                    CurrPage.SetSelectionFilter(PurchHeader);
                    PayOrderMgt.PaymentRegisterResetProblemDocument(PurchHeader);
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

        SETFILTER("Status App", '%1', "Status App"::Payment);
        SETRANGE("IW Documents", TRUE);

        SetSortType;
        SetRecFilters;
    end;

    var
        grUserSetup: Record "User Setup";
        LinkedGenJnlLine: Record "Gen. Journal Line";
        PayOrderMgt: Codeunit "Payment Order Management";
        Filter3: option Ready,Paid,Payment,Overdue,All;
        SortType1: option PayDate,PayDateFact,DocNo,Vendor;
        AmountType: Enum "Amount Type";
        CommentAddType: Enum "Purchase Comment Add. Type";

    local procedure SetRecFilters()
    begin
        FILTERGROUP(2);

        SETRANGE("Process User");
        SETRANGE("Status App");
        SETRANGE("Problem Document");
        SETRANGE(Paid);
        SETRANGE("Status App");
        SETRANGE("Due Date");

        CASE Filter3 OF
            Filter3::Ready:
                BEGIN
                    SETRANGE(Paid, FALSE);
                    SETRANGE("Status App", "Status App"::Payment);
                END;
            Filter3::Paid:
                BEGIN
                    SETRANGE(Paid, TRUE);
                    SETRANGE("Status App", "Status App"::Payment);
                END;
            Filter3::Payment:
                SETRANGE("Status App", "Status App"::Payment);
            Filter3::Overdue:
                BEGIN
                    SETRANGE(Paid, FALSE);
                    SETFILTER("Due Date", '<%1', TODAY);
                END;
        END;

        // SETRANGE(Archival, FALSE);

        FILTERGROUP(0);
    end;

    procedure SetSortType()
    begin
        CASE SortType1 OF
            SortType1::PayDate:
                SETCURRENTKEY("Due Date");
            SortType1::PayDateFact:
                SETCURRENTKEY("Paid Date Fact");
            SortType1::DocNo:
                SETCURRENTKEY("No.");
            SortType1::Vendor:
                SETCURRENTKEY("Buy-from Vendor Name");
        END;
    end;
}
