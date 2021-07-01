pageextension 80660 "Approval Comments (Ext)" extends "Approval Comments"
{
    layout
    {
        addlast(Control1)
        {
            field("Status App Act"; Rec."Status App Act")
            {
                ApplicationArea = All;
            }
        }
    }
}