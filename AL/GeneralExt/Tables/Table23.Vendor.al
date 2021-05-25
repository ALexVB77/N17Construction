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
        field(50009; "Giv. Manuf. Location Code"; Code[20])
        {
            Caption = 'Giv. Manuf. Location Code';
            Editable = false;
            TableRelation = Location;
            Description = 'SWC816,NC 51412 EP';
        }
        field(50010; "Giv. Manuf. Bin Code"; Code[20])
        {
            Caption = 'Giv. Manuf. Bin Code';
            Editable = false;
            TableRelation = Bin.Code where("Location Code" = field("Giv. Manuf. Location Code"));
            Description = 'SWC816, NC 51412 EP';
        }
    }
}