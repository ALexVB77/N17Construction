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
        field(60000; "Original No."; Code[20])
        {
            Caption = 'Original No.';
            Description = '50085';
        }
        field(60088; "Original Company"; Code[2])
        {
            Caption = 'Original Company';
            Description = '50085';
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
            CalcFormula = Exist("Document Attachment" WHERE("Table ID" = CONST(14901),
                                                       "No." = FIELD("No."),
                                                       "PK Key 2" = field("Vendor No.")));
            Caption = 'Exists Attachment';
            Description = '50085';

        }

        field(70004; "Project Dimension Code"; Code[20])
        {
            Caption = 'Project Dimension Code';
            Description = '50085';

            trigger OnLookup()
            begin
                grDevSetup.GET;
                grDevSetup.TESTFIELD("Project Dimension Code");

                grDimValue.SETRANGE("Dimension Code", grDevSetup."Project Dimension Code");
                IF grDimValue.FindFirst() THEN BEGIN
                    IF PAGE.RUNMODAL(PAGE::"Dimension Values", grDimValue) = ACTION::LookupOK THEN
                        "Project Dimension Code" := grDimValue.Code;
                END
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
        field(70011; WithOut; Boolean)
        {
            Caption = 'With Out';

            trigger OnValidate()
            begin
                UpdateCommitedDetail();
            end;
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
        grDevSetup: Record "Development Setup";

    procedure UpdateCommitedDetail()
    var
        CommitedDetail: Record "Commited Detail";
    begin

        CommitedDetail.SETRANGE("Vendor No.", "Vendor No.");
        CommitedDetail.SETRANGE("Agreement No.", "No.");
        IF CommitedDetail.FINDSET THEN
            REPEAT
                CommitedDetail.ByOrder := WithOut;
                CommitedDetail.MODIFY();
            UNTIL CommitedDetail.NEXT = 0;
    end;
}
