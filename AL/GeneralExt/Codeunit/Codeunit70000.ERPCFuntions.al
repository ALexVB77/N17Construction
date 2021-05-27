codeunit 70000 "ERPC Funtions"
{
    trigger OnRun()
    begin
    end;

    procedure PostForecastEntry(grPH: Record "Purchase Header")
    begin
        message('Call function PostForecastEntry() in CU 70000 ERPC Funtions')
    end;

    procedure UnpostForecastEntry(grPH: Record "Purchase Header")
    begin
        message('Call function UppostForecastEntry() in CU 70000 ERPC Funtions')
    end;

    procedure GetActStatus(pActCode: code[20]) Ret: code[30]
    var
        lrActLines: record "Act Lines";
        lrActLines1: record "Act Lines";
    begin
        lrActLines.SETRANGE("Act No.", pActCode);
        lrActLines.SETRANGE(Close, TRUE);
        IF lrActLines.FIND('+') THEN
            Ret := lrActLines."Stage Code";
    end;

    procedure GetAgreementActStatus(pAgrCode: code[20]) Ret: code[30]
    var
        lrActLines: record "Act Lines";
        lrActLines1: record "Act Lines";
        lrAct: record "Objects Act";
    begin
        lrAct.SETRANGE("Agreement No.", pAgrCode);
        lrAct.SETFILTER(Status, '<>%1&<>%2', lrAct.Status::New, lrAct.Status::Cancell);
        IF lrAct.FIND('-') THEN Ret := GetActStatus(lrAct."No.");
    end;

    procedure GetCommited(pAgreement: Code[20]; pCP: Code[20]; pCC: Code[20]) ReturnValue: Decimal
    var
        lrProjectsBudgetEntry: Record "Projects Budget Entry";
    begin
        lrProjectsBudgetEntry.SETCURRENTKEY("Work Version", "Agreement No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        lrProjectsBudgetEntry.SETRANGE("Work Version", TRUE);
        lrProjectsBudgetEntry.SETRANGE("Agreement No.", pAgreement);

        IF pCP <> '' THEN
            lrProjectsBudgetEntry.SETRANGE("Shortcut Dimension 1 Code", pCP);
        IF pCC <> '' THEN
            lrProjectsBudgetEntry.SETRANGE("Shortcut Dimension 2 Code", pCC);

        lrProjectsBudgetEntry.CALCSUMS("Without VAT");

        ReturnValue += lrProjectsBudgetEntry."Without VAT";
    end;

    procedure GetLinesDocumentsAmount(pPL: Record "Purchase Line") Ret: Decimal
    var
        lrPL: Record "Purchase Line";
        lrPH: Record "Purchase Header";
        PLt: Record "Purchase Line" temporary;
        TempVATAmountLine0: Record "VAT Amount Line" temporary;
        AmountWOVAT: Decimal;
        AmountVAT: Decimal;
        AmountWVAT: Decimal;
        Amount: Decimal;
    begin
        if lrPH.Get(pPL."Document Type", pPL."Document No.") then begin
            lrPH.Status := lrPH.Status::Released;
            lrPL.SetRange("Document Type", pPL."Document Type");
            lrPL.SetRange("Document No.", pPL."Document No.");

            if lrPL.FindSet() then
                repeat
                    PLt := lrPL;
                    PLt.INSERT;
                until lrPL.Next() = 0;

            //PLt.SetTemp(TRUE);
            PLt.SetPurchHeader(lrPH);
            PLt.CalcVATAmountLines(0, lrPH, PLt, TempVATAmountLine0);
            PLt.UpdateVATOnLines(0, lrPH, PLt, TempVATAmountLine0);

            if PLt.Get(pPL."Document Type", pPL."Document No.", pPL."Line No.") then
                Ret := PLt."Amount Including VAT";
        end;
        exit;

        AmountWOVAT := 0;
        AmountVAT := 0;
        AmountWVAT := 0;

        lrPH.Get(pPL."Document Type", pPL."Document No.");

        lrPL.SetRange("Document Type", pPL."Document Type");
        lrPL.SetRange("Document No.", pPL."Document No.");
        lrPL.SetRange("Line No.", pPL."Line No.");

        IF lrPL.FindFirst() then begin
            repeat
                if lrPH."Currency Factor" <> 0 then
                    Amount := lrPL."Line Amount"
                else
                    Amount := lrPL."Line Amount";

                if lrPH."Prices Including VAT" then begin
                    if lrPL."VAT %" <> 0 then begin
                        AmountVAT := AmountVAT + Round(Amount - (Amount / ((100 + lrPL."VAT %") / 100)), 0.01);
                        AmountWOVAT := AmountWOVAT + (Amount - Round(Amount - (Amount / ((100 + lrPL."VAT %") / 100)), 0.01));
                        AmountWVAT := AmountWVAT + Amount;
                    end else begin
                        AmountWOVAT := AmountWOVAT + Amount;
                        AmountWVAT := AmountWVAT + Amount;
                    end;
                end else begin
                    if lrPL."VAT %" <> 0 then begin
                        AmountVAT := AmountVAT + (Round(Amount * ((100 + lrPL."VAT %") / 100), 0.01) - Amount);
                        AmountWOVAT := AmountWOVAT + Amount;
                        AmountWVAT := AmountWVAT + (Amount + (Round(Amount * ((100 + lrPL."VAT %") / 100), 0.00001) - Amount));
                    end else begin
                        AmountWOVAT := AmountWOVAT + Amount;
                        AmountWVAT := AmountWVAT + Amount;
                    end;
                end;
            until lrPL.Next() = 0;
        end;

        Ret := AmountWVAT;
    end;

    procedure LookUpLocationCode(var LocationCode: code[10]): boolean
    var
        UserSetup: record "User Setup";
        Location: record Location;
        StorekeeperLocation: record "Warehouse Employee";
        LocationList: page "Location List";
        StorekeeperLocationList: page "Warehouse Employees";
        StoreKeeper: boolean;
    begin
        StorekeeperLocation.FILTERGROUP(2);
        StorekeeperLocation.SETRANGE("User ID", USERID);
        StorekeeperLocation.FILTERGROUP(0);
        IF NOT StorekeeperLocation.IsEmpty THEN BEGIN
            StorekeeperLocationList.SETTABLEVIEW(StorekeeperLocation);
            StorekeeperLocationList.LOOKUPMODE(TRUE);
            IF StorekeeperLocationList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                StorekeeperLocationList.GETRECORD(StorekeeperLocation);
                LocationCode := StorekeeperLocation."Location Code";
                EXIT(TRUE);
            END;
        END ELSE BEGIN
            LocationList.LOOKUPMODE(TRUE);
            IF LocationList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                LocationList.GETRECORD(Location);
                LocationCode := Location.Code;
                EXIT(TRUE);
            END;
        END;
    end;

    procedure DeleteBCPreBooking(PurchaseHeader: record "Purchase Header")
    var
        PurchLine: record "Purchase Line";
        VendorAgreementDetails: record "Projects Cost Control Entry";
        Buildingturn: record "Building turn";
        ProjectsLineDimension: record "Projects Line Dimension";
        ProjectsStructureLines: record "Projects Structure Lines";
        VAgreement: record "Vendor Agreement";
        VendorAgreementDetails1: record "Vendor Agreement Details";
        Vendor: record Vendor;
    begin
        VendorAgreementDetails.SETCURRENTKEY("Doc No.");
        VendorAgreementDetails.SETRANGE("Doc No.", PurchaseHeader."No.");
        IF VendorAgreementDetails.FINDFIRST THEN
            VendorAgreementDetails.DELETEALL(TRUE);
        IF Vendor.GET(PurchaseHeader."Buy-from Vendor No.") AND (Vendor."Agreement Posting" = Vendor."Agreement Posting"::Mandatory) THEN
            VAgreement.GET(PurchaseHeader."Buy-from Vendor No.", PurchaseHeader."Agreement No.")
        ELSE
            VAgreement.WithOut := true;
        IF VAgreement.WithOut THEN BEGIN
            PurchLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
            PurchLine.SETRANGE("Document No.", PurchaseHeader."No.");
            IF PurchLine.FINDSET THEN
                REPEAT
                    VendorAgreementDetails1.SETRANGE("Vendor No.", PurchaseHeader."Buy-from Vendor No.");
                    VendorAgreementDetails1.SETRANGE("Agreement No.", PurchaseHeader."Agreement No.");
                    VendorAgreementDetails1.SETRANGE("Global Dimension 1 Code", PurchLine."Shortcut Dimension 1 Code");
                    VendorAgreementDetails1.SETRANGE("Global Dimension 2 Code", PurchLine."Shortcut Dimension 2 Code");
                    VendorAgreementDetails1.SETRANGE("Cost Type", PurchLine."Cost Type");
                    IF VendorAgreementDetails1.FINDFIRST THEN BEGIN
                        VendorAgreementDetails1.Amount := VendorAgreementDetails1.Amount - PurchLine."Line Amount";
                        VendorAgreementDetails1.MODIFY(TRUE);
                    END;
                UNTIL PurchLine.NEXT = 0;
        END;
    end;

    procedure DeleteInvoice(prInvoice: record "Purchase Header"): boolean
    var
        grPurchPay: record "Purchases & Payables Setup";
        lrGenJnlLine: record "Gen. Journal Line";
        LocText001: Label 'Do you want to delete Payment Invoice %1 for %2?';
        LocText002: Label 'There are Cash Flow linked lines. Continue?';
        LocText50021: Label 'Request %1 in the "Payment" approval status. Unable to delete.\Use the archiving function.';
    begin
        // NC AB:
        // функция подвешена не к кнопке, на на триггер OnDelete, поэтому саму запись prInvoice не удаляем

        //NC 44343 > KGT
        IF prInvoice."Status App" = prInvoice."Status App"::Payment THEN
            ERROR(LocText50021, prInvoice."No.");
        //NC 44343 < KGT

        IF CONFIRM(STRSUBSTNO(LocText001, prInvoice."No.", prInvoice."Buy-from Vendor Name")) THEN BEGIN
            //NC 29594 HR beg
            IF prInvoice.HasBoundedCashFlows THEN BEGIN
                IF NOT CONFIRM(LocText002, FALSE) THEN
                    EXIT(false);
            END;
            //NC 29594 HR end

            grPurchPay.GET;

            Message('Вызвано удаление строк фин. журнала из DeleteInvoice() CU 70000. ПРОВЕРИТЬ!');
            /*
            lrGenJnlLine.SETRANGE("Journal Template Name", grPurchPay."Payment Calendar Tmpl");
            lrGenJnlLine.SETRANGE("Journal Batch Name", grPurchPay."Payment Calendar Batch");
            lrGenJnlLine.SETRANGE("Document No.", prInvoice."No.");
            IF lrGenJnlLine.FINDFIRST THEN 
                lrGenJnlLine.DELETEALL(TRUE);
            */

            // NC AB >>
            // // SWC DD 25.05.17 >>
            // prInvoice.GET(prInvoice."Document Type", prInvoice."No.");
            // // SWC DD 25.05.17 <<
            // prInvoice.DELETE(TRUE);
            // NC AB <<
            exit(true);

        END;
    end;

}