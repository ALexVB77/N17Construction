page 70004 "Documents Approval"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Payment Invoices (Approval)';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    RefreshOnActivate = true;
    SourceTable = "Gen. Journal Line";
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            group(Filters)
            {
                ShowCaption = false;
                field(ShowCancel; ShowCancel)
                {
                    ApplicationArea = All;
                    Caption = 'Show Rejected';
                    trigger OnValidate()
                    begin
                        FILTERGROUP(2);
                        IF ShowCancel THEN
                            SETRANGE("Status App")
                        ELSE
                            SETFILTER("Status App", '<>%1', "Status App"::Cancelled);
                        FILTERGROUP(0);
                        SetRecFilters;
                        CurrPage.UPDATE;
                    end;
                }
                field(cFilter1; Filter1)
                {
                    ApplicationArea = All;
                    Caption = 'Scope';
                    OptionCaption = 'My documents,Pre-Approver,All documents';
                    trigger OnValidate()
                    var
                        LocText001: Label 'You cannot use "All documents" value if %1 %2 = %3.';
                    begin
                        grUserSetup.GET(USERID);
                        if (grUserSetup."Status App" = grUserSetup."Status App"::Checker) and (Filter1 = Filter1::All) then
                            Error(LocText001, grUserSetup.TableCaption, grUserSetup.FieldCaption("Status App"), grUserSetup."Status App");
                        SetRecFilters;
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                field(Selection; Filter2)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Selection';
                    OptionCaption = 'All documents,Documents in processing,Ready-to-pay documents,Paid documents,Problem documents';
                    trigger OnValidate()
                    begin
                        SetRecFilters;
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                field("Sorting"; SortType)
                {
                    ApplicationArea = All;
                    Caption = 'Sorting';
                    OptionCaption = 'Document No.,Postng Date,Buy-from Vendor Name,Status App,Process User';
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
                field("Problem Document"; Rec."Problem Document")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        page.Runmodal(Page::"Payment Request Card", Rec);
                        CurrPage.Update(false);
                    end;
                }
                field("Vendor Invoice No."; PaymentInvoiceHeader."Vendor Invoice No.")
                {
                    Caption = 'Vendor Invoice No.';
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Order Date"; PaymentInvoiceHeader."Order Date")
                {
                    Caption = 'Order Date';
                    ApplicationArea = All;
                }
                field("Paid Date Fact"; PaymentInvoiceHeader."Paid Date Fact")
                {
                    Caption = 'Paid Date Fact';
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Status App"; Rec."Status App")
                {
                    ApplicationArea = All;
                }
                field("Date Status App"; Rec."Date Status App")
                {
                    ApplicationArea = All;
                }
                field("Process User"; Rec."Process User")
                {
                    ApplicationArea = All;
                }
                field("Agreement No."; Rec."Agreement No.")
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
                field("Exists Comment"; Rec."Comment")
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
                RunObject = Page "Payment Request Card";
                RunPageLink = "Journal Template Name" = FIELD("Journal Template Name"),
                                "Journal Batch Name" = FIELD("Journal Batch Name"),
                                "Line No." = FIELD("Line No.");
            }
            action(DocCard)
            {
                ApplicationArea = All;
                Caption = 'Edit';
                Image = Edit;
                RunObject = Page "Purchase Order App";
                RunPageLink = "No." = FIELD("Document No.");
            }
        }
        area(Navigation)
        {
            action(VendorCard)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Vendor';
                Enabled = VendorCardEnabled;
                Image = EditLines;
                RunObject = Codeunit "Gen. Jnl.-Show Card";
                ShortCutKey = 'Shift+F7';
            }
            action(Dimensions)
            {
                AccessByPermission = TableData Dimension = R;
                ApplicationArea = Dimensions;
                Caption = 'Dimensions';
                Image = Dimensions;
                ShortCutKey = 'Alt+D';

                trigger OnAction()
                begin
                    ShowDimensions();
                    CurrPage.SaveRecord;
                end;
            }
            action("Co&mments")
            {
                ApplicationArea = All;
                Caption = 'Co&mments';
                Image = ViewComments;
                RunObject = Page "Purch. Comment Sheet";
                RunPageLink = "Document Type" = const(Order),
                                "No." = FIELD("Document No."),
                                "Document Line No." = CONST(0);
            }
            action(DocAttach)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;

                trigger OnAction()
                var
                    PurchHeader: Record "Purchase Header";
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    PurchHeader.Get(PurchHeader."Document Type"::Order, "Document No.");
                    RecRef.GetTable(PurchHeader);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RunModal;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        PurchSetup.Get();
        PurchSetup.TestField("Payment Calendar Tmpl");
        PurchSetup.TestField("Payment Calendar Batch");

        FILTERGROUP(2);
        SETRANGE("Journal Template Name", PurchSetup."Payment Calendar Tmpl");
        SETRANGE("Journal Batch Name", PurchSetup."Payment Calendar Batch");
        SETFILTER("Status App", '<>%1', "Status App"::Cancelled);
        FILTERGROUP(0);

        Filter2 := Filter2::InProc;

        SetSortType;
        SetRecFilters;

        grUserSetup.GET(USERID);
    end;

    trigger OnAfterGetRecord()
    begin
        if not PaymentInvoiceHeader.Get(PaymentInvoiceHeader."Document Type"::Order, "Document No.") then
            PaymentInvoiceHeader.Init();
        VendorCardEnabled := (Rec."Account Type" = Rec."Account Type"::Vendor) AND (Rec."Account No." <> '')
    end;

    var
        PaymentInvoiceHeader: Record "Purchase Header";
        PurchSetup: Record "Purchases & Payables Setup";
        HasPmtFileErr: Boolean;
        grUserSetup: Record "User Setup";
        PaymentOrderMgt: Codeunit "Payment Order Management";
        Filter1: option MyDoc,Pre,All;
        Filter2: option All,InProc,Ready,Pay,Problem;
        SortType: option DocNo,PostDate,Vendor,StatusApp,UserProc;
        ShowCancel: Boolean;
        VendorCardEnabled: Boolean;


    local procedure SetRecFilters()
    var
        AE: record "Approval Entry";
        PH: record "Purchase Header";
    begin
        FILTERGROUP(2);

        SETRANGE("Pre-Approver");
        SETRANGE("Process User");
        SETRANGE("Status App");
        IF NOT ShowCancel THEN
            SETFILTER("Status App", '<>%1', "Status App"::Cancelled);
        SETRANGE("Problem Document");
        SETRANGE(Paid);

        CASE Filter2 OF
            Filter2::InProc:
                IF NOT ShowCancel THEN
                    SETFILTER("Status App", '<>%1&<>%2', "Status App"::Payment, "Status App"::Cancelled)
                ELSE
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
            Filter1::Pre:
                SETRANGE("Pre-Approver", USERID);
        END;

        FILTERGROUP(0);
    end;

    procedure SetSortType()
    begin
        CASE SortType OF
            SortType::DocNo:
                SETCURRENTKEY("Document No.");
            SortType::PostDate:
                SETCURRENTKEY("Posting Date");
            SortType::Vendor:
                SETCURRENTKEY(Description);
            SortType::StatusApp:
                SETCURRENTKEY("Status App");
            SortType::UserProc:
                SETCURRENTKEY("Process User");
        END;
    end;
}
