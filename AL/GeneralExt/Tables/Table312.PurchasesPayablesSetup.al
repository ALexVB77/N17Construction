tableextension 80312 "Purchases & Payab. Setup (Ext)" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50000; "Base Vendor No."; code[20])
        {
            Caption = 'Base Vendor No.';
            Description = 'NC 51373 AB';
            TableRelation = Vendor."No." where("Vendor Type" = CONST(Vendor));
        }
        field(50001; "Default Estimator"; code[20])
        {
            Caption = 'Default Estimator';
            Description = 'NC 51373 AB';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(50030; "Vendor Agreement Template Code"; Code[250])
        {
            Caption = 'Vendor Agreement Template Code';
            TableRelation = "Excel Template";
        }
        field(70002; "Payment Delay Period"; DateFormula)
        {
            Description = 'NC 51373 AB';
            Caption = 'Payment Delay Period';
        }

    }
}