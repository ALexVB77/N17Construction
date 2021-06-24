page 70256 "Summary Cash Flow Control"
{
    UsageCategory = Lists;
    ApplicationArea = All;
    Caption = 'Summary Cash Flow Control';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPlus;
    SaveValues = true;
    SourceTable = "Dimension Value";
    SourceTableView = where("Global Dimension No." = const(2));

    layout
    {
        area(Content)
        {
            group(Options)
            {
                field(PrjCode; ProjectCode)
                {
                    ApplicationArea = All;
                    Caption = 'Project Code';
                }
                field(CPflt; CPflt)
                {
                    ApplicationArea = All;
                    Caption = 'Cost Place';
                }
                field(CCflt; CCflt)
                {
                    ApplicationArea = All;
                    Caption = 'Cost Code';
                }
                field(StDate; StartingDate)
                {
                    ApplicationArea = All;
                    Caption = 'Starting Date';
                }
                field(sba; NotShowBlankAmounts)
                {
                    ApplicationArea = All;
                    Caption = 'Don''t show blank amounts';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Previous Set")
            {
                // ApplicationArea = Location;
                // Caption = 'Previous Set';
                // Image = PreviousSet;
                // Promoted = true;
                // PromotedCategory = Process;
                // PromotedIsBig = true;
                // PromotedOnly = true;
                // ToolTip = 'Go to the previous set of data.';

                // trigger OnAction()
                // begin
                //     SetColumns(MATRIX_SetWanted::Previous);
                // end;
            }
            action("Next Set")
            {
                // ApplicationArea = Location;
                // Caption = 'Next Set';
                // Image = NextSet;
                // Promoted = true;
                // PromotedCategory = Process;
                // PromotedIsBig = true;
                // PromotedOnly = true;
                // ToolTip = 'Go to the next set of data.';

                // trigger OnAction()
                // begin
                //     SetColumns(MATRIX_SetWanted::Next);
                // end;
            }
        }
    }

    var
        ProjectCode: code[20];
        CPflt: Code[250];
        CCflt: Code[250];
        StartingDate: Date;
        NotShowBlankAmounts: boolean;
}