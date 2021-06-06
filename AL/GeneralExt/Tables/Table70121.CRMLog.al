table 70121 "CRM Log"
{
    Caption = 'CRM Log';
    LookupPageId = "CRM Log";
    DrillDownPageId = "CRM Log";

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            Caption = 'Entry No.';

        }

        field(10; Datetime; Datetime)
        {
            Caption = 'Datetime';

        }

        field(11; "Object Id"; Guid)
        {
            Caption = 'Object Id';

        }

        field(12; "Object Type"; Enum "CRM Object Type")
        {
            Caption = 'Object Type';

        }

        field(13; "Object Xml"; Blob)
        {
            Caption = 'Object Xml';

        }

        field(14; "Object Xml Checksum"; Text[32])
        {
            Caption = 'Object Xml Checksum';

        }


        field(20; Action; Option)
        {
            Caption = 'Action';
            OptionCaption = 'Create,Update,Remove';
            OptionMembers = Create,Update,Remove;
        }

        field(21; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Done,Error,Prefetched,Skip;
            OptionCaption = 'Done,Error,Prefetched,Skip';

        }

        field(22; "Details Text 1"; Text[2048])
        {
            Caption = 'Details Text 1';

        }

        field(23; "Details Text 2"; Text[2048])
        {
            Caption = 'Details Text 2';

        }

        field(30; "Web Request Queue Id"; Guid)
        {
            Caption = 'Web Request Queue Id';
            TableRelation = "Web Request Queue";

        }


    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }

        key(Key2; "Datetime")
        {
        }

        key(Key3; "Object Type", "Object Id")
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