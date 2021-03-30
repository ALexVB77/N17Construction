tableextension 80098 "General Ledger Setup (Ext)" extends "General Ledger Setup"
{
    fields
    {
        field(75002; "Cost Type Dimension Code"; Code[20])
        {
            Caption = 'Cost Type Dimension Code';
            DataClassification = CustomerContent;
            TableRelation = Dimension;
            trigger OnValidate()
            begin
                "Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
            end;
        }
    }
}