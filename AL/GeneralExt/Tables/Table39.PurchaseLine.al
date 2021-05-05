tableextension 80039 "Purchase Line (Ext)" extends "Purchase Line"
{
    fields
    {
        field(70003; "Forecast Entry"; Integer)
        {
            Caption = 'Forecast Entry';
            Description = '50086';
        }
        field(70004; IW; Boolean)
        {
            Caption = 'IW';
            Description = '50085';
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header"."IW Documents" where("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }
        field(70011; Paid; Boolean)
        {
            Caption = 'Paid';
            Description = '50085';
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header".Paid where("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }
    }
}