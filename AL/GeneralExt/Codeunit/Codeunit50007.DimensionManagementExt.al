codeunit 50007 "Dimension Management (Ext)"
{
    procedure valDimValue(DimCode: Code[20]; DimValCode: Code[20]; var DimSetID: Integer)
    var
        DimensionManagement: Codeunit DimensionManagement;
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        DimensionManagement.GetDimensionSet(TempDimSetEntry, DimSetID);
        IF TempDimSetEntry.GET(TempDimSetEntry."Dimension Set ID", DimCode) THEN
            IF TempDimSetEntry."Dimension Value Code" <> DimValCode THEN
                TempDimSetEntry.DELETE;
        IF DimValCode <> '' THEN BEGIN
            TempDimSetEntry."Dimension Code" := DimCode;
            TempDimSetEntry."Dimension Value Code" := DimValCode;
            IF TempDimSetEntry.INSERT(TRUE) THEN;
        END;
        DimSetID := DimensionManagement.GetDimensionSetID(TempDimSetEntry);
    end;
}