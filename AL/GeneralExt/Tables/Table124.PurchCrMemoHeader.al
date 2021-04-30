tableextension 80124 "Purch. Cr. Memo Hdr. (Ext)" extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        field(70012; "Credit-Memo Reason"; Text[100])
        {
            Caption = 'Credit-Memo Reason';
            TableRelation = "Credit-Memo Reason";
            Description = '51462';
        }
    }

}