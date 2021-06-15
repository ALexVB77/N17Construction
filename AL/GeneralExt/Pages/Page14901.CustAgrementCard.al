pageextension 94901 "Customer Agreement Card (Ext)" extends "Customer Agreement Card"
{
    layout
    {
        modify("Customer Posting Group")
        {
            Editable = HasntOpenLedgerEntries;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnAfterGetRecord()
    begin
        OnFormat();
    end;

    var
        HasntOpenLedgerEntries: Boolean;

    local procedure OnFormat()
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgerEntry.SETRANGE("Customer No.", Rec."Customer No.");
        CustLedgerEntry.SETRANGE("Agreement No.", Rec."No.");
        CustLedgerEntry.SETRANGE(Open, TRUE);
        HasntOpenLedgerEntries := CustLedgerEntry.ISEMPTY;
    end;

}
