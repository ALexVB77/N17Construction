codeunit 50013 "Project Budget Management"
{
    trigger OnRun()
    begin

    end;

    var
        GLSetup: Record "General Ledger Setup";
        US: Record "User Setup";

    procedure ApplyPrjBudEntrytoPurchLine(var vPLine: Record "Purchase Line")
    var
        lPHead: Record "Purchase Header";
        lPBE: Record "Projects Budget Entry";
        lPBEtmp: Record "Projects Budget Entry" temporary;
        lExchRate: Record "Currency Exchange Rate";
        lLineAmt: Decimal;
    begin
        vPLine.TestField("Shortcut Dimension 1 Code");
        vPLine.TestField("Shortcut Dimension 2 Code");
        vPLine.TestField(Amount);
        lPHead.Get(vPLine."Document Type", vPLine."Document No.");
        lPHead.TestField("Buy-from Vendor No.");
        lPHead.TestField("Agreement No.");
        lPBEtmp.Reset();
        lPBEtmp.DeleteAll();
        lPBE.Reset();
        lPBE.SetRange("Shortcut Dimension 1 Code", vPLine."Shortcut Dimension 1 Code");
        lPBE.SetFilter("Shortcut Dimension 2 Code", '%1|%2', '', vPLine."Shortcut Dimension 2 Code");
        lPBE.SetRange("Contragent Type", lPBE."Contragent Type"::Vendor);
        lPBE.SetFilter("Contragent No.", '%1|%2', '', lPHead."Buy-from Vendor No.");
        lpbe.SetFilter("Agreement No.", '%1|%2', '', lPHead."Agreement No.");
        lLineAmt := vPLine.Amount / lExchRate.ExchangeRate(WorkDate(), vPLine."Currency Code");
        lPBE.SetFilter("Without VAT", '>=%1', lLineAmt);
        if lPBE.FindSet() then
            repeat
                if lPBE."Entry No." = lPBE."Parent Entry" then begin
                    lPBEtmp := lPBE;
                    lPBEtmp.Insert(false);
                end else begin
                    if (lPBE."Contragent No." <> '') and (lPBE."Agreement No." <> '') and (lpbe."Shortcut Dimension 2 Code" <> '') then begin
                        lPBEtmp := lPBE;
                        lPBEtmp.Insert(false);
                    end
                end;
            until lPBE.next = 0;
        if Page.RunModal(70141, lPBEtmp) = Action::LookupOK then begin
            vPLine."Forecast Entry" := CreatePrjBudEntry(vPLine, lPBEtmp);
            vPLine.Modify();
        end;
    end;

    procedure CreatePrjBudEntry(pPLine: Record "Purchase Line"; pPBE: Record "Projects Budget Entry") EntryNo: Integer
    var
        lPBE: Record "Projects Budget Entry";
        lParentPBE: Record "Projects Budget Entry";
        lPHead: Record "Purchase Header";
        lDimVal: Record "Dimension Value";
        lExchRate: Record "Currency Exchange Rate";
        lLineAmt: Decimal;
    begin
        lPHead.Get(pPLine."Document Type", pPLine."Document No.");
        lPHead.CalcFields("External Agreement No. (Calc)");
        GLSetup.Get;
        lDimVal.Get(GLSetup."Global Dimension 1 Code", pPLine."Shortcut Dimension 1 Code");
        lLineAmt := pPLine.Amount / lExchRate.ExchangeRate(WorkDate(), pPLine."Currency Code");
        lPBE.Init();
        lPBE.Date := lPHead."Posting Date";
        lPBE."Project Code" := lDimVal."Project Code";
        lPBE."Shortcut Dimension 1 Code" := pPLine."Shortcut Dimension 1 Code";
        lPBE."Shortcut Dimension 2 Code" := pPLine."Shortcut Dimension 2 Code";
        lPBE."Payment Description" := pPLine.Description;
        lPBE."Without VAT (LCY)" := lLineAmt;
        lPBE."Contragent Type" := lPBE."Contragent Type"::Vendor;
        lPBE."Contragent No." := lPHead."Buy-from Vendor No.";
        lPBE."Contragent Name" := lPHead."Buy-from Vendor Name";
        lPBE."Agreement No." := lPHead."Agreement No.";
        lPBE."External Agreement No." := lPHead."External Agreement No. (Calc)";
        lPBE."Parent Entry" := pPBE."Parent Entry";
        lPBE.Insert(true);
        lParentPBE.Get(pPBE."Entry No.");
        lParentPBE."Without VAT (LCY)" := lParentPBE."Without VAT (LCY)" - lPBE."Without VAT (LCY)";
        lParentPBE.Modify(false);
        exit(lPBE."Entry No.");
    end;

    procedure DeleteSTLine(pPrBudEntry: Record "Projects Budget Entry")
    var
        lUS: Record "User Setup";
        lPrBudEntry: Record "Projects Budget Entry";
        lTextErr001: Label 'Deleting long-term entries denied!';
        lTextErr002: Label 'Entry %1 is linked to payment document %2. Deleting denied!';
        lTextErr003: Label 'You do not have sufficient rights to perform the action!';

    begin
        lUS.Get(UserId);
        if not (lUS."CF Allow Long Entries Edit" or lUS."CF Allow Short Entries Edit") then
            Error(lTextErr003);

        if pPrBudEntry.GetFilters = '' then
            exit;
        if pPrBudEntry.FindSet() then
            repeat
                if (pPrBudEntry."Parent Entry" = 0) or (pPrBudEntry."Parent Entry" = pPrBudEntry."Entry No.") then
                    Error(lTextErr001);
                pPrBudEntry.CalcFields("Payment Doc. No.");
                if pPrBudEntry."Payment Doc. No." <> '' then
                    Error(lTextErr002);
                lPrBudEntry.Get(pPrBudEntry."Parent Entry");
                lPrBudEntry."Without VAT (LCY)" := lPrBudEntry."Without VAT (LCY)" + pPrBudEntry."Without VAT (LCY)";
                lPrBudEntry.Modify(false);
                pPrBudEntry.Delete(true);
            until pPrBudEntry.Next() = 0;
    end;

    procedure AllowLTEntryChange() ret: Boolean
    begin
        if US.Get(UserId) then
            ret := US."CF Allow Long Entries Edit";
    end;

    procedure AllowSTEntryChange() ret: Boolean
    begin
        if US.Get(UserId) then
            ret := US."CF Allow Short Entries Edit";
    end;
}