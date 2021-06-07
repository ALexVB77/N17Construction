pageextension 80459 "Sales & Receiv. Setup (Ext)" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field("CRM Worker Code"; Rec."CRM Worker Code")
            {
                ApplicationArea = Basic, Suite;
            }
        }

    }

}
