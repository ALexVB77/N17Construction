pageextension 92481 "Posted FA Movem. Act Sub. Ext" extends "Posted FA Movement Act Subform"
{
    layout
    {
        addafter("FA No.")
        {
            field("New FA No."; Rec."New FA No.")
            {
                ApplicationArea = FixedAssets;
            }
        }
        addafter("Depreciation Book Code")
        {
            field("New Depreciation Book Code"; Rec."New Depreciation Book Code")
            {
                ApplicationArea = FixedAssets;
            }
            field("FA Posting Group"; Rec."FA Posting Group")
            {
                ApplicationArea = FixedAssets;
            }
            field("New FA Posting Group"; Rec."New FA Posting Group")
            {
                ApplicationArea = FixedAssets;
            }
        }

    }
}