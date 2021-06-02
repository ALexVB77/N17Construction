page 70002 "Purchase List App"
{
    ApplicationArea = Basic, Suite;
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = "Purchase Header";
    DataCaptionFields = "Document Type";
    PageType = Worksheet;
    Caption = 'Payment Invoices (Checking)';
    RefreshOnActivate = true;
    CardPageId = "Purchase Order App";
    layout
    {
        area(content)
        {
            group(Filters)
            {
                ShowCaption = false;
                field(cFilter1; Filter1)
                {
                    ApplicationArea = All;
                    Caption = 'Scope';
                    Enabled = Filter1Enabled;
                    OptionCaption = 'My documents,All documents,My Approved';
                    trigger OnValidate()
                    begin
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
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        page.Runmodal(Page::"Purchase Order App", Rec);
                        CurrPage.Update(false);
                    end;
                }
                field("Vendor Invoice No."; Rec."Vendor Invoice No.")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Post Code"; Rec."Buy-from Post Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Buy-from Country/Region Code"; Rec."Buy-from Country/Region Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Buy-from Contact"; Rec."Buy-from Contact")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Pay-to Vendor No."; Rec."Pay-to Vendor No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Pay-to Name"; Rec."Pay-to Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Pay-to Post Code"; Rec."Pay-to Post Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Pay-to Country/Region Code"; Rec."Pay-to Country/Region Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Pay-to Contact"; Rec."Pay-to Contact")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Ship-to Contact"; Rec."Ship-to Contact")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                }
                field("Paid Date Fact"; Rec."Paid Date Fact")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("Invoice Amount Incl. VAT"; Rec."Invoice Amount Incl. VAT")
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
                field("Exists Attachment"; Rec."Exists Attachment")
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
                Image = Edit;

                trigger OnAction()
                begin
                    page.Runmodal(Page::"Purchase Order App", Rec);
                    CurrPage.Update(false);
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


    var
        grUserSetup: Record "User Setup";
        PaymentOrderMgt: Codeunit "Payment Order Management";
        Filter1: option mydoc,all,approved;
        Filter1Enabled: Boolean;
        Filter2: option all,inproc,ready,pay,problem;
        SortType: option docno,postdate,vendor,statusapp,userproc;


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
