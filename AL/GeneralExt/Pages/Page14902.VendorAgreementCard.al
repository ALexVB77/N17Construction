pageextension 94902 "Vendor Agreement Card (Ext)" extends "Vendor Agreement Card"
{
    layout
    {
        addafter("Tax Authority No.")
        {
            field("Vat Agent Posting Group"; Rec."Vat Agent Posting Group")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("VAT Agent")
        {
            part(BreakdownByLetter; "Vendor Agreement Details")
            {
                Caption = 'Breakdown by Letter';
                ApplicationArea = Basic, Suite;
                SubPageLink = "Agreement No." = field("No."), "Vendor No." = field("Vendor No.");
                UpdatePropagation = Both;
            }
            part(PaymentSchedule; "Vendor Agreement Budget")
            {
                Caption = 'Payment Schedule';
                ApplicationArea = Basic, Suite;
                SubPageLink = "Agreement No." = FIELD("No."), "Contragent No." = FIELD("Vendor No.");
                SubPageView = sorting(Date);
                UpdatePropagation = Both;
            }
        }
        addafter(Priority)
        {
            field("Exist Comment"; Rec."Exists Comment")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Exist Attachment"; Rec."Exists Attachment")
            {
                ApplicationArea = Basic, Suite;
            }

        }
        addbefore(Control1905767507)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(14901),
                              "No." = FIELD("No."),
                              "PK Key 2" = FIELD("Vendor No.");
            }
        }

    }
    actions
    {
        addlast("A&greement")
        {
            action(ChangeLog)
            {
                ApplicationArea = All;
                Caption = 'Change Log';
                Image = ChangeLog;

                trigger OnAction()
                var
                    ChangeLogEntry: Record "Change Log Entry";
                begin
                    ChangeLogEntry.Reset();
                    ChangeLogEntry.SetCurrentKey("Table No.", "Primary Key Field 1 Value", "Primary Key Field 2 Value");
                    ChangeLogEntry.SetRange("Table No.", Database::"Vendor Agreement");
                    ChangeLogEntry.SetRange("Primary Key Field 1 Value", Rec."Vendor No.");
                    ChangeLogEntry.SetRange("Primary Key Field 2 Value", Rec."No.");
                    Page.RunModal(Page::"Change Log Entries", ChangeLogEntry);
                end;
            }

            action(ExportToExcel)
            {
                ApplicationArea = All;
                Caption = 'Export to Excel';
                Image = Excel;

                trigger OnAction()
                var
                    ExportSubform: Report ExportSubform;
                begin
                    Clear(ExportSubform);
                    ExportSubform.UseRequestPage(false);
                    ExportSubform.SetDocNo(Rec."No.", Rec."Vendor No.");
                    ExportSubform.RunModal();
                end;
            }
        }
    }
}