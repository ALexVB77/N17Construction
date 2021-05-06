pageextension 80256 "Payment Journal (Ext)" extends "Payment Journal"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {

        addafter(PrintCheck)
        {
            action(PrintCheckExt)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print Payment Order';
                Ellipsis = true;
                Image = PrintCheck;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    BankAcc: Record "Bank Account";
                    GenJnlLine: Record "Gen. Journal Line";
                    DocPrint: Codeunit "Document-Print";
                    rep: Report "Bank Payment Order";
                begin
                    GenJnlLine.Reset();
                    GenJnlLine.Copy(Rec);
                    CurrPage.SETSELECTIONFILTER(GenJnlLine);
                    if (GenJnlLine.findset()) then begin
                        repeat
                            GenJnlLine.TestField("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
                            BankAcc.Get(GenJnlLine."Bal. Account No.");
                            case BankAcc."Account Type" of
                                BankAcc."Account Type"::"Bank Account":
                                    DocPrint.PrintCheck(GenJnlLine);

                                BankAcc."Account Type"::"Cash Account":
                                    DocPrint.PrintCashOrder(GenJnlLine);
                            end;
                        until (GenJnlLine.next() = 0)
                    end;
                    CODEUNIT.Run(CODEUNIT::"Adjust Gen. Journal Balance", Rec);
                end;
            }

        }
        modify(PrintCheck)
        {
            Visible = false;
        }

    }


}