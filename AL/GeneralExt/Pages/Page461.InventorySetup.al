pageextension 80461 "Inventory Setup (Ext)" extends "Inventory Setup"
{
    layout
    {
        addlast(content)
        {
            group(Another)
            {
                Caption = 'Another';
                field("Temp Item Code"; rec."Temp Item Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}