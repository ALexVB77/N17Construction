tableextension 80349 "Dimension Value (Ext)" extends "Dimension Value"
{
    fields
    {
        field(50005; "Cost Holder"; Code[20])
        {
            Description = 'NC 51373 AB';
            // Caption = 'Ответственный за Центр затрат';
            Caption = 'Cost Holder';
        }
        field(75000; "Check CF Forecast"; Boolean)
        {
            Description = 'NC 51373 AB';
        }
    }
}