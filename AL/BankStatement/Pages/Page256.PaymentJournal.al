pageextension 99990 "Payment Journal BS" extends "Payment Journal"
{
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
                    
                    GenJnlLine.TestField("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
                    BankAcc.Get(GenJnlLine."Bal. Account No.");
                    case BankAcc."Account Type" of
                        BankAcc."Account Type"::"Bank Account":
                            DocPrint.PrintCheck(GenJnlLine);

                        BankAcc."Account Type"::"Cash Account":
                            DocPrint.PrintCashOrder(GenJnlLine);
                    end;
                    
                    CODEUNIT.Run(CODEUNIT::"Adjust Gen. Journal Balance", Rec);
                end;
            }

        }
        modify(PrintCheck)
        {
            Visible = false;
        }
        modify("Void Payment Order")
        {
            Visible = false;
        }
        modify("Void &All Payment Orders")
        {
            Visible = false;
        }
        modify("Print Payment Order")
        {
            Visible = false;
        }
    }

}
