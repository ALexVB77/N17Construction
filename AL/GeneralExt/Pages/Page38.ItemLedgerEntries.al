pageextension 80038 "Item Ledger Entries (Ext)" extends "Item Ledger Entries"
{
    procedure ReturnSelectionFilter(var ItemLedgEntry: Record "Item Ledger Entry")
    begin
        //NC 22512 > DP
        CurrPage.SETSELECTIONFILTER(ItemLedgEntry);
        //NC 22512 < DP
    end;
}
