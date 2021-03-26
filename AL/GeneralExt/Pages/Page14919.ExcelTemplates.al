pageextension 94919 "Excel Templates (Ext)" extends "Excel Templates"
{

    actions
    {
        modify("Import Template")
        {
            Visible = false;
        }
        addafter("Import Template")
        {
            action("Import Template New")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Template New';
                Ellipsis = true;
                Image = ImportExcel;

                trigger OnAction()
                var
                    FileMgt: Codeunit "File Management";
                    Filename: Text;
                    TemplateExists: Boolean;
                begin
                    TemplateExists := BLOB.HasValue;
                    Filename := FileMgt.OpenFileDialog(Text002, '', FileMgt.GetToFilterText('', '*.xlsx'));
                    if Filename = '' then
                        exit;
                    FileMgt.ValidateFileExtension(Filename, '.xlsx');
                    if Filename = '' then
                        exit;

                    if TemplateExists then
                        if not Confirm(Text001, false, Code) then
                            exit;
                    Rec.BLOB.Import(Filename);
                    Filename := FileMgt.GetFileName(Filename);

                    UpdateTemplateHeight(Filename);

                    while StrPos(Filename, '\') <> 0 do
                        Filename := CopyStr(Filename, StrPos(Filename, '\') + 1);
                    "File Name" := CopyStr(Filename, 1, MaxStrLen("File Name"));
                    CurrPage.SaveRecord;
                end;
            }
        }
    }

    var
        Text001: Label 'Do you want to replace the existing definition for template %1?';
        Text002: Label 'Import';
}