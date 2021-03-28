pageextension 92479 "FA Movement Act Subform (Ext)" extends "FA Movement Act Subform"
{
    layout
    {
        addafter("New Depreciation Book Code")
        {
            field("FA Posting Group"; Rec."FA Posting Group")
            {
                ApplicationArea = FixedAssets;
            }
            field("New FA Posting Group"; Rec."New FA Posting Group")
            {
                ApplicationArea = FixedAssets;
            }
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = true;
        }
    }
}