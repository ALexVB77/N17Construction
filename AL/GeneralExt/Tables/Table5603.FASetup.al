tableextension 85603 "FA Setup (Ext)" extends "FA Setup"
{
    fields
    {
        field(50055; "FA Turnover Template Code"; Code[10])
        {
            Caption = 'FA Turnover Template Code';
            TableRelation = "Excel Template";
        }
    }
}