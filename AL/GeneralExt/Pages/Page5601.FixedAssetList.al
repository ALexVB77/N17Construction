pageextension 85601 "Fixed Asset List (Ext)" extends "Fixed Asset List"
{
    layout
    {
        addafter("Depreciation Group")
        {
            field("RAS Posting Group"; Rec."RAS Posting Group")
            {
                ApplicationArea = FixedAssets;
                ToolTip = 'Specifies a RAS posting group of the fixed asset.';
            }
        }
    }
    actions
    {
        addlast(reporting)
        {
            action("FA Turnover (Excel)")
            {
                ApplicationArea = FixedAssets;
                Caption = 'FA Turnover (Excel)';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "FA Turnover (Excel)";
            }
        }
    }
}