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
                        Caption = 'Budget Name';
                        ApplicationArea = All;
                    }
                    field(Description1; Description1)
                    {
                        Caption = 'Version Description';
                        ApplicationArea = All;
                    }
                    field(ImportOption; ImportOption)
                    {
                        Caption = 'Parametr';
                        ApplicationArea = All;
                    }
                    field(Description; Description)
                    {
                        Caption = 'Description';
                        ApplicationArea = All;
                    }
                    field(BuildTurn; BuildTurn)
                    {
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
    }

    trigger OnPreReport()
    begin
        ImportType := ImportType::"excel template";
    end;

    trigger OnPostReport()
    begin

    End;

    var
        FileName: text[250];
        SheetName: text[250];
        // Text000: Label 'You must specify a budget name to import to.';
        // Text001: Label 'Do you want to create %1 %2.';
        // Text002: Label '%1 %2 is blocked. You cannot import entries.';
        // Text003: Label 'Are you sure you want to %1 for %2 %3.';
        // Text004: Label '%1 table has been successfully updated with %2 entries.';
        // Text005: Label 'Imported from Excel ';
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
}