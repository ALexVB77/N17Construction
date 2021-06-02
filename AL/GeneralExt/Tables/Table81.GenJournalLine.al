tableextension 80081 "Gen. Journal Line (Ext)" extends "Gen. Journal Line"
{
    fields
    {
        field(70003; "Status App"; enum "Gen. Journal Approval Status")
        {
            Description = 'NC 51378 AB';
            Caption = 'Approval Status';
        }
        field(70004; "Process User"; Code[50])
        {
            Description = 'NC 51378 AB';
            Caption = 'Process User';
            TableRelation = "User Setup";
        }
        field(70005; "Date Status App"; Date)
        {
            Description = 'NC 51378 AB';
            Caption = 'Date Status Approval';
        }
        field(70016; Paid; Boolean)
        {
            Description = 'NC 51378 AB';
            CalcFormula = lookup("Purchase Header".Paid WHERE("Document Type" = const("Order"), "No." = FIELD("Document No.")));
            Caption = 'Paid';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70019; "Problem Document"; Boolean)
        {
            Description = 'NC 51378 AB';
            CalcFormula = lookup("Purchase Header"."Problem Document" WHERE("Document Type" = const("Order"), "No." = FIELD("Document No.")));
            Caption = 'Problem Document';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70022; "Pre-Approver"; Code[50])
        {
            Description = 'NC 51378 AB';
            Caption = 'Pre-Approver';
            TableRelation = "User Setup";
        }
    }
}