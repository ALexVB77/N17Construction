pageextension 80119 "User Setup (Ext)" extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field("Absents"; Rec."Absents")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Administrator IW"; Rec."Administrator IW")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Administrator PRJ"; Rec."Administrator PRJ")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Show All Acts KC-2"; Rec."Show All Acts KC-2")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Status App Act"; Rec."Status App Act")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}