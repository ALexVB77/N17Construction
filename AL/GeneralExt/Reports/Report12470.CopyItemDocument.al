report 82470 "Copy Item Document GE"
{
    Caption = 'Copy Item Document (new)';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(DocType; DocType)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Document Type';
                        OptionCaption = 'Receipt,Shipment,Posted Receipt,Posted Shipment,,,Post.Purch.Invoice,Posted Transfer Rcpt.,Purch. Rcpt. Header';
                        ToolTip = 'Specifies the type of the related document.';

                        trigger OnValidate()
                        begin
                            DocNo := '';
                            ValidateDocNo;
                        end;
                    }
                    field(DocNo; DocNo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Document No.';
                        ToolTip = 'Specifies the number of the related document.';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            LookupDocNo;
                        end;

                        trigger OnValidate()
                        begin
                            ValidateDocNo;
                        end;
                    }
                    field(IncludeHeader; IncludeHeader)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include Header';
                        ToolTip = 'Specifies if you want to copy information from the document header you are copying.';

                        trigger OnValidate()
                        begin
                            ValidateIncludeHeader;
                        end;
                    }
                    field(RecalculateLines; RecalculateLines)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Recalculate Lines';
                        ToolTip = 'Specifies that lines are recalculate and inserted on the document you are creating. The batch job retains the item numbers and item quantities but recalculates the amounts on the lines based on the customer information on the new document header.';

                        trigger OnValidate()
                        begin
                            RecalculateLines := true;
                        end;
                    }
                    field(AutoFillAppliesFields; AutoFillAppliesFields)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Specify appl. entries';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if DocNo <> '' then begin
                case DocType of
                    DocType::Receipt:
                        if FromItemDocHeader.Get(FromItemDocHeader."Document Type"::Receipt, DocNo) then
                            ;
                    DocType::Shipment:
                        if FromItemDocHeader.Get(FromItemDocHeader."Document Type"::Shipment, DocNo) then
                            ;
                    DocType::"Posted Receipt":
                        if FromItemRcptHeader.Get(DocNo) then
                            FromItemDocHeader.TransferFields(FromItemRcptHeader);
                    DocType::"Posted Shipment":
                        if FromItemShptHeader.Get(DocNo) then
                            FromItemDocHeader.TransferFields(FromItemShptHeader);
                end;
                if FromItemDocHeader."No." = '' then
                    DocNo := '';
            end;
            ValidateDocNo;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        dimMgt: Codeunit "DimensionManagement";
        dimSetIds: array[10] of integer;
    begin

        // SWC806 AK 230316 >>
        IF DocType = DocType::"Posted Transfer Rcpt." THEN BEGIN

            ItemDocHeader.VALIDATE("Location Code", FromTransferRcptHdr."Transfer-to Code");
            ItemDocHeader.VALIDATE("Shortcut Dimension 1 Code", FromTransferRcptHdr."Shortcut Dimension 1 Code");
            ItemDocHeader.VALIDATE("Shortcut Dimension 2 Code", FromTransferRcptHdr."Shortcut Dimension 2 Code");
            ItemDocHeader.MODIFY(TRUE);

            LastLineNo := 0;
            ItemDocLine.RESET;
            ItemDocLine.SETRANGE("Document Type", ItemDocHeader."Document Type");
            ItemDocLine.SETRANGE("Document No.", ItemDocHeader."No.");
            IF ItemDocLine.FINDLAST THEN
                LastLineNo := ItemDocLine."Line No.";

            FromTransferRcptLine.RESET;
            FromTransferRcptLine.SETRANGE("Document No.", FromTransferRcptHdr."No.");
            IF FromTransferRcptLine.FINDSET THEN
                REPEAT
                    LastLineNo += 10000;

                    ItemDocLine.INIT;
                    ItemDocLine."Document Type" := ItemDocHeader."Document Type";
                    ItemDocLine."Document No." := ItemDocHeader."No.";
                    ItemDocLine."Line No." := LastLineNo;
                    ItemDocLine.INSERT(TRUE);

                    ItemDocLine.VALIDATE("Item No.", FromTransferRcptLine."Item No.");
                    ItemDocLine.VALIDATE("Location Code", FromTransferRcptLine."Transfer-to Code");
                    ItemDocLine.VALIDATE("Shortcut Dimension 1 Code", FromTransferRcptLine."Shortcut Dimension 1 Code");
                    ItemDocLine.VALIDATE("Shortcut Dimension 2 Code", FromTransferRcptLine."Shortcut Dimension 2 Code");
                    ItemDocLine.VALIDATE(Quantity, FromTransferRcptLine.Quantity);
                    ItemDocLine.VALIDATE("Unit of Measure Code", FromTransferRcptLine."Unit of Measure Code");
                    ItemDocLine.VALIDATE(Description, FromTransferRcptLine.Description);
                    ItemDocLine.MODIFY(TRUE);


                    CopyDims(ItemDocLine, FromTransferRcptLine."Dimension Set ID");
                //CopyDims(DATABASE::"Transfer Receipt Line",
                //  FromTransferRcptLine."Document No.", FromTransferRcptLine."Line No.");
                UNTIL
                  FromTransferRcptLine.NEXT = 0;
        END
        ELSE
            // SWC806 AK 230316 <<
            //NC 22512 > DP
            IF DocType = DocType::"Purch. Rcpt. Header" THEN BEGIN
                ItemDocHeader."Posting Date" := FromPurchRcptHeader."Posting Date";
                ItemDocHeader."Document Date" := FromPurchRcptHeader."Posting Date";

                ItemDocHeader.VALIDATE("Location Code", FromPurchRcptHeader."Location Code");
                ItemDocHeader.VALIDATE("Shortcut Dimension 1 Code", FromPurchRcptHeader."Shortcut Dimension 1 Code");
                ItemDocHeader.VALIDATE("Shortcut Dimension 2 Code", FromPurchRcptHeader."Shortcut Dimension 2 Code");
                ItemDocHeader.MODIFY(TRUE);

                LastLineNo := 0;
                ItemDocLine.RESET;
                ItemDocLine.SETRANGE("Document Type", ItemDocHeader."Document Type");
                ItemDocLine.SETRANGE("Document No.", ItemDocHeader."No.");
                IF ItemDocLine.FINDLAST THEN
                    LastLineNo := ItemDocLine."Line No.";

                FromPurchRcptLine.RESET;
                FromPurchRcptLine.SETRANGE("Document No.", FromPurchRcptHeader."No.");
                IF FromPurchRcptLine.FINDSET THEN
                    REPEAT
                        LastLineNo += 10000;

                        ItemDocLine.INIT;
                        ItemDocLine."Document Type" := ItemDocHeader."Document Type";
                        ItemDocLine."Document No." := ItemDocHeader."No.";
                        ItemDocLine."Line No." := LastLineNo;
                        ItemDocLine.INSERT(TRUE);

                        ItemDocLine.VALIDATE("Item No.", FromPurchRcptLine."No.");
                        ItemDocLine.VALIDATE("Location Code", FromPurchRcptLine."Location Code");
                        ItemDocLine.VALIDATE("Shortcut Dimension 1 Code", FromPurchRcptLine."Shortcut Dimension 1 Code");
                        ItemDocLine.VALIDATE("Shortcut Dimension 2 Code", FromPurchRcptLine."Shortcut Dimension 2 Code");
                        ItemDocLine.VALIDATE(Quantity, FromPurchRcptLine.Quantity);
                        ItemDocLine.VALIDATE("Unit of Measure Code", FromPurchRcptLine."Unit of Measure Code");
                        ItemDocLine.VALIDATE(Description, FromPurchRcptLine.Description);

                        ItemDocLine.VALIDATE("Unit Amount", FromPurchRcptLine."Direct Unit Cost");
                        ItemDocLine.VALIDATE("Unit Cost", FromPurchRcptLine."Direct Unit Cost");
                        ItemDocLine.VALIDATE("Applies-from Entry", FromPurchRcptLine."Item Rcpt. Entry No.");
                        ItemDocLine.MODIFY(TRUE);

                        CopyDims(ItemDocLine, FromPurchRcptLine."Dimension Set ID");
                    //CopyDims(DATABASE::"Purch. Rcpt. Line",
                    //  FromPurchRcptLine."Document No.", FromPurchRcptLine."Line No.");
                    UNTIL FromPurchRcptLine.NEXT = 0;
            END
            ELSE
                //NC 22512 < DP

                //NCC0002 CITRU\ROMB 01.12.11 >
                IF DocType = DocType::"Post.Purch.Invoice" THEN BEGIN
                    ItemDocHeader."Location Code" := PurchInvHeader."Location Code";
                    ItemDocHeader."Posting Date" := PurchInvHeader."Posting Date";
                    ItemDocHeader."Document Date" := PurchInvHeader."Posting Date";
                    ItemDocHeader.VALIDATE("Shortcut Dimension 1 Code", PurchInvHeader."Shortcut Dimension 1 Code");
                    ItemDocHeader.MODIFY;
                    ItemDocLine.RESET;
                    ItemDocLine.SETRANGE("Document Type", ItemDocHeader."Document Type");
                    ItemDocLine.SETRANGE("Document No.", ItemDocHeader."No.");
                    IF NOT (ItemDocLine.FINDLAST) THEN
                        ItemDocLine."Line No." := 0;
                    LastLineNo := ItemDocLine."Line No.";
                    PurchInvLine.RESET;
                    PurchInvLine.SETRANGE("Document No.", PurchInvHeader."No.");
                    PurchInvLine.SETRANGE(Type, PurchInvLine.Type::Item);
                    IF PurchInvLine.FINDSET THEN
                        REPEAT
                            ItemDocLine.INIT;
                            ItemDocLine."Document Type" := ItemDocHeader."Document Type";
                            ItemDocLine."Document No." := ItemDocHeader."No.";
                            LastLineNo += 10000;
                            ItemDocLine."Line No." := LastLineNo;
                            ItemDocLine.VALIDATE("Item No.", PurchInvLine."No.");
                            ItemDocLine.INSERT(TRUE);
                            // MC IK 20120823 >>
                            ItemDocLine.VALIDATE("Location Code", PurchInvLine."Location Code");
                            // MC IK 20120823 <<
                            ItemDocLine.VALIDATE(Quantity, PurchInvLine.Quantity);

                            //?
                            /*ValueEntry.RESET;
                            ValueEntry.SETRANGE("Document No.", PurchInvLine."Document No.");
                            ValueEntry.SETRANGE("Document Line No.", PurchInvLine."Line No.");
                            ValueEntry.SETRANGE("Posting Date", PurchInvHeader."Posting Date");
                            ValueEntry.FINDFIRST;
                            ItemDocLine."Applies-to Entry" := ValueEntry."Item Ledger Entry No.";*/
                            //?

                            ItemDocLine.VALIDATE("Shortcut Dimension 1 Code", PurchInvLine."Shortcut Dimension 1 Code");
                            ItemDocLine.VALIDATE("Shortcut Dimension 2 Code", PurchInvLine."Shortcut Dimension 2 Code");
                            ItemDocLine.VALIDATE("Unit of Measure Code", PurchInvLine."Unit of Measure Code");
                            ItemDocLine.VALIDATE("Unit Amount", PurchInvLine."Direct Unit Cost");
                            ItemDocLine.VALIDATE("Unit Cost", PurchInvLine."Direct Unit Cost");
                            ItemDocLine.Description := PurchInvLine.Description;
                            ItemDocLine.MODIFY;

                            CopyDims(ItemDocLine, PurchInvLine."Dimension Set ID");
                        //CopyDims(DATABASE::"Purch. Inv. Line",
                        // PurchInvLine."Document No.",  // SWC806 AK 230316
                        //PurchInvLine."Line No.");
                        UNTIL PurchInvLine.NEXT = 0;
                END ELSE BEGIN
                    //NCC0002 CITRU\ROMB 01.12.11 <
                    CopyItemDocMgt.SetProperties(IncludeHeader, RecalculateLines, false, false, AutoFillAppliesFields);
                    CopyItemDocMgt.CopyItemDoc(DocType, DocNo, ItemDocHeader);
                end;
    end;

    var
        ItemDocHeader: Record "Item Document Header";
        FromItemDocHeader: Record "Item Document Header";
        FromItemRcptHeader: Record "Item Receipt Header";
        FromItemShptHeader: Record "Item Shipment Header";
        CopyItemDocMgt: Codeunit "Copy Item Document Mgt.";
        DocType: Option Receipt,Shipment,"Posted Receipt","Posted Shipment",,,"Post.Purch.Invoice","Posted Transfer Rcpt.","Purch. Rcpt. Header";
        DocNo: Code[20];
        IncludeHeader: Boolean;
        RecalculateLines: Boolean;
        AutoFillAppliesFields: Boolean;
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        ItemDocLine: Record "Item Document Line";
        LastLineNo: Integer;
        FromTransferRcptHdr: Record "Transfer Receipt Header";
        FromTransferRcptLine: Record "Transfer Receipt Line";
        FromPurchRcptHeader: Record "Purch. Rcpt. Header";
        FromPurchRcptLine: Record "Purch. Rcpt. Line";

    [Scope('OnPrem')]
    procedure SetItemDocHeader(var NewItemDocHeader: Record "Item Document Header")
    begin
        ItemDocHeader := NewItemDocHeader;
    end;

    local procedure ValidateDocNo()
    begin
        if DocNo = '' then
            FromItemDocHeader.Init
        else
            if FromItemDocHeader."No." = '' then begin
                FromItemDocHeader.Init();
                case DocType of
                    DocType::Receipt,
                  DocType::Shipment:
                        FromItemDocHeader.Get(DocType, DocNo);
                    DocType::"Posted Receipt":
                        begin
                            FromItemRcptHeader.Get(DocNo);
                            FromItemDocHeader.TransferFields(FromItemRcptHeader);
                        end;
                    DocType::"Posted Shipment":
                        begin
                            FromItemShptHeader.Get(DocNo);
                            FromItemDocHeader.TransferFields(FromItemShptHeader);
                        end;

                    //NC 22512 > DP
                    DocType::"Purch. Rcpt. Header":
                        BEGIN
                            FromPurchRcptHeader.GET(DocNo);
                        END;
                //NC 22512 < DP
                end;
            end;
        FromItemDocHeader."No." := '';

        //NCC0002 CITRU\ROMB 01.12.11 >
        IF (DocType = DocType::"Post.Purch.Invoice") AND (DocNo <> '') THEN
            PurchInvHeader.GET(DocNo);
        //NCC0002 CITRU\ROMB 01.12.11 <

        // SWC806 AK 230316 >>
        IF DocType = DocType::"Posted Transfer Rcpt." THEN
            IF NOT FromTransferRcptHdr.GET(DocNo) THEN
                CLEAR(FromTransferRcptHdr);
        // SWC806 AK 230316 <<

        IncludeHeader := true;
        ValidateIncludeHeader;
    end;

    local procedure LookupDocNo()
    begin
        case DocType of
            DocType::Receipt,
            DocType::Shipment:
                begin
                    FromItemDocHeader.FilterGroup := 2;
                    FromItemDocHeader.SetRange("Document Type", DocType);
                    if ItemDocHeader."Document Type" = DocType then
                        FromItemDocHeader.SetFilter("No.", '<>%1', ItemDocHeader."No.");
                    FromItemDocHeader.FilterGroup := 0;
                    FromItemDocHeader."Document Type" := DocType;
                    FromItemDocHeader."No." := DocNo;
                    if DocType = DocType::Receipt then begin
                        if PAGE.RunModal(PAGE::"Item Receipts", FromItemDocHeader, FromItemDocHeader."No.") = ACTION::LookupOK then
                            DocNo := FromItemDocHeader."No.";
                    end else begin
                        if PAGE.RunModal(PAGE::"Item Shipments", FromItemDocHeader, FromItemDocHeader."No.") = ACTION::LookupOK then
                            DocNo := FromItemDocHeader."No.";
                    end;
                end;
            DocType::"Posted Receipt":
                begin
                    FromItemRcptHeader."No." := DocNo;
                    if PAGE.RunModal(0, FromItemRcptHeader) = ACTION::LookupOK then
                        DocNo := FromItemRcptHeader."No.";
                end;
            DocType::"Posted Shipment":
                begin
                    FromItemShptHeader."No." := DocNo;
                    if PAGE.RunModal(0, FromItemShptHeader) = ACTION::LookupOK then
                        DocNo := FromItemShptHeader."No.";
                end;

            //NCC0002 CITRU\ROMB 01.12.11 >
            DocType::"Post.Purch.Invoice":
                BEGIN
                    PurchInvHeader."No." := DocNo;
                    IF page.RUNMODAL(0, PurchInvHeader) = ACTION::LookupOK THEN
                        DocNo := PurchInvHeader."No.";
                END;
            //NCC0002 CITRU\ROMB 01.12.11 <

            // SWC806 AK 230316 >>
            DocType::"Posted Transfer Rcpt.":
                BEGIN
                    FromTransferRcptHdr."No." := DocNo;
                    IF page.RUNMODAL(0, FromTransferRcptHdr) = ACTION::LookupOK THEN
                        DocNo := FromTransferRcptHdr."No.";
                END;
            // SWC806 AK 230316 <<
            //NC 22512 > DP
            DocType::"Purch. Rcpt. Header":
                BEGIN
                    FromPurchRcptHeader."No." := DocNo;
                    IF page.RUNMODAL(0, FromPurchRcptHeader) = ACTION::LookupOK THEN
                        DocNo := FromPurchRcptHeader."No.";
                END;
        //NC 22512 < DP
        end;
        ValidateDocNo;
    end;

    local procedure ValidateIncludeHeader()
    begin
        RecalculateLines :=
          not IncludeHeader;

        //NCC0002 CITRU\ROMB 01.12.11 >
        IF (DocType = DocType::"Post.Purch.Invoice")
           OR (DocType = DocType::"Posted Transfer Rcpt.")  // SWC806 AK 230316
           OR (DocType = DocType::"Purch. Rcpt. Header")    //NC 22512 DP
        THEN BEGIN
            // SWC816 AK 110516 >>
            // ItemDocHeader.TESTFIELD("Document Type", ItemDocHeader."Document Type"::Shipment);
            // либо надо снимать SaveValues на форме, не могу акт оприх. копированием создать
            // SWC816 AK 110516 <<
            IncludeHeader := FALSE;
            RecalculateLines := FALSE;
            AutoFillAppliesFields := FALSE;
        END;
        //NCC0002 CITRU\ROMB 01.12.11 <
    end;

    procedure CopyDims(var idl: Record "Item Document Line"; srcDimSetId: integer)
    var
        dimSetIds: array[10] of Integer;
        dimMgt: Codeunit DimensionManagement;
    begin
        clear(dimSetIds);
        dimSetIds[1] := idl."Dimension Set ID";
        dimSetIds[2] := srcDimSetId;
        idl."Dimension Set ID" := dimMgt.GetCombinedDimensionSetID(dimSetIds, idl."Shortcut Dimension 1 Code", idl."Shortcut Dimension 2 Code");
        idl.modify(true);
    end;
}

