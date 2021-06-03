page 70177 "Payment Invoices Detailed"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Payment Invoices Detailed';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    RefreshOnActivate = true;
    SourceTable = "Purchase Line";
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            group(Filters)
            {
                ShowCaption = false;
                field(cFilter1; Filter4)
                {
                    ApplicationArea = All;
                    Caption = 'Scope';
                    OptionCaption = 'My documents (Approver),My documents  (Checker),All documents';
                    trigger OnValidate()
                    var
                        LocText001: Label 'You cannot use "All documents" value if %1 %2 = %3 and %4 = %5.';
                    begin
                        grUserSetup.GET(USERID);
                        if Filter4 = Filter4::All then
                            if not ((grUserSetup."Status App" = grUserSetup."Status App"::Controller) or grUserSetup."Administrator IW") then
                                Error(LocText001,
                                    grUserSetup.TableCaption, grUserSetup.FieldCaption("Status App"), grUserSetup."Status App",
                                    grUserSetup.FieldCaption("Administrator IW"), grUserSetup."Administrator IW");
                        SetRecFilters;
                        CurrPage.UPDATE(FALSE);
                    end;
                }
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

            }
            repeater(Repeater12370003)
            {
                Editable = false;
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Vendor Name"; "Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Vendor Invoice No."; "Vendor Invoice No.")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = All;
                }
                field("Line No."; "Line No.")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount Including VAT"; "Amount Including VAT")
                {
                    ApplicationArea = All;
                }
                field("Agreement No."; "Agreement No.")
                {
                    ApplicationArea = All;
                }
                field("External Agreement No."; "External Agreement No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Status App"; "Status App")
                {
                    ApplicationArea = All;
                }
                field("Process User"; "Process User")
                {
                    ApplicationArea = All;
                }
                field(Comments; Comments)
                {
                    ApplicationArea = All;
                    Caption = 'Contains a comment';
                }
                field(Attachments; Attachments)
                {
                    ApplicationArea = All;
                    Caption = 'Contains a attachment';
                }
                field(Paid; Paid)
                {
                    ApplicationArea = All;
                }
                field("Paid Date Fact"; "Paid Date Fact")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; "Due Date")
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
            action(DocCard)
            {
                ApplicationArea = All;
                Caption = 'Edit';
                Image = Edit;
                RunObject = Page "Purchase Order App";
                RunPageLink = "No." = field("Document No.");
            }
        }
    }

    trigger OnOpenPage()
    begin
        Filter3 := Filter3::All;
        grUserSetup.GET(USERID);
        SetRecFilters;
    end;

    var
        grUserSetup: Record "User Setup";
        Filter3: Option Ready,Paid,Payment,Overdue,All;
        Filter4: Option MyDocA,MyDocC,All;
        Comments: Boolean;
        Attachments: Boolean;

    local procedure SetRecFilters()
    begin
        FILTERGROUP(2);

        SETRANGE("Status App");
        SETRANGE(Paid);
        SETRANGE("Due Date");
        SETRANGE("Process User");
        SETRANGE("Purchaser Code");
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

        grUserSetup.TESTFIELD("Salespers./Purch. Code");
        CASE Filter4 OF
            Filter4::MyDocC:
                SETRANGE("Purchaser Code", grUserSetup."Salespers./Purch. Code");
            Filter4::MyDocA:
                SETRANGE("Process User", USERID);
        END;

        FILTERGROUP(0);
    end;
}