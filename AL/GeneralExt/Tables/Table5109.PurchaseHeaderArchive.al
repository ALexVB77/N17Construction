tableextension 85109 "Purchase Header Archive (Ext)" extends "Purchase Header Archive"
{
    fields
    {
        field(70002; "Process User"; Code[50])
        {
            TableRelation = "User Setup";
            Description = 'NC 51373 AB';
            Caption = 'Process User';
        }
        field(70003; "Date Status App"; Date)
        {
            Description = 'NC 51373 AB';
            Caption = 'Date Status Approval';
        }
        field(70005; "Exists Attachment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Document Attachment" WHERE("Table ID" = CONST(5109), "Document Type" = FIELD("Document Type"), "No." = FIELD("No.")));
            Description = 'NC 51373 AB';
            Caption = 'Exists Attachment';
        }
        field(70007; "Payments Amount"; Decimal)
        {
            Description = 'NC 51373 AB';
            Caption = 'Payments Amount';
        }
        field(70008; "Invoice VAT Amount"; Decimal)
        {
            Description = 'NC 51373 AB';
            Caption = 'VAT Amount';
        }
        field(70009; "Invoice Amount Incl. VAT"; Decimal)
        {
            Description = 'NC 51373 AB';
            Caption = 'Invoice Amount Incl. VAT';
        }
        field(70011; "Request Payment Doc Type"; Boolean)
        {
            Description = 'NC 51373 AB';
            Caption = 'Request Payment Doc Type';
        }
        field(70012; "Payment Details"; Text[230])
        {
            Description = 'NC 51373 AB';
            Caption = 'Payment Details';
        }
        field(70013; "Vendor Bank Account"; Code[20])
        {
            Description = 'NC 51373 AB';
            Caption = 'Vendor Bank Account';
            TableRelation = "Bank Directory".BIC;
            ValidateTableRelation = false;
        }
        field(70014; "Vendor Bank Account No."; Text[30])
        {
            Description = 'NC 51373 AB';
            Caption = 'Vendor Bank Account #';
            TableRelation = "Vendor Bank Account".Code WHERE("Vendor No." = field("Pay-to Vendor No."));
            ValidateTableRelation = false;
        }
        field(70015; Controller; Code[50])
        {
            Caption = 'Controller';
            Description = 'NC 51373 AB';
            TableRelation = "User Setup"."User ID" WHERE("Status App Act" = CONST(1));
            ValidateTableRelation = false;
        }
        field(70016; Paid; Boolean)
        {
            Caption = 'Paid';
            Description = 'NC 51373 AB';
        }
        field(70018; "Paid Date Fact"; Date)
        {
            Caption = 'Paid Date Fact';
            Description = '50086';
        }
        field(70019; "Problem Document"; Boolean)
        {
            Description = 'NC 51373 AB';
            Caption = 'Problem Document';
        }
        field(70020; "Problem Type"; enum "Purchase Problem Type")
        {
            Caption = 'Problem Type';
            Description = 'NC 51373 AB';
        }
        field(70021; "OKATO Code"; Text[30])
        {
            TableRelation = OKATO;
            Description = 'NC 51373 AB';
            Caption = 'OKATO Code';
        }

        field(70022; "KBK Code"; Text[30])
        {
            TableRelation = KBK;
            Description = 'NC 51373 AB';
            Caption = 'KBK Code';
        }
        field(70023; Approver; Code[50])
        {
            Description = 'NC 51373 AB';
            Caption = 'Approver';
            TableRelation = "User Setup";
        }

        field(70024; "Pre-Approver"; Code[50])
        {
            Description = 'NC 51373 AB';
            Caption = 'Pre-Approver';
            TableRelation = "User Setup";
        }
        field(70026; PreApprover; Boolean)
        {
            Description = 'NC 51373 AB';
            Caption = 'Exist Pre-Approver';

            trigger OnValidate()
            begin
                IF NOT PreApprover THEN
                    "Pre-Approver" := '';
            end;
        }
        field(70034; "IW Documents"; Boolean)
        {
            Caption = 'IW Documents';
            Description = 'NC 50085 PA';
        }
        field(70035; "Problem Type Txt"; Text[180])
        {
            Description = 'NC 51373 AB';
            Caption = 'Problem Type';
        }
        field(70038; "Pre-booking Document"; Boolean)
        {
            Description = 'NC 51373 AB';
            Caption = 'Pre-booking Document';
        }
        field(70045; "Act Type"; enum "Purchase Act Type")
        {
            Caption = 'Act Type';
            Description = 'NC 51373 AB';
        }
        field(90003; "Status App Act"; Enum "Purchase Act Approval Status")
        {
            Description = 'NC 51373 AB';
            Caption = 'Approval Status';
        }
        field(90004; Estimator; Code[50])
        {
            Caption = 'Estimator';
            Description = 'NC 51373 AB';
            TableRelation = "User Setup"."User ID" WHERE("Status App Act" = CONST(Estimator));
        }
        field(90006; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
            Description = 'NC 51373 AB';
        }
        field(90009; "Receive Account"; Boolean)
        {
            Caption = 'Receive Account';
            Description = 'NC 51373 AB';
        }
        field(90019; "Location Document"; Boolean)
        {
            Description = 'NC 51373 AB';
            Caption = 'Location Document';
        }
        field(90020; Storekeeper; Code[50])
        {
            TableRelation = "User Setup";
            Description = 'NC 51373 AB';
            Caption = 'Storekeeper';
        }
    }
}