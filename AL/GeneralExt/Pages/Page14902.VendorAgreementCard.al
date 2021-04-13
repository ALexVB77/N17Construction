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
}