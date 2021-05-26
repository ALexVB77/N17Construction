pageextension 85703 "Location Card (Ext)" extends "Location Card"
{
    layout
    {
        addlast(General)
        {
            field(Blocked; Rec.Blocked)
            {
                ApplicationArea = All;
                Description = 'NC 51143 EP';
            }
            field("Def. Gen. Bus. Posting Group"; Rec."Def. Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                Description = 'NC 51143 EP';
            }
        }
    }
}