tableextension 80038 "Purchase Header (Ext)" extends "Purchase Header"
{
    fields
    {
        field(70018; "Paid Date Fact"; Date)
        {
            Caption = 'Paid Date Fact';
            Description = '50086';
        }
        field(70045; "Act Type"; enum "Purchase Act Type")
        {
            Caption = 'Act Type';
            Description = 'NC 51373 AB';
        }
    }
}