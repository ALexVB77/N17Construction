tableextension 80017 "G/L Entry (Ext)" extends "G/L Entry"
{
    fields
    {
        field(50020; "DenDoc Dim Value Code"; Code[20])
        {
            Caption = 'DenDoc Dim Value Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"), "Dimension Code" = const('ДЕНДОК')));
            Description = '51676';
            Editable = false;
        }
        field(50021; "Utilities Dim. Value Code"; Code[20])
        {
            Caption = 'Utilities Dim. Value Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"), "Dimension Code" = const('ДЕНДОК')));
            Description = '51676';

        }
    }



}