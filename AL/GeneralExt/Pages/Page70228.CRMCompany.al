page 70228 "CRM Company"
{
    SourceTable = "CRM Company";
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'CRM Copmany';


    layout
    {
        area(content)
        {
            repeater(Repeater12370003)
            {
                field("Project Guid"; Rec."Project Guid")
                {
                    ApplicationArea = All;

                }

                field("Project Name"; Rec."Project Name")
                {
                    ApplicationArea = All;

                }

                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = All;

                }



            }
        }
    }

    actions
    {
        area(navigation)
        {
        }
    }







}
