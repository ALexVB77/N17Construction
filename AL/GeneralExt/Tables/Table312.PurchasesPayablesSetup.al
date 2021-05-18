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
        field(50003; "Skip Check CF Forecast Dim."; code[20])
        {
            Caption = 'Skip Check CF Forecast Dimension';
            Description = 'NC 51373 AB';
            TableRelation = Dimension;
        }
        field(50004; "Skip Check CF Forecast Filter"; text[100])
        {
            Caption = 'Skip Check CF Forecast Filter';
            Description = 'NC 51373 AB';
        }
        field(50005; "Zero VAT Prod. Posting Group"; code[20])
        {
            Caption = 'Zero VAT Prod. Posting Group';
            Description = 'NC 51373 AB';
            TableRelation = "VAT Product Posting Group";
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