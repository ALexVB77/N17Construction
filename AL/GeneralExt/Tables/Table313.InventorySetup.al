tableextension 80313 "Inventory Setup (Ext)" extends "Inventory Setup"
{
    fields
    {
        field(70002; "Temp Item Code"; Code[20])
        {
            TableRelation = Item;
            Description = 'NC 51373 AB';
            Caption = 'Temp Item Code';
        }
    }
}