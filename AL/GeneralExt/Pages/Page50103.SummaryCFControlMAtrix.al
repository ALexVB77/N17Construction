page 50103 "Summary CF Control Matrix"
{
    PageType = ListPart;
    SourceTable = "Dimension Value";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;

                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(OriginalBudget; OriginalBudget)
                {
                    Caption = 'Original Budget';
                    ApplicationArea = All;
                }
                field(CFTotal; CFTotal)
                {
                    Caption = 'CF Total';
                    ApplicationArea = All;
                }
                field(CFTotalUnpaid; CFTotalUnpaid)
                {
                    Caption = 'CF Future (Unpaid)';
                    ApplicationArea = All;
                }
                field(Field1; MATRIX_CellData[1])
                {
                    ApplicationArea = Location;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[1];
                    DecimalPlaces = 0 : 5;
                    // Visible = Field1Visible;

                    trigger OnDrillDown()
                    begin
                        // MatrixOnDrillDown(1);
                    end;
                }
                field(Field12; MATRIX_CellData[2])
                {
                    ApplicationArea = Location;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[2];
                    DecimalPlaces = 0 : 5;
                    // Visible = Field1Visible;

                    trigger OnDrillDown()
                    begin
                        // MatrixOnDrillDown(2);
                    end;
                }
                field(Field3; MATRIX_CellData[3])
                {
                    ApplicationArea = Location;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[3];
                    DecimalPlaces = 0 : 5;
                    // Visible = Field1Visible;

                    trigger OnDrillDown()
                    begin
                        // MatrixOnDrillDown(3);
                    end;
                }
                field(Field4; MATRIX_CellData[4])
                {
                    ApplicationArea = Location;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[4];
                    DecimalPlaces = 0 : 5;
                    // Visible = Field1Visible;

                    trigger OnDrillDown()
                    begin
                        // MatrixOnDrillDown(4);
                    end;
                }
                field(Field5; MATRIX_CellData[5])
                {
                    ApplicationArea = Location;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[5];
                    DecimalPlaces = 0 : 5;
                    // Visible = Field1Visible;

                    trigger OnDrillDown()
                    begin
                        // MatrixOnDrillDown(5);
                    end;
                }
            }
        }
    }
    var
        OriginalBudget: Decimal;
        CFTotal: Decimal;
        CFTotalUnpaid: Decimal;
        MatrixRecord: Record Date;
        TempMatrixLocation: Record Location temporary;
        MATRIX_NoOfMatrixColumns: Integer;
        MATRIX_CellData: array[5] of Decimal;
        MATRIX_ColumnCaption: array[5] of Text[1024];
}