table 70120 "CRM Buyers"
{
    Caption = 'CRM Buyers';

    fields
    {
        field(1; "Unit Guid"; GUID)
        {
            Caption = 'Unit Guid';

        }

        field(2; "Buyer Guid"; GUID)
        {
            Caption = 'Buyer Guid';

        }

        field(10; "Contact Guid"; GUID)
        {
            Caption = 'Contact Guid';

        }

        field(11; "Contract Guid"; GUID)
        {
            Caption = 'Contract Guid';
        }

        field(100; "Ownership Percentage"; Decimal)
        {
            Caption = 'Ownership Percentage';
        }

        field(110; "Object of Investing"; Code[20])
        {
            TableRelation = Apartments;
            Caption = 'Investment Object';

        }

        field(120; "Reserving Contact Guid"; GUID)
        {
            Caption = 'Reserving Contact Guid';

        }

        field(121; "Reserving Contract Guid"; GUID)
        {
            Caption = 'Reserving Contract Guid';

        }

        field(130; "Buyer Is Active"; Boolean)
        {
            Caption = 'Buyer Is Active';

        }

        field(140; "Payment Plan Guid"; GUID)
        {
            Caption = 'Payment Plan Guid';

        }

        field(141; "Payment List Exists"; Boolean)
        {
            Caption = 'Payment List Exists';
        }

        field(142; "Payment Plan Changed"; Boolean)
        {

            Caption = 'Payment Plan Changed';
        }

        field(150; "Agreement Start"; Date)
        {
            Caption = 'Agreement Start';

        }

        field(160; "Agreement End"; Date)
        {
            Caption = 'Agreement End';

        }

        field(170; "Expected Registration Period"; Integer)
        {
            Caption = 'Expected Registration Period';

        }


    }


    keys
    {
        key(Key1; "Unit Guid", "Buyer Guid")
        {
            Clustered = true;

        }
        key(Key2; "Contact Guid")
        {

        }
        key(Key3; "Contract Guid")
        {

        }
        key(Key4; "Buyer Is Active")
        {

        }
        key(Key5; "Payment Plan Changed")
        {

        }
        key(Key6; "Payment Plan Guid")
        {

        }
        key(Key7; "Reserving Contact Guid")
        {

        }
    }


    fieldgroups
    {
    }

}
