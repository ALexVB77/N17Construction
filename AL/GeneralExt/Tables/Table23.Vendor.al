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
            Description = 'SWC816,NC 51412 EP';
        }
    }

    trigger OnAfterDelete()
    var
        InvtSetup: Record "Inventory Setup";
        Bin: Record "Bin";
    begin
        // NC 51412 > EP
        // Перенёс модификацию из Vendor.OnDelete()

        /* TODO: раскомментить, когда будут перенесены поля в table "Inventory Setup" @eapomazkov
            // SWC816 AK 190416 >>
            InvtSetup.Get();
            if InvtSetup."Use Giv. Production Func." then begin
                Bin.Reset();
                Bin.SetFilter("Location Code", '%1|%2|%3',
                            Rec."Giv. Manuf. Location Code",
                            InvtSetup."Giv. Production Loc. Code",
                            InvtSetup."Giv. Materials Loc. Code");
                Bin.SetRange(Code, Rec."Giv. Manuf. Bin Code");
                Bin.DeleteAll(true);
            end;
            // SWC816 AK 190416 <<  
        */

        // NC 51412 < EP
    end;
}