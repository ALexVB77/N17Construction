xmlport 1220 "Data Exch. Import - CSV"
{
    Caption = 'Data Exch. Import - CSV';
    Direction = Import;
    Format = VariableText;
    Permissions = TableData "Data Exch. Field" = rimd;
    TextEncoding = WINDOWS;
    UseRequestPage = false;

    schema
    {
        textelement(root)
        {
            MinOccurs = Zero;
            tableelement("Data Exch."; "Data Exch.")
            {
                AutoSave = false;
                XmlName = 'DataExchDocument';
                textelement(col1)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    XmlName = 'col1';

                    trigger OnAfterAssignVariable()
                    begin
                        ColumnNo := 1;
                        CheckLineType;
                        if not ColumnsAsRows then
                            InsertColumn(ColumnNo, col1);
                    end;
                }
                textelement(colx)
                {
                    MinOccurs = Zero;
                    Unbound = true;
                    XmlName = 'colx';

                    trigger OnAfterAssignVariable()
                    begin
                        if ColumnsAsRows then
                            InsertColumn(ColumnAsRowNo, colx)
                        else begin
                            ColumnNo += 1;
                            InsertColumn(ColumnNo, colx);
                        end;
                    end;
                }

                trigger OnAfterInitRecord()
                begin
                    FileLineNo += 1;
                end;

                trigger OnBeforeInsertRecord()
                begin
                    ValidateHeaderTag;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPostXmlPort()
    begin
        if not ColumnsAsRows then
            if (not LastLineIsFooter and SkipLine) or HeaderWarning then
                Error(LastLineIsHeaderErr);
    end;

    trigger OnPreXmlPort()
    begin
        InitializeGlobals;
    end;

    var
        DataExchField: Record "Data Exch. Field";
        DataExchEntryNo: Integer;
        ImportedLineNo: Integer;
        FileLineNo: Integer;
        HeaderLines: Integer;
        HeaderLineCount: Integer;
        ColumnNo: Integer;
        HeaderTag: Text;
        FooterTag: Text;
        SkipLine: Boolean;
        LastLineIsFooter: Boolean;
        HeaderWarning: Boolean;
        LineType: Option Unknown,Header,Footer,Data;
        CurrentLineType: Option;
        FullHeaderLine: Text;
        LastLineIsHeaderErr: Label 'The imported file contains unexpected formatting. One or more lines may be missing in the file.';
        WrongHeaderErr: Label 'The imported file contains unexpected formatting. One or more headers are incorrect.';
        ColumnsAsRows: Boolean;
        DocumentStartTag: Text;
        DataExchDefCode: Code[20];
        ColumnAsRowNo: Integer;
        DataExchLineDefCode: Code[20];

    local procedure InitializeGlobals()
    var
        DataExchDef: Record "Data Exch. Def";
    begin
        DataExchEntryNo := "Data Exch.".GetRangeMin("Entry No.");
        "Data Exch.".Get(DataExchEntryNo);
        DataExchLineDefCode := "Data Exch."."Data Exch. Line Def Code";
        DataExchDef.Get("Data Exch."."Data Exch. Def Code");
        HeaderLines := DataExchDef."Header Lines";
        ImportedLineNo := 0;
        FileLineNo := 0;
        HeaderTag := DataExchDef."Header Tag";
        FooterTag := DataExchDef."Footer Tag";
        HeaderLineCount := 0;
        CurrentLineType := LineType::Unknown;
        FullHeaderLine := '';
        currXMLport.FieldSeparator(DataExchDef.ColumnSeparatorChar);
        case DataExchDef."File Encoding" of
            DataExchDef."File Encoding"::"MS-DOS":
                currXMLport.TextEncoding(TEXTENCODING::MSDos);
            DataExchDef."File Encoding"::"UTF-8":
                currXMLport.TextEncoding(TEXTENCODING::UTF8);
            DataExchDef."File Encoding"::"UTF-16":
                currXMLport.TextEncoding(TEXTENCODING::UTF16);
            DataExchDef."File Encoding"::WINDOWS:
                currXMLport.TextEncoding(TEXTENCODING::Windows);
        end;
        DataExchDefCode := DataExchDef.Code;
        ColumnsAsRows := DataExchDef."Columns as Rows";
        if ColumnsAsRows then
            DocumentStartTag := DataExchDef."Document Start Tag";
    end;

    local procedure CheckLineType()
    begin
        IdentifyLineType;
        ValidateNonDataLine;
        TrackNonDataLines;
        SkipLine := CurrentLineType <> LineType::Data;

        if not SkipLine then begin
            HeaderLineCount := 0;
            if ColumnsAsRows then begin
                if col1 = DocumentStartTag then
                    ImportedLineNo += 1;
            end else
                ImportedLineNo += 1;
        end else
            if ColumnsAsRows then
                if col1 = DocumentStartTag then
                    ImportedLineNo += 1;
    end;

    local procedure IdentifyLineType()
    begin
        case true of
            FileLineNo <= HeaderLines:
                CurrentLineType := LineType::Header;
            (HeaderTag <> '') and (StrLen(col1) <= HeaderTagLength) and (StrPos(HeaderTag, col1) = 1):
                CurrentLineType := LineType::Header;
            (FooterTag <> '') and (StrLen(col1) <= FooterTagLength) and (StrPos(FooterTag, col1) = 1):
                CurrentLineType := LineType::Footer;
            else begin
                    if ColumnsAsRows then
                        IdentifyLineTypeByColumnName
                    else
                        CurrentLineType := LineType::Data;
                end;
        end;
    end;

    local procedure ValidateNonDataLine()
    begin
        if CurrentLineType = LineType::Header then begin
            if (HeaderTag <> '') and (StrLen(col1) <= HeaderTagLength) and (StrPos(HeaderTag, col1) = 0) then
                Error(WrongHeaderErr);
        end;
    end;

    local procedure TrackNonDataLines()
    begin
        case CurrentLineType of
            LineType::Header:
                begin
                    HeaderLineCount += 1;
                    if not HeaderWarning and (HeaderLines > 0) and (HeaderLineCount > HeaderLines) then
                        HeaderWarning := true;
                end;
            LineType::Data:
                if (HeaderLines > 0) and (HeaderLineCount > 0) and (HeaderLineCount < HeaderLines) then
                    HeaderWarning := true;
            LineType::Footer:
                LastLineIsFooter := true;
        end;
    end;

    local procedure HeaderTagLength(): Integer
    var
        DataExchDef: Record "Data Exch. Def";
    begin
        exit(GetFieldLength(DATABASE::"Data Exch. Def", DataExchDef.FieldNo("Header Tag")));
    end;

    local procedure FooterTagLength(): Integer
    var
        DataExchDef: Record "Data Exch. Def";
    begin
        exit(GetFieldLength(DATABASE::"Data Exch. Def", DataExchDef.FieldNo("Footer Tag")));
    end;

    local procedure GetFieldLength(TableNo: Integer; FieldNo: Integer): Integer
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
    begin
        RecRef.Open(TableNo);
        FieldRef := RecRef.Field(FieldNo);
        exit(FieldRef.Length);
    end;

    local procedure InsertColumn(columnNumber: Integer; var columnValue: Text)
    var
        savedColumnValue: Text;
    begin
        savedColumnValue := columnValue;
        columnValue := '';
        if SkipLine then begin
            if (CurrentLineType = LineType::Header) and (HeaderTag <> '') then
                FullHeaderLine += savedColumnValue + ';';
            exit;
        end;
        if savedColumnValue <> '' then begin
            DataExchField.Init();
            DataExchField.Validate("Data Exch. No.", DataExchEntryNo);
            DataExchField.Validate("Line No.", ImportedLineNo);
            DataExchField.Validate("Column No.", columnNumber);
            DataExchField.Validate(Value, CopyStr(savedColumnValue, 1, MaxStrLen(DataExchField.Value)));
            DataExchField.Validate("Data Exch. Line Def Code", DataExchLineDefCode);
            DataExchField.Insert(true);
        end;
    end;

    local procedure ValidateHeaderTag()
    begin
        if SkipLine and (CurrentLineType = LineType::Header) and (HeaderTag <> '') then
            if StrPos(FullHeaderLine, HeaderTag) = 0 then
                Error(WrongHeaderErr);
    end;

    local procedure IdentifyLineTypeByColumnName()
    var
        DataExchColDef: Record "Data Exch. Column Def";
        DataExchFieldMapping: Record "Data Exch. Field Mapping";
    begin
        with DataExchColDef do begin
            SetRange("Data Exch. Def Code", DataExchDefCode);
            SetRange(Name, col1);
            if FindFirst then begin
                DataExchFieldMapping.SetRange("Data Exch. Def Code", "Data Exch. Def Code");
                DataExchFieldMapping.SetRange("Data Exch. Line Def Code", "Data Exch. Line Def Code");
                DataExchFieldMapping.SetRange("Column No.", "Column No.");
                if not DataExchFieldMapping.IsEmpty then begin
                    ColumnAsRowNo := "Column No.";
                    CurrentLineType := LineType::Data;
                    exit;
                end;
            end;
        end;
        CurrentLineType := LineType::Unknown;
    end;
}

