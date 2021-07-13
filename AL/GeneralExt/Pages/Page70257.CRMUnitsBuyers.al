page 70257 "CRM Units and Buyers"
{
    Editable = false;
    SourceTable = "CRM Buyers";
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;


    layout
    {
        area(content)
        {
            repeater(Repeater12370003)
            {
                field("Unit Guid"; Rec."Unit Guid")
                {
                    ApplicationArea = All;

                }

                field("Buyer Guid"; Rec."Buyer Guid")
                {
                    ApplicationArea = All;

                }

                field("Contact Guid"; Rec."Contact Guid")
                {
                    ApplicationArea = All;

                }

                field("Contract Guid"; Rec."Contract Guid")
                {
                    ApplicationArea = All;

                }

                field("Reserving Contact Guid"; Rec."Reserving Contact Guid")
                {
                    ApplicationArea = All;

                }

                field("Buyer Is Active"; Rec."Buyer Is Active")
                {
                    ShowCaption = false;
                    ApplicationArea = All;

                }

                field("Ownership Percentage"; Rec."Ownership Percentage")
                {
                    ApplicationArea = All;

                }

                field("Object of Investing"; Rec."Object of Investing")
                {
                    ApplicationArea = All;

                }

                field("Project Id"; Rec."Project Id")
                {
                    ApplicationArea = All;
                }



            }
        }
    }




}
