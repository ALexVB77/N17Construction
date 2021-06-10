table 99932 "CRM Prefetched Object"
{
    Caption = 'CRM Prefetched Object';
    LookupPageId = "CRM Prefetched Objects";
    DrillDownPageId = "CRM Prefetched Objects";

    fields
    {
        field(1; Id; Guid)
        {
            Caption = 'Id';

        }

        field(5; ParentId; Guid)
        {
            Caption = 'ParentId';

        }

        field(10; "Type"; enum "CRM Object Type")
        {
            Caption = 'Type';

        }

        field(11; "Xml"; Blob)
        {
            Caption = 'Xml';

        }

        field(12; "Checksum"; Text[40])
        {
            Caption = 'Xml Checksum';

        }

        field(20; "Company name"; Text[60])
        {
            Caption = 'Company name';

        }

        field(30; "Prefetch Datetime"; DateTime)
        {
            Caption = 'Prefetch Datetime';

        }

        field(40; "Web Request Queue Id"; Guid)
        {
            Caption = 'Web Request Queue Id';
            TableRelation = "Web Request Queue";

        }

    }

    keys
    {
        key(Key1; Id)
        {
            Clustered = true;
        }

        key(Key2; Type)
        {
        }

    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure ExportObjectXml(ShowFileDialog: Boolean): Text
    var
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        OutStrm: OutStream;
        InStrm: InStream;
        FullFileName: Text;
    begin
        if IsNullGuid(Id) then
            exit;
        CalcFields(Xml);
        if not Xml.HasValue then
            exit;
        FullFileName := Format(Id) + '.txt';
        TempBlob.CreateOutStream(OutStrm);
        Xml.CreateInStream(InStrm);
        CopyStream(OutStrm, InStrm);
        exit(FileManagement.BLOBExport(TempBlob, FullFileName, ShowFileDialog));
    end;


}
