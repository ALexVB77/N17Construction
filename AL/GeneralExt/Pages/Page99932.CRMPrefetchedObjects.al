page 99932 "CRM Prefetched Objects"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CRM Prefetched Object";

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

                field(Type; Rec.Type)
                {
                    ApplicationArea = All;

                }

                field(Checksum; Rec.Checksum)
                {
                    ApplicationArea = All;

                }

                field("Prefetch Datetime"; Rec."Prefetch Datetime")
                {
                    ApplicationArea = All;

                }


            }
        }
    }


}
