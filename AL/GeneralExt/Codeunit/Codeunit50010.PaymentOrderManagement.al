codeunit 50010 "Payment Order Management"
{
    trigger OnRun()
    begin

    end;

    var
        PurchSetup: record "Purchases & Payables Setup";
        PurchSetupFound: Boolean;

    local procedure GetPurchSetupWithTestDim()
    begin
        if not PurchSetupFound then begin
            PurchSetupFound := true;
            PurchSetup.Get();
            PurchSetup.TestField("Cost Place Dimension");
            PurchSetup.TestField("Cost Code Dimension");
        end;
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

    procedure CreatePurchaseOrderAppFromAct(PurchaseHeader: Record "Purchase Header")
    var
        PurchSetup: Record "Purchases & Payables Setup";
        InvtSetup: Record "Inventory Setup";
        PaymentInvoice: Record "Purchase Header";
        Item: Record Item;
        VATPostingSetup: Record "VAT Posting Setup";
        Currency: Record Currency;
        CopyDocMgt: Codeunit "Copy Document Mgt.";
        RemAmount: Decimal;
        LinkedActExists: Boolean;
        RemActAmount: Decimal;
        FromDocType: Enum "Purchase Document Type From";
    begin
        CalcActRemaingAmount(PurchaseHeader, PaymentInvoice, LinkedActExists, RemAmount);

        PaymentInvoice.RESET;
        PaymentInvoice.INIT;
        PaymentInvoice."No." := '';
        PaymentInvoice."Document Type" := PaymentInvoice."Document Type"::Order;
        PaymentInvoice."IW Documents" := TRUE;
        PaymentInvoice.INSERT(TRUE);

        PurchSetup.Get();
        CopyDocMgt.SetProperties(true, true, false, false, false, PurchSetup."Exact Cost Reversing Mandatory", false);
        CopyDocMgt.CopyPurchDoc(FromDocType::Order, PurchaseHeader."No.", PaymentInvoice);

        PaymentInvoice."IW Documents" := TRUE;
        PaymentInvoice."Act Type" := PaymentInvoice."Act Type"::" ";
        if LinkedActExists then begin
            InvtSetup.Get();
            InvtSetup.TestField("Temp Item Code");
            Item.Get(InvtSetup."Temp Item Code");
            Item.TestField("VAT Prod. Posting Group");
            VATPostingSetup.GET(PaymentInvoice."VAT Bus. Posting Group", Item."VAT Prod. Posting Group");

            if PaymentInvoice."Currency Code" = '' then
                Currency.InitRoundingPrecision()
            else
                Currency.GET(PaymentInvoice."Currency Code");

            PaymentInvoice."Invoice Amount Incl. VAT" := RemActAmount;
            PaymentInvoice."Invoice VAT Amount" :=
                RemActAmount - Round(RemActAmount / (1 + (1 - 0 / 100) * VATPostingSetup."VAT %" / 100), Currency."Amount Rounding Precision");
        end;
        PaymentInvoice."Linked Purchase Order Act No." := PurchaseHeader."No.";
        PaymentInvoice.Modify(true);

        COMMIT;
        Page.RUNMODAL(Page::"Purchase Order App", PaymentInvoice);
    end;

    procedure LinkActAndPaymentInvoice(ActNo: code[20])
    var
        PurchaseHeader: Record "Purchase Header";
        PaymentInvoice: Record "Purchase Header";
        PurchListApp: Page "Purchase List App";
        LinkedActExists: Boolean;
        RemAmount: Decimal;
        LinkedCount: Integer;
        LocText001: Label 'There are no payment invoices to be linked to the act %1.';
        LocText002: Label '%1 payment invoices were related to Act %2.';
    begin
        PurchaseHeader.get(PurchaseHeader."Document Type"::Order, ActNo);
        CalcActRemaingAmount(PurchaseHeader, PaymentInvoice, LinkedActExists, RemAmount);

        PaymentInvoice.Reset();
        PaymentInvoice.FilterGroup(2);
        PaymentInvoice.SetCurrentKey("Buy-from Vendor No.", "Agreement No.");
        PaymentInvoice.SetRange("Buy-from Vendor No.", PurchaseHeader."Buy-from Vendor No.");
        PaymentInvoice.SetRange("Agreement No.", PurchaseHeader."Agreement No.");
        PaymentInvoice.SetRange("IW Documents", true);
        PaymentInvoice.SetRange("Linked Purchase Order Act No.", '');
        PaymentInvoice.SetRange("Document Type", PaymentInvoice."Document Type"::Order);
        PaymentInvoice.FilterGroup(0);
        if not PaymentInvoice.IsEmpty then begin
            PurchListApp.SetTableView(PaymentInvoice);
            PurchListApp.LookupMode(true);
            if PurchListApp.RunModal() = Action::LookupOK then begin
                PurchListApp.SetSelectionFilter(PaymentInvoice);
                if PaymentInvoice.FindSet() then
                    repeat
                        if RemAmount >= PaymentInvoice."Invoice Amount Incl. VAT" then begin
                            PaymentInvoice."Linked Purchase Order Act No." := ActNo;
                            PaymentInvoice.Modify();
                            RemAmount -= PaymentInvoice."Invoice Amount Incl. VAT";
                            LinkedCount += 1;
                        end;
                    until PaymentInvoice.next = 0;
                Message(LocText002, LinkedCount, ActNo);
            end;
            exit;
        end;
        Message(LocText001);
    end;

    local procedure CalcActRemaingAmount(PurchaseHeader: Record "Purchase Header"; PaymentInvoice: Record "Purchase Header"; var LinkedActExists: Boolean; var RemActAmount: Decimal)
    var
        LocText001: Label 'The total amount of linked payment orders exceeds the amount of Act %1.';
    begin
        PurchaseHeader.TestField("Invoice Amount Incl. VAT");
        RemActAmount := PurchaseHeader."Invoice Amount Incl. VAT";
        PaymentInvoice.SetCurrentKey("IW Documents", "Linked Purchase Order Act No.");
        PaymentInvoice.SetRange("IW Documents", true);
        PaymentInvoice.SetRange("Linked Purchase Order Act No.", PurchaseHeader."No.");
        PaymentInvoice.SetRange("Document Type", PaymentInvoice."Document Type"::Order);
        LinkedActExists := not PaymentInvoice.IsEmpty;
        if LinkedActExists then begin
            PaymentInvoice.CalcSums("Invoice Amount Incl. VAT");
            if PaymentInvoice."Invoice Amount Incl. VAT" >= PurchaseHeader."Invoice Amount Incl. VAT" then
                error(LocText001, PurchaseHeader."No.");
            RemActAmount -= PaymentInvoice."Invoice Amount Incl. VAT";
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

                        // SetPurchLineApprover(PurchLine, true);
                        PurchLine.MODIFY;
                    END;
                UNTIL VendArgDtld2.NEXT = 0;
            END;
        end;

    end;

    // NC AB: не используем, Approver заполяем на лету через функцию 
    // procedure SetPurchLineApprover(var PurchLine: Record "Purchase Line"; CheckSubstitute: Boolean)
    // var
    //     DimSetEntry: Record "Dimension Set Entry";
    //     DimValue: Record "Dimension Value";
    //      UserSetup: Record "User Setup";
    //     PurchasesSetup: Record "Purchases & Payables Setup";
    // begin
    //     with PurchLine do begin
    //         IF ("Dimension Set ID" = 0) or (Approver <> '') then
    //             EXIT;
    //         IF "Dimension Set ID" <> 0 THEN begin
    //             PurchasesSetup.GET;
    //             PurchasesSetup.TestField("Cost Place Dimension");
    //             IF DimSetEntry.GET("Dimension Set ID", PurchasesSetup."Cost Place Dimension") THEN
    //                 IF DimValue.GET(DimSetEntry."Dimension Code", DimSetEntry."Dimension Value Code") then
    //                     if not CheckSubstitute THEN
    //                         Approver := DimValue."Cost Holder"
    //                     else
    //                         if DimValue."Cost Holder" <> '' THEN BEGIN
    //                             UserSetup.GET(DimValue."Cost Holder");
    //                             IF UserSetup.Absents AND (UserSetup.Substitute <> '') THEN
    //                                 Approver := UserSetup.Substitute
    //                             ELSE
    //                                 Approver := UserSetup."User ID";
    //                         END;
    //         END;
    //     end;
    // end;

    // NC AB: не используем, Approver заполяем на лету через функцию 
    // procedure FillPurchLineApproverFromGlobalDim(GlobalDimNo: Integer; DimValueCode: code[20]; var PurchLine: Record "Purchase Line"; CheckSubstitute: Boolean)
    // var
    //     DimValue: Record "Dimension Value";
    //     UserSetup: Record "User Setup";
    //     PurchasesSetup: Record "Purchases & Payables Setup";
    // begin
    //     if DimValueCode = '' then
    //         exit;
    //     DimValue.SetRange(Code, DimValueCode);
    //     DimValue.SetRange("Global Dimension No.", GlobalDimNo);
    //     if not DimValue.FindFirst() then
    //         exit;
    //      PurchasesSetup.GET;
    //     PurchasesSetup.TestField("Cost Place Dimension");
    //     if PurchasesSetup."Cost Place Dimension" <> DimValue."Dimension Code" then
    //         exit;
    //     if not CheckSubstitute THEN
    //         PurchLine.Approver := DimValue."Cost Holder"
    //     else
    //         if DimValue."Cost Holder" <> '' THEN BEGIN
    //             UserSetup.GET(DimValue."Cost Holder");
    //             IF UserSetup.Absents AND (UserSetup.Substitute <> '') THEN
    //                 PurchLine.Approver := UserSetup.Substitute
    //             ELSE
    //                 PurchLine.Approver := UserSetup."User ID";
    //         END;
    // end;

    procedure PurchOrderActArchiveQst(PurchHeader: Record "Purchase Header"): Boolean;
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
                    exit(false);
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
                    IF not CONFIRM(Txt, TRUE) THEN
                        exit(false);
                    PurchOrderActArchive(PurchHeader);
                END ELSE
                    ERROR(LocText50011);
            END;
        end;
        exit(true);
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
        PurchHeader."Archiving Type" := PurchHeader."Archiving Type"::"Problem Act";
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

    procedure PurchPaymentInvoiceArchive(PurchHeader: Record "Purchase Header"): Boolean;
    var
        ArchiveMgt: Codeunit ArchiveManagement;
        ConfirmManagement: Codeunit "Confirm Management";
        LocText001: Label 'Document %1 has been archived.';
        LocText007: Label 'Archive %1 no.: %2?';
    begin
        PurchHeader.TestField("Status App", PurchHeader."Status App"::Payment);

        if not ConfirmManagement.GetResponseOrDefault(
             StrSubstNo(LocText007, PurchHeader."Document Type", PurchHeader."No."), true)
        then
            exit(false);
        PurchHeader."Archiving Type" := PurchHeader."Archiving Type"::"Problem Act";
        ArchiveMgt.StorePurchDocument(PurchHeader, false);
        //NC 44684 > KGT
        DisconnectFromAgreement(PurchHeader);
        //NC 44684 < KGT
        PurchHeader.SetHideValidationDialog(true);
        PurchHeader.Delete(true);
        Message(LocText001, PurchHeader."No.");
        exit(true);
    end;

    procedure DisconnectFromAgreement(PurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
        ProjectsBudgetEntry: Record "Projects Budget Entry";
        ForecastListAnalisys: page "Forecast List Analisys";
    begin
        // debug see later
        message('Вызов DisconnectFromAgreement');
        exit;

        //NC 44684 > KGT
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
        IF PurchaseLine.FINDSET THEN BEGIN
            REPEAT
                IF PurchaseLine."Forecast Entry" <> 0 THEN BEGIN
                    ProjectsBudgetEntry.SETCURRENTKEY("Entry No.");
                    ProjectsBudgetEntry.SETRANGE("Entry No.", PurchaseLine."Forecast Entry");
                    IF ProjectsBudgetEntry.FINDFIRST THEN BEGIN
                        PurchaseLine."Forecast Entry" := 0;
                        PurchaseLine.MODIFY;
                        ForecastListAnalisys.SETRECORD(ProjectsBudgetEntry);
                        message('Вызов ForecastListAnalisys.DisconnectFromAgreement');
                        exit;
                    END;
                END;
            UNTIL PurchaseLine.NEXT = 0;
        END;
        //NC 44684 < KGT
    end;

    procedure ApprovePurchaseOrderAct(PurchaseHeader: Record "Purchase Header")
    var
        ApprovalEntry: Record "Approval Entry";
        gcERPC: Codeunit "ERPC Funtions";
        ApprovalMgt: Codeunit "Approvals Mgmt.";
    begin

        //NC 40142 > DP
        IF PurchaseHeader."Location Document" THEN
            gcERPC.CheckShortCutDim1(PurchaseHeader);
        //NC 40142 < DP

        // NC AB: пока отключим, назначение непонятно
        // // SWC1041 DD 27.04.2017 >>
        // Wnd.OPEN('Утверждение акта или кс-2...');
        // grPurchHeader.LOCKTABLE;
        // grAttachment.LOCKTABLE;
        // ApprovalEntry.LOCKTABLE;
        // PurchHeaderAdd.LOCKTABLE;
        // PL.LOCKTABLE;
        // // SWC1041 DD 27.04.2017 <<

        CheckEmptyLines(PurchaseHeader); //SWC380 AKA 290115

        IF PurchaseHeader."Status App Act" = PurchaseHeader."Status App Act"::Approve THEN BEGIN
            // NC AB: используем стандарт, этого больше не надо, кроме одного момента ниже (set "Process User")
            // ApprovalEntry.SETRANGE("Table ID", 38);
            // ApprovalEntry.SETRANGE("Document Type", ApprovalEntry."Document Type"::Order);
            // ApprovalEntry.SETRANGE("Document No.", PurchaseHeader."No.");
            // // ApprovalEntry.SETRANGE("Approver ID", USERID);
            // ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
            // IF ApprovalEntry.FINDFIRST THEN BEGIN
            //     ApprovalMgt.ApproveApprovalRequest(ApprovalEntry);
            //     IF ApprovalEntry."Table ID" = DATABASE::"Purchase Header" THEN BEGIN
            //         IF PurchaseHeader.GET(ApprovalEntry."Document Type", ApprovalEntry."Document No.") THEN BEGIN
            //             ApproverCheck := PurchHeaderAdd.GetCheckApprover("Document Type", "No."); //SWC380 AKA 190115
            //             IF NOT ApproverCheck THEN                                                 //SWC380 AKA 190115
            //             BEGIN                                                                     //SWC380 AKA 190115
            //                PurchaseHeader."Process User" := gcERPC.GetCurrentAppr(PurchaseHeader);
            //                PurchaseHeader."Date Status App" := TODAY;
            //                PurchaseHeader.MODIFY;
            //            END;                                                                      //SWC380 AKA 190115
            //        END;
            //    END;
            //END ELSE BEGIN
            //    ApprovalEntry.SETFILTER(Status, '%1|%2', ApprovalEntry.Status::Created, ApprovalEntry.Status::Approved);
            //    IF ApprovalEntry.FINDSET THEN
            //        MESSAGE('Вы уже утвердили заявку ранее', USERID)
            //    ELSE
            //        MESSAGE('Утверждающий %1 отсутствует в таблице утверждения!', USERID);
            //END;
            ERROR('Дошли до статуса Approve!')
        END ELSE BEGIN
            IF PurchaseHeader."Act Type" in [PurchaseHeader."Act Type"::Act, PurchaseHeader."Act Type"::"Act (Production)"] THEN
                gcERPC.ChangeActStatus(PurchaseHeader);
            IF PurchaseHeader."Act Type" in [PurchaseHeader."Act Type"::"KC-2", PurchaseHeader."Act Type"::"KC-2 (Production)"] THEN
                ERROR('gcERPC.ChangeKC2Status(Rec);');
        END;
    end;

    local procedure CheckEmptyLines(PurchaseHeader: Record "Purchase Header")
    var
        PurchLineLoc: Record "Purchase Line";
    begin
        //SWC380 AKA 290115
        PurchLineLoc.SETRANGE("Document Type", PurchaseHeader."Document Type");
        PurchLineLoc.SETRANGE("Document No.", PurchaseHeader."No.");
        PurchLineLoc.SETFILTER(Type, '<>%1', PurchLineLoc.Type::" ");
        IF PurchLineLoc.FINDSET THEN
            REPEAT
                PurchLineLoc.TESTFIELD("No.");
                PurchLineLoc.TESTFIELD("Full Description");
                PurchLineLoc.TESTFIELD(Quantity);
            UNTIL PurchLineLoc.NEXT = 0;
    end;

    procedure GetPurchActApproverFromDim(DimSetID: Integer): Code[50]
    var
        DimSetEntry: Record "Dimension Set Entry";
        DimValueCC: Record "Dimension Value";
        DimValueCP: Record "Dimension Value";
    begin
        if DimSetID = 0 then
            exit('');
        GetPurchSetupWithTestDim();
        if not DimSetEntry.Get(DimSetID, PurchSetup."Cost Code Dimension") then
            exit('');
        if not DimValueCC.Get(DimSetEntry."Dimension Code", DimSetEntry."Dimension Value Code") then
            exit('');
        if not DimSetEntry.Get(DimSetID, PurchSetup."Cost Place Dimension") then
            exit('');
        if not DimValueCP.Get(DimSetEntry."Dimension Code", DimSetEntry."Dimension Value Code") then
            exit('');
        case DimValueCC."Cost Code Type" of
            DimValueCC."Cost Code Type"::Development:
                exit(GetApproverSubstitute(DimValueCP."Development Cost Place Holder"));
            DimValueCC."Cost Code Type"::Production:
                exit(GetApproverSubstitute(DimValueCP."Production Cost Place Holder"));
            DimValueCC."Cost Code Type"::Admin:
                exit(GetApproverSubstitute(DimValueCP."Admin Cost Place Holder"));
        end;
    end;

    procedure GetPurchActPreApproverFromDim(DimSetID: Integer): Code[50]
    var
        DimSetEntry: Record "Dimension Set Entry";
        DimValueCC: Record "Dimension Value";
    begin
        if DimSetID = 0 then
            exit('');
        GetPurchSetupWithTestDim();
        if not DimSetEntry.Get(DimSetID, PurchSetup."Cost Code Dimension") then
            exit('');
        if not DimValueCC.Get(DimSetEntry."Dimension Code", DimSetEntry."Dimension Value Code") then
            exit('');
        exit(GetApproverSubstitute(DimValueCC."Cost Holder"));
    end;

    local procedure GetApproverSubstitute(ApproverCode: Code[50]): Code[50]
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.GET(ApproverCode);
        IF UserSetup.Absents AND (UserSetup.Substitute <> '') THEN
            exit(UserSetup.Substitute)
        ELSE
            exit(UserSetup."User ID");
    end;

}