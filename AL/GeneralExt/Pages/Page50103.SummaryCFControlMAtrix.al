page 50103 "Summary CF Control Matrix"
{
    PageType = ListPart;
    SourceTable = "Dimension Value";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field(OriginalBudget; OriginalBudget)
                {
                    Caption = 'Original Budget';
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field(CFTotal; CFTotal)
                {
                    Caption = 'CF Total';
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field(CFTotalUnpaid; CFTotalUnpaid)
                {
                    Caption = 'CF Future (Unpaid)';
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field(Field1; MATRIX_CellData[1])
                {
                    ApplicationArea = Location;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[1];
                    DecimalPlaces = 0 : 5;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    // Visible = Field1Visible;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(1);
                    end;
                }
                field(Field12; MATRIX_CellData[2])
                {
                    ApplicationArea = Location;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[2];
                    DecimalPlaces = 0 : 5;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    // Visible = Field1Visible;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(2);
                    end;
                }
                field(Field3; MATRIX_CellData[3])
                {
                    ApplicationArea = Location;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[3];
                    DecimalPlaces = 0 : 5;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    // Visible = Field1Visible;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(3);
                    end;
                }
                field(Field4; MATRIX_CellData[4])
                {
                    ApplicationArea = Location;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[4];
                    DecimalPlaces = 0 : 5;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    // Visible = Field1Visible;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(4);
                    end;
                }
                field(Field5; MATRIX_CellData[5])
                {
                    ApplicationArea = Location;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[5];
                    DecimalPlaces = 0 : 5;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    // Visible = Field1Visible;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(5);
                    end;
                }
                field(Field6; MATRIX_CellData[6])
                {
                    ApplicationArea = Location;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[6];
                    DecimalPlaces = 0 : 5;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    // Visible = Field1Visible;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(6);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        MATRIX_CurrentColumnOrdinal: Integer;
    begin
        for MATRIX_CurrentColumnOrdinal := 1 to MATRIX_CurrentNoOfMatrixColumn do
            MATRIX_OnAfterGetRecord(MATRIX_CurrentColumnOrdinal);
        NameIndent := Rec.Indentation;
        Emphasize := Rec.Totaling <> '';
        if NotShowBlankAmount then
            Rec.SetRange(Blocked, false)
        else
            Rec.SetRange(Blocked);
    end;

    var
        OriginalBudget: Decimal;
        CFTotal: Decimal;
        CFTotalUnpaid: Decimal;
        MatrixRecords: array[32] of Record Date;
        MATRIX_NoOfMatrixColumns: Integer;
        MATRIX_CellData: array[32] of Decimal;
        MATRIX_ColumnCaption: array[32] of Text[1024];
        [InDataSet]
        Emphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;
        MatrixMgt: Codeunit "Matrix Management";
        CPFilter: Code[250];
        CCFilter: Code[250];
        PrjFilter: Code[20];
        StartingDate: Date;
        NotShowBlankAmount: Boolean;
        RoundingFactorFormatString: Text;
        // RoundingFactor: Option "None","1","1000","1000000";
        MATRIX_CurrentNoOfMatrixColumn: Integer;
        PrjBudEntries: Record "Projects Budget Entry";
        gLineType: Option CP,CC;


    procedure Load(MatrixColumns1: array[32] of Text[1024]; var MatrixRecords1: array[32] of Record Date; CurrentNoOfMatrixColumns: Integer; CPFilter1: Code[250]; CCFilter1: Code[250]; PrjFilter1: Code[20]; StartingDate1: Date; NotShowBlank1: Boolean; LinesType: Option CP,CC)
    var
        i: Integer;
    begin
        for i := 1 to 12 do begin
            if MatrixColumns1[i] = '' then
                MATRIX_ColumnCaption[i] := ' '
            else
                MATRIX_ColumnCaption[i] := MatrixColumns1[i];
            MatrixRecords[i] := MatrixRecords1[i];
        end;
        if MATRIX_ColumnCaption[1] = '' then; // To make this form pass preCAL test

        if CurrentNoOfMatrixColumns > ArrayLen(MATRIX_CellData) then
            MATRIX_CurrentNoOfMatrixColumn := ArrayLen(MATRIX_CellData)
        else
            MATRIX_CurrentNoOfMatrixColumn := CurrentNoOfMatrixColumns;
        CPFilter := CPFilter1;
        CCFilter := CCFilter1;
        PrjFilter := PrjFilter1;
        // RoundingFactor := RoundingFactor1;
        StartingDate := StartingDate1;
        NotShowBlankAmount := NotShowBlank1;
        // RoundingFactorFormatString := MatrixMgt.GetFormatString(RoundingFactor, false);
        gLineType := LinesType;
        InitTable();
        CurrPage.Update(false);
    end;

    local procedure MATRIX_OnDrillDown(ColumnID: Integer)
    var
        CostBudgetEntries: Page "Cost Budget Entries";
    begin
        // SetDateFilter(ColumnID);
        // CostBudgetEntry.SetCurrentKey("Budget Name", "Cost Type No.", "Cost Center Code", "Cost Object Code", Date);
        // if Type in [Type::Total, Type::"End-Total"] then
        //     CostBudgetEntry.SetFilter("Cost Type No.", Totaling)
        // else
        //     CostBudgetEntry.SetRange("Cost Type No.", "No.");
        // CostBudgetEntry.SetFilter("Cost Center Code", CostCenterFilter);
        // CostBudgetEntry.SetFilter("Cost Object Code", CostObjectFilter);
        // CostBudgetEntry.SetFilter("Budget Name", BudgetFilter);
        // CostBudgetEntry.SetFilter(Date, GetFilter("Date Filter"));
        // CostBudgetEntry.FilterGroup(26);
        // CostBudgetEntry.SetFilter(Date, '..%1|%1..', MatrixRecords[ColumnID]."Period Start");
        // CostBudgetEntry.FilterGroup(0);

        // CostBudgetEntries.SetCurrRegNo(CurrRegNo);
        // CostBudgetEntries.SetTableView(CostBudgetEntry);
        // CostBudgetEntries.RunModal;
        // CurrRegNo := CostBudgetEntries.GetCurrRegNo;
        // CurrPage.Update(false);
    end;

    local procedure MATRIX_OnAfterGetRecord(ColumnID: Integer)
    begin
        SetFilters(ColumnID, 2);
        PrjBudEntries.CalcSums("Without VAT (LCY)");
        // MATRIX_CellData[ColumnID] := MatrixMgt.RoundValue(PrjBudEntries."Without VAT (LCY)", RoundingFactor);
        MATRIX_CellData[ColumnID] := PrjBudEntries."Without VAT (LCY)";
    end;

    local procedure SetFilters(ColumnID: Integer; pAmtType: Option All,Actuals,Unpaid)
    begin
        PrjBudEntries.SetRange(Date, MatrixRecords[ColumnID]."Period Start", MatrixRecords[ColumnID]."Period End");
        PrjBudEntries.SetRange("Project Code", PrjFilter);
        case gLineType of
            gLineType::CP:
                begin
                    PrjBudEntries.SetFilter("Shortcut Dimension 1 Code", Rec.Code);
                    PrjBudEntries.SetFilter("Shortcut Dimension 2 Code", CCFilter);
                end;
            gLineType::CC:
                begin
                    PrjBudEntries.SetFilter("Shortcut Dimension 1 Code", CPFilter);
                    PrjBudEntries.SetFilter("Shortcut Dimension 2 Code", Rec.Code);
                end;
        end;
        PrjBudEntries.SetRange(Reversed, false);
        case pAmtType of
            pAmtType::All:
                PrjBudEntries.SetRange(Close);
            pAmtType::Actuals:
                PrjBudEntries.SetRange(Close, true);
            pAmtType::Unpaid:
                PrjBudEntries.SetRange(Close, false);
        end;

    end;

    local procedure InitTable()
    var
        DimVal: Record "Dimension Value";
    begin
        Rec.Reset();
        Rec.DeleteAll();
        DimVal.Reset();
        DimVal.SetRange(Blocked, false);
        DimVal.SetRange("Global Dimension No.", gLineType + 1);
        if DimVal.FindSet() then
            repeat
                Rec.Init();
                Rec := DimVal;
                SetFilters(1, 0);
                PrjBudEntries.SetRange(Date, MatrixRecords[1]."Period Start", MatrixRecords[6]."Period End");
                PrjBudEntries.CalcSums("Without VAT (LCY)");
                if PrjBudEntries."Without VAT (LCY)" = 0 then
                    Rec.Blocked := true;
                Rec.Insert(false);
            until DimVal.Next() = 0;
    end;
}