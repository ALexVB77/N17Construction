codeunit 99999 "Additional Management BS"
{
    // Event Subscribers >>
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

    begin
        transformationRule.get(TransformationCode);
        IF (transformationRule."Custom Transformation Type" <> transformationRule."Custom Transformation Type"::" ") THEN BEGIN
            //OutputText := FORMAT(bankAccountCode);
        END;
        /*
                CASE (transformationRule."Custom Transformation Type") OF
                    transformationRule."Custom Transformation Type"::" ":
                        OutputText := InputText;
                    transformationRule."Custom Transformation Type"::AddPrefix:
                        BEGIN
                            bankAcc.GET(OutputText);
                            CLEAR(prefix);
                            IF (STRPOS(InputText, bankAcc.ChekDocPrefix) <> 1) THEN BEGIN
                                prefix := bankAcc.ChekDocPrefix;
                            END;
                            // NC PS-22224 GG >>
                            //OutputText := prefix + InputText;
                            CLEAR(padCh);
                            bankAcc.TESTFIELD("Bank Payment Order No. Series");
                            tmpCode := noSerMgt.GetNextNo(bankAcc."Bank Payment Order No. Series", TODAY, FALSE);
                            IF (tmpCode <> '') THEN BEGIN
                                l := STRLEN(tmpCode) - STRLEN(prefix) - STRLEN(InputText);
                                IF (l > 0) THEN padCh := PADSTR('', l, '0');
                            END;
                            OutputText := prefix + padCh + InputText;
                            // NC PS-22224 GG <<

                        END;
                    transformationRule."Custom Transformation Type"::DelPrefix:
                        BEGIN
                            bankAcc.GET(OutputText);
                            IF (bankAcc.ChekDocPrefix <> '') THEN BEGIN
                                IF (STRPOS(InputText, bankAcc.ChekDocPrefix) > 0) THEN BEGIN
                                    InputText := COPYSTR(InputText, STRPOS(InputText, bankAcc.ChekDocPrefix) + STRLEN(bankAcc.ChekDocPrefix));
                                    // NC PS-22224 GG >>
                                    InputText := DELCHR(InputText, '<', '0');
                                    // NC PS-22224 GG <<
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
        */
    end;

    // t 1237 <<


    // cu 12 >>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostBankAccOnBeforeBankAccLedgEntryInsert', '', false, false)]
    local procedure OnPostBankAccOnBeforeBankAccLedgEntryInsert(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; BankAccount: Record "Bank Account");
    begin
        BankAccountLedgerEntry."Payment Purpose" := GenJournalLine."Payment Purpose";
    end;
    // cu 12 <<
    // Event Subscribers <<
}