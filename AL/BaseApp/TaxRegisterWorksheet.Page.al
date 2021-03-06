page 17202 "Tax Register Worksheet"
{
    Caption = 'Tax Register Worksheet';
    CardPageID = "Tax Register Card";
    DelayedInsert = true;
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Tax Register";

    layout
    {
        area(content)
        {
            repeater(Control100)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the description of the tax register name.';
                }
                field("Table ID"; "Table ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the table identifier of the tax register name.';
                    Visible = TableIDVisible;
                }
                field("Storing Method"; "Storing Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the storing method associated with the tax register name.';
                    Visible = StoringMethodVisible;
                }
                field("G/L Corr. Analysis View Code"; "G/L Corr. Analysis View Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the general ledger corresponding analysis view code associated with the tax register name.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Show Data")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Data';
                Image = ShowMatrix;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Tax Register Accumulation";
                RunPageLink = "Section Code" = FIELD("Section Code"),
                              "No." = FIELD("No.");
                ToolTip = 'View the related details.';
            }
        }
    }

    trigger OnInit()
    begin
        StoringMethodVisible := true;
        TableIDVisible := true;
    end;

    trigger OnOpenPage()
    begin
        CurrentSectionCode := "Section Code";
        TaxRegMgt.OpenJnl(CurrentSectionCode, Rec);

        CurrPage.Editable := not CurrPage.LookupMode;
        TableIDVisible := CurrPage.Editable;
        StoringMethodVisible := CurrPage.Editable;
    end;

    var
        TaxRegMgt: Codeunit "Tax Register Mgt.";
        CurrentSectionCode: Code[10];
        [InDataSet]
        TableIDVisible: Boolean;
        [InDataSet]
        StoringMethodVisible: Boolean;
}

