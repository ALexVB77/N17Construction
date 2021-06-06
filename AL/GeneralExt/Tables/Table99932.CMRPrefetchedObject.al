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

        field(10; "Type"; enum "CRM Object Type")
        {
            Caption = 'Type';

        }

        field(11; "Xml"; Blob)
        {
            Caption = 'Xml';

        }

        field(12; "Checksum"; Text[32])
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

}