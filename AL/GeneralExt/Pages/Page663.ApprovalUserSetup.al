pageextension 80663 "Approval User Setup (Ext)" extends "Approval User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field("Status App"; Rec."Status App")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Status App Act"; Rec."Status App Act")
            {
                ApplicationArea = Basic, Suite;
            }
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
        }
    }
}