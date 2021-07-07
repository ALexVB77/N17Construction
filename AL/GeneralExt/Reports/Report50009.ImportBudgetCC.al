report 50009 "Import Budget CC"
{
    ProcessingOnly = true;
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ToItemBudgetName; ToItemBudgetName)
                    {
                        Visible = false;
                        Caption = 'Budget Name';
                        ApplicationArea = All;
                    }
                    field(Description1; Description1)
                    {
                        Caption = 'Version Description';
                        ApplicationArea = All;
                        Visible = VersionDescVisible;
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            grPrjVesion: Record "Project Version";
                        begin

                            grPrjVesion.SETRANGE("Project Code", ToItemBudgetName);
                            grPrjVesion.SETFILTER("Version Code", '<>%1', 'WORK');
                            IF grPrjVesion.FIND('-') THEN BEGIN
                                IF Page.RUNMODAL(Page::"Projects Version", grPrjVesion) = ACTION::LookupOK THEN BEGIN
                                    VersionCode := grPrjVesion."Version Code";
                                    Description1 := grPrjVesion.Description;
                                END;
                            END;
                        end;
                    }
                    field(ImportOption; ImportOption)
                    {
                        Caption = 'Parametr';
                        ApplicationArea = All;
                        Visible = ParamVisible;
                    }
                    field(Description; Description)
                    {
                        Caption = 'Description';
                        ApplicationArea = All;
                    }
                    field(BuildTurn; BuildTurn)
                    {
                        Visible = false;
                        Caption = 'Build Turn';
                        ApplicationArea = All;
                    }
                    field(FirstLine; FirstLine)
                    {
                        Caption = 'Skip first line';
                        ApplicationArea = All;
                    }
                }
            }
        }
        trigger OnOpenPage()
        begin
            Description := Text005 + FORMAT(WORKDATE) + ' ' + FORMAT(TIME);
            Description1 := '';
            ToItemBudgetName := gCode;
            VersionCode := '';

            ImportOption := 0;
            IF gType = 1 THEN BEGIN
                ParamVisible := FALSE;
                VersionDescVisible := TRUE;
                // //NC 30425, 28312 HR beg
                // IF NewXLSFormatForTargetBudget THEN BEGIN
                //     ImportType := ImportType::"Excel Template";
                //     RequestOptionsForm.cImport.EDITABLE := FALSE;
                //     RequestOptionsForm.SkipReadingFristLine.EDITABLE := FALSE;
                // END;
                // //NC 30425, 28312 HR end
            END ELSE BEGIN
                VersionDescVisible := FALSE;
                ParamVisible := TRUE;
            END;

            IF gType = 6 THEN BEGIN
                // ImportType := ImportType::"Excel Template";
                // RequestOptionsForm.cImport.EDITABLE := FALSE;

                ParamVisible := FALSE;
                VersionDescVisible := TRUE;
            END;
        end;
    }

    trigger OnPreReport()
    begin
        ImportType := ImportType::"excel template";
    end;

    trigger OnPostReport()
    var
        i: integer;
        EndOfLoop: integer;
        Found: boolean;
        xlsNomCode: code[35];
        xlsDate: date;
        xlsNomCodePrev: code[35];
        xlsQuantityTxt: text[30];
        lPCCE: record "Projects Cost Control Entry";
        grNewVersion: record "Project Version";
        CPCode: code[20];
        PostAmount: decimal;
        CostCode: code[20];
        // ProjectsStructureLines: record "Projects Structure Lines";
        // BT: record "Building turn";
        XLSDescr: text[250];
        xlsSumTxt: text[30];
        xlsSum: decimal;
        CostType: code[20];
        LineNo: integer;
        DimValue: record "Dimension Value";
    // ProjectsStructureLines2: record "Projects Structure Lines";
    // BuildingProjectLoc: record "Building project";
    begin
        Uploaded := UploadIntoStream(TextUp001, '', Excel2007FileType, FileName, InStr);
        if not Uploaded then
            exit;
        ExcelBuf.Reset();
        SheetName := ExcelBuf.SelectSheetsNameStream(InStr);
        ExcelBuf.OpenBookStream(InStr, SheetName);
        ExcelBuf.ReadSheet();

        IF gType = 1 THEN BEGIN
            IF VersionCode = '' THEN BEGIN
                gVer := grVer.GetNextVersion;
                grNewVersion."Version Code" := gVer;
                grNewVersion."Project Code" := ToItemBudgetName;
                grNewVersion.Description := Description1;
                grNewVersion.TESTFIELD(Description);
                grNewVersion.INSERT(TRUE);
                gVer := grNewVersion."Version Code";
            END ELSE
                gVer := VersionCode;
        END;

        IF FirstLine THEN
            Var1 := 2
        ELSE
            Var1 := 1;

        IF ImportOption = ImportOption::"Replace entries" THEN BEGIN
            IF gType <> 1 THEN BEGIN
                lPCCE.SETRANGE("Project Code", ToItemBudgetName);
                lPCCE.SETRANGE("Analysis Type", gType);
                // IF BuildTurn <> '' THEN
                //     lPCCE.SETRANGE("Project Turn Code", BuildTurn);
                IF lPCCE.FINDSET THEN
                    lPCCE.DELETEALL(TRUE);
            END ELSE BEGIN
                IF VersionCode <> '' THEN BEGIN
                    lPCCE.SETRANGE("Project Code", ToItemBudgetName);
                    lPCCE.SETRANGE("Analysis Type", gType);
                    lPCCE.SETRANGE("Version Code", VersionCode);
                    // IF BuildTurn <> '' THEN
                    //     lPCCE.SETRANGE("Project Turn Code", BuildTurn);
                    IF lPCCE.FINDSET THEN
                        lPCCE.DELETEALL(TRUE);
                    //SWC274 SM 181114 >>
                    IF gType = lPCCE."Analysis Type"::"Current Budget".AsInteger() THEN BEGIN
                        lPCCE.SETRANGE("Analysis Type", lPCCE."Analysis Type"::Estimate);
                        IF lPCCE.FINDSET THEN
                            lPCCE.DELETEALL(TRUE);
                    END;
                    //SWC274 SM 181114 <<

                    //NC 30425, 28312 HR beg
                    IF
                    // NewXLSFormatForTargetBudget AND 
                    (gType = 1) THEN BEGIN
                        lPCCE.SETRANGE("Analysis Type", lPCCE."Analysis Type"::Forecast);
                        lPCCE.SETRANGE("Imported Form File", TRUE);
                        lPCCE.DELETEALL(TRUE);
                    END;
                    //NC 30425, 28312 HR end

                END;
            END;
        END;



    End;

    var
        FileName: text[250];
        SheetName: text[250];
        ParamVisible: Boolean;
        VersionDescVisible: Boolean;
        Uploaded: Boolean;
        InStr: InStream;
        ExcelBuf: Record "Excel Buffer" temporary;
        TextUp001: Label 'Select file';
        Excel2007FileType: Label 'Excel Files (*.xlsx;*.xls)|*.xlsx;*.xls', Comment = '{Split=r''\|''}{Locked=s''1''}';
        // Text000: Label 'You must specify a budget name to import to.';
        // Text001: Label 'Do you want to create %1 %2.';
        // Text002: Label '%1 %2 is blocked. You cannot import entries.';
        // Text003: Label 'Are you sure you want to %1 for %2 %3.';
        // Text004: Label '%1 table has been successfully updated with %2 entries.';
        Text005: Label 'Imported from Excel ';
        // Text006: Label 'Import Excel File';
        // Text007: Label 'Table Data';
        // Text008: Label 'Show as Lines';
        // Text009: Label 'Show as Columns';
        // Text010: Label 'Replace entries,Add entries';
        // Text011: Label 'The text %1 can only be specified once in the Excel worksheet.';
        // Text012: Label 'The filters specified by worksheet must be placed in the lines before the table.';
        // Text013: Label 'Date Filter';
        // Text014: Label 'Customer Filter';
        // Text015: Label 'Vendor Filter';
        // Text016: Label 'Analyzing Data...\\';
        // Text017: Label 'Item Filter';
        // Text018: Label '%1 is not a valid dimension value.';
        // Text019: Label '%1 is not a valid line definition.';
        // Text020: Label '%1 is not a valid column definition.';
        // Text021: Label 'You must specify a dimension value in row %1, column %2.';
        // Text022: Label 'Значение Измерения CP в таблице Измерение Значение, Код Номер %1 отсутствует\Загрузка отменена';
        // Text023: Label 'Ошибка импорта: ячейка (строка %1, колонка %2) должна сожержать число.';
        // Text024: Label 'Загружено строк бюджета: %1 из %2 строк файла Excel.';
        // Text025: Label 'Некоторые строки не были загружены. Детальная информация в файле лога на экране.';
        ToItemBudgetName: code[10];
        RecNo: integer;
        EntryNo: integer;
        ImportOption: Option "replace entries","add entries";
        Description: text[250];
        gCode: code[20];
        FirstLine: boolean;
        Window: dialog;
        Var1: integer;
        Rows: integer;
        dd: integer;
        StageCode: code[20];
        DimCode: code[10];
        gType: integer;
        cduERPC: codeunit "ERPC Funtions";
        ErrorTXT: text[1000];
        gVer: code[20];
        grVer: record "Project Version";
        Description1: text[250];
        BuildTurn: code[20];
        gvBuildingTurn: record "Building turn";
        ImportType: Option "cmpro template","excel template","estimate template";
        DescriptionEntry: text[250];
        VersionCode: code[20];
        CreateCC: boolean;
        SaveVar1: integer;
        SubStageCode: code[20];
        ELineNo: integer;
        xlsQuantity: decimal;
        EUnitPrice: decimal;
        ElineID: integer;
        EUM: text[10];
        VATAmt: decimal;
        AmtInclVAT: decimal;
        VATprc: decimal;
        NewXLSFormatForTargetBudget: boolean;
        Buff: record "Projects Cost Control Entry" temporary;
        xlDataRowsCount: integer;
        xlAffectedRows: integer;
        CostTemp: record "Projects Article" temporary;

    procedure SetCode(pCode: code[20]; pVer: code[20])
    begin
        gCode := pCode;
        gVer := pVer;
    end;

    procedure SetImportType(pType: integer)
    begin
        gType := pType;
    end;
}