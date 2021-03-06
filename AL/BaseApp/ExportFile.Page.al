page 26575 "Export File"
{
    Caption = 'Export File';
    PageType = Card;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(FileName; FileName)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'File Name';
                    ToolTip = 'Specifies the name of the file.';

                    trigger OnAssistEdit()
                    var
                        NewFileName: Text[250];
                        WindowTitle: Text[50];
                    begin
                        case FileType of
                            FileType::"Electronic File":
                                WindowTitle := Text001;
                            FileType::"Excel File":
                                WindowTitle := Text002;
                        end;
#if not CLEAN17
                        NewFileName := FileMgt.SaveFileDialog(WindowTitle, FileName, '');
                        if NewFileName <> '' then
                            FileName := NewFileName;
#endif
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        if HiddenFileName <> '' then
            FileName := HiddenFileName;
    end;

    var
#if not CLEAN17
        FileMgt: Codeunit "File Management";
#endif
        FileType: Option "Electronic File","Excel File";
        FileName: Text[250];
        HiddenFileName: Text[250];
        Text001: Label 'Save Electronic File';
        Text002: Label 'Save Excel File';

    [Scope('OnPrem')]
    procedure SetParameters(NewFileName: Text[250]; NewFileType: Option)
    begin
        HiddenFileName := NewFileName;
        FileType := NewFileType;
    end;

    [Scope('OnPrem')]
    procedure GetParameters(var NewFileName: Text[250])
    begin
        NewFileName := FileName;
    end;
}

