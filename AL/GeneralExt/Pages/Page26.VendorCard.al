pageextension 80026 "Vendor Card (Ext)" extends "Vendor Card"
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
        addlast(Receiving)
        {
            field("Giv. Manuf. Location Code"; Rec."Giv. Manuf. Location Code")
            {
                ApplicationArea = All;
            }
            field("Giv. Manuf. Bin Code"; Rec."Giv. Manuf. Bin Code")
            {
                ApplicationArea = All;
            }
        }
    }
}