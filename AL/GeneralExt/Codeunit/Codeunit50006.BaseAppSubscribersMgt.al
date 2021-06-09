codeunit 50006 "Base App. Subscribers Mgt."
{
    // t 81 >>
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterValidateEvent', 'Prepayment', false, false)]
    local procedure onAfterValidatePrepayment(Rec: Record "Gen. Journal Line"; xRec: Record "Gen. Journal Line"; CurrFieldNo: Integer)
    begin
        if Rec.Prepayment then begin
            if (xRec."Prepayment Document No." = '') then begin
                Rec."Prepayment Document No." := '';
                SetPrepaymentDoc(Rec);
            end;
        end;

    end;

    local procedure SetPrepaymentDoc(var GenJnlLine2: Record "Gen. Journal Line")
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesSetup: Record "Sales & Receivables Setup";
        ReleaseDoc: Codeunit "Release Sales Document";
        LText001: Label 'Advance %1';
        Text50000: label 'Create sales invoice?';
    begin
        //NC 23904 HR beg
        IF NOT CONFIRM(Text50000, FALSE) THEN
            EXIT;

        SalesSetup.GET;
        SalesSetup.TESTFIELD("Invoice Nos.");
        SalesSetup.TESTFIELD("Prepay. Inv. G/L Acc. No. (ac)");

        SalesHeader.INIT;
        SalesHeader.VALIDATE("No. Series", SalesSetup."Invoice Nos.");
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader.VALIDATE("Posting Date", GenJnlLine2."Posting Date");
        SalesHeader."No." := '';
        SalesHeader.INSERT(TRUE);

        SalesHeader."External Document No." := GenJnlLine2."Document No.";
        SalesHeader.VALIDATE("Sell-to Customer No.", GenJnlLine2."Account No.");
        SalesHeader.VALIDATE("Agreement No.", GenJnlLine2."Agreement No.");
        SalesHeader."Posting Description" :=
          COPYSTR(STRSUBSTNO(LText001, GenJnlLine2.Description), 1, MAXSTRLEN(SalesHeader."Posting Description"));
        SalesHeader.VALIDATE("Shortcut Dimension 1 Code", GenJnlLine2."Shortcut Dimension 1 Code");
        SalesHeader.VALIDATE("Shortcut Dimension 2 Code", GenJnlLine2."Shortcut Dimension 2 Code");
        SalesHeader.MODIFY(TRUE);

        SalesLine.INIT;
        SalesLine.VALIDATE("Document Type", SalesHeader."Document Type");
        SalesLine.VALIDATE("Document No.", SalesHeader."No.");
        SalesLine."Line No." := 10000;
        SalesLine.VALIDATE("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
        //SalesLine.VALIDATE("Bill-to Customer No.", SalesHeader."Bill-to Customer No.");
        SalesLine.VALIDATE(Type, SalesLine.Type::"G/L Account");
        SalesLine.VALIDATE("No.", SalesSetup."Prepay. Inv. G/L Acc. No. (ac)"); //'901034110'
        SalesLine.VALIDATE(Quantity, 1);
        SalesLine.VALIDATE("Unit of Measure Code", 'УСЛ');
        SalesLine.VALIDATE("Unit Price", ABS(GenJnlLine2.Amount));
        SalesLine.INSERT(TRUE);

        ReleaseDoc.RUN(SalesHeader);

        GenJnlLine2.VALIDATE("Prepayment Document No.", SalesHeader."No.");

        Page.RUN(page::"Sales Invoice", SalesHeader);

        //NC 23904 HR end
    end;
    // t 81 <<

    // t 5740 >>
    [EventSubscriber(ObjectType::Table, Database::"Transfer Header", 'OnUpdateTransLines', '', false, false)]
    local procedure OnUpdateTransLines(var TransferLine: Record "Transfer Line"; TransferHeader: Record "Transfer Header"; FieldID: Integer);
    var
        Location: Record Location;
    begin
        case FieldID of
            TransferHeader.FieldNo("Vendor No."):
                begin
                    //NC 22512 > DP
                    IF Location.GET(TransferLine."Transfer-to Code") AND Location."Bin Mandatory" THEN
                        TransferLine.VALIDATE("Transfer-To Bin Code", TransferHeader."Vendor No.");
                    //NC 22512 < DP
                end;
            // NC 51144 GG >>
            TransferHeader.FieldNo("New Shortcut Dimension 1 Code"):
                begin
                    TransferLine.Validate("New Shortcut Dimension 1 Code", TransferHeader."New Shortcut Dimension 1 Code");
                end;
            TransferHeader.FieldNo("New Shortcut Dimension 2 Code"):
                begin
                    TransferLine.Validate("New Shortcut Dimension 2 Code", TransferHeader."New Shortcut Dimension 2 Code");
                end;
        // NC 51144 GG <<
        end
    end;

    // t 5740 <<
    // cu 367 >>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::CheckManagement, 'OnBeforeVoidCheckGenJnlLine2Modify', '', false, false)]
    local procedure OnBeforeVoidCheckGenJnlLine2Modify(var GenJournalLine2: Record "Gen. Journal Line"; GenJournalLine: Record "Gen. Journal Line");
    begin
        GenJournalLine2."Document No." := GenJournalLine."Document No.";
    end;

    // cu 367 <<
    [EventSubscriber(ObjectType::Table, DATABASE::"Report Selections", 'OnBeforeSetReportLayoutCustom', '', true, true)]
    local procedure SetDocumentPrintBufferUserFilter(RecordVariant: Variant; ReportUsage: Integer; var DocumentPrintBuffer: Record "Document Print Buffer")
    begin
        DocumentPrintBuffer.SetRange("User ID", UserId());
        if DocumentPrintBuffer.FindFirst() then;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"FA Document-Post", 'OnBeforePostFAReleaseMovement', '', false, false)]
    local procedure CustomPostFAReleaseMovement(sender: Codeunit "FA Document-Post"; DocType: Option; var FADocLine: Record "FA Document Line"; var FADeprBook: Record "FA Depreciation Book"; var FADeprBook2: Record "FA Depreciation Book"; var FAReclassJnlLine: Record "FA Reclass. Journal Line"; var FAJnlSetup: Record "FA Journal Setup"; var GenJnlLine: Record "Gen. Journal Line"; var TaxRegisterSetup: Record "Tax Register Setup"; var FA: Record "Fixed Asset"; var FAJnlLine: Record "FA Journal Line"; var PostedFADocHeader: Record "Posted FA Doc. Header"; var FAReclassCheckLine: Codeunit "FA Reclass. Check Line"; var FAReclassTransferLine: Codeunit "FA Reclass. Transfer Line"; var DimMgt: Codeunit DimensionManagement; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var FAJnlPostLine: Codeunit "FA Jnl.-Post Line"; var ReclassDone: Boolean; var PreviewMode: Boolean; var IsHandled: Boolean)
    var
        FADocHeader: Record "FA Document Header";
        FAReclassTransferLineExt: Codeunit "FA Reclass. Transfer Line Ext";
    begin
        if (DocType = FADocHeader."Document Type"::Release) or
           (FADocLine."FA No." <> FADocLine."New FA No.") or
           (FADocLine."Depreciation Book Code" <> FADocLine."New Depreciation Book Code") or // reclassification
           (FADocLine."FA Posting Group" <> FADocLine."New FA Posting Group")
        then begin
            FADeprBook.Get(FADocLine."FA No.", FADocLine."Depreciation Book Code");
            FADeprBook2.Get(FADocLine."New FA No.", FADocLine."New Depreciation Book Code");
            if (DocType = FADocHeader."Document Type"::Release) or
                (FADocLine."FA No." <> FADocLine."New FA No.") or
                (FADocLine."Depreciation Book Code" <> FADocLine."New Depreciation Book Code")
            then begin
                FADeprBook2."Depreciation Starting Date" := CalcDate('<CM+1D>', FADocLine."FA Posting Date");
                if FADeprBook."No. of Depreciation Years" > 0 then
                    FADeprBook2.Validate("No. of Depreciation Years", FADeprBook."No. of Depreciation Years")
                else
                    FADeprBook2.Validate("No. of Depreciation Years");
            end;
            FADeprBook2.Modify();

            FAReclassJnlLine.Init();
            FAReclassJnlLine.Validate("FA No.", FADocLine."FA No.");
            if FADocLine."New FA No." <> '' then
                FAReclassJnlLine.Validate("New FA No.", FADocLine."New FA No.")
            else
                FAReclassJnlLine.Validate("New FA No.", FADocLine."FA No.");
            FAReclassJnlLine."FA Posting Date" := FADocLine."FA Posting Date";
            FAReclassJnlLine."Posting Date" := FADocLine."Posting Date";
            FAReclassJnlLine."Depreciation Book Code" := FADocLine."Depreciation Book Code";
            FAReclassJnlLine."New Depreciation Book Code" := FADocLine."New Depreciation Book Code";
            FAReclassJnlLine.Description := FADocLine.Description;
            FAReclassJnlLine."Document No." := PostedFADocHeader."No.";
            FAReclassJnlLine."FA Location Code" := FADocLine."FA Location Code";
            FAReclassJnlLine."Employee No." := FADocLine."FA Employee No.";
            FAReclassJnlLine."FA Posting Group" := FADocLine."FA Posting Group";
            FAReclassJnlLine."New FA Posting Group" := FADocLine."New FA Posting Group";
            FAReclassJnlLine.Validate(Quantity, FADocLine.Quantity);
            FAReclassJnlLine."Reclassify Acquisition Cost" := true;
            FAReclassJnlLine."Reclassify Write-Down" := true;
            FAReclassJnlLine."Reclassify Appreciation" := true;
            FAReclassJnlLine."Reclassify Depreciation" := DocType = FADocHeader."Document Type"::Movement;
            FAReclassCheckLine.Run(FAReclassJnlLine);
            FAReclassTransferLineExt.FAReclassLine(FAReclassJnlLine, ReclassDone);

            if (FADocLine."New FA Posting Group" <> '') and (FADeprBook2."FA Posting Group" <> FADocLine."New FA Posting Group") then begin
                FADeprBook2.Get(FADocLine."New FA No.", FADocLine."New Depreciation Book Code");
                FADeprBook2."FA Posting Group" := FADocLine."New FA Posting Group";
                FADeprBook2.modify;
            end;

            // Post G/L or FA Journal Lines
            Clear(FAJnlSetup);
            if not FAJnlSetup.Get(FADocLine."Depreciation Book Code", UserId) then
                FAJnlSetup.Get(FADocLine."Depreciation Book Code", '');

            GenJnlLine.SetRange("Document No.", PostedFADocHeader."No.");
            GenJnlLine.SetRange("Object Type", GenJnlLine."Account Type"::"Fixed Asset");
            GenJnlLine.SetRange("Object No.", FADocLine."FA No.");
            if GenJnlLine.FindSet then begin
                repeat
                    GenJnlLine."Shortcut Dimension 1 Code" := FADocLine."Shortcut Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := FADocLine."Shortcut Dimension 2 Code";
                    GenJnlLine."Dimension Set ID" := FADocLine."Dimension Set ID";
                    GenJnlLine."Reason Code" := FADocLine."Reason Code";
                    GenJnlLine."Tax Difference Code" := TaxRegisterSetup."Default FA TD Code";
                    if GenJnlLine.Quantity < 1 then
                        GetFADefaultDim(
                          FA."No.",
                          GenJnlLine."Shortcut Dimension 1 Code",
                          GenJnlLine."Shortcut Dimension 2 Code",
                          GenJnlLine."Dimension Set ID",
                          FADocLine."Source Code",
                          DimMgt);

                    GenJnlPostLine.SetPreviewMode(PreviewMode);
                    GenJnlPostLine.RunWithCheck(GenJnlLine);
                until GenJnlLine.Next = 0;
                GenJnlLine.DeleteAll(true);
            end;

            FAJnlLine.SetRange("Document No.", PostedFADocHeader."No.");
            FAJnlLine.SetRange("FA No.", FADocLine."FA No.");
            if FAJnlLine.FindSet then begin
                repeat
                    FAJnlLine."Shortcut Dimension 1 Code" := FADocLine."Shortcut Dimension 1 Code";
                    FAJnlLine."Shortcut Dimension 2 Code" := FADocLine."Shortcut Dimension 2 Code";
                    FAJnlLine."Dimension Set ID" := FADocLine."Dimension Set ID";
                    FAJnlPostLine.FAJnlPostLine(FAJnlLine, true);
                until FAJnlLine.Next = 0;
                FAJnlLine.DeleteAll(true);
            end;
        end else // Just FA Entry posting
            sender.FAPostTransfer(FADocLine, true);
        FA.Get(FADocLine."FA No.");
        FA.Validate("Global Dimension 1 Code", FADocLine."Shortcut Dimension 1 Code");
        FA.Validate("Global Dimension 2 Code", FADocLine."Shortcut Dimension 2 Code");
        if DocType = FADocHeader."Document Type"::Release then begin
            FA.Status := FA.Status::Operation;
            FA."Initial Release Date" := PostedFADocHeader."FA Posting Date";
        end;
        if DocType = FADocHeader."Document Type"::Movement then begin
            FA.Status := FADocLine.Status;
            FA."Status Date" := PostedFADocHeader."FA Posting Date";
        end;
        FA."Status Document No." := PostedFADocHeader."No.";
        FA.Modify();

        IsHandled := true;
    end;

    local procedure GetFADefaultDim(FANo: Code[20]; var GlobalDimCode1: Code[20]; var GlobalDimCode2: Code[20]; var DimSetID: Integer; SourceCode: Code[20]; var DimMgt: Codeunit DimensionManagement)
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        TableID[1] := DATABASE::"Fixed Asset";
        No[1] := FANo;
        GlobalDimCode1 := '';
        GlobalDimCode2 := '';
        DimSetID := DimMgt.GetDefaultDimID(TableID, No, SourceCode, GlobalDimCode1, GlobalDimCode2, 0, 0);
    end;

    [EventSubscriber(ObjectType::Codeunit, COdeunit::"FA Insert Ledger Entry", 'OnBeforeCheckFADocNo', '', true, true)]
    local procedure CheckFADocNo(FALedgEntry: Record "FA Ledger Entry"; var IsHandled: Boolean)
    var
        FA: Record "Fixed Asset";
        OldFALedgEntry: Record "FA Ledger Entry";
        FALedgEntry2: Record "FA Ledger Entry";
        DepreciationCalc: Codeunit "Depreciation Calculation";
        ErrText001: Label '%1 = %2 already exists for %5 (%3 = %4).';
    begin
        if FA.Get(FALedgEntry."FA No.") then;
        OldFALedgEntry.SetCurrentKey("FA No.", "Depreciation Book Code", "FA Posting Category", "FA Posting Type", "Document No.");
        OldFALedgEntry.SetRange("FA No.", FALedgEntry."FA No.");
        OldFALedgEntry.SetRange("Depreciation Book Code", FALedgEntry."Depreciation Book Code");
        OldFALedgEntry.SetRange("FA Posting Category", FALedgEntry."FA Posting Category");
        OldFALedgEntry.SetRange("FA Posting Type", FALedgEntry."FA Posting Type");
        OldFALedgEntry.SetRange("Document No.", FALedgEntry."Document No.");
        OldFALedgEntry.SetRange("Entry No.", 0, FALedgEntry2.GetLastEntryNo());
        OldFALedgEntry.SetRange("FA Posting Group", FALedgEntry."FA Posting Group");
        if OldFALedgEntry.FindFirst then
            Error(
              ErrText001,
              OldFALedgEntry.FieldCaption("Document No."),
              OldFALedgEntry."Document No.",
              OldFALedgEntry.FieldCaption("FA Posting Type"),
              OldFALedgEntry."FA Posting Type",
              DepreciationCalc.FAName(FA, FALedgEntry."Depreciation Book Code"));

        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', true, true)]
    local procedure OnBeforeDrillDownDocAttFackBox(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        VendAgreement: Record "Vendor Agreement";
    begin
        case DocumentAttachment."Table ID" of
            DATABASE::"Vendor Agreement":
                begin
                    RecRef.Open(DATABASE::"Vendor Agreement");
                    VendAgreement.Reset();
                    if DocumentAttachment."PK Key 2" <> '' then
                        VendAgreement.SetRange("Vendor No.", DocumentAttachment."PK Key 2");
                    VendAgreement.SetRange("No.", DocumentAttachment."No.");
                    if VendAgreement.FindFirst() then
                        RecRef.GetTable(VendAgreement);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', true, true)]
    local procedure OnAfterOpenForRecRefDocAttDet(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef; var FlowFieldsEditable: Boolean)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        PKNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::"Vendor Agreement":
                begin
                    FieldRef := RecRef.Field(1);
                    PKNo := FieldRef.Value;
                    FieldRef := RecRef.Field(2);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("PK Key 2", PKNo);
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnInsertRecordEvent', '', true, true)]
    local procedure OnInsertRecordDocAttDetails(VAR Rec: Record "Document Attachment"; BelowxRec: Boolean; VAR xRec: Record "Document Attachment"; VAR AllowInsert: Boolean)
    var
        CurrFltGr: Integer;
    begin
        if Rec.GetFilter("PK Key 2") <> '' then
            Rec."PK Key 2" := Rec.GetFilter("PK Key 2");
        if Rec."Attachment Link" <> '' then begin
            if IsNullGuid(rec."Attached By") then
                rec."Attached By" := UserSecurityId();
            rec.Insert(false);
            AllowInsert := false;
        end;
    end;

    // Codeunit 5063 ArchiveManagement 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ArchiveManagement, 'OnAfterStorePurchDocument', '', false, false)]
    local procedure OnAfterStorePurchDocument(var PurchaseHeader: Record "Purchase Header"; var PurchaseHeaderArchive: Record "Purchase Header Archive");
    var
        DocAttach: Record "Document Attachment";
        DocAttachArch: Record "Document Attachment Archive";
    begin
        if PurchaseHeader."Archiving Type" = PurchaseHeader."Archiving Type"::" " then
            exit;

        DocAttach.SetFilter("Table ID", '%1|%2', Database::"Purchase Header", Database::"Purchase Line");
        DocAttach.SetRange("Document Type", PurchaseHeader."Document Type");
        DocAttach.SetRange("No.", PurchaseHeader."No.");
        if DocAttach.FindSet() then
            repeat
                DocAttachArch.Init();
                DocAttachArch.TransferFields(DocAttach);
                IF DocAttach."Table ID" = Database::"Purchase Header" then
                    DocAttachArch."Table ID" := Database::"Purchase Header Archive"
                else
                    DocAttachArch."Table ID" := Database::"Purchase Line Archive";
                DocAttachArch."Version No." := PurchaseHeaderArchive."Version No.";
                DocAttachArch."Doc. No. Occurrence" := PurchaseHeaderArchive."Doc. No. Occurrence";
                DocAttach.CalcFields("Document Reference ID");
                DocAttachArch."Document Reference ID" := DocAttach."Document Reference ID";
                DocAttachArch.INSERT;
            until DocAttach.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Transfer Document", 'OnBeforeCheckTransLines', '', false, false)]
    local procedure OnBeforeCheckTransLines(var TransferLine: Record "Transfer Line";
                                            var IsHandled: Boolean;
                                            TransHeader: Record "Transfer Header");
    var
        InvtSetup: Record "Inventory Setup";
    begin
        // NC 51411 > EP
        // Перенес модификацию из cu "Release Transfer Document".OnRun()

        // SWC816 AK 200416 >>
        InvtSetup.Get();
        if InvtSetup."Use Giv. Production Func." then begin
            InvtSetup.TestField("Giv. Materials Loc. Code");
            if (TransHeader."Transfer-from Code" = InvtSetup."Giv. Materials Loc. Code") or
               (TransHeader."Transfer-to Code" = InvtSetup."Giv. Materials Loc. Code") then begin
                TransHeader.TestField("Vendor No.");
                TransHeader.TestField("Agreement No.");
            end;
        end;
        // SWC816 AK 200416 <<

        // NC 51411 < EP
    end;

    // Table 38 Purchase Header
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeTestNoSeries', '', false, false)]
    local procedure OnBeforeTestNoSeries(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean);
    var
        PurchSetup: Record "Purchases & Payables Setup";
    begin
        IsHandled := true;
        PurchSetup.Get();
        with PurchaseHeader do
            case "Document Type" of
                "Document Type"::Quote:
                    PurchSetup.TestField("Quote Nos.");
                "Document Type"::Order:
                    //PurchSetup.TestField("Order Nos.");
                    if "Act Type" = "Act Type"::" " then begin
                        if not "IW Documents" then
                            PurchSetup.TestField("Order Nos.")
                        else
                            PurchSetup.TestField("Payment Request Nos.");
                    end else
                        PurchSetup.TestField("Act Order Nos.");
                "Document Type"::Invoice:
                    begin
                        if "Empl. Purchase" then
                            PurchSetup.TestField("Advance Statement Nos.")
                        else begin
                            PurchSetup.TestField("Invoice Nos.");
                            PurchSetup.TestField("Posted Invoice Nos.");
                        end;
                    end;
                "Document Type"::"Return Order":
                    PurchSetup.TestField("Return Order Nos.");
                "Document Type"::"Credit Memo":
                    begin
                        PurchSetup.TestField("Credit Memo Nos.");
                        PurchSetup.TestField("Posted Credit Memo Nos.");
                    end;
                "Document Type"::"Blanket Order":
                    PurchSetup.TestField("Blanket Order Nos.");
            end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterGetNoSeriesCode', '', false, false)]
    local procedure OnAfterGetNoSeriesCode(var PurchHeader: Record "Purchase Header"; PurchSetup: Record "Purchases & Payables Setup"; var NoSeriesCode: Code[20]);
    begin
        if PurchHeader."Document Type" = PurchHeader."Document Type"::Order then begin
            if PurchHeader."Act Type" = PurchHeader."Act Type"::" " then begin
                if PurchHeader."IW Documents" then
                    NoSeriesCode := PurchSetup."Payment Request Nos.";
            end else
                NoSeriesCode := PurchSetup."Act Order Nos.";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterFinalizePosting', '', false, false)]
    local procedure SendVendorAgreementMail(var PurchHeader: Record "Purchase Header")
    var
        CompanyInfo: Record "Company Information";
        LocVend: Record Vendor;
        VendAgr: Record "Vendor Agreement";
        CheckLimitDateFilter: Text;
        VendorAgreement: Record "Vendor Agreement";
    begin
        if (PurchHjreader."Buy-from Address" <> '') AND (PurchHeader."Agreement No." <> '') then begin
            CompanyInfo.Get;
            LocVend.GET(PurchHeader."Buy-from Address");

            if CompanyInfo."Use RedFlags in Agreements" then
                if LocVend.GetLineColor = 'Attention' then begin
                    VendAgr.Get(PurchHeader."Buy-from Address", PurchHeader."Agreement No.");
                    CheckLimitDateFilter := VendAgr.GetLimitDateFilter();

                    if CheckLimitDateFilter <> '' then
                        VendAgr.SetFilter("Check Limit Date Filter", CheckLimitDateFilter)
                    else
                        VendAgr.SetRange("Check Limit Date Filter");

                    VendAgr.CalcFields("Purch. Original Amt. (LCY)");

                    if PurchHeader."Original Company" = '' then
                        if (VendAgr."Check Limit Amount (LCY)" - VendAgr."Purch. Original Amt. (LCY)" < 0) then
                            VendorAgreement.SendVendAgrMail(VendAgr, 1);
                end;
        end;
    end;
}