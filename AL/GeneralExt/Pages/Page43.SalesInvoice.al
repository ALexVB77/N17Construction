pageextension 80043 "Sales Invoice (Ext)" extends "Sales Invoice"

{
    layout
    {
        addlast(General)
        {
            field(Gift; Rec.Gift)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
