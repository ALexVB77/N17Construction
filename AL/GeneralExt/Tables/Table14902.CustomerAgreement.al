tableextension 94902 "Customer Agreement (Ext)" extends "Customer Agreement"
{
    fields
    {
        field(70001; "Agreement Type"; Option)
        {
            Caption = 'Agreement Type';
            OptionCaption = 'Sale Agreement,Iinvestment Agreement, Reservation Agreement,Inv. Sales Agreement,Service,Prev Inv. Sales Agreement';
            OptionMembers = "Sale Agreement","Investment Agreement","Reserving Agreement","Inv. Sales Agreement",Service,"Prev Inv. Sales Agreement","Transfer of rights";
        }

        field(70006; "Agreement Sub Type"; Option)
        {
            Caption = 'Invest Agreement Type';
            OptionCaption = 'Basic,Additional Agreement';
            OptionMembers = Basic,Additional;

        }

        field(70061; "Apartment Amount"; Decimal)
        {
            BlankZero = true;
            Caption = 'Cost object (RUB)';
        }

        field(70080; "Payment Type"; Option)
        {
            Caption = 'Payment Type';
            OptionCaption = '100%,Inv,Ipot';
            OptionMembers = "100%",Inv,Ipot;

        }

    }


    var
        myInt: Integer;
}