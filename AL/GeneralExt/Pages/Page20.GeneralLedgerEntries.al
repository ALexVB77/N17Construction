pageextension 80020 "General Ledger Entries (Ext)" extends "General Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("DenDoc Dim Value"; Rec."DenDoc Dim Value Code")
            {
                ApplicationArea = Basic, Suite;
            }

            field("Utilities Dim. Value Code"; Rec."Utilities Dim. Value Code")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}