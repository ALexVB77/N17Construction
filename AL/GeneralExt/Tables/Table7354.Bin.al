tableextension 87354 "Bin (Ext)" extends Bin
{
    fields
    {
        field(50000; "Givened Manuf."; Boolean)
        {
            Caption = 'Givened Manuf.';
            Description = 'SWC816, NC 51411 EP';
            Editable = false;
        }
    }

    trigger OnBeforeRename()
    var
        RenameProhibitedErr: Label 'Renaming Bins with attribute "%1" is not allowed', Comment = '%1 = Attribute Field Caption';
    begin
        // NC 51411 > EP
        // Перенес модификацию из OnRename()

        // SWC816 AK 190416 >>
        if Rec."Givened Manuf." then
            Error(RenameProhibitedErr, FieldCaption("Givened Manuf."));
        // SWC816 AK 190416 <<

        // NC 51411 < EP
    end;
}