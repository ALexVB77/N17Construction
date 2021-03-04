pageextension 80029 "Vendor Ledger Entries (Ext)" extends "Vendor Ledger Entries"
{

    actions
    {
        addlast("F&unctions")
        {
            action(TransferToGD)
            {
                ApplicationArea = All;
                Caption = 'Transfer to GD';

                trigger OnAction()
                var
                    rpt: report "Create Guarantee Deduction";
                begin
                    //NC 27087 HR 230518 beg
                    Rec.TESTFIELD("Document Type", Rec."Document Type"::Invoice);
                    Rec.CALCFIELDS("Remaining Amt. (LCY)");
                    Rec.TESTFIELD("Remaining Amt. (LCY)");
                    rpt.SETTABLEVIEW(Rec);
                    rpt.SetVLE(Rec."Entry No.");
                    rpt.RUNMODAL;
                    //NC 27087 HR 230518 end
                end;
            }

        }
    }


}


