report 99998 TestRep
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = True;

    dataset
    {

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    trigger OnPreReport()
    var
        myInt: Integer;
    begin

    end;

    var
        myInt: Integer;
}