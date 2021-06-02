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
        field(70020; "Check Limit Starting Date"; Date)
        {
            Caption = 'Check Limit Starting Date';
            Description = 'NC 51432 PA';

            trigger OnValidate()
            begin
                CheckDatesForLimit();
            end;
        }
        field(70021; "Check Limit Ending Date"; Date)
        {
            Caption = 'Check Limit Ending Date';
            Description = 'NC 51432 PA';

            trigger OnValidate()
            begin
                CheckDatesForLimit();
            end;
        }
        field(70022; "Check Limit Amount (LCY)"; Decimal)
        {
            Caption = 'Check Limit Amount (LCY)';
            Description = 'NC 51432 PA';
        }
        field(70023; "Purch. Original Amt. (LCY)"; Decimal)
        {
            Caption = 'Purch. Original Amt. (LCY)';
            Description = 'NC 51432 PA';
            FieldClass = FlowField;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" where("Entry Type" = filter("Initial Entry"),
                                                                                   "Document Type" = filter(Invoice | "Credit Memo"),
                                                                                   "Vendor No." = field("Vendor No."),
                                                                                   "Agreement No." = field("No."),
                                                                                   "Posting Date" = field("Check Limit Date Filter")));
        }
        field(70024; "Check Limit Date Filter"; Date)
        {
            Caption = 'Check Limit Date Filter';
            Description = 'NC 51432 PA';
            FieldClass = FlowFilter;
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
        Text12402: Label '%1 should be later than %2.';

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

    local procedure CheckDatesForLimit()
    begin
        if ("Check Limit Ending Date" <> 0D) and
           ("Check Limit Starting Date" <> 0D) and
           ("Check Limit Ending Date" < "Check Limit Starting Date") then
            Error(Text12402, FieldCaption("Check Limit Ending Date"), FieldCaption("Check Limit Starting Date"));
    end;

    procedure GetLimitDateFilter(): Text
    begin
        if ("Check Limit Starting Date" = 0D) and ("Check Limit Ending Date" = 0D) then
            exit('');

        if ("Check Limit Starting Date" = 0D) and ("Check Limit Ending Date" <> 0D) then
            exit(StrSubstNo('..%1', "Check Limit Ending Date"));

        if ("Check Limit Starting Date" <> 0D) and ("Check Limit Ending Date" = 0D) then
            exit(StrSubstNo('%1..', "Check Limit Starting Date"));

        if ("Check Limit Starting Date" <> 0D) and ("Check Limit Ending Date" <> 0D) then
            exit(STRSUBSTNO('%1..%2', "Check Limit Starting Date", "Check Limit Ending Date"));
    end;
}
