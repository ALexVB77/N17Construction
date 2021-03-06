page 17246 "Tax Reg. Norm Jurisdictions"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Tax Register Norm Jurisdictions';
    PageType = List;
    SourceTable = "Tax Register Norm Jurisdiction";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code"; Code)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the norm jurisdiction code.';
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the description of the norm jurisdiction code.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Jurisdiction")
            {
                Caption = '&Jurisdiction';
                Image = ViewDetails;
                action(Groups)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Groups';
                    Image = Group;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Tax Register Norm Groups";
                    RunPageLink = "Norm Jurisdiction Code" = FIELD(Code);
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("&Export Settings")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Export Settings';
                    Ellipsis = true;
                    Image = ExportFile;
                    ToolTip = 'Export an XML file that contains information about the tax register norm jurisdiction.';

                    trigger OnAction()
                    begin
                        CurrPage.SetSelectionFilter(NormJurisdiction);
                        #if not CLEAN17
                        ExportSettings(NormJurisdiction);
                        #endif
                    end;
                }
                action("&Import Settings")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Import Settings';
                    Ellipsis = true;
                    Image = Import;
                    ToolTip = 'Import an XML file that contains settings for norm jurisdictions.';

                    trigger OnAction()
                    begin
                        PromptImportSettings;
                    end;
                }
            }
        }
    }

    var
        NormJurisdiction: Record "Tax Register Norm Jurisdiction";
}

