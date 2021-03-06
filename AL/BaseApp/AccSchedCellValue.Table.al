table 342 "Acc. Sched. Cell Value"
{
    Caption = 'Acc. Sched. Cell Value';

    fields
    {
        field(1; "Row No."; Integer)
        {
            Caption = 'Row No.';
        }
        field(2; "Column No."; Integer)
        {
            Caption = 'Column No.';
        }
        field(3; Value; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Value';
        }
        field(4; "Has Error"; Boolean)
        {
            Caption = 'Has Error';
        }
        field(5; "Period Error"; Boolean)
        {
            Caption = 'Period Error';
        }
        field(12400; Expression; Text[80])
        {
            Caption = 'Expression';
        }
        field(12401; "Schedule Name"; Code[10])
        {
            Caption = 'Schedule Name';
            TableRelation = "Acc. Schedule Name";
        }
    }

    keys
    {
        key(Key1; "Schedule Name", "Row No.", "Column No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

