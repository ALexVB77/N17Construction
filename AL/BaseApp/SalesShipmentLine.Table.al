table 111 "Sales Shipment Line"
{
    Caption = 'Sales Shipment Line';
    DrillDownPageID = "Posted Sales Shipment Lines";
    LookupPageID = "Posted Sales Shipment Lines";
    Permissions = TableData "Item Ledger Entry" = r,
                  TableData "Value Entry" = r;

    fields
    {
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Sales Shipment Header";

            trigger OnValidate()
            begin
                UpdateDocumentId();
            end;
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; Type; Enum "Sales Line Type")
        {
            Caption = 'Type';
        }
        field(6; "No."; Code[20])
        {
            CaptionClass = GetCaptionClass(FieldNo("No."));
            Caption = 'No.';
            TableRelation = IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge";
        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(8; "Posting Group"; Code[20])
        {
            Caption = 'Posting Group';
            Editable = false;
            TableRelation = IF (Type = CONST(Item)) "Inventory Posting Group"
            ELSE
            IF (Type = CONST("Fixed Asset")) "FA Posting Group";
        }
        field(10; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(11; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(12; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(13; "Unit of Measure"; Text[50])
        {
            Caption = 'Unit of Measure';
        }
        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(22; "Unit Price"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 2;
            Caption = 'Unit Price';
        }
        field(23; "Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost (LCY)';
        }
        field(25; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(27; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(32; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;
        }
        field(34; "Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight';
            DecimalPlaces = 0 : 5;
        }
        field(35; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DecimalPlaces = 0 : 5;
        }
        field(36; "Units per Parcel"; Decimal)
        {
            Caption = 'Units per Parcel';
            DecimalPlaces = 0 : 5;
        }
        field(37; "Unit Volume"; Decimal)
        {
            Caption = 'Unit Volume';
            DecimalPlaces = 0 : 5;
        }
        field(38; "Appl.-to Item Entry"; Integer)
        {
            AccessByPermission = TableData Item = R;
            Caption = 'Appl.-to Item Entry';
        }
        field(39; "Item Shpt. Entry No."; Integer)
        {
            Caption = 'Item Shpt. Entry No.';
        }
        field(40; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(41; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(42; "Customer Price Group"; Code[10])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
        }
        field(45; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(52; "Work Type Code"; Code[10])
        {
            Caption = 'Work Type Code';
            TableRelation = "Work Type";
        }
        field(58; "Qty. Shipped Not Invoiced"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Qty. Shipped Not Invoiced';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(61; "Quantity Invoiced"; Decimal)
        {
            Caption = 'Quantity Invoiced';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(65; "Order No."; Code[20])
        {
            Caption = 'Order No.';
        }
        field(66; "Order Line No."; Integer)
        {
            Caption = 'Order Line No.';
        }
        field(68; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(71; "Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
        }
        field(72; "Purch. Order Line No."; Integer)
        {
            Caption = 'Purch. Order Line No.';
        }
        field(73; "Drop Shipment"; Boolean)
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer" = R;
            Caption = 'Drop Shipment';
        }
        field(74; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(75; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(77; "VAT Calculation Type"; Enum "Tax Calculation Type")
        {
            Caption = 'VAT Calculation Type';
        }
        field(78; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";
        }
        field(79; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";
        }
        field(80; "Attached to Line No."; Integer)
        {
            Caption = 'Attached to Line No.';
            TableRelation = "Sales Shipment Line"."Line No." WHERE("Document No." = FIELD("Document No."));
        }
        field(81; "Exit Point"; Code[10])
        {
            Caption = 'Exit Point';
            TableRelation = "Entry/Exit Point";
        }
        field(82; "Area"; Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;
        }
        field(83; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";
        }
        field(85; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(86; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(87; "Tax Group Code"; Code[20])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(89; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(90; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(91; "Currency Code"; Code[10])
        {
            CalcFormula = Lookup("Sales Shipment Header"."Currency Code" WHERE("No." = FIELD("Document No.")));
            Caption = 'Currency Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(97; "Blanket Order No."; Code[20])
        {
            Caption = 'Blanket Order No.';
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST("Blanket Order"));
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(98; "Blanket Order Line No."; Integer)
        {
            Caption = 'Blanket Order Line No.';
            TableRelation = "Sales Line"."Line No." WHERE("Document Type" = CONST("Blanket Order"),
                                                           "Document No." = FIELD("Blanket Order No."));
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(99; "VAT Base Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            Caption = 'VAT Base Amount';
            Editable = false;
        }
        field(100; "Unit Cost"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            Editable = false;
        }
        field(107; "IC Partner Ref. Type"; Enum "IC Partner Reference Type")
        {
            Caption = 'IC Partner Ref. Type';
            DataClassification = CustomerContent;
        }
        field(108; "IC Partner Reference"; Code[20])
        {
            Caption = 'IC Partner Reference';
            DataClassification = CustomerContent;
        }
        field(131; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(138; "IC Item Reference No."; Code[50])
        {
            AccessByPermission = TableData "Item Reference" = R;
            Caption = 'IC Item Reference No.';
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions();
            end;
        }
        field(826; "Authorized for Credit Card"; Boolean)
        {
            Caption = 'Authorized for Credit Card';
        }
        field(1001; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            Editable = false;
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
        }
        field(1002; "Job Contract Entry No."; Integer)
        {
            Caption = 'Job Contract Entry No.';
            Editable = false;
        }
        field(5402; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = IF (Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("No."));
        }
        field(5403; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Location Code"),
                                            "Item Filter" = FIELD("No."),
                                            "Variant Filter" = FIELD("Variant Code"));
        }
        field(5404; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."))
            ELSE
            "Unit of Measure";
        }
        field(5415; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(5461; "Qty. Invoiced (Base)"; Decimal)
        {
            Caption = 'Qty. Invoiced (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5600; "FA Posting Date"; Date)
        {
            Caption = 'FA Posting Date';
        }
        field(5602; "Depreciation Book Code"; Code[10])
        {
            Caption = 'Depreciation Book Code';
            TableRelation = "Depreciation Book";
        }
        field(5605; "Depr. until FA Posting Date"; Boolean)
        {
            Caption = 'Depr. until FA Posting Date';
        }
        field(5612; "Duplicate in Depreciation Book"; Code[10])
        {
            Caption = 'Duplicate in Depreciation Book';
            TableRelation = "Depreciation Book";
        }
        field(5613; "Use Duplication List"; Boolean)
        {
            Caption = 'Use Duplication List';
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(5705; "Cross-Reference No."; Code[20])
        {
            AccessByPermission = TableData "Item Cross Reference" = R;
            Caption = 'Cross-Reference No.';
            ObsoleteReason = 'Cross-Reference replaced by Item Reference feature.';
            ObsoleteState = Pending;
            ObsoleteTag = '17.0';
        }
        field(5706; "Unit of Measure (Cross Ref.)"; Code[10])
        {
            Caption = 'Unit of Measure (Cross Ref.)';
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."));
            ObsoleteReason = 'Cross-Reference replaced by Item Reference feature.';
            ObsoleteState = Pending;
            ObsoleteTag = '17.0';
        }
        field(5707; "Cross-Reference Type"; Option)
        {
            Caption = 'Cross-Reference Type';
            OptionCaption = ' ,Customer,Vendor,Bar Code';
            OptionMembers = " ",Customer,Vendor,"Bar Code";
            ObsoleteReason = 'Cross-Reference replaced by Item Reference feature.';
            ObsoleteState = Pending;
            ObsoleteTag = '17.0';
        }
        field(5708; "Cross-Reference Type No."; Code[30])
        {
            Caption = 'Cross-Reference Type No.';
            ObsoleteReason = 'Cross-Reference replaced by Item Reference feature.';
            ObsoleteState = Pending;
            ObsoleteTag = '17.0';
        }
        field(5709; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = IF (Type = CONST(Item)) "Item Category";
        }
        field(5710; Nonstock; Boolean)
        {
            Caption = 'Catalog';
        }
        field(5711; "Purchasing Code"; Code[10])
        {
            Caption = 'Purchasing Code';
            TableRelation = Purchasing;
        }
        field(5712; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            ObsoleteReason = 'Product Groups became first level children of Item Categories.';
            ObsoleteState = Removed;
            ObsoleteTag = '15.0';
        }
        field(5725; "Item Reference No."; Code[50])
        {
            AccessByPermission = TableData "Item Reference" = R;
            Caption = 'Item Reference No.';
        }
        field(5726; "Item Reference Unit of Measure"; Code[10])
        {
            Caption = 'Unit of Measure (Item Ref.)';
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."));
        }
        field(5727; "Item Reference Type"; Enum "Item Reference Type")
        {
            Caption = 'Item Reference Type';
        }
        field(5728; "Item Reference Type No."; Code[30])
        {
            Caption = 'Item Reference Type No.';
        }
        field(5790; "Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';
            Editable = false;
        }
        field(5791; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';
            Editable = false;
        }
        field(5792; "Shipping Time"; DateFormula)
        {
            AccessByPermission = TableData "Shipping Agent Services" = R;
            Caption = 'Shipping Time';
        }
        field(5793; "Outbound Whse. Handling Time"; DateFormula)
        {
            AccessByPermission = TableData Location = R;
            Caption = 'Outbound Whse. Handling Time';
        }
        field(5794; "Planned Delivery Date"; Date)
        {
            Caption = 'Planned Delivery Date';
            Editable = false;
        }
        field(5795; "Planned Shipment Date"; Date)
        {
            Caption = 'Planned Shipment Date';
            Editable = false;
        }
        field(5811; "Appl.-from Item Entry"; Integer)
        {
            AccessByPermission = TableData Item = R;
            Caption = 'Appl.-from Item Entry';
            MinValue = 0;
        }
        field(5812; "Item Charge Base Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            Caption = 'Item Charge Base Amount';
        }
        field(5817; Correction; Boolean)
        {
            Caption = 'Correction';
            Editable = false;
        }
        field(6608; "Return Reason Code"; Code[10])
        {
            Caption = 'Return Reason Code';
            TableRelation = "Return Reason";
        }
        field(7000; "Price Calculation Method"; Enum "Price Calculation Method")
        {
            Caption = 'Price Calculation Method';
        }
        field(7001; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(7002; "Customer Disc. Group"; Code[20])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";
        }
        field(8000; "Document Id"; Guid)
        {
            Caption = 'Document Id';
            trigger OnValidate()
            begin
                UpdateDocumentNo();
            end;
        }
        field(12400; "FA Location Code"; Code[10])
        {
            Caption = 'FA Location Code';
        }
        field(12430; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
        }
        field(12431; "Amount Including VAT (LCY)"; Decimal)
        {
            Caption = 'Amount Including VAT (LCY)';
        }
        field(12432; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(12433; "Amount Including VAT"; Decimal)
        {
            Caption = 'Amount Including VAT';
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Order No.", "Order Line No.", "Posting Date")
        {
        }
        key(Key3; "Blanket Order No.", "Blanket Order Line No.")
        {
        }
        key(Key4; "Item Shpt. Entry No.")
        {
        }
        key(Key5; "Sell-to Customer No.")
        {
        }
        key(Key6; "Bill-to Customer No.")
        {
        }
        key(Key7; "Document Id")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Document No.", "Line No.", "Sell-to Customer No.", Type, "No.", "Shipment Date")
        {
        }
    }

    trigger OnInsert()
    begin
        UpdateDocumentId();
    end;

    trigger OnDelete()
    var
        ServItem: Record "Service Item";
        SalesDocLineComments: Record "Sales Comment Line";
    begin
        ServItem.Reset();
        ServItem.SetCurrentKey("Sales/Serv. Shpt. Document No.", "Sales/Serv. Shpt. Line No.");
        ServItem.SetRange("Sales/Serv. Shpt. Document No.", "Document No.");
        ServItem.SetRange("Sales/Serv. Shpt. Line No.", "Line No.");
        ServItem.SetRange("Shipment Type", ServItem."Shipment Type"::Sales);
        if ServItem.Find('-') then
            repeat
                ServItem.Validate("Sales/Serv. Shpt. Document No.", '');
                ServItem.Validate("Sales/Serv. Shpt. Line No.", 0);
                ServItem.Modify(true);
            until ServItem.Next = 0;

        SalesDocLineComments.SetRange("Document Type", SalesDocLineComments."Document Type"::Shipment);
        SalesDocLineComments.SetRange("No.", "Document No.");
        SalesDocLineComments.SetRange("Document Line No.", "Line No.");
        if not SalesDocLineComments.IsEmpty then
            SalesDocLineComments.DeleteAll();

        PostedATOLink.DeleteAsmFromSalesShptLine(Rec);
    end;

    var
        Text000: Label 'Shipment No. %1:';
        Text001: Label 'The program cannot find this Sales line.';
        Currency: Record Currency;
        SalesShptHeader: Record "Sales Shipment Header";
        PostedATOLink: Record "Posted Assemble-to-Order Link";
        DimMgt: Codeunit DimensionManagement;
        UOMMgt: Codeunit "Unit of Measure Management";
        CurrencyRead: Boolean;

    procedure GetCurrencyCode(): Code[10]
    begin
        if "Document No." = SalesShptHeader."No." then
            exit(SalesShptHeader."Currency Code");
        if SalesShptHeader.Get("Document No.") then
            exit(SalesShptHeader."Currency Code");
        exit('');
    end;

    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2 %3', TableCaption, "Document No.", "Line No."));
    end;

    procedure ShowItemTrackingLines()
    var
        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
    begin
        ItemTrackingDocMgt.ShowItemTrackingForShptRcptLine(DATABASE::"Sales Shipment Line", 0, "Document No.", '', 0, "Line No.");
    end;

    procedure InsertInvLineFromShptLine(var SalesLine: Record "Sales Line")
    var
        SalesInvHeader: Record "Sales Header";
        SalesOrderHeader: Record "Sales Header";
        SalesOrderLine: Record "Sales Line";
        TempSalesLine: Record "Sales Line" temporary;
        TransferOldExtLines: Codeunit "Transfer Old Ext. Text Lines";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        TranslationHelper: Codeunit "Translation Helper";
        ExtTextLine: Boolean;
        NextLineNo: Integer;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCodeInsertInvLineFromShptLine(Rec, SalesLine, IsHandled);
        if IsHandled then
            exit;

        SetRange("Document No.", "Document No.");

        TempSalesLine := SalesLine;
        if SalesLine.Find('+') then
            NextLineNo := SalesLine."Line No." + 10000
        else
            NextLineNo := 10000;

        if SalesInvHeader."No." <> TempSalesLine."Document No." then
            SalesInvHeader.Get(TempSalesLine."Document Type", TempSalesLine."Document No.");

        if SalesLine."Shipment No." <> "Document No." then begin

            OnInsertInvLineFromShptLineOnBeforeInsertDescriptionLine(
                Rec, SalesLine, TempSalesLine, SalesInvHeader, NextLineNo);

            SalesLine.Init();
            SalesLine."Line No." := NextLineNo;
            SalesLine."Document Type" := TempSalesLine."Document Type";
            SalesLine."Document No." := TempSalesLine."Document No.";
            TranslationHelper.SetGlobalLanguageByCode(SalesInvHeader."Language Code");
            SalesLine.Description := StrSubstNo(Text000, "Document No.");
            TranslationHelper.RestoreGlobalLanguage;
            IsHandled := false;
            OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine(Rec, SalesLine, NextLineNo, IsHandled);
            if not IsHandled then begin
                SalesLine.Insert();
                OnAfterDescriptionSalesLineInsert(SalesLine, Rec, NextLineNo);
                NextLineNo := NextLineNo + 10000;
            end;
        end;

        TransferOldExtLines.ClearLineNumbers;

        repeat
            ExtTextLine := (TransferOldExtLines.GetNewLineNumber("Attached to Line No.") <> 0);

            if (Type <> Type::" ") and SalesOrderLine.Get(SalesOrderLine."Document Type"::Order, "Order No.", "Order Line No.")
            then begin
                if (SalesOrderHeader."Document Type" <> SalesOrderLine."Document Type"::Order) or
                   (SalesOrderHeader."No." <> SalesOrderLine."Document No.")
                then
                    SalesOrderHeader.Get(SalesOrderLine."Document Type"::Order, "Order No.");

                InitCurrency("Currency Code");

                if SalesInvHeader."Prices Including VAT" then begin
                    if not SalesOrderHeader."Prices Including VAT" then
                        SalesOrderLine."Unit Price" :=
                          Round(
                            SalesOrderLine."Unit Price" * (1 + SalesOrderLine."VAT %" / 100),
                            Currency."Unit-Amount Rounding Precision");
                end else begin
                    if SalesOrderHeader."Prices Including VAT" then
                        SalesOrderLine."Unit Price" :=
                          Round(
                            SalesOrderLine."Unit Price" / (1 + SalesOrderLine."VAT %" / 100),
                            Currency."Unit-Amount Rounding Precision");
                end;
            end else begin
                SalesOrderHeader.Init();
                if ExtTextLine or (Type = Type::" ") then begin
                    SalesOrderLine.Init();
                    SalesOrderLine."Line No." := "Order Line No.";
                    SalesOrderLine.Description := Description;
                    SalesOrderLine."Description 2" := "Description 2";
                    OnInsertInvLineFromShptLineOnAfterAssignDescription(Rec, SalesOrderLine);
                end else
                    Error(Text001);
            end;

            SalesLine := SalesOrderLine;
            SalesLine."Line No." := NextLineNo;
            SalesLine."Document Type" := TempSalesLine."Document Type";
            SalesLine."Document No." := TempSalesLine."Document No.";
            SalesLine."Variant Code" := "Variant Code";
            SalesLine."Location Code" := "Location Code";
            SalesLine."Drop Shipment" := "Drop Shipment";
            SalesLine."Shipment No." := "Document No.";
            SalesLine."Shipment Line No." := "Line No.";
            ClearSalesLineValues(SalesLine);
            if not ExtTextLine and (SalesLine.Type <> SalesLine.Type::" ") then begin
                IsHandled := false;
                OnInsertInvLineFromShptLineOnBeforeValidateQuantity(Rec, SalesLine, IsHandled);
                if not IsHandled then
                    SalesLine.Validate(Quantity, Quantity - "Quantity Invoiced");
                CalcBaseQuantities(SalesLine, "Quantity (Base)" / Quantity);

                OnInsertInvLineFromShptLineOnAfterCalcQuantities(SalesLine, SalesOrderLine);

                SalesLine.Validate("Unit Price", SalesOrderLine."Unit Price");
                SalesLine."Allow Line Disc." := SalesOrderLine."Allow Line Disc.";
                SalesLine."Allow Invoice Disc." := SalesOrderLine."Allow Invoice Disc.";
                SalesOrderLine."Line Discount Amount" :=
                  Round(
                    SalesOrderLine."Line Discount Amount" * SalesLine.Quantity / SalesOrderLine.Quantity,
                    Currency."Amount Rounding Precision");
                if SalesInvHeader."Prices Including VAT" then begin
                    if not SalesOrderHeader."Prices Including VAT" then
                        SalesOrderLine."Line Discount Amount" :=
                          Round(
                            SalesOrderLine."Line Discount Amount" *
                            (1 + SalesOrderLine."VAT %" / 100), Currency."Amount Rounding Precision");
                end else begin
                    if SalesOrderHeader."Prices Including VAT" then
                        SalesOrderLine."Line Discount Amount" :=
                          Round(
                            SalesOrderLine."Line Discount Amount" /
                            (1 + SalesOrderLine."VAT %" / 100), Currency."Amount Rounding Precision");
                end;
                SalesLine.Validate("Line Discount Amount", SalesOrderLine."Line Discount Amount");
                SalesLine."Line Discount %" := SalesOrderLine."Line Discount %";
                SalesLine.UpdatePrePaymentAmounts;
                OnInsertInvLineFromShptLineOnAfterUpdatePrepaymentsAmounts(SalesLine, SalesOrderLine, Rec);

                if SalesOrderLine.Quantity = 0 then
                    SalesLine.Validate("Inv. Discount Amount", 0)
                else
                    SalesLine.Validate(
                      "Inv. Discount Amount",
                      Round(
                        SalesOrderLine."Inv. Discount Amount" * SalesLine.Quantity / SalesOrderLine.Quantity,
                        Currency."Amount Rounding Precision"));
            end;

            SalesLine."Attached to Line No." :=
              TransferOldExtLines.TransferExtendedText(
                SalesOrderLine."Line No.",
                NextLineNo,
                "Attached to Line No.");
            SalesLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
            SalesLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
            SalesLine."Dimension Set ID" := "Dimension Set ID";
            IsHandled := false;
            OnBeforeInsertInvLineFromShptLine(Rec, SalesLine, SalesOrderLine, IsHandled);
            if not IsHandled then
                SalesLine.Insert();
            OnAfterInsertInvLineFromShptLine(SalesLine, SalesOrderLine, NextLineNo, Rec);

            ItemTrackingMgt.CopyHandledItemTrkgToInvLine(SalesOrderLine, SalesLine);

            NextLineNo := NextLineNo + 10000;
            if "Attached to Line No." = 0 then
                SetRange("Attached to Line No.", "Line No.");
        until (Next = 0) or ("Attached to Line No." = 0);

        if SalesOrderHeader.Get(SalesOrderHeader."Document Type"::Order, "Order No.") then begin
            SalesOrderHeader."Get Shipment Used" := true;
            SalesOrderHeader.Modify();
        end;
    end;

    procedure GetSalesInvLines(var TempSalesInvLine: Record "Sales Invoice Line" temporary)
    var
        SalesInvLine: Record "Sales Invoice Line";
        ItemLedgEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
    begin
        TempSalesInvLine.Reset();
        TempSalesInvLine.DeleteAll();

        if Type <> Type::Item then
            exit;

        FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
        ItemLedgEntry.SetFilter("Invoiced Quantity", '<>0');
        if ItemLedgEntry.FindSet then begin
            ValueEntry.SetCurrentKey("Item Ledger Entry No.", "Entry Type");
            ValueEntry.SetRange("Entry Type", ValueEntry."Entry Type"::"Direct Cost");
            ValueEntry.SetFilter("Invoiced Quantity", '<>0');
            repeat
                ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgEntry."Entry No.");
                if ValueEntry.FindSet then
                    repeat
                        if ValueEntry."Document Type" = ValueEntry."Document Type"::"Sales Invoice" then
                            if SalesInvLine.Get(ValueEntry."Document No.", ValueEntry."Document Line No.") then begin
                                TempSalesInvLine.Init();
                                TempSalesInvLine := SalesInvLine;
                                if TempSalesInvLine.Insert() then;
                            end;
                    until ValueEntry.Next = 0;
            until ItemLedgEntry.Next = 0;
        end;
    end;

    procedure CalcShippedSaleNotReturned(var ShippedQtyNotReturned: Decimal; var RevUnitCostLCY: Decimal; ExactCostReverse: Boolean)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        TotalCostLCY: Decimal;
        TotalQtyBase: Decimal;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCalcShippedSaleNotReturned(Rec, ShippedQtyNotReturned, RevUnitCostLCY, ExactCostReverse, IsHandled);
        if IsHandled then
            exit;

        ShippedQtyNotReturned := 0;
        if (Type <> Type::Item) or (Quantity <= 0) then begin
            RevUnitCostLCY := "Unit Cost (LCY)";
            exit;
        end;

        RevUnitCostLCY := 0;
        FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
        if ItemLedgEntry.FindSet then
            repeat
                ShippedQtyNotReturned := ShippedQtyNotReturned - ItemLedgEntry."Shipped Qty. Not Returned";
                if ExactCostReverse then begin
                    ItemLedgEntry.CalcFields("Cost Amount (Expected)", "Cost Amount (Actual)");
                    TotalCostLCY :=
                      TotalCostLCY + ItemLedgEntry."Cost Amount (Expected)" + ItemLedgEntry."Cost Amount (Actual)";
                    TotalQtyBase := TotalQtyBase + ItemLedgEntry.Quantity;
                end;
            until ItemLedgEntry.Next = 0;

        if ExactCostReverse and (ShippedQtyNotReturned <> 0) and (TotalQtyBase <> 0) then
            RevUnitCostLCY := Abs(TotalCostLCY / TotalQtyBase) * "Qty. per Unit of Measure"
        else
            RevUnitCostLCY := "Unit Cost (LCY)";

        ShippedQtyNotReturned := CalcQty(ShippedQtyNotReturned);
    end;

    local procedure CalcQty(QtyBase: Decimal): Decimal
    begin
        if "Qty. per Unit of Measure" = 0 then
            exit(QtyBase);
        exit(Round(QtyBase / "Qty. per Unit of Measure", UOMMgt.QtyRndPrecision));
    end;

    procedure FilterPstdDocLnItemLedgEntries(var ItemLedgEntry: Record "Item Ledger Entry")
    begin
        ItemLedgEntry.Reset();
        ItemLedgEntry.SetCurrentKey("Document No.");
        ItemLedgEntry.SetRange("Document No.", "Document No.");
        ItemLedgEntry.SetRange("Document Type", ItemLedgEntry."Document Type"::"Sales Shipment");
        ItemLedgEntry.SetRange("Document Line No.", "Line No.");
    end;

    procedure ShowItemSalesInvLines()
    var
        TempSalesInvLine: Record "Sales Invoice Line" temporary;
    begin
        if Type = Type::Item then begin
            GetSalesInvLines(TempSalesInvLine);
            PAGE.RunModal(PAGE::"Posted Sales Invoice Lines", TempSalesInvLine);
        end;
    end;

    local procedure InitCurrency(CurrencyCode: Code[10])
    begin
        if (Currency.Code = CurrencyCode) and CurrencyRead then
            exit;

        if CurrencyCode <> '' then
            Currency.Get(CurrencyCode)
        else
            Currency.InitRoundingPrecision;
        CurrencyRead := true;
    end;

    procedure ShowLineComments()
    var
        SalesCommentLine: Record "Sales Comment Line";
    begin
        SalesCommentLine.ShowComments(SalesCommentLine."Document Type"::Shipment.AsInteger(), "Document No.", "Line No.");
    end;

    procedure ShowAsmToOrder()
    begin
        PostedATOLink.ShowPostedAsm(Rec);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    procedure AsmToShipmentExists(var PostedAsmHeader: Record "Posted Assembly Header"): Boolean
    var
        PostedAssembleToOrderLink: Record "Posted Assemble-to-Order Link";
    begin
        if not PostedAssembleToOrderLink.AsmExistsForPostedShipmentLine(Rec) then
            exit(false);
        exit(PostedAsmHeader.Get(PostedAssembleToOrderLink."Assembly Document No."));
    end;

    [Scope('OnPrem')]
    procedure UpdateVATOnLines(var SalesShptHeader: Record "Sales Shipment Header"; var SalesShptLine: Record "Sales Shipment Line"; var VATAmountLine: Record "VAT Amount Line")
    var
        TempVATAmountLineRemainder: Record "VAT Amount Line" temporary;
        Currency: Record Currency;
        RecRef: RecordRef;
        xRecRef: RecordRef;
        ChangeLogMgt: Codeunit "Change Log Management";
        NewAmount: Decimal;
        NewAmountIncludingVAT: Decimal;
        NewVATBaseAmount: Decimal;
        VATAmount: Decimal;
        VATDifference: Decimal;
        InvDiscAmount: Decimal;
        LineAmountToInvoice: Decimal;
        SalesSetup: Record "Sales & Receivables Setup";
        Totals: array[4] of Decimal;
        LineAmount: Decimal;
        CurrExchRate: Record "Currency Exchange Rate";
        LineDiscountAmount: Decimal;
    begin
        Clear(Totals);

        if SalesShptHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else
            Currency.Get(SalesShptHeader."Currency Code");

        TempVATAmountLineRemainder.DeleteAll();

        with SalesShptLine do begin
            SetRange("Document No.", SalesShptHeader."No.");
            SetFilter(Type, '>0');
            SetFilter(Quantity, '<>0');
            SalesSetup.Get();
            LockTable();
            if Find('-') then
                repeat
                    LineDiscountAmount :=
                      Round(
                        Round(Quantity * "Unit Price", Currency."Amount Rounding Precision") *
                        "Line Discount %" / 100, Currency."Amount Rounding Precision");
                    LineAmount := Round(Quantity * "Unit Price" - LineDiscountAmount, Currency."Amount Rounding Precision");
                    VATAmountLine.Get(
                      Format("VAT %"), "VAT Calculation Type", "Tax Group Code", false, LineAmount >= 0);
                    if VATAmountLine.Modified then begin
                        if not TempVATAmountLineRemainder.Get(
                          Format("VAT %"), "VAT Calculation Type", "Tax Group Code", false, LineAmount >= 0)
                        then begin
                            TempVATAmountLineRemainder := VATAmountLine;
                            TempVATAmountLineRemainder.Init();
                            TempVATAmountLineRemainder.Insert();
                        end;

                        if SalesShptHeader."Prices Including VAT" then begin
                            if (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount" = 0) or
                               (LineAmount = 0)
                            then begin
                                VATAmount := 0;
                                NewAmountIncludingVAT := 0;
                            end else begin
                                if not SalesSetup."Calc. VAT per Line" then
                                    VATAmount :=
                                      TempVATAmountLineRemainder."VAT Amount" +
                                      VATAmountLine."VAT Amount" *
                                      LineAmount / VATAmountLine."Line Amount"
                                else
                                    VATAmount :=
                                      VATAmountLine."VAT Amount" *
                                      LineAmount / VATAmountLine."Line Amount";
                                NewAmountIncludingVAT :=
                                  TempVATAmountLineRemainder."Amount Including VAT" +
                                  VATAmountLine."Amount Including VAT" *
                                  LineAmount / VATAmountLine."Line Amount";
                            end;
                            NewAmount :=
                              Round(NewAmountIncludingVAT, Currency."Amount Rounding Precision") -
                              Round(VATAmount, Currency."Amount Rounding Precision");
                            NewVATBaseAmount :=
                              Round(
                                NewAmount * (1 - SalesShptHeader."VAT Base Discount %" / 100),
                                Currency."Amount Rounding Precision");
                        end else begin
                            if "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" then begin
                                VATAmount := LineAmount;
                                NewAmount := 0;
                                NewVATBaseAmount := 0;
                            end else begin
                                NewAmount := LineAmount;
                                NewVATBaseAmount :=
                                  Round(
                                    NewAmount * (1 - SalesShptHeader."VAT Base Discount %" / 100),
                                    Currency."Amount Rounding Precision");
                                if VATAmountLine."VAT Base" = 0 then
                                    VATAmount := 0
                                else
                                    if not SalesSetup."Calc. VAT per Line" then
                                        VATAmount :=
                                          TempVATAmountLineRemainder."VAT Amount" +
                                          VATAmountLine."VAT Amount" * NewAmount / VATAmountLine."VAT Base"
                                    else
                                        VATAmount :=
                                          VATAmountLine."VAT Amount" * NewAmount / VATAmountLine."VAT Base";
                            end;
                            NewAmountIncludingVAT := NewAmount + Round(VATAmount, Currency."Amount Rounding Precision");
                        end;
                        Amount := NewAmount;
                        "Amount Including VAT" := Round(NewAmountIncludingVAT, Currency."Amount Rounding Precision");
                        "VAT Base Amount" := NewVATBaseAmount;
                        Totals[1] := Totals[1] + Amount;
                        Totals[2] := Totals[2] + "Amount Including VAT";
                        "Amount (LCY)" :=
                          Round(
                            CurrExchRate.ExchangeAmtFCYToLCY(
                              SalesShptHeader."Posting Date", SalesShptHeader."Currency Code",
                              Totals[1], SalesShptHeader."Currency Factor")) - Totals[3];
                        "Amount Including VAT (LCY)" :=
                          Round(
                            CurrExchRate.ExchangeAmtFCYToLCY(
                              SalesShptHeader."Posting Date", SalesShptHeader."Currency Code",
                              Totals[2], SalesShptHeader."Currency Factor")) - Totals[4];
                        Totals[3] := Totals[3] + "Amount (LCY)";
                        Totals[4] := Totals[4] + "Amount Including VAT (LCY)";
                        Modify;

                        TempVATAmountLineRemainder."Amount Including VAT" :=
                          NewAmountIncludingVAT - Round(NewAmountIncludingVAT, Currency."Amount Rounding Precision");
                        TempVATAmountLineRemainder."VAT Amount" := VATAmount - NewAmountIncludingVAT + NewAmount;
                        TempVATAmountLineRemainder.Modify();
                    end;
                until Next = 0;
            SetRange(Type);
            SetRange(Quantity);
        end;
    end;

    [Scope('OnPrem')]
    procedure CalcVATAmountLines(var SalesShptHeader: Record "Sales Shipment Header"; var SalesShptLine: Record "Sales Shipment Line"; var VATAmountLine: Record "VAT Amount Line")
    var
        PrevVatAmountLine: Record "VAT Amount Line";
        Currency: Record Currency;
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        QtyFactor: Decimal;
        SalesSetup: Record "Sales & Receivables Setup";
        SalesLine2: Record "Sales Line";
        RoundingLineInserted: Boolean;
        TotalVATAmount: Decimal;
        LineDiscountAmount: Decimal;
    begin
        if SalesShptHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else
            Currency.Get(SalesShptHeader."Currency Code");

        VATAmountLine.DeleteAll();

        with SalesShptLine do begin
            SetRange("Document No.", SalesShptHeader."No.");
            SetFilter(Type, '>0');
            SetFilter(Quantity, '<>0');
            SalesSetup.Get();
            if Find('-') then
                repeat
                    if "VAT Calculation Type" in
                       ["VAT Calculation Type"::"Reverse Charge VAT", "VAT Calculation Type"::"Sales Tax"]
                    then
                        "VAT %" := 0;
                    if not VATAmountLine.Get(
                      Format("VAT %"), "VAT Calculation Type", "Tax Group Code", false, Quantity * "Unit Price" >= 0)
                    then begin
                        VATAmountLine.Init();
                        VATAmountLine."VAT Identifier" := Format("VAT %");
                        VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                        VATAmountLine."Tax Group Code" := "Tax Group Code";
                        VATAmountLine."VAT %" := "VAT %";
                        VATAmountLine.Modified := true;
                        VATAmountLine.Positive := Quantity * "Unit Price" >= 0;
                        VATAmountLine.Insert();
                    end;
                    VATAmountLine.Quantity := VATAmountLine.Quantity + Quantity;
                    LineDiscountAmount :=
                      Round(
                        Round(Quantity * "Unit Price", Currency."Amount Rounding Precision") *
                        "Line Discount %" / 100, Currency."Amount Rounding Precision");
                    VATAmountLine."Line Amount" :=
                      VATAmountLine."Line Amount" +
                      Round(Quantity * "Unit Price" - LineDiscountAmount, Currency."Amount Rounding Precision");
                    VATAmountLine.Modify();
                until Next = 0;
            SetRange(Type);
            SetRange(Quantity);
        end;

        with VATAmountLine do
            if Find('-') then
                repeat
                    if (PrevVatAmountLine."VAT Identifier" <> VATAmountLine."VAT Identifier") or
                       (PrevVatAmountLine."VAT Calculation Type" <> VATAmountLine."VAT Calculation Type") or
                       (PrevVatAmountLine."Tax Group Code" <> VATAmountLine."Tax Group Code") or
                       (PrevVatAmountLine."Use Tax" <> VATAmountLine."Use Tax")
                    then
                        PrevVatAmountLine.Init();
                    if SalesShptHeader."Prices Including VAT" then begin
                        case "VAT Calculation Type" of
                            "VAT Calculation Type"::"Normal VAT",
                            "VAT Calculation Type"::"Reverse Charge VAT":
                                begin
                                    "VAT Base" :=
                                      Round(
                                        ("Line Amount" - "Invoice Discount Amount") / (1 + "VAT %" / 100),
                                        Currency."Amount Rounding Precision") - "VAT Difference";
                                    "VAT Amount" :=
                                      "VAT Difference" +
                                      Round(
                                        PrevVatAmountLine."VAT Amount" +
                                        ("Line Amount" - "Invoice Discount Amount" - "VAT Base" - "VAT Difference") *
                                        (1 - SalesShptHeader."VAT Base Discount %" / 100),
                                        Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                    if not SalesSetup."Calc. VAT per Line" then
                                        "VAT Amount" :=
                                          "VAT Difference" +
                                          Round(
                                            PrevVatAmountLine."VAT Amount" +
                                            ("Line Amount" - "Invoice Discount Amount" - "VAT Base" - "VAT Difference") *
                                            (1 - SalesShptHeader."VAT Base Discount %" / 100),
                                            Currency."Amount Rounding Precision", Currency.VATRoundingDirection)
                                    else
                                        "VAT Amount" :=
                                        "VAT Difference" +
                                        PrevVatAmountLine."VAT Amount" +
                                        ("Line Amount" - "Invoice Discount Amount" - "VAT Base" - "VAT Difference") *
                                        (1 - SalesShptHeader."VAT Base Discount %" / 100);
                                    "Amount Including VAT" := "VAT Base" + "VAT Amount";
                                    if Positive then
                                        PrevVatAmountLine.Init
                                    else begin
                                        PrevVatAmountLine := VATAmountLine;
                                        PrevVatAmountLine."VAT Amount" :=
                                          ("Line Amount" - "Invoice Discount Amount" - "VAT Base" - "VAT Difference") *
                                          (1 - SalesShptHeader."VAT Base Discount %" / 100);
                                        PrevVatAmountLine."VAT Amount" :=
                                          PrevVatAmountLine."VAT Amount" -
                                          Round(PrevVatAmountLine."VAT Amount", Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                    end;
                                end;
                            "VAT Calculation Type"::"Full VAT":
                                begin
                                    "VAT Base" := 0;
                                    "VAT Amount" := "VAT Difference" + "Line Amount" - "Invoice Discount Amount";
                                    "Amount Including VAT" := "VAT Amount";
                                end;
                            "VAT Calculation Type"::"Sales Tax":
                                begin
                                    "Amount Including VAT" := "Line Amount" - "Invoice Discount Amount";
                                    "VAT Base" :=
                                      Round(
                                        SalesTaxCalculate.ReverseCalculateTax(
                                          SalesShptHeader."Tax Area Code", "Tax Group Code", SalesShptHeader."Tax Liable",
                                          SalesShptHeader."Posting Date", "Amount Including VAT", Quantity, SalesShptHeader."Currency Factor"),
                                        Currency."Amount Rounding Precision");
                                    "VAT Amount" := "VAT Difference" + "Amount Including VAT" - "VAT Base";
                                    if "VAT Base" = 0 then
                                        "VAT %" := 0
                                    else
                                        "VAT %" := Round(100 * "VAT Amount" / "VAT Base", 0.00001);
                                end;
                        end;
                    end else begin
                        case "VAT Calculation Type" of
                            "VAT Calculation Type"::"Normal VAT",
                            "VAT Calculation Type"::"Reverse Charge VAT":
                                begin
                                    "VAT Base" := "Line Amount" - "Invoice Discount Amount";
                                    if not SalesSetup."Calc. VAT per Line" then
                                        "VAT Amount" :=
                                          "VAT Difference" +
                                          Round(
                                            PrevVatAmountLine."VAT Amount" +
                                            "VAT Base" * "VAT %" / 100 * (1 - SalesShptHeader."VAT Base Discount %" / 100),
                                            Currency."Amount Rounding Precision", Currency.VATRoundingDirection)
                                    else
                                        "VAT Amount" :=
                                          "VAT Difference" +
                                          PrevVatAmountLine."VAT Amount" +
                                          "VAT Base" * "VAT %" / 100 * (1 - SalesShptHeader."VAT Base Discount %" / 100);
                                    "Amount Including VAT" := "Line Amount" - "Invoice Discount Amount" + "VAT Amount";
                                    if Positive then
                                        PrevVatAmountLine.Init
                                    else begin
                                        PrevVatAmountLine := VATAmountLine;
                                        PrevVatAmountLine."VAT Amount" :=
                                          "VAT Base" * "VAT %" / 100 * (1 - SalesShptHeader."VAT Base Discount %" / 100);
                                        PrevVatAmountLine."VAT Amount" :=
                                          PrevVatAmountLine."VAT Amount" -
                                          Round(PrevVatAmountLine."VAT Amount", Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                    end;
                                end;
                            "VAT Calculation Type"::"Full VAT":
                                begin
                                    "VAT Base" := 0;
                                    "VAT Amount" := "VAT Difference" + "Line Amount" - "Invoice Discount Amount";
                                    "Amount Including VAT" := "VAT Amount";
                                end;
                            "VAT Calculation Type"::"Sales Tax":
                                begin
                                    "VAT Base" := "Line Amount" - "Invoice Discount Amount";
                                    "VAT Amount" :=
                                      SalesTaxCalculate.CalculateTax(
                                        SalesShptHeader."Tax Area Code", "Tax Group Code", SalesShptHeader."Tax Liable",
                                        SalesShptHeader."Posting Date", "VAT Base", Quantity, SalesShptHeader."Currency Factor");
                                    if "VAT Base" = 0 then
                                        "VAT %" := 0
                                    else
                                        "VAT %" := Round(100 * "VAT Amount" / "VAT Base", 0.00001);
                                    "VAT Amount" :=
                                      "VAT Difference" +
                                      Round("VAT Amount", Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                    "Amount Including VAT" := "VAT Base" + "VAT Amount";
                                end;
                        end;
                    end;
                    "Calculated VAT Amount" := "VAT Amount" - "VAT Difference";
                    Modify;
                until Next = 0;
    end;

    procedure InitFromSalesLine(SalesShptHeader: Record "Sales Shipment Header"; SalesLine: Record "Sales Line")
    begin
        Init;
        TransferFields(SalesLine);
        if ("No." = '') and HasTypeToFillMandatoryFields() then
            Type := Type::" ";
        "Posting Date" := SalesShptHeader."Posting Date";
        "Document No." := SalesShptHeader."No.";
        Quantity := SalesLine."Qty. to Ship";
        "Quantity (Base)" := SalesLine."Qty. to Ship (Base)";
        if Abs(SalesLine."Qty. to Invoice") > Abs(SalesLine."Qty. to Ship") then begin
            "Quantity Invoiced" := SalesLine."Qty. to Ship";
            "Qty. Invoiced (Base)" := SalesLine."Qty. to Ship (Base)";
        end else begin
            "Quantity Invoiced" := SalesLine."Qty. to Invoice";
            "Qty. Invoiced (Base)" := SalesLine."Qty. to Invoice (Base)";
        end;
        "Qty. Shipped Not Invoiced" := Quantity - "Quantity Invoiced";
        if SalesLine."Document Type" = SalesLine."Document Type"::Order then begin
            "Order No." := SalesLine."Document No.";
            "Order Line No." := SalesLine."Line No.";
        end;

        OnAfterInitFromSalesLine(SalesShptHeader, SalesLine, Rec);
    end;

    local procedure ClearSalesLineValues(var SalesLine: Record "Sales Line")
    begin
        SalesLine."Quantity (Base)" := 0;
        SalesLine.Quantity := 0;
        SalesLine."Outstanding Qty. (Base)" := 0;
        SalesLine."Outstanding Quantity" := 0;
        SalesLine."Quantity Shipped" := 0;
        SalesLine."Qty. Shipped (Base)" := 0;
        SalesLine."Quantity Invoiced" := 0;
        SalesLine."Qty. Invoiced (Base)" := 0;
        SalesLine.Amount := 0;
        SalesLine."Amount Including VAT" := 0;
        SalesLine."Purchase Order No." := '';
        SalesLine."Purch. Order Line No." := 0;
        SalesLine."Special Order Purchase No." := '';
        SalesLine."Special Order Purch. Line No." := 0;
        SalesLine."Special Order" := false;
        SalesLine."Appl.-to Item Entry" := 0;
        SalesLine."Appl.-from Item Entry" := 0;

        OnAfterClearSalesLineValues(Rec, SalesLine);
    end;

    procedure FormatType(): Text
    var
        SalesLine: Record "Sales Line";
    begin
        if Type = Type::" " then
            exit(SalesLine.FormatType);

        exit(Format(Type));
    end;

    local procedure CalcBaseQuantities(var SalesLine: Record "Sales Line"; QtyFactor: Decimal)
    begin
        SalesLine."Quantity (Base)" :=
          Round(SalesLine.Quantity * QtyFactor, UOMMgt.QtyRndPrecision);
        SalesLine."Qty. to Asm. to Order (Base)" :=
          Round(SalesLine."Qty. to Assemble to Order" * QtyFactor, UOMMgt.QtyRndPrecision);
        SalesLine."Outstanding Qty. (Base)" :=
          Round(SalesLine."Outstanding Quantity" * QtyFactor, UOMMgt.QtyRndPrecision);
        SalesLine."Qty. to Ship (Base)" :=
          Round(SalesLine."Qty. to Ship" * QtyFactor, UOMMgt.QtyRndPrecision);
        SalesLine."Qty. Shipped (Base)" :=
          Round(SalesLine."Quantity Shipped" * QtyFactor, UOMMgt.QtyRndPrecision);
        SalesLine."Qty. Shipped Not Invd. (Base)" :=
          Round(SalesLine."Qty. Shipped Not Invoiced" * QtyFactor, UOMMgt.QtyRndPrecision);
        SalesLine."Qty. to Invoice (Base)" :=
          Round(SalesLine."Qty. to Invoice" * QtyFactor, UOMMgt.QtyRndPrecision);
        SalesLine."Qty. Invoiced (Base)" :=
          Round(SalesLine."Quantity Invoiced" * QtyFactor, UOMMgt.QtyRndPrecision);
        SalesLine."Return Qty. to Receive (Base)" :=
          Round(SalesLine."Return Qty. to Receive" * QtyFactor, UOMMgt.QtyRndPrecision);
        SalesLine."Return Qty. Received (Base)" :=
          Round(SalesLine."Return Qty. Received" * QtyFactor, UOMMgt.QtyRndPrecision);
        SalesLine."Ret. Qty. Rcd. Not Invd.(Base)" :=
          Round(SalesLine."Return Qty. Rcd. Not Invd." * QtyFactor, UOMMgt.QtyRndPrecision);
    end;

    local procedure GetFieldCaption(FieldNumber: Integer): Text[100]
    var
        "Field": Record "Field";
    begin
        Field.Get(DATABASE::"Sales Shipment Line", FieldNumber);
        exit(Field."Field Caption");
    end;

    procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    begin
        case FieldNumber of
            FieldNo("No."):
                exit(StrSubstNo('3,%1', GetFieldCaption(FieldNumber)));
        end;
    end;

    procedure HasTypeToFillMandatoryFields(): Boolean
    begin
        exit(Type <> Type::" ");
    end;

    local procedure UpdateDocumentId()
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        if "Document No." = '' then begin
            Clear("Document Id");
            exit;
        end;

        if not SalesShipmentHeader.Get("Document No.") then
            exit;

        "Document Id" := SalesShipmentHeader.SystemId;
    end;


    local procedure UpdateDocumentNo()
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        if IsNullGuid(Rec."Document Id") then begin
            Clear(Rec."Document No.");
            exit;
        end;

        if not SalesShipmentHeader.GetBySystemId(Rec."Document Id") then
            exit;

        "Document No." := SalesShipmentHeader."No.";
    end;

    procedure UpdateReferencedIds()
    begin
        UpdateDocumentId();
    end;


    [IntegrationEvent(false, false)]
    local procedure OnAfterClearSalesLineValues(var SalesShipmentLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterDescriptionSalesLineInsert(var SalesLine: Record "Sales Line"; SalesShipmentLine: Record "Sales Shipment Line"; var NextLineNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitFromSalesLine(SalesShptHeader: Record "Sales Shipment Header"; SalesLine: Record "Sales Line"; var SalesShptLine: Record "Sales Shipment Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertInvLineFromShptLine(var SalesLine: Record "Sales Line"; SalesOrderLine: Record "Sales Line"; NextLineNo: Integer; SalesShipmentLine: Record "Sales Shipment Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcShippedSaleNotReturned(var SalesShipmentLine: Record "Sales Shipment Line"; var ShippedQtyNotReturned: Decimal; var RevUnitCostLCY: Decimal; ExactCostReverse: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertInvLineFromShptLine(var SalesShptLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; SalesOrderLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine(var SalesShptLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; var NextLineNo: Integer; var Handled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCodeInsertInvLineFromShptLine(var SalesShipmentLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertInvLineFromShptLineOnAfterAssignDescription(var SalesShipmentLine: Record "Sales Shipment Line"; var SalesOrderLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertInvLineFromShptLineOnAfterCalcQuantities(var SalesLine: Record "Sales Line"; SalesOrderLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertInvLineFromShptLineOnAfterUpdatePrepaymentsAmounts(var SalesLine: Record "Sales Line"; var SalesOrderLine: Record "Sales Line"; var SalesShipmentLine: Record "Sales Shipment Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertInvLineFromShptLineOnBeforeValidateQuantity(SalesShipmentLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertInvLineFromShptLineOnBeforeInsertDescriptionLine(SalesShipmentLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; TempSalesLine: Record "Sales Line" temporary; var SalesInvHeader: Record "Sales Header"; var NextLineNo: integer)
    begin
    end;
}

