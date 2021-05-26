pageextension 80015 "Location List (Ext)" extends "Location List"
{
    layout
    {
        addlast(Control1)
        {
            field(Blocked; Rec.Blocked)
            {
                ApplicationArea = All;
                Description = 'NC 51143 EP';
            }
        }
    }

    trigger OnOpenPage()
    begin
        // NC 51143 > EP
        // Перенес модификацию из OnOpenForm()

        //NC 22512 > DP
        Rec.SetRange(Blocked, false);
        //NC 22512 < DP

        // NC 51143 < EP
    end;
}