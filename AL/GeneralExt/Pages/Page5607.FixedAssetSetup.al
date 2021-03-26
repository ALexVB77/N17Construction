pageextension 85607 "Fixed Asset Setup (Ext)" extends "Fixed Asset Setup"
{
    layout
    {
        addafter("FA-4a Template Code")
        {
            field("FA-4b Template Code"; "FA-4b Template Code")
            {
                ApplicationArea = FixedAssets;
            }
        }
    }
}