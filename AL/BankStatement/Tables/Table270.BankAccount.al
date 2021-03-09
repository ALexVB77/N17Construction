tableextension 80270 "Bank Account BNV" extends "Bank Account"
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
        field(50003; "Max Len. Pmt Purpose Text"; Integer)
        {
            DataClassification = CustomerContent;
        }
    }
}