pageextension 92452 "Item Shipment GE" extends "Item Shipment"
{
    layout
    {
        addafter("Gen. Bus. Posting Group")
        {
            field("Vendor No."; Rec."Vendor No.")
            {
                ApplicationArea = all;
            }
            field("Agreement No."; Rec."Agreement No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
