page 50016 "Calc. Gen. Journal Update"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Calc. Gen Journal Operand";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                //field(Name; NameSource)
                //{
                //ApplicationArea = All;

                //}
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}