tableextension 85740 "Transfer Header (Ext)" extends "Transfer Header"
{
    fields
    {
        // Add changes to table fields here
    }

    var
        myInt: Integer;
        hasInventorySetup: Boolean;
        invtSetup: Record "Inventory Setup";

    procedure GetInventoryLines()
    var
        myInt: Integer;
        Text60001: Label 'For following ILE Remaining Qty is greater than Open Qty =  Remaining Qty - Tracked Qty - Reserved Qty. Only lines with open Quantities are transferred to Order.';
        Text60002: Label 'ILE No. %1, Remaining Qty %2, Open Qty %3';
        ItemLedgEntry: Record "Item Ledger Entry";
        ItemLedgEntryPage: Page "Item Ledger Entries";
        NewTransLine: Record "Transfer Line";
        LastLineUsed: Integer;
        ltTempInvBuffer: Record "Inventory Buffer" temporary;
        PurchRcptHdr: Record "Purch. Rcpt. Header";
        ValueEntry: Record "Value Entry";
        PurchHdr: Record "Purchase Header";
        PurchInvHdr: Record "Purch. Inv. Header";
        ldQty: Decimal;
        ErrorMessage: text[1024];
        Location: Record Location;
        TransferLineReserve: Codeunit "Transfer Line-Reserve";
        trackingSpecification: Record "Tracking Specification";
        resEntry: Record "Reservation Entry";
        transDir: enum "Transfer Direction";
    begin

        //NC 22512 > DP
        GetInventorySetup;
        error('t85740. Under construction!');
        /*
                ErrorMessage := '';

                TESTFIELD("Transfer-from Code");
                TESTFIELD("Transfer-to Code");
                TESTFIELD("Posting Date");
                TESTFIELD(Status, Status::Open);
                TESTFIELD("In-Transit Code");
                ltTempInvBuffer.RESET;
                ltTempInvBuffer.DELETEALL;
                ItemLedgEntry.RESET;
                ItemLedgEntry.SETCURRENTKEY("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date");
                ItemLedgEntry.FILTERGROUP(2);
                ItemLedgEntry.SETRANGE("Location Code", "Transfer-from Code");
                ItemLedgEntry.SETRANGE(Open, TRUE);
                ItemLedgEntry.SETRANGE(Positive, TRUE);
                ItemLedgEntry.FILTERGROUP(0);
                ItemLedgEntry.SETFILTER("Remaining Quantity", '<>0');
                CLEAR(ItemLedgEntryPage);
                ItemLedgEntryPage.SETTABLEVIEW(ItemLedgEntry);
                ItemLedgEntryPage.LOOKUPMODE(TRUE);
                IF ItemLedgEntryPage.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    ItemLedgEntryPage.ReturnSelectionFilter(ItemLedgEntry);
                    NewTransLine.RESET;
                    NewTransLine.SETRANGE("Document No.", "No.");
                    IF NewTransLine.FINDLAST THEN
                        LastLineUsed := NewTransLine."Line No."
                    ELSE BEGIN
                        LastLineUsed := 0;
                    END;
                    IF ItemLedgEntry.FINDSET THEN
                        REPEAT
                            ltTempInvBuffer.RESET;
                            ltTempInvBuffer.DELETEALL;
                            BEGIN
                                LastLineUsed := LastLineUsed + 10000;
                                NewTransLine.INIT;
                                NewTransLine."Document No." := "No.";
                                NewTransLine."Line No." := LastLineUsed;
                                NewTransLine.INSERT(TRUE);
                                NewTransLine.VALIDATE("Item No.", ItemLedgEntry."Item No.");

                                BEGIN
                                    ItemLedgEntry.CALCFIELDS("Reserved Quantity");
                                    ldQty := ItemLedgEntry."Remaining Quantity" - ItemLedgEntry."Reserved Quantity";

                                    IF ldQty <> ItemLedgEntry."Remaining Quantity" THEN
                                        IF ErrorMessage = '' THEN
                                            ErrorMessage := STRSUBSTNO(Text60002, ItemLedgEntry."Entry No.", ItemLedgEntry."Remaining Quantity", ldQty)
                                        ELSE
                                            ErrorMessage += '\' + STRSUBSTNO(Text60002, ItemLedgEntry."Entry No.", ItemLedgEntry."Remaining Quantity", ldQty);

                                    IF ldQty > 0 THEN
                                        NewTransLine.VALIDATE(Quantity, ldQty);
                                END;
                                IF NewTransLine.Quantity > 0 THEN BEGIN
                                    NewTransLine.VALIDATE("Qty. to Ship", NewTransLine.Quantity);

                                    NewTransLine.MODIFY;  // must be here because of modify with trigger later in code
                                    NewTransLine.SetILE(0);

                                    IF (ItemLedgEntry."Lot No." <> '') THEN
                                        NewTransLine.SetILE(ItemLedgEntry."Entry No.");

                                    NewTransLine.VALIDATE("Transfer-To Bin Code", CheckLocBinCombiantion(NewTransLine."Transfer-to Code",
                                                                                                        NewTransLine."Transfer-from Bin Code"));

                                    IF Location.GET("Transfer-to Code") AND Location."Bin Mandatory" AND ("Vendor No." <> '') THEN
                                        NewTransLine.VALIDATE("Transfer-To Bin Code", "Vendor No.");

                                    NewTransLine."Shortcut Dimension 1 Code" := ItemLedgEntry."Global Dimension 1 Code";
                                    NewTransLine."Shortcut Dimension 2 Code" := ItemLedgEntry."Global Dimension 2 Code";

                                    NewTransLine."New Shortcut Dimension 1 Code" := ItemLedgEntry."Global Dimension 1 Code";
                                    NewTransLine."New Shortcut Dimension 2 Code" := ItemLedgEntry."Global Dimension 2 Code";

                                    NewTransLine."Dimension Set ID" := ItemLedgEntry."Dimension Set ID";

                                    NewTransLine.MODIFY(TRUE);

                                    //NC 41281 > DP
                                    clear(resEntry);
                                    trackingSpecification.InitTrackingSpecification(32, 0, '', '', 0, ItemLedgEntry."Entry No.", ItemLedgEntry."Variant Code", ItemLedgEntry."Location Code", ItemLedgEntry."Qty. per Unit of Measure");
                                    TransferLineReserve.CreateReservationSetFrom(trackingSpecification);
                                    TransferLineReserve.CreateReservation(NewTransLine, NewTransLine.Description, NewTransLine."Shipment Date",
                                                                          NewTransLine.Quantity, NewTransLine."Quantity (Base)", resEntry, transDir::Inbound);
                                    //NC 41281 < DP
                                END ELSE
                                    NewTransLine.DELETE(TRUE);
                            END;
                        UNTIL ItemLedgEntry.NEXT = 0;

                    IF ErrorMessage <> '' THEN
                        MESSAGE(Text60001 + '\' + ErrorMessage);

                END;
                //NC 22512 < DP
        */
    end;

    local procedure GetInventorySetup()
    begin
        if not HasInventorySetup then begin
            InvtSetup.Get();
            HasInventorySetup := true;
        end;
    end;

}