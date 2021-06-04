page 99931 "Web Request Queue"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Web Request Queue";
    SourceTableView = sorting("Datetime creating") order(descending);

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Id; Rec.Id)
                {
                    ApplicationArea = All;

                }
                field("Date time"; Rec."Datetime creating")
                {
                    ApplicationArea = All;

                }

                field("Worker Code"; Rec."Worker Code")
                {
                    ApplicationArea = All;

                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;

                }

                field("Error Message"; Rec."Error Message")
                {
                    ApplicationArea = All;
                    Editable = false;

                }


            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ShowRequestBody)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin
                    Message('Under construction');
                end;
            }
        }
    }
}
