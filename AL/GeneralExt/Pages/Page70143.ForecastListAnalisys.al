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
                    Caption = 'Code';
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
                field(TemplateDescription; TemplateDescription)
                {
                    Editable = false;
                    ApplicationArea = All;

                }
            }
            group(FilterGr2)
            {
                field(DateFilter1; DateFilter1)
                {
                    ApplicationArea = All;
                    Caption = 'Date Filter';
                    // trigger OnValidate()
                    // var 
                    //     ApplicationManagement: codeunit ApplicationManagement;
                    // begin
                    //     DateFilter1OnAfterValidate; //navnav;

                    //     IF ApplicationManagement.MakeDateFilter(DateFilter1) = 0 THEN;
                    //     GLAccBudgetBuf.SETFILTER("Date Filter",DateFilter1);
                    //     DateFilter1 := GLAccBudgetBuf.GETFILTER("Date Filter");
                    // end;


                }

                field(CostPlaceFlt; CostPlaceFlt)
                {
                    ApplicationArea = All;
                    Caption = 'COST PLACE';
                    trigger OnLookup(var Text: text): boolean
                    begin
                        // gvBuildingTurn.SETRANGE("Building project Code", "Project Code");
                        // IF gvBuildingTurn.FINDFIRST THEN BEGIN
                        //     IF PAGE.RUNMODAL(PAGE::"Dev Building turn", gvBuildingTurn) = ACTION::LookupOK THEN BEGIN
                        //         CostPlaceFlt := gvBuildingTurn.Code;
                        //         SETFILTER("Building Turn", CostPlaceFlt);
                        //         CurrPage.UPDATE;
                        //         CurrPage.UPDATECONTROLS;
                        //     END;
                        // END;
                    end;

                    trigger OnValidate()
                    begin
                        // CostPlaceFltOnAfterValidate; //navnav;

                    end;


                }

                field(CostCodeFlt; CostCodeFlt)
                {
                    ApplicationArea = All;
                    Caption = 'COST CODE';
                    trigger OnValidate()
                    var
                        _PSL: record "Projects Structure Lines";
                    begin
                        // CostCodeFltOnAfterValidate; //navnav;

                        // //NC 37278 17-09-2019 HR beg
                        // IF CostCodeFlt <> '' THEN BEGIN
                        //     _PSL.SETRANGE("Project Code", "Project Code");
                        //     _PSL.SETRANGE(Version, GetDefVersion1(TemplateCode));
                        //     _PSL.SETRANGE("Structure Post Type", _PSL."Structure Post Type"::Posting);
                        //     _PSL.SETFILTER(Code, CostCodeFlt);
                        //     IF _PSL.ISEMPTY THEN
                        //         ERROR('Статья бюджета %1 не существует', CostCodeFlt);
                        // END;
                        // //NC 37278 17-09-2019 HR end
                    end;

                    trigger OnLookup(var Text: text): boolean
                    begin
                        grProjectsStructureLines1.SETRANGE("Project Code", "Project Code");
                        grProjectsStructureLines1.SETRANGE(Version, GetDefVersion1(TemplateCode));
                        grProjectsStructureLines1.SETRANGE("Structure Post Type", grProjectsStructureLines1."Structure Post Type"::Posting);
                        IF grProjectsStructureLines1.FINDFIRST THEN BEGIN
                            IF grProjectsStructureLines1.GET("Project Code", "Analysis Type", "Version Code", "Line No.") THEN;

                            IF PAGE.RUNMODAL(PAGE::"Projects Article List", grProjectsStructureLines1) = ACTION::LookupOK THEN BEGIN
                                CostCodeFlt := grProjectsStructureLines1.Code;
                                SETFILTER("Shortcut Dimension 2 Code", CostCodeFlt);
                                CurrPage.UPDATE;
                            END;
                        END;
                    end;


                }

                field(Overdue; Overdue)
                {
                    ApplicationArea = All;
                    Caption = 'Overdue';
                    trigger OnValidate()
                    begin
                        // OverdueOnAfterValidate; //navnav;

                    end;


                }

                field(gDate; gDate)
                {
                    ApplicationArea = All;
                    Caption = 'Overdue on Date';
                    trigger OnValidate()
                    begin
                        // gDateOnAfterValidate; //navnav;

                    end;


                }

                field(HideZeroAmountLine; HideZeroAmountLine)
                {
                    ShowCaption = false;
                    ApplicationArea = All;
                    Caption = 'Don''t show zero amount lines';
                    trigger OnValidate()
                    begin
                        // HideZeroAmountLineOnAfterValidate; //navnav;

                    end;


                }
            }
            repeater(Repeater12370003)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    Editable = false;
                    ApplicationArea = All;

                }

                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                    Editable = false;
                    ApplicationArea = All;

                }
                field(Close; Rec.Close)
                {
                    Editable = false;
                    ShowCaption = false;
                    ApplicationArea = All;
                    Caption = 'Actual Flag';
                    trigger OnValidate()
                    begin
                        // CloseOnAfterValidate; //navnav;

                    end;


                }

                field("Date"; Rec.Date)
                {
                    Editable = true;
                    NotBlank = true;
                    ApplicationArea = All;
                    Caption = 'Date';
                    trigger OnValidate()
                    begin
                        // DateOnAfterValidate; //navnav;

                        //NC 27251 HR beg
                        //CheckUniqMonthCFLine;
                        //NC 27251 HR end
                    end;


                }

                field("Project Code"; Rec."Project Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Caption = 'Project Code';

                }
                field("Cost Code"; Rec."Cost Code")
                {
                    Editable = false;
                    ApplicationArea = All;

                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Visible = false;
                    Editable = false;
                    ApplicationArea = All;

                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = false;
                    ApplicationArea = All;

                }
                field(Description; Rec.Description)
                {
                    Editable = true;
                    ApplicationArea = All;
                    Caption = 'Description';
                    trigger OnAssistEdit()
                    var
                        lrPL: record "Purchase Line";
                        lrPH: record "Purchase Header";
                    begin
                        IF Close THEN BEGIN
                            lrPL.SETCURRENTKEY("Forecast Entry");
                            lrPL.SETRANGE("Forecast Entry", "Entry No.");
                            IF lrPL.FINDFIRST THEN BEGIN
                                lrPH.SETRANGE("Document Type", lrPL."Document Type");
                                lrPH.SETRANGE("No.", lrPL."Document No.");
                                IF lrPH.FINDFIRST THEN BEGIN
                                    PAGE.RUN(70000, lrPH);

                                END;
                            END;
                        END;
                    end;


                }
                field("Description 2"; Rec."Description 2")
                {
                    Editable = true;
                    ApplicationArea = All;
                    Caption = 'Description 2';

                }
                field("Without VAT (LCY)"; Rec."Without VAT (LCY)")
                {
                    Visible = true;
                    Editable = false;
                    ApplicationArea = All;

                }
                field("Contragent No."; Rec."Contragent No.")
                {
                    Editable = true;
                    ApplicationArea = All;
                    Caption = 'Vendor No.';
                    trigger OnValidate()
                    begin
                        //NC 27251 HR beg
                        //CheckUniqMonthCFLine;
                        //NC 27251 HR end
                    end;

                    trigger OnLookup(var Text: text): boolean
                    begin

                        IF grVendor.FINDFIRST THEN BEGIN
                            IF grVendor.GET("Contragent No.") THEN;
                            IF PAGE.RUNMODAL(PAGE::"Vendor List", grVendor) = ACTION::LookupOK THEN BEGIN
                                Rec.VALIDATE("Contragent No.", grVendor."No.");
                            END;
                        END;
                    end;
                }
                field(CName; Rec."Contragent Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Caption = 'Vendor Name';

                }
                field("Agreement No."; Rec."Agreement No.")
                {
                    Editable = true;
                    ApplicationArea = All;
                    Caption = 'Agreement No.';
                    trigger OnLookup(var Text: text): boolean
                    var
                        lrProjectsBudgetEntry: record "Projects Budget Entry";
                        lfCFCorrection: page "Forecast List Analisys Correct";
                    begin
                        CurrPage.SAVERECORD;
                        COMMIT;
                        grVendorAgreement.SETRANGE("Vendor No.", Rec."Contragent No.");
                        grVendorAgreement.SETRANGE(Active, TRUE);
                        IF grVendorAgreement.FINDFIRST THEN BEGIN
                            IF grVendorAgreement.GET("Contragent No.", "Agreement No.") THEN;
                            IF PAGE.RUNMODAL(PAGE::"Vendor Agreements", grVendorAgreement) = ACTION::LookupOK THEN BEGIN
                                IF grVendorAgreement."No." <> '' THEN BEGIN
                                    IF Rec."Building Turn" = '' THEN BEGIN
                                        MESSAGE(TEXT0004);
                                        EXIT;
                                    END;

                                    //NC 28666 HR beg
                                    //IF "Cost Code"  = '' THEN
                                    //BEGIN
                                    //  MESSAGE(TEXT0005);
                                    //  EXIT;
                                    //END;
                                    IF (NOT IsProductionProject) AND (Rec."Cost Code" = '') THEN BEGIN
                                        MESSAGE(TEXT0005);
                                        EXIT;
                                    END;
                                    //NC 28666 HR end

                                    IF Rec."Without VAT" = 0 THEN BEGIN
                                        MESSAGE(TEXT0006);
                                        EXIT;
                                    END;
                                END;

                                Delta := Amount;
                                vAgreement.GET("Contragent No.", grVendorAgreement."No.");
                                // IF NOT vAgreement.Virtual THEN   // CHECK
                                if true then BEGIN
                                    // SWC DD 20.07.17 >>
                                    IF NOT vAgreement."Don't Check CashFlow" THEN
                                        // SWC DD 20.07.17 <<
                                        //   IF Delta>(vAgreement."Agreement Amount"-GetAmount(grVendorAgreement."No.")) THEN
                                        //   BEGIN
                                        //     MESSAGE(TEXT001);
                                        //     EXIT;
                                        //   END;


                                        VALIDATE("Agreement No.", grVendorAgreement."No.");
                                    IF ("Agreement No." <> '') AND (xRec."Agreement No." = '') THEN BEGIN
                                        //NC 29435 HR beg
                                        ////NC 28666 HR beg
                                        //IF NOT (IsProductionProject AND ("Cost Code" = '')) THEN BEGIN
                                        ////NC 28666 HR end
                                        IF NOT IsProductionProject THEN BEGIN
                                            //NC 29435 HR end

                                            MESSAGE(TEXT0008);
                                            CLEAR(lfCFCorrection);
                                            lfCFCorrection.LOOKUPMODE := TRUE;
                                            lrProjectsBudgetEntry.SETCURRENTKEY(Date);
                                            lrProjectsBudgetEntry.SETRANGE("Project Code", "Project Code");
                                            lrProjectsBudgetEntry.SETRANGE("Project Turn Code", "Project Turn Code");
                                            lrProjectsBudgetEntry.SETRANGE("Cost Code", "Cost Code");
                                            lrProjectsBudgetEntry.SETFILTER("Contragent No.", '%1|%2', '', "Contragent No.");
                                            lrProjectsBudgetEntry.SETRANGE("Agreement No.", '');
                                            lrProjectsBudgetEntry.SETFILTER("Entry No.", '<>%1', "Entry No.");
                                            lrProjectsBudgetEntry.SETRANGE(NotVisible, FALSE);
                                            IF lrProjectsBudgetEntry.FINDFIRST THEN;
                                            lfCFCorrection.SETTABLEVIEW(lrProjectsBudgetEntry);
                                            lfCFCorrection.SetData(Rec);
                                            IF lfCFCorrection.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                                // SetSum;
                                            END
                                            ELSE BEGIN
                                                // ClearSum;
                                                Rec.VALIDATE("Agreement No.", OldAgreement);
                                                MESSAGE(TEXT0009);
                                            END;
                                        END; //NC 28666 HR <>
                                    END;
                                END
                                ELSE
                                    VALIDATE("Agreement No.", grVendorAgreement."No.");

                            END;
                        END;
                        OldAgreement := "Agreement No.";
                        CurrPage.UPDATE;
                    end;

                    trigger OnValidate()
                    begin
                        // AgreementNoOnAfterValidate; //navnav;

                    end;


                }

                field(AE; Rec."External Agreement No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Caption = 'External Agreement No.';

                }
                field("Payment Doc. No."; Rec."Payment Doc. No.")
                {
                    Visible = true;
                    Editable = false;
                    ApplicationArea = All;

                }

                field("Create User"; Rec."Create User")
                {
                    ApplicationArea = All;

                }
                field("Parent Entry"; Rec."Parent Entry")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {

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
        TEXT0013: Label 'Operation is bound to document IW \ Amount available for transfer to 1st level=% 1 \ Transfer is not possible!';
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