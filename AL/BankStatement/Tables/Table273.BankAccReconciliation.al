
tableextension 99992 "Bank Acc. Reconciliation BS" extends "Bank Acc. Reconciliation"
{
    fields
    {

        field(61120; "Statement Begin Saldo"; Decimal)
        {
            Caption = 'Statement begin saldo';
            Editable = false;
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = lookup("Bank Acc. Reconciliation Line"."Statement Begin Saldo" WHERE("Bank Account No." = FIELD("Bank Account No."),
                                                                                                "Statement Type" = Field("Statement Type"),
                                                                                                "Statement No." = field("Statement No.")
                                                                                                ));
        }
        field(61130; "Total Income Amount"; Decimal)
        {
            Caption = 'Total income amount';
            Editable = false;
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = lookup("Bank Acc. Reconciliation Line"."total income amount" WHERE("Bank Account No." = FIELD("Bank Account No."),
                                                                                                "Statement Type" = Field("Statement Type"),
                                                                                                "Statement No." = field("Statement No.")
                                                                                                ));
        }
        field(61140; "Total Outcome Amount"; Decimal)
        {
            Caption = 'Total outcome amount';
            Editable = false;
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = lookup("Bank Acc. Reconciliation Line"."total outcome amount" WHERE("Bank Account No." = FIELD("Bank Account No."),
                                                                                                "Statement Type" = Field("Statement Type"),
                                                                                                "Statement No." = field("Statement No.")
                                                                                                ));
        }
        field(61150; "Statement End Saldo"; Decimal)
        {
            Caption = 'Statement end saldo';
            Editable = false;
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = lookup("Bank Acc. Reconciliation Line"."Statement end Saldo" WHERE("Bank Account No." = FIELD("Bank Account No."),
                                                                                                "Statement Type" = Field("Statement Type"),
                                                                                                "Statement No." = field("Statement No.")
                                                                                                ));
        }

    }


}
