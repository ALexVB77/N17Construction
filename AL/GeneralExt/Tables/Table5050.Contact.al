tableextension 85050 "Contact (Ext)" extends Contact
{
    fields
    {
        field(70013; "Passport No."; Code[20])
        {
            Caption = 'Passport No.';
        }

        field(70038; "Passport Series"; Code[20])
        {
            Caption = 'Passport series';
        }

        field(70014; "Delivery of passport"; Text[250])
        {
            Caption = 'Passport issued';
        }

        field(70016; Registration; Text[250])
        {
            Caption = 'Registration address';
        }

    }



    var
        myInt: Integer;
}