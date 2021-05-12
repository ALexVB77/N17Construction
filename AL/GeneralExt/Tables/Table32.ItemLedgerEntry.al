tableextension 80032 "Item Ledger Entry (Ext)" extends "Item Ledger Entry"
{
    fields
    {
        field(50004; "User ID from Value"; Code[50])
        {

            Caption = 'User ID from value';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("Value Entry"."User ID" WHERE("Item Ledger Entry No." = FIELD("Entry No.")));
        }
        field(50005; Comment; text[80])
        {
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Inventory Comment Line".Comment where("No." = field("Document No."), "Line No." = field("Entry No.")));
        }

    }
    procedure InsertDocLineFromILE(var pItemDocumentLine: Record "Item Document Line"; var ptTempInvBuffer: Record "Inventory Buffer")
    var
        ItemDocumentHeader: Record "Item Document Header";
        TempItemDocumentLine: Record "Item Document Line" temporary;
        ItemTrackingMgt: Codeunit "Item Tracing Mgt.";
        NextLineNo: Integer;
    begin

        //NC 22512 > DP
        SETRANGE("Entry No.", "Entry No.");

        TempItemDocumentLine := pItemDocumentLine;
        IF pItemDocumentLine.FINDLAST THEN
            NextLineNo := pItemDocumentLine."Line No." + 10000
        ELSE
            NextLineNo := 10000;

        //insert line
        IF ptTempInvBuffer.FINDFIRST THEN BEGIN
            REPEAT
                InsertDocLineFromILE2(pItemDocumentLine, TempItemDocumentLine, ptTempInvBuffer.Quantity,
                                      ptTempInvBuffer."Bin Code", NextLineNo);
            UNTIL ptTempInvBuffer.NEXT = 0;
        END ELSE BEGIN
            InsertDocLineFromILE2(pItemDocumentLine, TempItemDocumentLine, "Remaining Quantity", '', NextLineNo);
        END;
        //NC 22512 < DP

    end;

    procedure InsertDocLineFromILE2(var pItemDocumentLine: Record "Item Document Line"; TempItemDocumentLine: Record "Item Document Line"; LineQtyBase: Decimal; BinCode: Code[10]; NextLineNo: Integer)
    var
        ItemDocumentHeader: Record "Item Document Header";
        ItemTrackingMgt: Codeunit "Item Tracing Mgt.";
        DimMgt: Codeunit DimensionManagement;
        ItemDoc: Record "Item Document Header";
        Item: Record Item;

    begin

        //NC 22512 > DP
        //insert line

        pItemDocumentLine.INIT;

        pItemDocumentLine."Line No." := NextLineNo;
        pItemDocumentLine."Document Type" := TempItemDocumentLine."Document Type";
        pItemDocumentLine."Document No." := TempItemDocumentLine."Document No.";
        pItemDocumentLine.VALIDATE("Item No.", "Item No.");
        //NC 49346 > DP
        pItemDocumentLine.VALIDATE("Unit of Measure Code", "Unit of Measure Code");
        IF "Qty. per Unit of Measure" <> 0 THEN
            LineQtyBase := ROUND(LineQtyBase / "Qty. per Unit of Measure", 0.00001);
        //NC 49346 < DP

        pItemDocumentLine.VALIDATE("Location Code", "Location Code");
        IF BinCode <> '' THEN
            pItemDocumentLine.VALIDATE("Bin Code", BinCode);
        pItemDocumentLine.VALIDATE(Quantity, LineQtyBase);
        //pItemDocumentLine."Lot No." := "Lot No.";
        //pItemDocumentLine."Expiration date" := "Expiration Date";
        //pItemDocumentLine."Serial No." := "Serial No.";
        //    pItemDocumentLine."CD No." := "CD No."; // NC 51144 GG
        pItemDocumentLine."Applies-to Entry" := "Entry No.";
        //<CF.00000722>
        CALCFIELDS("Cost Amount (Actual)");
        IF ("Invoiced Quantity" <> 0) AND ("Cost Amount (Actual)" <> 0) THEN BEGIN
            pItemDocumentLine.VALIDATE("Unit Amount", ROUND("Cost Amount (Actual)" / "Invoiced Quantity", 0.01));
            pItemDocumentLine.VALIDATE("Unit Cost", ROUND("Cost Amount (Actual)" / "Invoiced Quantity", 0.01));
        END ELSE BEGIN
            //NC 34774 > DP
            /*
            pItemDocumentLine.VALIDATE("Unit Amount", 0);
                      pItemDocumentLine.VALIDATE("Unit Cost", 0);
            */
            IF Item.GET("Item No.") THEN BEGIN
                pItemDocumentLine.VALIDATE("Unit Cost", Item."Unit Cost");
            END;
            //NC 34774 < DP
        END;
        //</CF.00000722>

        //<CF.00000722>
        ItemDoc.GET(TempItemDocumentLine."Document Type", TempItemDocumentLine."Document No.");
        //pItemDocumentLine."Reason Code" := ItemDoc."Reason Code";
        //pItemDocumentLine."Sales Type" := ItemDoc."Sales Type";
        //</CF.00000722>

        pItemDocumentLine."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
        pItemDocumentLine."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
        pItemDocumentLine.INSERT;

        // NC 51144 GG >>
        /*
        CASE TRUE OF
          //(pItemDocumentLine."Serial No." <> ''): pItemDocumentLine.VALIDATE("Serial No.");
          //(pItemDocumentLine."Lot No." <> ''): pItemDocumentLine.VALIDATE("Lot No.");
          //<CF.00000722>
          (pItemDocumentLine."CD No." <> ''): pItemDocumentLine.VALIDATE("CD No.");
          //</CF.00000722>
        END;



        LedgEntryDim.SETRANGE("Table ID",DATABASE::"Item Ledger Entry");
        LedgEntryDim.SETRANGE("Entry No.","Entry No.");

        DimMgt.MoveLedgEntryDimToDocDim(LedgEntryDim,DATABASE::"Item Document Line",pItemDocumentLine."Document No.",
                                        pItemDocumentLine."Line No.",pItemDocumentLine."Document Type"+7);

        */

        pItemDocumentLine."Dimension Set ID" := "Dimension Set ID";
        // NC 51144 GG << 



        /*!!!
        dimension
        IF (pItemDocumentLine."Dimension Set ID" <> 0) OR ("Dimension Set ID" <> 0) THEN BEGIN
          DimensionSetIDArr[1] := "Dimension Set ID";
          DimensionSetIDArr[2] := pItemDocumentLine."Dimension Set ID";

          pItemDocumentLine."Dimension Set ID" := DimMgt.GetCombinedDimensionSetID(DimensionSetIDArr,pItemDocumentLine."Shortcut Dimension 1
          // <CF.00001797>
          NewDimSetID := pItemDocumentLine."Dimension Set ID";
          DimMgt.FillDimBufferFromDimSetID(NewDimSetID);
          NewDimSetID := DimMgt.SetDimFromDimMappForDocLine(DATABASE::Item, NewDimSetID);
          IF pItemDocumentLine."Dimension Set ID" <> NewDimSetID THEN BEGIN
            pItemDocumentLine."Dimension Set ID" := NewDimSetID;
            DimMgt.UpdateGlobalDimFromDimSetID(
               pItemDocumentLine."Dimension Set ID", pItemDocumentLine."Shortcut Dimension 1 Code",pItemDocumentLine."Shortcut Dimension 2 C
          END;
          // </CF.00001797>
          pItemDocumentLine.MODIFY(TRUE);
        END;
        !!!}*/
        //NC 22512 < DP

    end;

}