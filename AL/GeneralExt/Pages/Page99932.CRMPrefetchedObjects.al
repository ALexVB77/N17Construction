page 99932 "CRM Prefetched Objects"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CRM Prefetched Object";
    Caption = 'CRM Prefetched Objects';
    InsertAllowed = false;

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

                field(ParentId; rec.ParentId)
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

    actions
    {
        area(processing)
        {
            action(DownloadObjectXml)
            {
                ApplicationArea = All;
                Caption = 'Download Object Xml';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Scope = Repeater;

                trigger OnAction()
                begin
                    Rec.ExportObjectXml(true);
                end;
            }
        }
    }

}
