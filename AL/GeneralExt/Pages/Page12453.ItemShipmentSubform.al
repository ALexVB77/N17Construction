pageextension 92453 "Item Shipment Subform (Ext)" extends "Item Shipment Subform"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Item &Tracking Lines")
        {
            action(GetItemLedgerEntryLines)
            {
                Caption = 'Get Item Ledger Lines';
                Image = InventoryPick;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    GetInventory();
                end;

            }
        }
    }

    var
        myInt: Integer;

    procedure GetInventory()

    begin

        //NC 22512 > DP
        CODEUNIT.RUN(CODEUNIT::"Inven.-Get Inventory", Rec);
        //NC 22512 < DP

    end;
}