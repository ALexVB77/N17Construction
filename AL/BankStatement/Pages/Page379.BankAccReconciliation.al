pageextension 99992 "Bank Acc. Reconciliation BS" extends "Bank Acc. Reconciliation"
{
    layout
    {
        modify(BalanceLastStatement)
        {
            Visible = false;
        }
        modify(StatementEndingBalance)
        {
            Visible = false;
        }
        addafter(General)
        {
            group(Control1)
            {
                ShowCaption = false;
                field("Statement Begin Saldo"; "Statement Begin Saldo")
                {
                    ApplicationArea = all;
                }
                field("Total Income Amount"; "Total Income Amount")
                {
                    ApplicationArea = all;
                }
                field("Total Outcome Amount"; "Total Outcome Amount")
                {
                    ApplicationArea = all;
                }
                field("Statement End Saldo"; "Statement End Saldo")
                {
                    ApplicationArea = all;
                }
                //field(Tot)
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