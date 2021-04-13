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
        }
    }
}