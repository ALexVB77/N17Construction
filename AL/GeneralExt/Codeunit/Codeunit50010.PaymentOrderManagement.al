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
        IsLocationDocument: Boolean;
        LocationCode: code[20];
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

        WhseEmployee.SetRange("User ID", UserId);
        IF WhseEmployee.FindFirst() THEN BEGIN
            Selected := DIALOG.STRMENU(Text50003, 1, Text50004);
            CASE Selected OF
                1:
                    BEGIN
                        IsLocationDocument := TRUE;
                        Location.GET(WhseEmployee.GetDefaultLocation('', TRUE));
                        Location.TESTFIELD("Bin Mandatory", FALSE);
                        LocationCode := Location.Code;
                    END;
                2:
                    ;
                ELSE
                    ERROR(Text50005);
            END;
        END;

        with grPurchHeader do begin
            RESET;
            INIT;
            "No." := '';
            "Document Type" := "Document Type"::Order;
            "Pre-booking Document" := TRUE;
            "Act Type" := ActTypeOption;
            INSERT(TRUE);
            VALIDATE("Buy-from Vendor No.", PurchSetup."Base Vendor No.");

            if IsLocationDocument then begin
                "Location Document" := TRUE;
                Storekeeper := USERID;
                VALIDATE("Location Code", LocationCode);
            end;

            "Status App Act" := "Status App Act"::Controller;
            "Process User" := USERID;
            "Payment Doc Type" := "Payment Doc Type"::"Payment Request";
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

    procedure NewOrderApp(PurchHeader: Record "Purchase Header")
    var
        grPurchHeader: Record "Purchase Header";
        PurchSetup: Record "Purchases & Payables Setup";
        grUS: Record "User Setup";
    begin

        PurchSetup.GET;
        PurchSetup.TestField("Base Vendor No.");

        grUS.GET(USERID);

        grPurchHeader.RESET;
        grPurchHeader.INIT;
        grPurchHeader."No." := '';
        grPurchHeader."Document Type" := grPurchHeader."Document Type"::Order;
        grPurchHeader."IW Documents" := TRUE;
        grPurchHeader.INSERT(TRUE);

        grPurchHeader.VALIDATE("Buy-from Vendor No.", PurchSetup."Base Vendor No.");
        grPurchHeader.VALIDATE("Status App", grUS."Status App");
        grPurchHeader."Process User" := USERID;
        IF grUS."Status App" <> grUS."Status App"::Reception THEN
            grPurchHeader."Payment Doc Type" := grPurchHeader."Payment Doc Type"::"Payment Request"
        ELSE
            grPurchHeader."Payment Doc Type" := grPurchHeader."Payment Doc Type"::Invoice;
        grPurchHeader."Status App" := grPurchHeader."Status App"::Reception;
        grPurchHeader."Date Status App" := TODAY;
        grPurchHeader.MODIFY(TRUE);

        COMMIT;
        Page.RUNMODAL(Page::"Purchase Order App", grPurchHeader);
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

                        SetPurchLineApprover(PurchLine, true);
                        PurchLine.MODIFY;
                    END;
                UNTIL VendArgDtld2.NEXT = 0;
            END;
        end;

    end;

    procedure SetPurchLineApprover(var PurchLine: Record "Purchase Line"; CheckSubstitute: Boolean)
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
                        if not CheckSubstitute THEN
                            Approver := DimValue."Cost Holder"
                        else
                            if DimValue."Cost Holder" <> '' THEN BEGIN
                                UserSetup.GET(DimValue."Cost Holder");
                                IF UserSetup.Absents AND (UserSetup.Substitute <> '') THEN
                                    Approver := UserSetup.Substitute
                                ELSE
                                    Approver := UserSetup."User ID";
                            END;
            END;
        end;
    end;

    procedure FillPurchLineApproverFromGlobalDim(GlobalDimNo: Integer; DimValueCode: code[20]; var PurchLine: Record "Purchase Line"; CheckSubstitute: Boolean)
    var
        DimValue: Record "Dimension Value";
        UserSetup: Record "User Setup";
        PurchasesSetup: Record "Purchases & Payables Setup";
    begin
        if DimValueCode = '' then
            exit;
        DimValue.SetRange(Code, DimValueCode);
        DimValue.SetRange("Global Dimension No.", GlobalDimNo);
        if not DimValue.FindFirst() then
            exit;
        PurchasesSetup.GET;
        PurchasesSetup.TestField("Cost Place Dimension");
        if PurchasesSetup."Cost Place Dimension" <> DimValue."Dimension Code" then
            exit;

        if not CheckSubstitute THEN
            PurchLine.Approver := DimValue."Cost Holder"
        else
            if DimValue."Cost Holder" <> '' THEN BEGIN
                UserSetup.GET(DimValue."Cost Holder");
                IF UserSetup.Absents AND (UserSetup.Substitute <> '') THEN
                    PurchLine.Approver := UserSetup.Substitute
                ELSE
                    PurchLine.Approver := UserSetup."User ID";
            END;
    end;

    procedure PurchOrderActArchiveQst(PurchHeader: Record "Purchase Header")
    var
        UserSetup: record "User Setup";
        LocText50000: Label 'Budget data will be deleted. Add a document to the archive of problem documents?';
        LocText50008: Label 'Do you want to add %1 %2 to the archive of problem documents and send the Order %3 to the archive? Order-related Receipts will be canceled.';
        LocText50009: Label 'Access is denied.';
        LocText50010: label 'Do you want to add a document to the archive of problem documents?';
        LocText50011: Label 'You can send a document to the archive at the stage of Controller, Approve, Signing or Accountant!';
        LocText50012: Label 'You can send a document to the archive only at the Verification stage.';
        Txt: Text;
    begin
        with PurchHeader do begin
            IF "Location Document" THEN BEGIN
                IF "Status App Act" <> "Status App Act"::Checker THEN
                    ERROR(LocText50012);
                UserSetup.GET(USERID);
                IF "Process User" <> USERID THEN
                    ERROR(LocText50009);
                IF PurchHeader.GET("Document Type"::Order, "Invoice No.") THEN
                    Txt := STRSUBSTNO(LocText50008, "Act Type", "No.", PurchHeader."No.")
                ELSE
                    Txt := LocText50010;
                IF NOT CONFIRM(Txt, FALSE) THEN
                    EXIT;
                PurchOrderActArchive(PurchHeader);
                IF PurchHeader.GET("Document Type"::Order, "Invoice No.") THEN
                    PurchHeader.PurchOrderArchive();
            END ELSE BEGIN
                IF "Status App Act" IN
                    ["Status App Act"::"Controller", "Status App Act"::Approve, "Status App Act"::Signing, "Status App Act"::Accountant]
                THEN BEGIN
                    IF "Status App Act" = "Status App Act"::Signing THEN
                        Txt := LocText50000
                    ELSE
                        Txt := LocText50010;
                    IF CONFIRM(Txt, TRUE) THEN
                        PurchOrderActArchive(PurchHeader);
                END ELSE
                    ERROR(LocText50011);
            END;
        end;
    end;

    local procedure PurchOrderActArchive(PurchHeader: Record "Purchase Header");
    var
        gvduERPC: Codeunit "ERPC Funtions";
        LocText50013: Label 'Document %1 has been sent to the archive.';
        ArchiveMgt: Codeunit ArchiveManagement;
    begin
        DeleteRelatedInvoiceDoc(PurchHeader);
        gvduERPC.DeleteBCPreBooking(PurchHeader); //Удаление бюджета
        PurchHeader."Problem Document" := TRUE;
        PurchHeader."Problem Type" := PurchHeader."Problem Type"::"Act error";
        // NC AB >>
        // не оставляем архивный акт в T36 и T37, оправляем его в T5109 и T5110
        // PurchHeader.MODIFY();
        ArchiveMgt.StorePurchDocument(PurchHeader, false);
        PurchHeader.SetHideValidationDialog(true);
        PurchHeader.Delete(true);
        // NC AB <<
        MESSAGE(LocText50013, PurchHeader."No.");
    end;

    procedure DeleteRelatedInvoiceDoc(var InPurchHeader: Record "Purchase Header")
    var
        PurchHeader: record "Purchase Header";
        PurchCommentLine: record "Purch. Comment Line";
        DocSignMgt: codeunit "Doc. Signature Management";
    begin
        IF InPurchHeader."Invoice No." <> '' THEN BEGIN
            IF PurchHeader.GET(PurchHeader."Document Type"::Invoice, InPurchHeader."Invoice No.") THEN BEGIN
                DocSignMgt.DeleteDocSign(DATABASE::"Purchase Header", PurchHeader."Document Type".AsInteger(), PurchHeader."No.");
                PurchCommentLine.DeleteComments(PurchHeader."Document Type".AsInteger(), PurchHeader."No.");
                InPurchHeader."Invoice No." := '';
                InPurchHeader.MODIFY();
            END;
        END;
    end;
}