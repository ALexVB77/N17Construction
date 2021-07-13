pageextension 94925 "VAT Settlement Worksheet GE" extends "VAT Settlement Worksheet"
{
    layout
    {
        addafter(Type)
        {
            field("Global Dimension 1 Filter"; Rec."Global Dimension 1 Filter")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 2 Filter"; Rec."Global Dimension 2 Filter")
            {
                ApplicationArea = All;
            }
            field("Cost Code Type Filter"; Rec."Cost Code Type Filter")
            {
                ApplicationArea = All;
            }

        }
        addafter("Document No.")
        {
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = Dimensions;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = Dimensions;
            }
            field("Cost Code Type"; Rec."Cost Code Type")
            {
                ApplicationArea = Dimensions;
            }
        }


    }
    var

}
