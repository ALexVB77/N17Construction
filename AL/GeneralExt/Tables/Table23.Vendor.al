tableextension 80023 "Vendor (Ext)" extends Vendor
{
    fields
    {
        field(50000; "Vat Agent Posting Group"; code[20])
        {
            Caption = 'Vat Agent Posting Group';
            TableRelation = "Vendor Posting Group";
            Description = '50067';
        }
    }
}