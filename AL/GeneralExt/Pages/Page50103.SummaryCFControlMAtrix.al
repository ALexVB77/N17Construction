page 50103 "Summary CF Control Matrix"
{
    PageType = ListPart;
    SourceTable = "Dimension Value";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;

                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }

            }
        }
    }
    var
        myInt: Integer;
}