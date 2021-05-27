tableextension 80014 "Location (Ext)" extends Location
{
    fields
    {
        modify("Bin Mandatory")
        {
            trigger OnAfterValidate()
            var
                Vendor: Record Vendor;
                Bin: Record Bin;
            begin
                // NC 51411 > EP
                // Перенес модификацию из OnValidate()

                //NC 34049 > DP
                if Rec."Bin Mandatory" then begin
                    Vendor.SetRange("Vendor Type", Vendor."Vendor Type"::Vendor);
                    if Vendor.FindSet() then
                        repeat
                            if not Bin.Get(Rec.Code, Vendor."No.") then begin
                                Bin.Init();
                                Bin."Location Code" := Code;
                                Bin.Code := Vendor."No.";
                                Bin.Description := Vendor.Name;
                                Bin."Givened Manuf." := true;
                                Bin.Insert();
                            end;
                        until Vendor.Next() = 0;
                end;
                //NC 34049 < DP

                // NC 51411 < EP
            end;
        }
        field(50010; Blocked; Boolean)
        {
            Caption = 'Blocked';
            Description = 'NC22512,NC 51143 EP';
        }
        field(50020; "Def. Gen. Bus. Posting Group"; Code[20])
        {
            // NC 51143 > EP
            // Code[10] -> Code[20], потому что в
            // table "Gen. Business Posting Group" увеличилась длина ключа
            // NC 51143 < EP

            Caption = 'Def. Gen. Bus. Posting Group';
            Description = 'NC22512 DP,NC 51143 EP';
            TableRelation = "Gen. Business Posting Group";
        }
    }
}