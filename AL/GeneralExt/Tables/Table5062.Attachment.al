tableextension 85062 "Attachment (Ext)" extends Attachment
{
    fields
    {
        field(70000; "Document Type"; enum "Attachment Document Type Ext")
        {
            Description = 'NC 51373 AB';
            Caption = 'Document Type';
        }
        field(70001; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Description = 'NC 51373 AB';
        }
        field(70002; "Document Line"; Integer)
        {
            Caption = 'Document Line';
            Description = 'NC 51373 AB';
        }
    }
}