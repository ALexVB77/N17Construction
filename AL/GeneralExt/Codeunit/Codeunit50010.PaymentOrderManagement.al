codeunit 50010 "Payment Order Management"
{
    trigger OnRun()
    begin

    end;

    procedure FuncNewRec(PurchHeader: Record "Purchase Header"; ActTypeOption: enum "Purchase Act Type")
    var
        grUS: record "User Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        WhseEmployee: record "Warehouse Employee";
        grPurchHeader: Record "Purchase Header";
        Location: Record Location;
        // Text50000: Label 'У вас нет прав на создание документа. Данные права имеет контролер.';
        Text50000: Label 'You do not have permission to create the document. The controller has these rights.';
        Text50003: Label 'Warehouse document,Act/KS-2 for the service';
        Text50004: Label 'Select the type of document to create.';
        Text50005: Label 'It is required to select the type of document.';
        LocErrorText1: Label 'The estimator cannot create a document with the type Act!';
        Selected: Integer;
    begin
        grUS.GET(USERID);
        IF NOT (grUS."Status App Act" IN [grUS."Status App Act"::Сontroller, grUS."Status App Act"::Estimator]) then begin
            MESSAGE(Text50000);
            EXIT;
        end;
        if (ActTypeOption in [ActTypeOption::Act, ActTypeOption::"Act (Production)"]) and (grUS."Status App Act" = grUS."Status App Act"::Estimator) then
            ERROR(LocErrorText1);

        PurchSetup.GET;
        PurchSetup.TestField("Base Vendor No.");

        with grPurchHeader do begin
            RESET;
            INIT;
            "No." := '';
            "Document Type" := "Document Type"::Order;
            "Pre-booking Document" := TRUE;
            "Act Type" := ActTypeOption;
            INSERT(TRUE);
            VALIDATE("Buy-from Vendor No.", PurchSetup."Base Vendor No.");

            IF WhseEmployee.get(UserId) THEN BEGIN
                Selected := DIALOG.STRMENU(Text50003, 1, Text50004);
                CASE Selected OF
                    1:
                        BEGIN
                            "Location Document" := TRUE;
                            Storekeeper := USERID;
                            Location.GET(WhseEmployee.GetDefaultLocation('', TRUE));
                            Location.TESTFIELD("Bin Mandatory", FALSE);
                            VALIDATE("Location Code", Location.Code);
                        END;
                    2:
                        ;
                    ELSE
                        ERROR(Text50005);
                END;
            END;

            "Status App Act" := "Status App Act"::Controller;
            "Process User" := USERID;
            "Request Payment Doc Type" := TRUE;
            "Date Status App" := TODAY;
            Controller := USERID;
            if "Act Type" in ["Act Type"::"KC-2", "Act Type"::"KC-2 (Production)"] then
                if PurchSetup."Default Estimator" <> '' then
                    Estimator := PurchSetup."Default Estimator";
            MODIFY(TRUE);

            COMMIT;
            PAGE.RUNMODAL(PAGE::"Purchase Order Act", grPurchHeader);
        end;
    end;

    procedure ActInterBasedOn(PurchHeader: Record "Purchase Header")
    var
        InvSetup: Record "Inventory Setup";
        PurchLine: Record "Purchase Line";
        VendArgDtld: Record "Vendor Agreement Details";
        VendArgDtld2: Record "Vendor Agreement Details";
        VendArgDtldPage: Page "Vendor Agreement Details";
        Text001: Label 'Nothing selected!';
        LineNo: Integer;
        Amt: Decimal;
    begin
        with PurchHeader do begin
            TESTFIELD("Agreement No.");
            InvSetup.GET;
            InvSetup.TESTFIELD("Temp Item Code");
            VendArgDtld.SETRANGE("Agreement No.", "Agreement No.");
            VendArgDtldPage.SETRECORD(VendArgDtld);
            VendArgDtldPage.SETTABLEVIEW(VendArgDtld);
            VendArgDtldPage.LOOKUPMODE(TRUE);
            IF VendArgDtldPage.RUNMODAL = ACTION::LookupOK THEN BEGIN
                VendArgDtldPage.SetSelectionFilter(VendArgDtld2);
                IF NOT VendArgDtld2.FINDSET THEN
                    ERROR(Text001);
                PurchLine.SETRANGE("Document No.", "No.");
                PurchLine.SETRANGE("Document Type", "Document Type");
                LineNo := 0;
                IF PurchLine.FINDLAST THEN
                    LineNo := PurchLine."Line No.";
                REPEAT
                    Amt := VendArgDtld2.GetRemainAmt;
                    IF Amt > 0 THEN BEGIN
                        LineNo += 10000;
                        PurchLine.INIT;
                        PurchLine."Document Type" := "Document Type";
                        PurchLine."Document No." := "No.";
                        PurchLine."Line No." := LineNo;
                        PurchLine.VALIDATE(Type, PurchLine.Type::Item);
                        PurchLine.VALIDATE("No.", InvSetup."Temp Item Code");
                        PurchLine.INSERT(TRUE);
                        PurchLine.VALIDATE(Quantity, 1);
                        PurchLine.VALIDATE("Currency Code", VendArgDtld2."Currency Code");
                        PurchLine.VALIDATE("Full Description", COPYSTR(VendArgDtld2.Description, 1, MAXSTRLEN(PurchLine."Full Description")));
                        PurchLine.VALIDATE("Unit Cost (LCY)", ROUND(Amt / (100 + PurchLine."VAT %") * 100, 0.000001));
                        PurchLine.VALIDATE("Direct Unit Cost", PurchLine."Unit Cost (LCY)");
                        PurchLine.VALIDATE("Shortcut Dimension 1 Code", VendArgDtld2."Global Dimension 1 Code");
                        PurchLine.VALIDATE("Shortcut Dimension 2 Code", VendArgDtld2."Global Dimension 2 Code");
                        PurchLine.VALIDATE("Cost Type", VendArgDtld2."Cost Type");
                        PurchLine.VALIDATE("VAT Prod. Posting Group");
                        PurchLine.MODIFY(TRUE);

                        SetPurchLineApprover(PurchLine);
                        PurchLine.MODIFY;
                    END;
                UNTIL VendArgDtld2.NEXT = 0;
            END;
        end;

    end;

    procedure SetPurchLineApprover(PurchLine: Record "Purchase Line")
    var
        DimSetEntry: Record "Dimension Set Entry";
        DimValue: Record "Dimension Value";
        UserSetup: Record "User Setup";
        PurchasesSetup: Record "Purchases & Payables Setup";
    begin
        with PurchLine do begin
            IF ("Dimension Set ID" = 0) or (Approver <> '') then
                EXIT;
            IF "Dimension Set ID" <> 0 THEN begin
                PurchasesSetup.GET;
                PurchasesSetup.TestField("Cost Place Dimension");
                IF DimSetEntry.GET("Dimension Set ID", PurchasesSetup."Cost Place Dimension") THEN
                    IF DimValue.GET(DimSetEntry."Dimension Code", DimSetEntry."Dimension Value Code") then
                        IF DimValue."Cost Holder" <> '' THEN BEGIN
                            UserSetup.GET(DimValue."Cost Holder");
                            IF UserSetup.Absents AND (UserSetup.Substitute <> '') THEN
                                Approver := UserSetup.Substitute
                            ELSE
                                Approver := UserSetup."User ID";
                        END;
            END;
        end;
    end;

}