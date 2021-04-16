codeunit 50006 "Base App. Subscribers Mgt."
{
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
}