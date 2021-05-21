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
        field(70001; "Not VAT"; Boolean)
        {
            Description = 'NC 51373 AB';
            Caption = 'Without VAT';
            trigger OnValidate()
            begin
                IF xRec."Not VAT" <> "Not VAT" THEN
                    CheckProductionPrjDataModify(xRec."Dimension Set ID");
                IF "Not VAT" THEN BEGIN
                    PurchSetup.Get();
                    PurchSetup.TestField("Zero VAT Prod. Posting Group");
                    "Old VAT Prod. Posting Group" := "VAT Prod. Posting Group";
                    VALIDATE("VAT Prod. Posting Group", PurchSetup."Zero VAT Prod. Posting Group");
                END ELSE
                    VALIDATE("VAT Prod. Posting Group", "Old VAT Prod. Posting Group");
            end;
        }
        field(70002; "Old VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'Old VAT Prod. Posting Group';
            Description = 'NC 51373 AB';
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
        field(70021; Approver; Code[50])
        {
            Description = 'NC 51373 AB';
            Caption = 'Approver';
            TableRelation = "User Setup";
        }
    }
    var
        PurchSetup: Record "Purchases & Payables Setup";

    procedure CheckProductionPrjDataModify(xDimSetID: integer);
    var
        DimValue: record "Dimension Value";
        PurchSetup: Record "Purchases & Payables Setup";
        DimSetEntry: Record "Dimension Set Entry";
    begin
        IF "Forecast Entry" = 0 THEN
            EXIT;
        IF xDimSetID = 0 then
            exit;
        PurchSetup.GET;
        PurchSetup.TESTFIELD("Cost Place Dimension");
        IF PurchSetup."Skip Check CF Forecast Filter" <> '' THEN begin
            DimSetEntry.SetRange("Dimension Code", PurchSetup."Cost Place Dimension");
            DimSetEntry.SetRange("Dimension Set ID", xDimSetID);
            IF DimSetEntry.FindSet() then begin
                DimValue.SetRange("Dimension Code", PurchSetup."Cost Place Dimension");
                DimValue.SetFilter(Code, PurchSetup."Skip Check CF Forecast Filter");
                DimValue.FilterGroup(2);
                DimValue.Setrange(Code, DimSetEntry."Dimension Value Code");
                DimValue.FilterGroup(0);
                if not DimValue.IsEmpty then
                    exit;
                DimValue.GET(PurchSetup."Cost Place Dimension", DimSetEntry."Dimension Value Code");
                if not DimValue."Check CF Forecast" then
                    exit;
            end else
                exit;
        end;
        TESTFIELD("Forecast Entry", 0);
    end;

}