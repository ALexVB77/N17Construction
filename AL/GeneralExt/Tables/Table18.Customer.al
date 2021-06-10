tableextension 80018 "Customer (Ext)" extends Customer
{
    fields
    {
        field(50700; "CRM GUID"; GUID)
        {
            Description = 'NCS-441';

        }

        field(80010; "CRM Checksum"; Text[40])
        {
            Caption = 'CRM Checksum';

        }

    }

    keys
    {
        key(key70000; "CRM GUID") { }

    }
}
