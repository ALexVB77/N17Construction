
tableextension 99992 "Bank Acc. Reconciliation BS" extends "Bank Acc. Reconciliation"
{
    fields
    {
        field(61150; "Statement End Saldo"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Statement end saldo';
            Editable = false;
        }
    }


}
