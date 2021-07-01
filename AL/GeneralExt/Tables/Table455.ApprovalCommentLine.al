tableextension 80455 "Approval Comment Line (Ext)" extends "Approval Comment Line"
{
    fields
    {
        field(50000; "Linked Approval Entry No."; Integer)
        {
            Caption = 'Linked Approval Entry No.';
            Description = 'NC 51374 AB';
        }
        field(50001; "Status App Act"; Enum "Purchase Act Approval Status")
        {
            CalcFormula = lookup("Approval Entry"."Status App Act" WHERE("Entry No." = FIELD("Linked Approval Entry No.")));
            Caption = 'Act Approval Status';
            Description = 'NC 51374 AB';
            Editable = false;
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(Key50000; "Linked Approval Entry No.")
        {
        }
    }
}