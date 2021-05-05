tableextension 80114 "Sales Cr.Memo Header (Ext)" extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50020; "Credit-Memo Reason"; Text[100])
        {
            Caption = 'Credit-Memo Reason';
            TableRelation = "Credit-Memo Reason";
            Description = '51462';
        }
    }
}