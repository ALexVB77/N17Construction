tableextension 80038 "Purchase Header (Ext)" extends "Purchase Header"
{
    fields
    {
        field(50001; "Payment Assignment"; Text[15])
        {
            Description = 'NC 51378 AB';
            Caption = 'Payment Assignment';
        }
        field(50010; "Linked Purchase Order Act No."; Code[20])
        {
            Description = 'NC 51378 AB';
            Caption = 'Linked Purchase Order Act No.';
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Order));
        }
        field(70002; "Process User"; Code[50])
        {
            TableRelation = "User Setup";
            Description = 'NC 51373 AB';
            Caption = 'Process User';
            trigger OnValidate()
            begin
                UpdatePurchLinesByFieldNo(FIELDNO("Process User"), CurrFieldNo <> 0);
            end;
        }
        field(70003; "Date Status App"; Date)
        {
            Description = 'NC 51373 AB';
            Caption = 'Date Status Approval';
        }
        field(70005; "Exists Attachment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Document Attachment" WHERE("Table ID" = CONST(38), "Document Type" = FIELD("Document Type"), "No." = FIELD("No.")));
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
            trigger OnValidate()
            begin
                // NC 51373 AB >> #CHECKLATER
                // отключил, мне не надо                
                // "Invoice Amount":="Invoice Amount Incl. VAT"-"Invoice VAT Amount";
                // // NCS-026 AP 110314 >>
                // ExchangeFCYtoLCY();
                // // NCS-026 AP 110314 <<
                // NC 51373 AB >>
            end;
        }
        field(70009; "Invoice Amount Incl. VAT"; Decimal)
        {
            Description = 'NC 51373 AB';
            Caption = 'Invoice Amount Incl. VAT';
            trigger OnValidate()
            begin
                // NC 51373 AB >> #CHECKLATER
                // отключил, мне не надо
                // "Invoice Amount":="Invoice Amount Incl. VAT"-"Invoice VAT Amount";
                // // NCS-026 AP 110314 >>
                // ExchangeFCYtoLCY();
                // // NCS-026 AP 110314 <<
                // NC 51373 AB >>
            end;
        }
        field(70010; "Payment Type"; Option)
        {
            Description = 'NC 51378 AB';
            Caption = 'Payment Type';
            OptionCaption = 'Prepay,Postpay';
            OptionMembers = "pre-pay","post-payment";
        }
        field(70011; "Payment Doc Type"; Option)
        {
            Description = 'NC 51373 AB';
            Caption = 'Payment Doc Type';
            OptionCaption = 'Invoice,Payment Request';
            OptionMembers = Invoice,"Payment Request";
        }
        field(70012; "Payment Details"; Text[230])
        {
            Description = 'NC 51373 AB';
            Caption = 'Payment Details';
            trigger OnValidate()
            var
                CreditMemoReason: record "Credit-Memo Reason";
            begin
                IF ("Payment Details" <> '') AND ("Document Type" = "Document Type"::"Credit Memo") THEN
                    CreditMemoReason.GET("Payment Details");
            end;

            trigger OnLookup()
            var
                CreditMemoReason: record "Credit-Memo Reason";
            begin
                IF "Document Type" = "Document Type"::"Credit Memo" THEN BEGIN
                    IF CreditMemoReason.GET("Payment Details") THEN;
                    IF PAGE.RUNMODAL(0, CreditMemoReason) = ACTION::LookupOK THEN
                        VALIDATE("Payment Details", CreditMemoReason.Reason);
                END;
            end;
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
            trigger OnValidate()
            var
                gvduERPC: codeunit "ERPC Funtions";
            begin
                IF Paid THEN BEGIN
                    TESTFIELD("Paid Date Fact");
                    gvduERPC.PostForecastEntry(Rec);
                END ELSE BEGIN
                    gvduERPC.UnpostForecastEntry(Rec);
                END;
            end;
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
            trigger OnValidate()
            var
                PurchSetup: Record "Purchases & Payables Setup";
            begin
                //NC 27251 HR beg
                IF NOT "Problem Document" THEN
                    VALIDATE("Due Date", WORKDATE)
                ELSE BEGIN
                    PurchSetup.GET;
                    PurchSetup.TESTFIELD("Payment Delay Period");
                    TESTFIELD("Due Date");
                    VALIDATE("Due Date", CALCDATE(PurchSetup."Payment Delay Period", "Due Date"));
                END;
                UpdateCF;
                //NC 27251 HR end
            end;
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
        field(70027; "IW Planned Repayment Date"; Date)
        {
            Description = 'NC 51378 AB';
            Caption = 'IW Planned Repayment Date';
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
        field(70047; "Payment to Person"; Boolean)
        {
            Caption = 'Payment to Person';
            Description = 'NC 51378 AB';
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
            ValidateTableRelation = false;
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
            trigger OnValidate()
            var
                VLE: record "Vendor Ledger Entry";
            begin
                // NC 51373 AB >>
                // надо сделать FF поле в Т25 
                // //NC-47007 DP >>
                // IF "Invoice No."<>'' THEN
                // BEGIN
                //   VLE.SETRANGE("Document No.","Invoice No.");
                //   VLE.MODIFYALL("Receive Account","Receive Account");
                // END;
                //NC-47007 DP <<
            end;
        }
        field(90019; "Location Document"; Boolean)
        {
            Description = 'NC 51373 AB';
            Editable = false;
            Caption = 'Location Document';

        }
        field(90020; Storekeeper; Code[50])
        {
            TableRelation = "User Setup";
            Description = 'NC 51373 AB';
            Editable = false;
            Caption = 'Storekeeper';
        }
    }

    keys
    {
        key(Key50000; "IW Documents", "Linked Purchase Order Act No.")
        {
            SumIndexFields = "Invoice Amount Incl. VAT";
        }
    }

    local procedure UpdateCF()
    var
        PL: record "Purchase Line";
        PBE: record "Projects Budget Entry";
    begin
        //NC 27251 HR beg
        IF "Due Date" = 0D THEN
            EXIT;
        PL.SETRANGE("Document Type", "Document Type");
        PL.SETRANGE("Document No.", "No.");
        IF PL.FINDSET THEN BEGIN
            REPEAT
                IF PL."Forecast Entry" <> 0 THEN BEGIN
                    PBE.SETRANGE("Entry No.", PL."Forecast Entry");
                    IF PBE.FINDFIRST THEN BEGIN
                        PBE.VALIDATE(Date, "Due Date");
                        PBE.VALIDATE("Problem Pmt. Document", "Problem Document");
                        PBE.MODIFY(TRUE);
                    END;
                END;
            UNTIL PL.NEXT = 0;
        END;
        //NC 27251 HR end
    end;

    procedure GetStatusAppAct(DocType: Enum "Purchase Act Approval Status"; No: Code[20]): Integer
    begin
        IF GET(DocType, No) THEN
            EXIT("Status App Act".AsInteger());
    end;

    procedure PurchOrderArchive()
    var
        PurchRcptLine: record "Purch. Rcpt. Line";
        UndoPurchRcptLine: codeunit "Undo Purchase Receipt Line";
        ArchiveMgt: Codeunit ArchiveManagement;
        LocText50013: Label 'Document %1 has been sent to the archive.';
    begin
        PurchRcptLine.SETRANGE("Order No.", "No.");
        PurchRcptLine.SETRANGE(Correction, FALSE);
        IF NOT PurchRcptLine.ISEMPTY THEN BEGIN
            UndoPurchRcptLine.SetHideDialog(TRUE);
            UndoPurchRcptLine.RUN(PurchRcptLine);
        END;

        // NC AB >>
        // не оставляем архивный акт в T36 и T37, оправляем его в T5109 и T5110
        // Archival := TRUE;
        // MODIFY;
        ArchiveMgt.StorePurchDocument(Rec, false);
        Rec.SetHideValidationDialog(true);
        Rec.Delete(true);
        // NC AB <<

        MESSAGE(LocText50013, "No.");
    end;

    procedure HasBoundedCashFlows(): Boolean
    var
        PurchLine3: record "Purchase Line";
    begin
        //NC 29594 HR beg
        PurchLine3.SETRANGE("Document Type", "Document Type");
        PurchLine3.SETRANGE("Document No.", "No.");
        PurchLine3.SETFILTER("Forecast Entry", '<>0');
        EXIT(NOT PurchLine3.ISEMPTY);
        //NC 29594 HR end
    end;
}