tableextension 80254 "Vat Entry GE" extends "VAT Entry"
{
    fields
    {
        field(50005; "VAT Allocation"; Boolean)
        {
            Caption = 'VAT Allocation';
            DataClassification = CustomerContent;
        }
    }
}
