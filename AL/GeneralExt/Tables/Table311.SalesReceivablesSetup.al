tableextension 80311 "Sales & Receiv. Setup (Ext)" extends "Sales & Receivables Setup"
{
    fields
    {
        field(70000; "Building Act Nos."; Code[10])
        {
            TableRelation = "No. Series";
            Caption = 'Building Act Nos.';
        }
    }

}