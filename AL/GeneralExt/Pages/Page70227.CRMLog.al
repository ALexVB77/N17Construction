page 70227 "CRM Log"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CRM Log";
    SourceTableView = sorting("Datetime") order(descending);

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;

                }
                field("Datetime"; Rec.Datetime)
                {
                    ApplicationArea = All;

                }

                field("Object Id"; Rec."Object Id")
                {
                    ApplicationArea = All;

                }

                field("Object Type"; Rec."Object Type")
                {
                    ApplicationArea = All;

                }


                field("Action"; Rec."Action")
                {
                    ApplicationArea = All;

                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;

                }

                field("Details Text 1"; Rec."Details Text 1")
                {
                    ApplicationArea = All;

                }

                field("Details Text 2"; Rec."Details Text 2")
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
            action(Preview)
            {
                ApplicationArea = All;
                Caption = 'Object Xml Preview';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Scope = Repeater;

                trigger OnAction()
                begin
                    //if "File Name" <> '' then
                    //    Export(true);
                end;
            }
        }
    }

}
