pageextension 85740 "Transfer Order (Ext)" extends "Transfer Order"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {

        addafter(GetReceiptLines)
        {
            action(GetItemLedgerEntryLines)
            {
                Caption = 'Get Item Ledger Lines';
                Image = InventoryPick;
                ApplicationArea = All;
                trigger OnAction()
                begin

                    //NC 22512 > DP
                    rec.GetInventoryLines;
                    //NC 22512 < DP
                end;

            }
        }
    }

    var
        myInt: Integer;
}