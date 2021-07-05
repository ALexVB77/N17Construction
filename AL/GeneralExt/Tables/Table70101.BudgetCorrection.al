table 70101 "Budget Correction"
{
    Caption = 'Budget Correction';

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Name; Text[250])
        {
            Caption = 'Name';
        }
        field(3; "Dimension Totaling 1"; Text[250])
        {
            Caption = 'Dimension 1';
        }
        field(4; "Dimension Totaling 2"; Text[250])
        {
            Caption = 'Dimension 2';
        }
        field(5; "G/A Account Totaling"; Text[250])
        {
            Caption = 'Account';
        }

        field(6; "Period Group Type"; Option)
        {
            Caption = 'Group';
            OptionMembers = " ",Day,Week,Month;
            OptionCaption = 'No,Day,Week,Month';
        }
        field(7; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(8; "Journal Template Name"; Code[100])
        {
            Caption = 'Journal Template Name';
        }
        field(9; "Journal Batch Name"; Code[100])
        {
            Caption = 'Journal Batch Name';
        }
        field(10; "Source Code"; Code[100])
        {
            Caption = 'Source Code';
        }
        field(11; "Company Name"; Text[50])
        {
            Caption = 'Company Name';
        }
        field(12; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = " ",Active;
            OptionCaption = ' ,Active';
        }
        field(13; "Project Code"; Code[20])
        {
            Caption = 'Project Code';
        }
        field(14; "Correction Batch"; Boolean)
        {
            Caption = 'Batch Adjustments';
        }
        field(19; "G/L Account Totaling 1"; Text[250])
        {
            Caption = 'Account 1';
        }
        field(20; "G/L Account Totaling 2"; Text[250])
        {
            Caption = 'Account 2';
        }
        field(21; "G/L Account Totaling 3"; Text[250])
        {
            Caption = 'Account 3';
        }
        field(60088; "Original Company"; Code[2])
        {
            Caption = 'Original Company';
        }
    }

    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

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