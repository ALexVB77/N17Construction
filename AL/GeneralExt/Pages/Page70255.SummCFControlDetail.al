page 70255 "Summ. Cash Flow Control Detail"
{
    UsageCategory = Lists;
    ApplicationArea = All;
    Caption = 'Summary Cash Flow Control Detail';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPlus;
    SaveValues = true;
    SourceTable = "Dimension Value";
    SourceTableView = where("Global Dimension No." = const(1));

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
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        DimVal: Record "Dimension Value";
                    begin
                        GLSetup.Get;
                        GLSetup.TestField("Project Dimension Code");
                        DimVal.Reset();
                        DimVal.SetRange("Dimension Code", GLSetup."Project Dimension Code");
                        DimVal.SetRange(Blocked, false);
                        if Page.RunModal(Page::"Dimension Values", DimVal) = Action::LookupOK then begin
                            ProjectCode := DimVal.Code;
                            ValidatePrjCode();
                        end;

                    end;

                    trigger OnValidate()
                    begin
                        ValidatePrjCode();
                        UpdateMatrixSubpage();

                    end;
                }
                field(CPflt; CPflt)
                {
                    ApplicationArea = All;
                    Caption = 'Cost Place';
                    trigger OnValidate()
                    begin
                        UpdateMatrixSubpage();
                    end;
                }
                field(CCflt; CCflt)
                {
                    ApplicationArea = All;
                    Caption = 'Cost Code';
                    trigger OnValidate()
                    begin
                        UpdateMatrixSubpage();
                    end;
                }
                field(PeriodType; PeriodType)
                {
                    ApplicationArea = All;
                    Caption = 'View by';
                    OptionCaption = 'Day,Week,Month,Quarter,Year,Accounting Period,Year3';
                    ToolTip = 'Specifies by which period amounts are displayed.';

                    trigger OnValidate()
                    begin
                        DateFilter := Format(StartingDate) + '..' + Format(CalcDate('<+20Y>', StartingDate));
                        SetColumns(SetWanted::First);
                        UpdateMatrixSubpage();
                        DateFilter := '';
                    end;
                }
                field(StDate; StartingDate)
                {
                    ApplicationArea = All;
                    Caption = 'Starting Date';
                    trigger OnValidate()
                    begin
                        DateFilter := Format(StartingDate) + '..' + Format(CalcDate('<+20Y>', StartingDate));
                        SetColumns(SetWanted::First);
                        UpdateMatrixSubpage();
                        DateFilter := '';
                    end;
                }
                field(sba; NotShowBlankAmounts)
                {
                    ApplicationArea = All;
                    Caption = 'Don''t show blank amounts';
                    trigger OnValidate()
                    begin
                        UpdateMatrixSubpage();
                    end;
                }
            }
            part(MatrixPage; "Summary CF Control Matrix")
            {
                ApplicationArea = All;
                ShowFilter = false;
            }

        }
    }

    actions
    {
        area(processing)
        {
            action("Previous Set")
            {
                ApplicationArea = Location;
                Caption = 'Previous Set';
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Go to the previous set of data.';

                trigger OnAction()
                begin
                    SetColumns(SetWanted::Previous);
                    UpdateMatrixSubpage();
                end;
            }
            action("Next Set")
            {
                ApplicationArea = Location;
                Caption = 'Next Set';
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Go to the next set of data.';

                trigger OnAction()
                begin
                    SetColumns(SetWanted::Next);
                    UpdateMatrixSubpage();
                end;
            }
            action(ImportOB)
            {
                Caption = 'Import Original Budget';
                ApplicationArea = All;
                Visible = false;
                trigger OnAction()
                var
                    lOrBud: Record "Original Budget";
                begin
                    lOrBud.ImportExcel();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        StartingDate := Today;
        DateFilter := Format(StartingDate) + '..' + Format(CalcDate('<+20Y>', StartingDate));
        SetColumns(SetWanted::First);
        UpdateMatrixSubpage();
        DateFilter := '';
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if UserSetup.get(UserId) then begin
            UserSetup."Last Project Code" := ProjectCode;
            UserSetup.Modify(false);
        end;
    end;

    var
        ProjectCode: code[20];
        CPflt: Code[250];
        CCflt: Code[250];
        StartingDate: Date;
        NotShowBlankAmounts: boolean;
        UserSetup: Record "User Setup";
        GLSetup: Record "General Ledger Setup";
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period",Year3;
        SetWanted: Option First,Previous,Same,Next,PreviousColumn,NextColumn;
        MatrixRecords: array[32] of Record Date;
        MatrixColumnCaptions: array[32] of Text[80];
        ColumnSet: Text[80];
        PKFirstRecInCurrSet: Text[80];
        CurrSetLength: Integer;
        DateFilter: Text[1024];

    procedure SetColumns(SetWanted: Option First,Previous,Same,Next,PreviousColumn,NextColumn)
    var
        MatrixMgt: Codeunit "Matrix Management";
        PeriodMgtExt: Codeunit "Period Management Ext";
    begin
        if PeriodType <> PeriodType::Year3 then
            MatrixMgt.GeneratePeriodMatrixData(SetWanted, 6, false, PeriodType, DateFilter,
              PKFirstRecInCurrSet, MatrixColumnCaptions, ColumnSet, CurrSetLength, MatrixRecords)
        else
            PeriodMgtExt.GeneratePeriodMatrixData(SetWanted, 6, false, PeriodType, DateFilter,
              PKFirstRecInCurrSet, MatrixColumnCaptions, ColumnSet, CurrSetLength, MatrixRecords);
    end;

    local procedure UpdateMatrixSubpage();
    begin
        CurrPage.MatrixPage.PAGE.Load(MatrixColumnCaptions, MatrixRecords, CurrSetLength, CPflt,
          CCflt, ProjectCode, StartingDate, NotShowBlankAmounts, 0, PeriodType);
    end;

    local procedure ValidatePrjCode()
    begin
        Rec.SetRange("Project Code", ProjectCode);
    end;

    procedure SetFilters(pProjectCode: code[20]; pCPflt: Code[250]; pCCflt: Code[250]; pStartingDate: Date; pNotShowBlankAmounts: boolean; pPeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period",Year3)
    begin
        ProjectCode := pProjectCode;
        PeriodType := pPeriodType;
        CCflt := pCCflt;
        CPflt := pCPflt;
        StartingDate := pStartingDate;
        NotShowBlankAmounts := pNotShowBlankAmounts;
    end;
}