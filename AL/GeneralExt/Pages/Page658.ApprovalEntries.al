pageextension 80658 "Approval Entries (Ext)" extends "Approval Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("Status App Act"; "Status App Act")
            {
                ApplicationArea = All;
            }
        }
    }
}