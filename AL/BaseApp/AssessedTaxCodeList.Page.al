page 14922 "Assessed Tax Code List"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Assessed Tax Codes';
    CardPageID = "Assessed Tax Code Card";
    Editable = false;
    PageType = List;
    SourceTable = "Assessed Tax Code";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1470000)
            {
                ShowCaption = false;
                field("Code"; Code)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the code number that represents an assessed fixed assets tax.';
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a description for the assessed tax code.';
                }
                field("Region Code"; "Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a two-character region code that is used with the Tax Authority No. field to determine the OKATO code.';
                }
                field("Rate %"; "Rate %")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the tax rate for this assessed fixed assets tax.';
                }
                field("Dec. Rate Tax Allowance Code"; "Dec. Rate Tax Allowance Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a code for the assessed tax allowance code that reduces the calculated assessed tax amount.';
                }
                field("Dec. Amount Tax Allowance Code"; "Dec. Amount Tax Allowance Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the amount of an assessed tax allowance.';
                }
                field("Decreasing Amount"; "Decreasing Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value to be used in the assessed tax calculation if there is a tax allowance that reduces assessed taxes.';
                }
                field("Exemption Tax Allowance Code"; "Exemption Tax Allowance Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a code for an assessed tax allowance exemption.';
                }
                field("Decreasing Amount Type"; "Decreasing Amount Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether the decreasing amount value is a percentage or an amount.';
                }
            }
        }
    }

    actions
    {
    }
}

