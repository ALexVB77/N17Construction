pageextension 80539 "MyDim Value Comb Ext" extends "MyDim Value Combinations"
{
    layout
    {
        addafter(ShowColumnName)
        {
            field(ColFilter; ColFilter)
            {
                Caption = 'Column Filter';
                //Visible = true;
                ApplicationArea = All;
                trigger OnLookup(var Text: Text): Boolean
                var
                    IsoMgt: Codeunit "Isolated Storage Management GE";
                    TmpStr1: Text;
                    TmpStr2: Text;
                    SetWanted: Option Initial,Previous,Same,Next,PreviousColumn,NextColumn;
                    DimensionValueList: Page "Dimension Value List";
                    DimensionValue: Record "Dimension Value";
                begin
                    IsoMgt.getBool('ShowCaptionFromPage', ShowNames, true);
                    IsoMgt.getString('RowFromPage', TmpStr1, true);
                    Evaluate(Row, TmpStr1);
                    IsoMgt.getString('ColFromPage', TmpStr2, true);
                    Evaluate(Col, TmpStr2);
                    CLEAR(DimensionValueList);

                    DimensionValue.Reset();
                    DimensionValue.SetRange(DimensionValue."Dimension Code", Col);

                    DimensionValueList.SetTableView(DimensionValue);
                    DimensionValueList.LookupMode := TRUE;

                    if DimensionValueList.RunModal() = Action::LookupOK then begin
                        ColFilter := DimensionValueList.GetSelectionFilter;
                        IsoMgt.init();
                        IsoMgt.setString('DimValColumnFilter', ColFilter);

                    end;
                    Load(Row, Col, ShowNames);
                    MATRIX_GenerateColumnCaptions(SetWanted::Initial);
                    UpdateMatrixSubform();
                end;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addlast(processing)
        {
            /*action( Tetbutton)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Message(MatrixRecord.Code);
                end;
            }*/

        }

    }

    var
        //MatrixRecord: Record "Dimension Value";
        Row: Code[20];
        Col: Code[20];
        ShowNames: Boolean;
        ColFilter: Code[20];
}