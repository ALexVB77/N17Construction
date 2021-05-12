tableextension 80098 "General Ledger Setup (Ext)" extends "General Ledger Setup"
{
    fields
    {
        field(50030; "Allow Diff in Check"; Decimal)
        {
            Caption = 'Allow Diff in Check';
            Description = 'NC 50085 PA';
        }
        field(75002; "Cost Type Dimension Code"; Code[20])
        {
            Caption = 'Cost Type Dimension Code';
            Description = 'NC 50085 PA';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                "Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
            end;
        }
    }
}