tableextension 92453 "Item Document Line GE" extends "Item Document Line"
{
    fields
    {
        field(50000; "Change From Giv. Prod. Order"; Boolean)
        {
            Caption = 'Change From Giv. Prod. Order';
            DataClassification = CustomerContent;
        }
    }
    var

        ChangeFromGivProdOrder: Boolean;

    procedure SetChangeFromGivProdOrder(ChangeFromDivProdOrderNew: boolean)
    begin

        // SWC816 AK 120516 >>    
        ChangeFromGivProdOrder := ChangeFromDivProdOrderNew;
        // SWC816 AK 120516 <<

    end;
}
