page 17287 "Tax Reg. Norm Dim. Filters"
{
    Caption = 'Norm Dimension Filters';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Tax Reg. Norm Dim. Filter";

    layout
    {
        area(content)
        {
            repeater(Control100)
            {
                ShowCaption = false;
                field("Dimension Code"; "Dimension Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the dimension code associated with the norm dimension filter.';
                }
                field("Dimension Value Filter"; "Dimension Value Filter")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the dimension value that the data is filtered by.';
                }
                field("Dimension Name"; "Dimension Name")
                {
                    ApplicationArea = Basic, Suite;
                    AssistEdit = true;
                    Caption = 'Value Name';
                    ToolTip = 'Specifies the dimension name associated with the norm dimension filter.';

                    trigger OnAssistEdit()
                    begin
                        DrillDownValueName;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        CurrPage.Editable := not CurrPage.LookupMode;
    end;

    var
        DimValue: Record "Dimension Value";

    [Scope('OnPrem')]
    procedure DrillDownValueName()
    begin
        if "Dimension Value Filter" <> '' then begin
            DimValue.Reset();
            DimValue.FilterGroup(2);
            DimValue.SetRange("Dimension Code", "Dimension Code");
            DimValue.FilterGroup(0);
            DimValue.SetFilter(Code, "Dimension Value Filter");
            PAGE.RunModal(0, DimValue);
        end;
    end;
}

