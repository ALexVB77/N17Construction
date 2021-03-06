page 14912 "Invent. Act Subform"
{
    Caption = 'Lines';
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Invent. Act Line";

    layout
    {
        area(content)
        {
            repeater(Control1210000)
            {
                ShowCaption = false;
                field("Contractor Type"; "Contractor Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of contractor that this inventory act line applies to.';
                }
                field("Contractor No."; "Contractor No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the customer number or vendor number of the contractor.';
                }
                field("Contractor Name"; "Contractor Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the contractor name.';
                }
                field("Posting Group"; "Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the posting group for which the debt or liability amount is calculated.';
                }
                field("G/L Account No."; "G/L Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the receivables or payables account for which the debt or liability amount is calculated.';
                }
                field(Category; Category)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the amount category.';
                }
                field("Total Amount"; "Total Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total amount of debts or liabilities in this inventory act.';

                    trigger OnDrillDown()
                    begin
                        DrillDownAmount;
                    end;
                }
                field("Confirmed Amount"; "Confirmed Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total amount of debts or liabilities by default.';
                }
                field("Not Confirmed Amount"; "Not Confirmed Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the amount that is not confirmed by the contractor.';
                }
                field("Overdue Amount"; "Overdue Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specify the amount that is reported overdue by the contractor.';
                }
            }
        }
    }

    actions
    {
    }
}

