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

        // NC 51412 < EP
    end;

    procedure CreateGivenedBin()
    var
        InvtSetup: Record "Inventory Setup";
        Bin: Record "Bin";
        BinCreatedMsg: Label 'Bin %1 has been created', Comment = '%1 = Created Bin Code';
    begin
        // NC 51411 > EP
        // Перенёс функцию

        // SWC816 AK 190416 >>
        InvtSetup.Get();
        if not InvtSetup."Use Giv. Production Func." then
            exit;

        InvtSetup.TestField("Giv. Production Loc. Code");
        InvtSetup.TestField("Giv. Materials Loc. Code");

        if not Bin.Get(InvtSetup."Giv. Production Loc. Code", Rec."No.") then begin
            Bin.Init();
            Bin.Validate("Location Code", InvtSetup."Giv. Production Loc. Code");
            Bin.Validate(Code, "No.");
            Bin.Validate(Description, CopyStr(Rec."Full Name", 1, MaxStrLen(Bin.Description)));
            Bin.Validate("Givened Manuf.", true);
            Bin.Insert(true);
        end;

        Rec.Validate("Giv. Manuf. Location Code", Bin."Location Code");
        Rec.Validate("Giv. Manuf. Bin Code", Bin.Code);
        Rec.Modify();

        if not Bin.Get(InvtSetup."Giv. Materials Loc. Code", "No.") then begin
            Bin.Init();
            Bin.Validate("Location Code", InvtSetup."Giv. Materials Loc. Code");
            Bin.Validate(Code, "No.");
            Bin.Validate(Description, CopyStr(Rec."Full Name", 1, MaxStrLen(Bin.Description)));
            Bin.Validate("Givened Manuf.", true);
            Bin.Insert(true);
        end;

        Message(BinCreatedMsg, Bin.Code);
        // SWC816 AK 190416 <<

        // NC 51411 < EP
    end;
}