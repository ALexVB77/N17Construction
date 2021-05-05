pageextension 80020 "General Ledger Entries (Ext)" extends "General Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("DenDoc Dim Value"; Rec."DenDoc Dim Value Code")
            {
                ApplicationArea = Basic, Suite;
            }

            field("Utilities Dim. Value Code"; Rec."Utilities Dim. Value Code")
            {
                ApplicationArea = Basic, Suite;
            }

            field("Credit-Memo Reason"; GetCrMemoReason())
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
    procedure GetCrMemoReason(): Text[230]
    var
        PCMH: Record "Purch. Cr. Memo Hdr.";
        SCMH: Record "Sales Cr.Memo Header";
    begin

        // SWC1100 DD 28.09.17 >>
        IF PCMH.GET("Document No.") THEN
            EXIT(PCMH."Credit-Memo Reason")
        ELSE
            IF SCMH.GET("Document No.") THEN
                EXIT(SCMH."Credit-Memo Reason");
        // SWC1100 DD 28.09.17 <<

    end;

}