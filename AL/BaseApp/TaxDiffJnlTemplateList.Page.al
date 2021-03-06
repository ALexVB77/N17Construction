page 17304 "Tax Diff. Jnl. Template List"
{
    Caption = 'Tax Diff. Jnl. Template List';
    Editable = false;
    PageType = List;
    SourceTable = "Tax Diff. Journal Template";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Name; Name)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name associated with the tax differences journal template.';
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the description of the tax differences journal template.';
                }
                field(Type; Type)
                {
                    ToolTip = 'Specifies the type associated with the tax differences journal template.';
                    Visible = false;
                }
                field("Source Code"; "Source Code")
                {
                    ToolTip = 'Specifies the source code that specifies where the entry was created.';
                    Visible = false;
                }
                field("Reason Code"; "Reason Code")
                {
                    ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the entry.';
                    Visible = false;
                }
                field("Page ID"; "Page ID")
                {
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the form ID associated with the tax differences journal template.';
                    Visible = false;
                }
                field("Page Name"; "Page Name")
                {
                    DrillDown = false;
                    ToolTip = 'Specifies the form name associated with the tax differences journal template.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

