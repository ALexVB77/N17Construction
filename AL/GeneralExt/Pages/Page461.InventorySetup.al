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
        addlast(General)
        {
            field("Use Giv. Production Func."; Rec."Use Giv. Production Func.")
            {
                ApplicationArea = All;
                Description = 'NC 51411 EP';
            }
        }
        addlast(Location)
        {
            field("Giv. Materials Loc. Code"; Rec."Giv. Materials Loc. Code")
            {
                ApplicationArea = All;
                Description = 'NC 51411 EP';
            }
            field("Giv. Production Loc. Code"; Rec."Giv. Production Loc. Code")
            {
                ApplicationArea = All;
                Description = 'NC 51411 EP';
            }
            field("Default Location Code"; Rec."Default Location Code")
            {
                ApplicationArea = All;
            }
        }
    }
}