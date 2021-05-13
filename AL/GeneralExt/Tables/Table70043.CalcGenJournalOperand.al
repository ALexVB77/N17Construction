table 70043 "Calc. Gen Journal Operand"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';

        }
        field(50000; "Calc. Gen. Jnl. Entry No."; Integer)
        {
            Caption = 'Calc. Gen. Jnl. Entry No.';

        }
        field(50001; "Type Operation"; Option)
        {
            Caption = 'Type Operation';
            OptionMembers = "Condition","SummaLCY","Base","BaseItem","Distribute","DistributeItem","DimDistribute";

        }
        field(50014; "BegEndSaldo"; Option)
        {
            Caption = 'BegEndSaldo';
            OptionMembers = "BegSaldo","EndSaldo";
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }
}