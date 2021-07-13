tableextension 80036 "Sales Header (Ext)" extends "Sales Header"
{
    fields
    {
        // Add changes to table fields here
        field(50000; Gift; Boolean)
        {
            Caption = 'Gift';
        }

        field(50100; "Government Agreement No."; Text[50])
        {
            Caption = 'Government Agreement No.';
        }
    }
}
