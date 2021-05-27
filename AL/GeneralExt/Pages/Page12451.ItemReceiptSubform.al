pageextension 92451 "Item Receipt Subform (Ext)" extends "Item Receipt Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
            {
                ApplicationArea = All;
                Description = 'NC 50113 EP';
            }
        }
    }
}