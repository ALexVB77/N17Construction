tableextension 80039 "Purchase Line (Ext)" extends "Purchase Line"
{
    fields
    {
        field(70000; "Full Description"; Text[250])
        {
            Description = 'NC 51373 AB';
            Caption = 'Description';

            trigger OnValidate()
            begin
                Description := COPYSTR("Full Description", 1, MaxStrLen(Description));
                "Description 2" := COPYSTR("Full Description", MaxStrLen(Description) + 1, MaxStrLen("Description 2"));
            end;
        }
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
        field(70016; "Cost Type"; Code[20])
        {
            Caption = 'Cost Type';
            Description = '50085';

            trigger OnValidate()
            var
                GLS: Record "General Ledger Setup";
                DimensionValue: Record "Dimension Value";
                DimensionManagement: Codeunit "Dimension Management (Ext)";
            begin
                if "Line No." <> 0 then begin
                    GLS.Get;
                    DimensionManagement.valDimValue(GLS."Cost Type Dimension Code", "Cost Type", "Dimension Set ID");
                end;
            end;

            trigger OnLookup()
            var
                GLS: Record "General Ledger Setup";
                DimensionValue: Record "Dimension Value";
                DimensionManagement: Codeunit "Dimension Management (Ext)";
            begin
                GLS.Get;
                DimensionValue.SetRange("Dimension Code", GLS."Cost Type Dimension Code");
                if DimensionValue.FindFirst() then begin
                    if DimensionValue.Get(GLS."Cost Type Dimension Code", "Cost Type") then;
                    if Page.RUNMODAL(Page::"Dimension Value List", DimensionValue) = Action::LookupOK then begin
                        "Cost Type" := DimensionValue.Code;
                        DimensionManagement.valDimValue(GLS."Cost Type Dimension Code", "Cost Type", "Dimension Set ID");
                    end;
                end;
            end;
        }
    }
}