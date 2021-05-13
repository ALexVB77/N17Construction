table 70045 "Calculation Journal Line"
{
    Caption = 'Calculation Journal Line';
    Description = '50708';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(50000; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ClosingDates = true;
            Editable = true;
        }
        field(50005; "Month"; Integer)
        {
            Caption = 'Month';
        }
        field(50006; "Year"; Integer)
        {
            Caption = 'Year';
        }
        field(50011; "Last Run Date"; Date)
        {
            Caption = 'Last Run Date';
            Editable = false;
        }
        field(50012; "Last Run Time"; Time)
        {
            Caption = 'Last Run Time';
            Editable = false;
        }
        field(50013; "User ID"; Code[20])
        {
            Caption = 'User ID';
            Editable = false;
        }

    }
    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    var
        Text003: Label 'You cannot rename a %1';

    trigger OnInsert()
    begin
        SetPostDate;

        "Last Run Date" := 0D;
        "Last Run Time" := 0T;
        "User ID" := '';
    end;

    trigger OnModify()
    begin
        SetPostDate
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin
        ERROR(Text003, TABLECAPTION);
    end;

    procedure SetPostDate()
    var
        Dt: Date;
        M: Integer;
        Y: Integer;
    begin
        IF (Month < 1) OR (Month > 12) OR (Year = 0) THEN BEGIN
            "Posting Date" := 0D;
            EXIT;
        END;

        M := Month + 1;
        Y := Year;
        IF M > 12 THEN BEGIN
            M := M - 12;
            Y := Y + 1;
        END;
        Dt := DMY2DATE(1, M, Y) - 1;
        //MC GS 04.10.2013 >>
        //IF "Posting Date" <> Dt THEN "Posting Date" := Dt;
        IF ("Posting Date" <> Dt) AND ("Posting Date" = 0D)
        THEN
            "Posting Date" := Dt;
        //MC GS 04.10.2013 <<
    end;

}