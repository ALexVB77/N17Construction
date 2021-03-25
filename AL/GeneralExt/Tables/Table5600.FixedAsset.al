tableextension 85600 "Fixed Asset (Ext)" extends "Fixed Asset"
{
    fields
    {
        field(50018; "RAS Posting Group"; Code[20])
        {
            CalcFormula = lookup("FA Depreciation Book"."FA Posting Group" where("FA No." = field("No."), "Depreciation Book Code" = filter('ЭКСПЛУАТ|РБП-УЧТ')));
            Caption = 'RAS Posting Group';
            FieldClass = FlowField;
        }
    }
}