tableextension 99999 "Bank Account BS" extends "Bank Account"
{
    fields
    {
        field(50001; "Ingoing Order M-4 No. Series"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";

        }
        field(50002; "Check Description for Import"; Boolean)
        {
            DataClassification = CustomerContent;

        }
    }
}