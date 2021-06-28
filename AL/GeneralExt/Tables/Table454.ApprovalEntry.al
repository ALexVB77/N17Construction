tableextension 80454 "Approval Entry (Ext)" extends "Approval Entry"
{
    fields
    {
        field(50000; "Status App Act"; Enum "Purchase Act Approval Status")
        {
            Description = 'NC 51373 AB';
            Caption = 'Act Approval Status';
        }
        field(50001; "Act Type"; enum "Purchase Act Type")
        {
            Caption = 'Act Type';
            Description = 'NC 51373 AB';
        }
    }
}