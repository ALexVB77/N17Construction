page 70143 "Forecast List Analisys"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    InsertAllowed = true;
    DeleteAllowed = false;
    SourceTable = "Projects Budget Entry";
    DelayedInsert = true;
    PopulateAllFields = true;
    Caption = 'Transaction Register';

    layout
    {
        area(Content)
        {
            group(FiltersGr1)
            {
                field(TemplateCode; TemplateCode)
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: text): boolean
                    begin
                        // //NC 27251 HR beg
                        // ProjectStructure.RESET;
                        // ProjectStructure.FILTERGROUP(2);
                        // ProjectStructure.SETRANGE(Template, FALSE);
                        // ProjectStructure.SETFILTER("Development/Production", gcduERPC.GetBldPrjTypeFilter);
                        // ProjectStructure.FILTERGROUP(0);
                        // IF PAGE.RUNMODAL(0, ProjectStructure) = ACTION::LookupOK THEN BEGIN
                        //   TemplateCode := ProjectStructure.Code;
                        //   ValidateProject;
                        // END;
                        // //NC 27251 HR end
                    end;

                    trigger OnValidate()
                    begin
                        TemplateCodeOnAfterValidate; //navnav;

                    end;


                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        CurrTrType: code[20];
        GLSetup: record "General Ledger Setup";
        TemplateName: code[10];
        LineDimOption: Option structure,period,"global dimension 1","global dimension 2";
        ColumnDimOption: Option structure,period,"global dimension 1","global dimension 2";
        LineDimCode: text[30];
        ColumnDimCode: text[30];
        PeriodType: Option day,week,month,quarter,year,"accounting period";
        RoundingFactor: Option "none","1","1000","1000000";
        ShowColumnName: boolean;
        StructAmount: decimal;
        DateFilter: text[30];
        InternalDateFilter: text[30];
        MatrixHeader: text[50];
        PeriodInitialized: boolean;
        InputError: boolean;
        InputErrorText: text[250];
        NormalFormatString: text[80];
        StructLine: record "Projects Structure Lines";
        ProjectStructure: record "Projects Structure";
        gvBuildingTurn: record "Building turn";
        TemplateCode: code[20];
        TemplateDescription: text[250];
        AnalysisType: Option inv,det,est;
        grProjectsStructure: record "Projects Structure";
        JT: record "Projects Structure Lines";
        DevSetup: record "Projects Structure";
        CalcType: Option "0","1","2","3";
        VersionCode: code[20];
        grPrjVesion: record "Project Version";
        grPrjStructure: record "Projects Structure";
        gvAnalysisType: integer;
        grPrjVesionNav: record "Project Version";
        ProjectsStructureLines: record "Projects Structure Lines";
        // ProjectStructureList: page "Project Structure List";
        ProjectsBudgetEntry: record "Projects Budget Entry";
        OldLineNo: integer;
        ProjectsBudgetEntry1: record "Projects Budget Entry";
        // gfTurnStructureAnalisys: page "Turn Structure Analisys";
        AnalysisDataType: Option bdir,bdds;
        gAmountTotal: decimal;
        gcduERPC: codeunit "ERPC Funtions";
        BudgetOnDate: date;
        FixBudget: boolean;
        gAmountTotalBudget: decimal;
        AmountType: Option amount,wamount,vat;
        grProjectsBudgetEntry: record "Projects Budget Entry";
        grProjectsStructureLines: record "Projects Structure Lines";
        grCustomerAgreement: record "Customer Agreement";
        // grInvestmentAgreementLIne: record "Investment Agreement LIne";
        DateFilter1: text[30];
        GLAccBudgetBuf: record "G/L Acc. Budget Buffer";
        CostPlaceFlt: text[200];
        CostCodeFlt: text[200];
        gSorting: Option pdate,pcontrname,costcode;
        Overdue: boolean;
        OnlyOpen: boolean;
        grDevelopmentSetup: record "Development Setup";
        TypeOper: Option all,open,close;
        gDate: date;
        grPrjStrLine: record "Projects Structure Lines";
        // frmAdjustedBudget: page "Adjusted Budget";
        DataType: Option all,act,comm,res,ytb;
        vAgreement: record "Vendor Agreement";
        Delta: decimal;
        grProjectsStructureLines1: record "Projects Structure Lines";
        ProjectVersion: record "Project Version";
        grVendor: record Vendor;
        grVendorAgreement: record "Vendor Agreement";
        OldAgreement: code[20];
        US: record "User Setup";
        TEXT0012: Label 'Operation is bound to document IW \ Amount available for transfer to 1st level =% 1 \ Continue?';
        TEXT0013: Label 'Operation is bound to document IW \ Amount available for transfer to 1st level=% 1 \ Transfer is not possible?';
        TEXT0004: Label 'You must set the Project Code!';
        TEXT0005: Label 'You must set CC!';
        TEXT0006: Label 'The amount of the transaction must be determined!';
        TEXT0007: Label 'Clear contract number!';
        TEXT001: Label 'The Contract Balance Amount has been exceeded!';
        TEXT0008: Label 'You must select the Cash Flow records from which you want to debit this amount.';
        TEXT0009: Label 'Canceled by user.';
        TEXT0010: Label 'Unlink payment from supplier and contract (move to level 1)?';
        TEXT0011: Label 'Operations cannot be deleted!';
        TEXT0014: Label 'You are not allowed to copy actual operations.';
        HideZeroAmountLine: boolean;

    local procedure TemplateCodeOnAfterValidate()
    begin
        ValidateProject;

    end;

    procedure ValidateProject()
    begin
        //NC 27251 HR beg
        // IF TemplateCode = '' THEN
        //   gcduERPC.TestBldProjectCode(TemplateCode, 70072);

        // IF grProjectsStructure.GET(TemplateCode,AnalysisType) THEN BEGIN
        //   gvAnalysisType:=grProjectsStructure.Type;
        //   TemplateDescription:=grProjectsStructure.Description;
        //   CalcType:=grProjectsStructure.Type+1;
        // END ELSE BEGIN
        //   TemplateDescription:='';
        //   CalcType:=0;
        // END;

        // //SETRANGE("Project Code");
        // //FILTERGROUP(2);
        // Rec.SETFILTER("Project Code", TemplateCode);
        // //FILTERGROUP(0);


        // IF Rec.FIND('-') THEN;
        // CurrPage.UPDATE(FALSE); 
        //NC 27251 HR end
    end;
}