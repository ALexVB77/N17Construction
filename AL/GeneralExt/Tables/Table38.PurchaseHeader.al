tableextension 80038 "Purchase Header (Ext)" extends "Purchase Header"
{
    fields
    {
        // NC 51373 AB >>
        field(69999; "Status App NEW"; option)
        {
            Caption = 'Status App';
            OptionCaption = ' ,Reception,Controller,Checker,Approve,Payment,Request';
            OptionMembers = " ",Reception,Controller,Checker,Approve,Payment,Request;
            Description = 'NC 51373 AB';
        }
        // NC 51373 AB <<      
        field(70002; "Process User"; Code[20])
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
            CalcFormula = Exist("Attachment" WHERE("Document Type" = CONST(Purchase), "Document No." = FIELD("No."), "Document Line" = CONST(0)));
            Description = 'NC 51373 AB';
            Caption = 'Exists Attachment';
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
        field(70016; Paid; Boolean)
        {
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
        field(70023; Approver; Code[20])
        {
            Description = 'NC 51373 AB';
            Caption = 'Approver';

        }
        field(70045; "Act Type"; enum "Purchase Act Type")
        {
            Caption = 'Act Type';
            Description = 'NC 51373 AB';
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
}