pageextension 80460 "Purchases & Payab. Setup (Ext)" extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("M-4 Template Code")
        {
            field("Vendor Agreement Template Code"; Rec."Vendor Agreement Template Code")
            {
                ApplicationArea = All;
            }
        }
    }
}