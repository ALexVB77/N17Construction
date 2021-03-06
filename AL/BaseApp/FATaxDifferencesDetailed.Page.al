page 17336 "FA Tax Differences Detailed"
{
    Caption = 'FA Tax Differences Detailed';
    DataCaptionFields = "FA No.";
    Editable = false;
    PageType = List;
    SourceTable = "Tax Diff. FA Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control1210000)
            {
                ShowCaption = false;
                field("Tax Difference Code"; "Tax Difference Code")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'This field is used internally.';
                }
                field(Description; Description)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the description associated with this line.';
                }
                field(Difference; Difference)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the description associated with this line.';

                    trigger OnDrillDown()
                    begin
                        DrillDownAmount;
                    end;
                }
                field("Amount (Base)"; "Amount (Base)")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the base amount associated with the tax difference for the fixed asset.';

                    trigger OnDrillDown()
                    begin
                        DrillDownAmount;
                    end;
                }
                field("Amount (Tax)"; "Amount (Tax)")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the amount including tax.';

                    trigger OnDrillDown()
                    begin
                        DrillDownAmount;
                    end;
                }
                field("Tax Amount"; "Tax Amount")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'This field is used internally.';

                    trigger OnDrillDown()
                    begin
                        DrillDownAmount;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    [Scope('OnPrem')]
    procedure FillBuffer(var TaxDiffFABuffer: Record "Tax Diff. FA Buffer")
    begin
        if TaxDiffFABuffer.FindSet then
            repeat
                Rec := TaxDiffFABuffer;
                Insert;
            until TaxDiffFABuffer.Next = 0;
    end;
}

