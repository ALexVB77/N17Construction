table 17220 "Tax Register Norm Jurisdiction"
{
    Caption = 'Tax Register Norm Jurisdiction';
    LookupPageID = "Tax Reg. Norm Jurisdictions";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description)
        {
        }
    }

    trigger OnDelete()
    var
        TaxRegNormGroup: Record "Tax Register Norm Group";
        TaxRegNormTerm: Record "Tax Reg. Norm Term";
    begin
        TaxRegNormGroup.SetRange("Norm Jurisdiction Code", Code);
        TaxRegNormGroup.DeleteAll(true);

        TaxRegNormTerm.SetRange("Norm Jurisdiction Code", Code);
        TaxRegNormTerm.DeleteAll(true);
    end;

    var
        FileMgt: Codeunit "File Management";
        FileName: Text;
        Text001: Label 'Import File';
        Text002: Label 'Export File';

#if not CLEAN17
    [Scope('OnPrem')]
    [Obsolete('Does nothing on non-Windows client.', '17.4')]
    procedure ExportSettings(var TaxRegNormJurisdiction: Record "Tax Register Norm Jurisdiction")
    var
        NormJurisdictionSettings: XMLport "Norm Jurisdiction";
        OutputFile: File;
        OutStr: OutStream;
        ServerFileName: Text;
    begin
        FileName := FileMgt.SaveFileDialog(Text002, '.xml', '');
        if (FileName = '') or (FileName = '*.xml') then
            exit;

        ServerFileName := FileMgt.ServerTempFileName('xml');

        OutputFile.Create(ServerFileName);
        OutputFile.CreateOutStream(OutStr);
        NormJurisdictionSettings.SetDestination(OutStr);
        NormJurisdictionSettings.SetData(TaxRegNormJurisdiction);
        NormJurisdictionSettings.Export;
        OutputFile.Close;
        Clear(OutStr);

        FileMgt.DownloadToFile(ServerFileName, FileName);
    end;
#endif

    [Scope('OnPrem')]
    procedure ImportSettings(FileName: Text)
    var
        NormJurisdictionSettings: XMLport "Norm Jurisdiction";
        InputFile: File;
        InStr: InStream;
    begin
        InputFile.Open(FileName);
        InputFile.CreateInStream(InStr);
        NormJurisdictionSettings.SetSource(InStr);
        NormJurisdictionSettings.Import;
        NormJurisdictionSettings.ImportData;
        InputFile.Close;
        Clear(InStr);
    end;

    [Scope('OnPrem')]
    procedure PromptImportSettings()
    begin
#if not CLEAN17
        FileName := FileMgt.OpenFileDialog(Text001, '', '');
        if FileMgt.IsLocalFileSystemAccessible then
            FileName := FileMgt.UploadFileSilent(FileName);
#else
        FileName := FileMgt.UploadFile(Text001, '');
#endif
        if FileName <> '' then
            ImportSettings(FileName);
    end;
}

