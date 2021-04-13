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
        addafter("FA Inventory Card FA-6")
        {
            action("FA Inventory Card FA-6 New")
            {
                ApplicationArea = FixedAssets;
                Caption = 'FA Inventory Card FA-6';
                Image = Report;
                ToolTip = 'View the registration of fixed assets and operations, including the movement of fixed assets within the organization.';
                trigger OnAction()
                var
                    FA: Record "Fixed Asset";
                begin
                    FA.Get(Rec."No.");
                    FA.SetRecFilter;
                    REPORT.Run(REPORT::"FA Inventory Card FA-6 (Ext)", true, true, FA);
                end;
            }
        }
        modify("FA Inventory Card FA-6")
        {
            Visible = false;
        }
    }
}