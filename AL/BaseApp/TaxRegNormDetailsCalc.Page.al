page 17280 "Tax Reg. Norm Details (Calc)"
{
    Caption = 'Norm Details (Calc)';
    DataCaptionExpression = FormTitle();
    DelayedInsert = true;
    Editable = false;
    PageType = List;
    SourceTable = "Tax Register Norm Detail";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Effective Date"; "Effective Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the effective date associated with the norm details.';
                }
                field(Norm; Norm)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the norm value that is used to calculate tax differences.';

                    trigger OnDrillDown()
                    begin
                        DrillDownAmount;
                    end;
                }
                field(LineDescription; LineDescription)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Description';
                    ToolTip = 'Specifies a description of the record or entry.';
                }
            }
        }
    }

    actions
    {
    }

    [Scope('OnPrem')]
    procedure DrillDownAmount()
    var
        NormAccumulation: Record "Tax Reg. Norm Accumulation";
    begin
        NormAccumulation.SetCurrentKey("Norm Jurisdiction Code", "Norm Group Code");
        NormAccumulation.SetRange("Norm Jurisdiction Code", "Norm Jurisdiction Code");
        NormAccumulation.SetRange("Norm Group Code", "Norm Group Code");
        NormAccumulation.SetRange("Ending Date", "Effective Date");
        NormAccumulation.SetRange("Line Type", NormAccumulation."Line Type"::"Norm Value");
        if NormAccumulation.FindFirst then;
        NormAccumulation.SetRange("Line Type");
        PAGE.RunModal(0, NormAccumulation);
    end;
}

