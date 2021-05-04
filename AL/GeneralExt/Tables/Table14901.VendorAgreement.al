tableextension 94901 "Vendor Agreement (Ext)" extends "Vendor Agreement"
{
    fields
    {
        field(50000; "Vat Agent Posting Group"; code[20])
        {
            Caption = 'Vat Agent Posting Group';
            TableRelation = "Vendor Posting Group";
            Description = '50067';
        }
        field(70001; "Agreement Amount"; Decimal)
        {
            Caption = 'Agreement Amount';
            Description = '50085';

            trigger OnValidate()
            begin
                "Amount Without VAT" := "Agreement Amount" - "VAT Amount";
            end;
        }
        field(70002; "Exists Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST(14901),
                                                      "No." = FIELD("No.")));
            Caption = 'Exists Comment';
            Description = '50085';
        }
        field(70003; "Exists Attachment"; Boolean)
        {
            FieldClass = FlowField;
            // CalcFormula = Exist("Attachment WF" WHERE ("Document Type"=CONST(VendAgreement),
            //                                            "Document No.""=FIELD(No.),
            //                                            "Document Line"=CONST(0)));
            Caption = 'Exists Attachment';
            Description = '50085';

        }

        field(70004; "Project Dimension Code"; Code[20])
        {
            Caption = 'Project Dimension Code';
            Description = '50085';

            trigger OnLookup()
            begin
                // grDevSetup.GET;
                // grDevSetup.TESTFIELD("Project Dimension Code");

                // grDimValue.SETRANGE("Dimension Code",grDevSetup."Project Dimension Code");
                // IF grDimValue.FIND('-') THEN
                // BEGIN
                //  IF FORM.RUNMODAL(FORM::"Dimension Values",grDimValue) = ACTION::LookupOK THEN
                //  "Project Dimension Code":=grDimValue.Code;
                // END
            end;
        }
        field(70008; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount';
            Description = '50085';

            trigger OnValidate()
            begin
                "Amount Without VAT" := "Agreement Amount" - "VAT Amount";
            end;
        }
        field(70009; "Amount Without VAT"; Decimal)
        {
            Caption = 'Amount Without VAT';
            Description = '50085';
        }
        field(70013; "Paid With VAT"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("Vendor No."),
                                                                                  "Agreement No." = FIELD("No."),
                                                                                  "Document Type" = FILTER(" " | Payment | Refund),
                                                                                  "Entry Type" = FILTER("Initial Entry" | "Unrealized Loss" | "Unrealized Gain" | "Realized Loss" | "Realized Gain" | "Payment Discount" | "Payment Discount (VAT Excl.)" | "Payment Discount (VAT Adjustment)" | "Payment Tolerance" | "Payment Discount Tolerance" | "Payment Tolerance (VAT Excl.)" | "Payment Tolerance (VAT Adjustment)" | "Payment Discount Tolerance (VAT Excl.)" | "Payment Discount Tolerance (VAT Adjustment)"),
                                                                                  "Posting Date" = FIELD(FILTER("Paid With VAT Date Filter"))));
            Caption = 'Paid With VAT';
            Description = '50085';
        }

        field(70018; "Unbound Cost"; Decimal)
        {
            Caption = 'Unbound Cost';
        }

        field(70025; "Paid With VAT Date Filter"; Date)
        {
            Caption = 'Paid With VAT Date Filter';
            Description = '50085';
            FieldClass = FlowFilter;
        }
        field(70040; "Don't Check CashFlow"; Boolean)
        {
            Caption = 'Don''t Check CashFlow';
            Description = '50085';
        }
    }
    var
        grDimValue: Record "Dimension Value";
    // grDevSetup: Record "70070";
}