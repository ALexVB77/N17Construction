tableextension 80018 "Customer (Ext)" extends Customer
{
    fields
    {
        field(50700; "CRM GUID"; GUID)
        {
            Description = 'NCS-441';

        }
    }

    keys
    {
        key(key70000; "CRM GUID") { }

    }
}
