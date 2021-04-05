codeunit 99999 "Additional Management BS"
{
    // Event Subscribers >>

    // TABLES
    // t 1237 >>
    [EventSubscriber(ObjectType::Table, Database::"Transformation Rule", 'OnAfterValidateEvent', 'Transformation Type', false, false)]
    local procedure onAfterValidateTransformationType(var Rec: Record "Transformation Rule")
    begin
        IF (Rec."Transformation Type" <> Rec."Transformation Type"::Custom) THEN CLEAR(Rec."Custom Transformation Type");
    end;


    [EventSubscriber(ObjectType::Table, Database::"Transformation Rule", 'OnTransformation', '', false, false)]
    local procedure OnTransformation(TransformationCode: Code[20]; InputText: Text; var OutputText: Text);
    var
        transformationRule: Record "Transformation Rule";
        noSerMgt: Codeunit NoSeriesManagement;
        ism: Codeunit "Isolated Storage Management BS";
        bankAcc: Record "Bank Account";
        prefix: Code[7];
        padCh: Code[10];
        tmpCode: code[20];
        l: Integer;
        TextLenghtError: Label 'Text length "%1" must be in range %2..%3';
    begin
        transformationRule.get(TransformationCode);

        IF (transformationRule."Custom Transformation Type" <> transformationRule."Custom Transformation Type"::" ") THEN BEGIN
            //OutputText := FORMAT(bankAccountCode);
            if (ism.getString('T1237.BankAccountCode', OutputText, false)) then;
        END;
        CASE (transformationRule."Custom Transformation Type") OF
            transformationRule."Custom Transformation Type"::" ":
                OutputText := InputText;
            transformationRule."Custom Transformation Type"::AddPrefix:
                BEGIN
                    bankAcc.GET(OutputText);

                    CLEAR(prefix);
                    IF (STRPOS(InputText, bankAcc.CheckDocPrefix) <> 1) THEN BEGIN
                        prefix := bankAcc.CheckDocPrefix;
                    END;
                    CLEAR(padCh);
                    bankAcc.TESTFIELD("Bank Payment Order No. Series");
                    tmpCode := noSerMgt.GetNextNo(bankAcc."Bank Payment Order No. Series", TODAY, FALSE);
                    IF (tmpCode <> '') THEN BEGIN
                        l := STRLEN(tmpCode) - STRLEN(prefix) - STRLEN(InputText);
                        IF (l > 0) THEN padCh := PADSTR('', l, '0');
                    END;
                    OutputText := prefix + padCh + InputText;
                END;
            transformationRule."Custom Transformation Type"::DelPrefix:
                BEGIN
                    bankAcc.GET(OutputText);

                    IF (bankAcc.CheckDocPrefix <> '') THEN BEGIN
                        IF (STRPOS(InputText, bankAcc.CheckDocPrefix) > 0) THEN BEGIN
                            InputText := COPYSTR(InputText, STRPOS(InputText, bankAcc.CheckDocPrefix) + STRLEN(bankAcc.CheckDocPrefix));
                            InputText := DELCHR(InputText, '<', '0');
                        END;
                    END;

                    OutputText := InputText;
                END;
            transformationRule."Custom Transformation Type"::CheckLength:
                BEGIN
                    OutputText := InputText;
                    IF (NOT (STRLEN(OutputText) IN [transformationRule."Min. Length" .. transformationRule."Max. Length"])) THEN ERROR(TextLenghtError, OutputText, transformationRule."Min. Length", transformationRule."Max. Length");
                END;
        END;
    end;

    // t 1237 <<

    // REPORTS
    [EventSubscriber(ObjectType::Report, Report::"Trans. Bank Rec. to Gen. Jnl.", 'OnBeforeGenJnlLineInsert', '', false, false)]
    local procedure OnBeforeGenJnlLineInsert(var GenJournalLine: Record "Gen. Journal Line"; BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line");
    begin

        IF (BankAccReconciliationLine."Payment Direction" = BankAccReconciliationLine."Payment Direction"::Incoming) THEN BEGIN
            GenJournalLine.VALIDATE(Amount, -ABS(GenJournalLine.Amount));
        END ELSE BEGIN
            GenJournalLine.VALIDATE(Amount, ABS(GenJournalLine.Amount));
        END;

        GenJournalLine."Export Status" := GenJournalLine."Export Status"::"Bank Statement Found";
        GenJournalLine."Statement No." := BankAccReconciliationLine."Statement No.";
        GenJournalLine."Statement Line No." := BankAccReconciliationLine."Statement Line No.";

        BankAccReconciliationLine."Line Status" := BankAccReconciliationLine."Line Status"::"Transferred to Gen. Journal";
        BankAccReconciliationLine.Modify();
    end;



    // CODEUNITS
    // cu 12 >>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostBankAccOnBeforeBankAccLedgEntryInsert', '', false, false)]
    local procedure OnPostBankAccOnBeforeBankAccLedgEntryInsert(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; BankAccount: Record "Bank Account");
    begin
        BankAccountLedgerEntry."Payment Purpose" := GenJournalLine."Payment Purpose";
    end;
    // cu 12 <<
    // Event Subscribers <<
}