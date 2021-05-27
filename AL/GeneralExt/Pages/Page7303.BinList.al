pageextension 87303 "Bin List (Ext)" extends "Bin List"
{
    layout
    {
        modify(Code)
        {
            trigger OnAssistEdit()
            var
                Vendor: Record Vendor;
            begin
                // NC 51411 > EP
                // Перенес модификацию из OnAssistEdit()

                // SWC816 AK 190416 >>
                if not Rec."Givened Manuf." then
                    exit;
                // NC 51411 > EP
                // Vendor.Get(Code);
                if Vendor.Get(Code) then
                    // NC 51411 < EP
                    Page.RunModal(Page::"Vendor Card", Vendor);
                // SWC816 AK 190416 <<

                // NC 51411 < EP
            end;
        }
        addlast(Control1)
        {
            field("Givened Manuf."; Rec."Givened Manuf.")
            {
                ApplicationArea = All;
                Description = 'NC 51411 EP';
            }
        }
    }
}