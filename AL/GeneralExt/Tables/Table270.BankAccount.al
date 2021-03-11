tableextension 80270 "Bank Account (Ext)" extends "Bank Account"
{
    fields
    {
        field(50003; "Max Len. Pmt Purpose Text"; Integer)
        {
            DataClassification = CustomerContent;

        }
    }
}