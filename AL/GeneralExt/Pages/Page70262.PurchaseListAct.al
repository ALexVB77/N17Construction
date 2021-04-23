page 70262 "Purchase List Act"
{
    ApplicationArea = Basic, Suite;
    UsageCategory = Tasks;
    Editable = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = "Purchase Header";
    PageType = Worksheet;
    Caption = 'Payment Orders List';
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater(Repeater1237120003)
            {
                Editable = false;
                ShowCaption = false;
                field("Problem Document"; "Problem Document")
                {
                    Editable = false;
                    ShowCaption = false;
                    ApplicationArea = All;
                }
                field("No."; "No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }
}