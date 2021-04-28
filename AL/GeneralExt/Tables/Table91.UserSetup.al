tableextension 80091 "User Setup (Ext)" extends "User Setup"
{
    fields
    {
        field(70040; "Show All Acts KC-2"; Boolean)
        {
            Description = 'NC 51373 AB';
            Caption = 'Show All Acts KC-2';
        }
        field(70015; "Status App Act"; enum "User Setup Act Approval Status")
        {
            Description = 'NC 51373 AB';
            Caption = 'Approval Status';
        }
        field(70005; "Administrator IW"; Boolean)
        {
            Description = 'NC 51373 AB';
            Caption = 'Administrator IW';
        }
    }
}