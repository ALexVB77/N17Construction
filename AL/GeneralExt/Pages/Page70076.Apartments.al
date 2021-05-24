page 70076 Apartments
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Apartments;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Object No."; Rec."Object No.")
                {
                    ApplicationArea = All;

                }
                field(Descriotion; Rec.Descriotion)
                {
                    ApplicationArea = All;

                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;

                }
                field("Total Area (Project)"; Rec."Total Area (Project)")
                {
                    ApplicationArea = All;

                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
    }
}