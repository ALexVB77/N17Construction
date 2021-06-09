tableextension 80311 "Sales & Receiv. Setup (Ext)" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50020; "Prepay. Inv. G/L Acc. No. (ac)"; code[20])
        {
            Caption = 'Prepay. Inv. G/L Acc. No. (ac)';
            TableRelation = "G/L Account";
        }
        field(70000; "Building Act Nos."; Code[10])
        {
            TableRelation = "No. Series";
            Caption = 'Building Act Nos.';
        }

        field(70001; "CRM Worker Code"; Code[20])
        {
            TableRelation = "Web Request Worker Setup";
            Caption = 'CRM Worker Code';
        }
    }

}
