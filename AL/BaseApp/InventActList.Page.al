page 14911 "Invent. Act List"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Contractors Inventory Acts';
    CardPageID = "Invent. Act Card";
    Editable = false;
    PageType = List;
    SourceTable = "Invent. Act Header";
    UsageCategory = ReportsAndAnalysis;

    layout
    {
        area(content)
        {
            repeater(Control1210000)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Inventory Date"; "Inventory Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date of inventory, and is filled with the work date.';
                }
                field("Reason Document Type"; "Reason Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of reason document.';
                }
                field("Reason Document No."; "Reason Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the reason document number.';
                }
                field("Reason Document Date"; "Reason Document Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date of the reason document.';
                }
                field("Act Date"; "Act Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the inventory act date, and is filled with the work date.';
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the status of the inventory act.';
                }
            }
        }
    }

    actions
    {
    }
}

