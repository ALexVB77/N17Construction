pageextension 80119 "User Setup (Ext)" extends "User Setup"
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
            field("Master Approver (Development)"; "Master Approver (Development)")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Master Approver (Production)"; "Master Approver (Production)")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Show All Acts KC-2"; Rec."Show All Acts KC-2")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Show All Pay Inv"; rec."Show All Pay Inv")
            {
                ApplicationArea = Basic, Suite;
            }
            field("CF Allow Long Entries Edit"; Rec."CF Allow Long Entries Edit")
            {
                ApplicationArea = Basic, Suite;
            }
            field("CF Allow Short Entries Edit"; Rec."CF Allow Short Entries Edit")
            {
                ApplicationArea = Basic, Suite;
            }
            field(ddd; Rec."Change Agreem. Posting Group")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Allow Edit DenDoc Dimension"; Rec."Allow Edit DenDoc Dimension")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Vend. Agr. Creator Notif."; Rec."Vend. Agr. Creator Notif.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Vend. Agr. Controller Notif."; Rec."Vend. Agr. Controller Notif.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}
