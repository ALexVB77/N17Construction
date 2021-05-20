pageextension 80461 "Inventory Setup (Ext)" extends "Inventory Setup"
{
    layout
    {
        addlast(Templates)
        {
            group(Other)
            {
                Caption = 'Other';
                field("Temp Item Code"; rec."Temp Item Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}