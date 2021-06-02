tableextension 80081 "Gen. Journal Line (Ext)" extends "Gen. Journal Line"
{
    fields
    {
        field(70003; "Status App"; enum "Gen. Journal Approval Status")
        {
            Description = 'NC 51378 AB';
            Caption = 'Approval Status';
        }
    }
}