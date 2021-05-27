tableextension 80313 "Inventory Setup (Ext)" extends "Inventory Setup"
{
    fields
    {
        field(50000; "Giv. Materials Loc. Code"; Code[20])
        {
            // TODO: перенести зависимости в t12450, t12453, t12454, cu12453 @eapomazkov
            Caption = 'Giv. Materials Loc. Code';
            Description = 'SWC816, NC 51411 EP';
            TableRelation = Location;
        }
        field(50001; "Giv. Production Loc. Code"; Code[20])
        {
            // TODO: перенести зависимости в t12450, t12453, t12454, cu12453 @eapomazkov
            Caption = 'Giv. Production Loc. Code';
            Description = 'SWC816, NC 51411 EP';
            TableRelation = Location;
        }
        field(50007; "Use Giv. Production Func."; Boolean)
        {
            // TODO: перенести зависимости в t12450, t12453, t12454, cu12453 @eapomazkov
            Caption = 'Use Giv. Production Func.';
            Description = 'SWC816, NC 51411 EP';
        }
        field(70002; "Temp Item Code"; Code[20])
        {
            TableRelation = Item;
            Description = 'NC 51373 AB';
            Caption = 'Temp Item Code';
        }
    }
}