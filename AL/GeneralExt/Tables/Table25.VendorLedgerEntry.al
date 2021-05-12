tableextension 80025 "Vendor Ledger Entry (Ext)" extends "Vendor Ledger Entry"
{
    fields
    {
        field(50003; "Include in Paid With VAT"; Boolean)
        {
            Caption = 'Include in Paid With VAT';
            Description = '50085';
        }
    }
}