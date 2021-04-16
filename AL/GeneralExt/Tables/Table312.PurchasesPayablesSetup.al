tableextension 80312 "Purchases & Payab. Setup (Ext)" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50030; "Vendor Agreement Template Code"; Code[250])
        {
            Caption = 'Vendor Agreement Template Code';
            TableRelation = "Excel Template";
        }
    }
}