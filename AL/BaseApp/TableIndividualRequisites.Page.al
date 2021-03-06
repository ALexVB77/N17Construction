page 26555 "Table Individual Requisites"
{
    AutoSplitKey = true;
    Caption = 'Table Individual Requisites';
    DelayedInsert = true;
    PageType = Worksheet;
    SourceTable = "Table Individual Requisite";

    layout
    {
        area(content)
        {
            repeater(Control1210000)
            {
                ShowCaption = false;
                field(Description; Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the description associated with the individual table requisite.';
                }
                field("Row Code"; "Row Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the row code associated with the individual table requisite.';
                }
                field("Column No."; "Column No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a number for the column in the view.';
                }
                field("Requisites Group Name"; "Requisites Group Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the requisites group name associated with the individual table requisite.';
                }
                field(Bold; Bold)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if you want the amounts in this line to be printed in bold.';
                }
                field(IntDataSourceCellMapping; IntDataSourceCellMapping)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Int. Data Source Cell Mapping';

                    trigger OnAssistEdit()
                    begin
                        StatReportTableMapping.ShowMappingCard(
                          "Report Code",
                          "Table Code",
                          "Line No.",
                          0,
                          IntDataSourceCellMapping);
                    end;

                    trigger OnValidate()
                    begin
                        if IntDataSourceCellMapping = '' then
                            if StatReportTableMapping.Get("Report Code", "Table Code", "Line No.", 0) then
                                StatReportTableMapping.Delete();
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        IntDataSourceCellMapping := '';
        if StatReportTableMapping.Get("Report Code", "Table Code", "Line No.", 0) then
            IntDataSourceCellMapping := StatReportTableMapping.GetRecDescription;
    end;

    var
        StatReportTableMapping: Record "Stat. Report Table Mapping";
        IntDataSourceCellMapping: Text[250];
}

