pageextension 99940 "Excel Templates (Ext)" extends "Excel Templates"
{
    layout
    {
        addafter("File Name")
        {
            field("Sheet Name"; Rec."Sheet Name")
            {
                ApplicationArea = All;

                trigger OnAssistEdit()
                var
                    ExcelBuffer: Record "Excel Buffer Mod";
                begin
                    if Rec.BLOB.HasValue then
                        Rec."Sheet Name" := ExcelBuffer.SelectSheetsName(Rec."File Name");
                end;
            }
        }
    }
}