tableextension 81173 "Document Attachment (Ext)" extends "Document Attachment"
{
    fields
    {
        field(50000; "Attachment Link"; Text[2048])
        {
            Caption = 'Attachment Link';
        }
        field(50001; "PK Key 2"; Code[20])
        {
            Caption = 'Primary Key 2';
        }
    }
}