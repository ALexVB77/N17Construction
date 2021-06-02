tableextension 80349 "Dimension Value (Ext)" extends "Dimension Value"
{
    fields
    {
        field(50005; "Cost Holder"; Code[50])
        {
            Description = 'NC 51373 AB';
            Caption = 'Cost Holder';
            TableRelation = "User Setup";

            trigger OnValidate()
            begin
                CheckCostDimension(true);
            end;
        }
        field(50020; "Cost Code Type"; Option)
        {
            Description = 'NC 51373 AB';
            Caption = 'Cost Code Type';
            OptionCaption = ' ,Production,Development,Admin';
            OptionMembers = " ",Production,Development,Admin;

            trigger OnValidate()
            begin
                CheckCostDimension(true);
            end;
        }
        field(50021; "Development Cost Place Holder"; code[50])
        {
            Description = 'NC 51373 AB';
            Caption = 'Development Cost Place Holder';
            TableRelation = "User Setup";

            trigger OnValidate()
            begin
                CheckCostDimension(false);
            end;
        }
        field(50022; "Production Cost Place Holder"; code[50])
        {
            Description = 'NC 51373 AB';
            Caption = 'Production Cost Place Holder';
            TableRelation = "User Setup";

            trigger OnValidate()
            begin
                CheckCostDimension(false);
            end;
        }
        field(50023; "Admin Cost Place Holder"; code[50])
        {
            Description = 'NC 51373 AB';
            Caption = 'Admin Cost Place Holder';
            TableRelation = "User Setup";

            trigger OnValidate()
            begin
                CheckCostDimension(false);
            end;
        }
        field(51000; "Project Code"; Code[20])
        {
            Description = 'NC 51381';
            Caption = 'Project Code';
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('PROJECT'));
        }
        field(75000; "Check CF Forecast"; Boolean)
        {
            Description = 'NC 51373 AB';
        }
    }
    var
        PurchSetup: Record "Purchases & Payables Setup";

    local procedure CheckCostDimension(IsCostCode: Boolean)
    begin
        PurchSetup.Get();
        IF IsCostCode then begin
            PurchSetup.TestField("Cost Code Dimension");
            TestField("Dimension Code", PurchSetup."Cost Code Dimension");
        end else begin
            PurchSetup.TestField("Cost Place Dimension");
            TestField("Dimension Code", PurchSetup."Cost Place Dimension");
        end;
    end;

}