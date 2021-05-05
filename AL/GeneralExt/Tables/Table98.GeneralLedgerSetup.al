tableextension 80098 "General Ledger Setup (Ext)" extends "General Ledger Setup"
{
    fields
    {
        field(50030; "Allow Diff in Check"; Decimal)
        {
            Caption = 'Allow Diff in Check';
            Description = 'NC 50085 PA';
        }
    }
}