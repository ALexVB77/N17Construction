table 50003 "Original Budget"
{

    fields
    {
        field(1; "Cost Place"; Code[20])
        {
            Caption = 'Cost Place';

        }
        field(2; "Cost Code"; Code[20])
        {
            Caption = 'Cost Code';
        }
        field(3; Amount; Decimal)
        {
            Caption = 'Amount';
        }
    }

    keys
    {
        key(Key1; "Cost Place", "Cost Code")
        {
            Clustered = true;
        }
    }
}