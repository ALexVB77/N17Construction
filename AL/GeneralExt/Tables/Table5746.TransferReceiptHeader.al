tableextension 85764 "Transfer Receipt Header (Ext)" extends "Transfer Receipt Header"
{
    fields
    {
        field(50010; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            Description = 'NC 51417 PA';
            TableRelation = "Vendor";
        }
        field(50011; "Agreement No."; Code[20])
        {
            Caption = 'Agreement No.';
            Description = 'NC 51417 PA';
            TableRelation = "Vendor Agreement"."No." where("Vendor No." = field("Vendor No."));
        }
    }
}