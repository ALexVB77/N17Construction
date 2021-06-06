codeunit 50004 "Cen. Jnl. -Post Line (Ext)"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnUpdateVendorPostingGroup', '', false, false)]
    local procedure OnUpdateVendorPostingGroup(sender: Codeunit "Gen. Jnl.-Post Line";
                                               var VendPostingGr: Record "Vendor Posting Group";
                                               var DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";
                                               var UseAddCurrAmount: Boolean;
                                               var GLEntry: Record "G/L Entry";
                                               var GenJnlLine: Record "Gen. Journal Line")
    var
        OldVendPostingGroup: Record "Vendor Posting Group";
        Vend: Record "Vendor";
        VendAgreemnt: Record "Vendor Agreement";
        LCYCurrency: Record "Currency";
        VATAgentVATPmtAmount: Decimal;
        VATAgentACYAmount: Decimal;
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        OldVendPostingGroup := VendPostingGr;
        if Vend.Get(DtldCVLedgEntryBuf."CV No.") and Vend."VAT Agent" then begin
            if DtldCVLedgEntryBuf."Agreement No." <> '' then begin
                VendAgreemnt.GET(Vend."No.", DtldCVLedgEntryBuf."Agreement No.");
                VendAgreemnt.TestField("Vat Agent Posting Group");
                VendPostingGr.Get(VendAgreemnt."Vat Agent Posting Group");
            end else begin
                Vend.TestField("Vat Agent Posting Group");
                VendPostingGr.Get(Vend."Vat Agent Posting Group");
            end;
            LCYCurrency.InitRoundingPrecision();
            VATPostingSetup.Get(DtldCVLedgEntryBuf."VAT Bus. Posting Group", DtldCVLedgEntryBuf."VAT Prod. Posting Group");
            VATAgentVATPmtAmount := Round(DtldCVLedgEntryBuf."Amount (LCY)" * VATPostingSetup."VAT %" / 100,
                                         LCYCurrency."Amount Rounding Precision", LCYCurrency.VATRoundingDirection());
            VATAgentACYAmount := Round(DtldCVLedgEntryBuf."Additional-Currency Amount" * VATPostingSetup."VAT %" / 100,
                                       LCYCurrency."Amount Rounding Precision", LCYCurrency.VATRoundingDirection);
            sender.InitGLEntry(GenJnlLine, GLEntry, OldVendPostingGroup."Payables Account", -VATAgentVATPmtAmount, -VATAgentACYAmount, UseAddCurrAmount, true);
            GLEntry."Bal. Account Type" := GLEntry."Bal. Account Type"::"G/L Account";
            GLEntry."Bal. Account No." := VendPostingGr."Prepayment Account";
            sender.InitGLEntry(GenJnlLine, GLEntry, VendPostingGr."Prepayment Account", VATAgentVATPmtAmount, VATAgentACYAmount, UseAddCurrAmount, true);
            GLEntry."Bal. Account Type" := GLEntry."Bal. Account Type"::"G/L Account";
            GLEntry."Bal. Account No." := OldVendPostingGroup."Payables Account";
            sender.InsertGLEntry(GenJnlLine, GLEntry, true);
        end;
        VendPostingGr := OldVendPostingGroup;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnUpdatePostingGroupInGenJnlLine', '', false, false)]
    local procedure OnUpdatePostingGroupInGenJnlLine(var GenJnlLine: Record "Gen. Journal Line";
                                                     var Vend: Record "Vendor";
                                                     var VendAgrmt: Record "Vendor Agreement")
    begin
        if GenJnlLine.Prepayment then begin
            Vend.TestField("Vat Agent Posting Group");
            IF GenJnlLine."Agreement No." <> '' then begin
                GenJnlLine."Posting Group" := VendAgrmt."Vat Agent Posting Group";
            end else begin
                GenJnlLine."Posting Group" := Vend."Vat Agent Posting Group";
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterFinalizePosting', '', false, false)]
    local procedure SendVendorAgreementMail(sender: Codeunit "Purch.-Post")
    begin
        // if ("Buy-" <> '') AND (AgreementNo <> '') then begin
        //         //SWC003 SM 100414 >>
        //         CompanyInfo.GET;
        //         LocVend.GET(VendorNo);
        //         IF CompanyInfo."Use RedFlags in Agreements" THEN
        //         //IF NOT (LocVend."Vendor Type" IN [Vend."Vendor Type"::"Resp. Employee",
        //         //                                 Vend."Vendor Type"::"Tax Authority"]) THEN
        //         IF LocVend.GetLineColor = 255 THEN //SWC003 SM 200514
        //         BEGIN
        //         //SWC003 SM 100414 <<
        //          VendAgr.GET(VendorNo, AgreementNo);
        //          CheckLimitDateFilter := VendAgr.GetLimitDateFilter();
        //          IF CheckLimitDateFilter <> '' THEN
        //            VendAgr.SETFILTER("Check Limit Date Filter", CheckLimitDateFilter)
        //          ELSE
        //            VendAgr.SETRANGE("Check Limit Date Filter");
        //          VendAgr.CALCFIELDS("Purch. Original Amt. (LCY)");
        //          IF PurchHeader."Original Company" = '' THEN //NCS-980
        //          IF (VendAgr."Check Limit Amount (LCY)"-VendAgr."Purch. Original Amt. (LCY)" < 0) THEN
        //            MgtNotif.SendVendAgrMail(VendAgr,1);
        //         END; //SWC003
        //       END;
        //       // SWC001 AK 20131212 <<
    end;
}