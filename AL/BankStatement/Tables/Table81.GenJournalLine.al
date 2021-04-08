tableextension 99991 "Gen. Journal Line BS" extends "Gen. Journal Line"
{
    fields
    {
        field(50060; "Payer KPP"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Payer KPP';
        }
    }
}