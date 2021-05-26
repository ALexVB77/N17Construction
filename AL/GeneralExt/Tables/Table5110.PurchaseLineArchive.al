tableextension 85110 "Purchase Line Archive (Ext)" extends "Purchase Line Archive"
{
    fields
    {
        field(70000; "Full Description"; Text[250])
        {
            Description = 'NC 51373 AB';
            Caption = 'Description';
        }
        field(70001; "Not VAT"; Boolean)
        {
            Description = 'NC 51373 AB';
            Caption = 'Without VAT';
        }
        field(70002; "Old VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'Old VAT Prod. Posting Group';
            Description = 'NC 51373 AB';
        }
        field(70003; "Forecast Entry"; Integer)
        {
            Caption = 'Forecast Entry';
            Description = '50086';
        }
        field(70016; "Cost Type"; Code[20])
        {
            Caption = 'Cost Type';
            Description = '50085';
        }
        field(70021; Approver; Code[50])
        {
            Description = 'NC 51373 AB';
            Caption = 'Approver';
            TableRelation = "User Setup";
        }
    }
}