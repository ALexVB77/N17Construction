table 312 "Purchases & Payables Setup"
{
    Caption = 'Purchases & Payables Setup';
    DrillDownPageID = "Purchases & Payables Setup";
    LookupPageID = "Purchases & Payables Setup";

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Discount Posting"; Option)
        {
            Caption = 'Discount Posting';
            OptionCaption = 'No Discounts,Invoice Discounts,Line Discounts,All Discounts';
            OptionMembers = "No Discounts","Invoice Discounts","Line Discounts","All Discounts";

            trigger OnValidate()
            var
                DiscountNotificationMgt: Codeunit "Discount Notification Mgt.";
            begin
                DiscountNotificationMgt.NotifyAboutMissingSetup(RecordId, '', "Discount Posting", 0);
            end;
        }
        field(6; "Receipt on Invoice"; Boolean)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            Caption = 'Receipt on Invoice';

            trigger OnValidate()
            begin
                CheckPrepmtAdjmtSetup(not "Receipt on Invoice");
            end;
        }
        field(7; "Invoice Rounding"; Boolean)
        {
            Caption = 'Invoice Rounding';
        }
        field(8; "Ext. Doc. No. Mandatory"; Boolean)
        {
            Caption = 'Ext. Doc. No. Mandatory';
            InitValue = true;
        }
        field(9; "Vendor Nos."; Code[20])
        {
            Caption = 'Vendor Nos.';
            TableRelation = "No. Series";
        }
        field(10; "Quote Nos."; Code[20])
        {
            Caption = 'Quote Nos.';
            TableRelation = "No. Series";
        }
        field(11; "Order Nos."; Code[20])
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            Caption = 'Order Nos.';
            TableRelation = "No. Series";
        }
        field(12; "Invoice Nos."; Code[20])
        {
            Caption = 'Invoice Nos.';
            TableRelation = "No. Series";
        }
        field(13; "Posted Invoice Nos."; Code[20])
        {
            Caption = 'Posted Invoice Nos.';
            TableRelation = "No. Series";
        }
        field(14; "Credit Memo Nos."; Code[20])
        {
            Caption = 'Credit Memo Nos.';
            TableRelation = "No. Series";
        }
        field(15; "Posted Credit Memo Nos."; Code[20])
        {
            Caption = 'Posted Credit Memo Nos.';
            TableRelation = "No. Series";
        }
        field(16; "Posted Receipt Nos."; Code[20])
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            Caption = 'Posted Receipt Nos.';
            TableRelation = "No. Series";
        }
        field(19; "Blanket Order Nos."; Code[20])
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            Caption = 'Blanket Order Nos.';
            TableRelation = "No. Series";
        }
        field(20; "Calc. Inv. Discount"; Boolean)
        {
            AccessByPermission = TableData "Vendor Invoice Disc." = R;
            Caption = 'Calc. Inv. Discount';
        }
        field(21; "Appln. between Currencies"; Option)
        {
            AccessByPermission = TableData Currency = R;
            Caption = 'Appln. between Currencies';
            OptionCaption = 'None,EMU,All';
            OptionMembers = "None",EMU,All;
        }
        field(22; "Copy Comments Blanket to Order"; Boolean)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            Caption = 'Copy Comments Blanket to Order';
            InitValue = true;
        }
        field(23; "Copy Comments Order to Invoice"; Boolean)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            Caption = 'Copy Comments Order to Invoice';
            InitValue = true;
        }
        field(24; "Copy Comments Order to Receipt"; Boolean)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            Caption = 'Copy Comments Order to Receipt';
            InitValue = true;
        }
        field(25; "Allow VAT Difference"; Boolean)
        {
            Caption = 'Allow VAT Difference';
        }
        field(26; "Calc. Inv. Disc. per VAT ID"; Boolean)
        {
            Caption = 'Calc. Inv. Disc. per VAT ID';
        }
        field(27; "Posted Prepmt. Inv. Nos."; Code[20])
        {
            Caption = 'Posted Prepmt. Inv. Nos.';
            TableRelation = "No. Series";
        }
        field(28; "Posted Prepmt. Cr. Memo Nos."; Code[20])
        {
            Caption = 'Posted Prepmt. Cr. Memo Nos.';
            TableRelation = "No. Series";
        }
        field(29; "Check Prepmt. when Posting"; Boolean)
        {
            Caption = 'Check Prepmt. when Posting';
        }
        field(33; "Prepmt. Auto Update Frequency"; Option)
        {
            Caption = 'Prepmt. Auto Update Frequency';
            DataClassification = SystemMetadata;
            OptionCaption = 'Never,Daily,Weekly';
            OptionMembers = Never,Daily,Weekly;

            trigger OnValidate()
            var
                PrepaymentMgt: Codeunit "Prepayment Mgt.";
            begin
                if "Prepmt. Auto Update Frequency" = xRec."Prepmt. Auto Update Frequency" then
                    exit;

                PrepaymentMgt.CreateAndStartJobQueueEntryPurchase("Prepmt. Auto Update Frequency");
            end;
        }
        field(35; "Default Posting Date"; Enum "Default Posting Date")
        {
            Caption = 'Default Posting Date';
        }
        field(36; "Default Qty. to Receive"; Option)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            Caption = 'Default Qty. to Receive';
            OptionCaption = 'Remainder,Blank';
            OptionMembers = Remainder,Blank;
        }
        field(37; "Archive Quotes and Orders"; Boolean)
        {
            Caption = 'Archive Quotes and Orders';
            ObsoleteReason = 'Replaced by new fields Archive Quotes and Archive Orders';
            ObsoleteState = Pending;
            ObsoleteTag = '15.0';
        }
        field(38; "Post with Job Queue"; Boolean)
        {
            Caption = 'Post with Job Queue';

            trigger OnValidate()
            begin
                if not "Post with Job Queue" then
                    "Post & Print with Job Queue" := false;
            end;
        }
        field(39; "Job Queue Category Code"; Code[10])
        {
            Caption = 'Job Queue Category Code';
            TableRelation = "Job Queue Category";
        }
        field(40; "Job Queue Priority for Post"; Integer)
        {
            Caption = 'Job Queue Priority for Post';
            InitValue = 1000;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Job Queue Priority for Post" < 0 then
                    Error(Text001);
            end;
        }
        field(41; "Post & Print with Job Queue"; Boolean)
        {
            Caption = 'Post & Print with Job Queue';

            trigger OnValidate()
            begin
                if "Post & Print with Job Queue" then
                    "Post with Job Queue" := true;
            end;
        }
        field(42; "Job Q. Prio. for Post & Print"; Integer)
        {
            Caption = 'Job Q. Prio. for Post & Print';
            InitValue = 1000;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Job Queue Priority for Post" < 0 then
                    Error(Text001);
            end;
        }
        field(43; "Notify On Success"; Boolean)
        {
            Caption = 'Notify On Success';
        }
        field(46; "Allow Document Deletion Before"; Date)
        {
            Caption = 'Allow Document Deletion Before';
        }
        field(47; "Report Output Type"; Option)
        {
            Caption = 'Report Output Type';
            DataClassification = CustomerContent;
            OptionCaption = 'PDF,,,Print';
            OptionMembers = PDF,,,Print;

            trigger OnValidate()
            var
                EnvironmentInformation: Codeunit "Environment Information";
            begin
                if "Report Output Type" = "Report Output Type"::Print then
                    if EnvironmentInformation.IsSaaS then
                        TestField("Report Output Type", "Report Output Type"::PDF);
            end;
        }
        field(52; "Archive Quotes"; Option)
        {
            Caption = 'Archive Quotes';
            OptionCaption = 'Never,Question,Always';
            OptionMembers = Never,Question,Always;
        }
        field(53; "Archive Orders"; Boolean)
        {
            Caption = 'Archive Orders';
        }
        field(54; "Archive Blanket Orders"; Boolean)
        {
            Caption = 'Archive Blanket Orders';
        }
        field(55; "Archive Return Orders"; Boolean)
        {
            Caption = 'Archive Return Orders';
        }
        field(56; "Ignore Updated Addresses"; Boolean)
        {
            Caption = 'Ignore Updated Addresses';
        }
        field(57; "Create Item from Item No."; Boolean)
        {
            Caption = 'Create Item from Item No.';
        }
        field(58; "Copy Vendor Name to Entries"; Boolean)
        {
            Caption = 'Copy Vendor Name to Entries';

            trigger OnValidate()
            var
                UpdateNameInLedgerEntries: Codeunit "Update Name In Ledger Entries";
            begin
                if "Copy Vendor Name to Entries" then
                    UpdateNameInLedgerEntries.NotifyAboutBlankNamesInLedgerEntries(RecordId);
            end;
        }
        field(59; "Copy Inv. No. To Pmt. Ref."; Boolean)
        {
            Caption = 'Copy Invoice No. To Payment Reference';
        }
        field(170; "Insert Std. Purch. Lines Mode"; Option)
        {
            Caption = 'Insert Std. Purch. Lines Mode';
            DataClassification = SystemMetadata;
            ObsoleteReason = 'Not needed after refactoring';
            ObsoleteState = Pending;
            OptionCaption = 'Manual,Automatic,Always Ask';
            OptionMembers = Manual,Automatic,"Always Ask";
            ObsoleteTag = '15.0';
        }
        field(171; "Insert Std. Lines on Quotes"; Boolean)
        {
            Caption = 'Insert Std. Lines on Quotes';
            DataClassification = SystemMetadata;
            ObsoleteReason = 'Not needed after refactoring';
            ObsoleteState = Pending;
            ObsoleteTag = '15.0';
        }
        field(172; "Insert Std. Lines on Orders"; Boolean)
        {
            Caption = 'Insert Std. Lines on Orders';
            DataClassification = SystemMetadata;
            ObsoleteReason = 'Not needed after refactoring';
            ObsoleteState = Pending;
            ObsoleteTag = '15.0';
        }
        field(173; "Insert Std. Lines on Invoices"; Boolean)
        {
            Caption = 'Insert Std. Lines on Invoices';
            DataClassification = SystemMetadata;
            ObsoleteReason = 'Not needed after refactoring';
            ObsoleteState = Pending;
            ObsoleteTag = '15.0';
        }
        field(174; "Insert Std. Lines on Cr. Memos"; Boolean)
        {
            Caption = 'Insert Std. Lines on Cr. Memos';
            DataClassification = SystemMetadata;
            ObsoleteReason = 'Not needed after refactoring';
            ObsoleteState = Pending;
            ObsoleteTag = '15.0';
        }
        field(210; "Copy Line Descr. to G/L Entry"; Boolean)
        {
            Caption = 'Copy Line Descr. to G/L Entry';
            DataClassification = SystemMetadata;
        }
        field(1217; "Debit Acc. for Non-Item Lines"; Code[20])
        {
            Caption = 'Debit Acc. for Non-Item Lines';
            TableRelation = "G/L Account" WHERE("Direct Posting" = CONST(true),
                                                 "Account Type" = CONST(Posting),
                                                 Blocked = CONST(false));
        }
        field(1218; "Credit Acc. for Non-Item Lines"; Code[20])
        {
            Caption = 'Credit Acc. for Non-Item Lines';
            TableRelation = "G/L Account" WHERE("Direct Posting" = CONST(true),
                                                 "Account Type" = CONST(Posting),
                                                 Blocked = CONST(false));
        }
        field(5800; "Posted Return Shpt. Nos."; Code[20])
        {
            AccessByPermission = TableData "Return Shipment Header" = R;
            Caption = 'Posted Return Shpt. Nos.';
            TableRelation = "No. Series";
        }
        field(5801; "Copy Cmts Ret.Ord. to Ret.Shpt"; Boolean)
        {
            AccessByPermission = TableData "Return Shipment Header" = R;
            Caption = 'Copy Cmts Ret.Ord. to Ret.Shpt';
            InitValue = true;
        }
        field(5802; "Copy Cmts Ret.Ord. to Cr. Memo"; Boolean)
        {
            AccessByPermission = TableData "Return Shipment Header" = R;
            Caption = 'Copy Cmts Ret.Ord. to Cr. Memo';
            InitValue = true;
        }
        field(6600; "Return Order Nos."; Code[20])
        {
            AccessByPermission = TableData "Return Shipment Header" = R;
            Caption = 'Return Order Nos.';
            TableRelation = "No. Series";
        }
        field(6601; "Return Shipment on Credit Memo"; Boolean)
        {
            AccessByPermission = TableData "Return Shipment Header" = R;
            Caption = 'Return Shipment on Credit Memo';

            trigger OnValidate()
            begin
                CheckPrepmtAdjmtSetup(not "Return Shipment on Credit Memo");
            end;
        }
        field(6602; "Exact Cost Reversing Mandatory"; Boolean)
        {
            Caption = 'Exact Cost Reversing Mandatory';
        }
        field(7000; "Price Calculation Method"; Enum "Price Calculation Method")
        {
            Caption = 'Price Calculation Method';
            InitValue = "Lowest Price";

            trigger OnValidate()
            var
                PriceCalculationMgt: Codeunit "Price Calculation Mgt.";
                PriceType: Enum "Price Type";
            begin
                PriceCalculationMgt.VerifyMethodImplemented("Price Calculation Method", PriceType::Purchase);
            end;
        }
        field(7001; "Price List Nos."; Code[20])
        {
            Caption = 'Price List Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(12400; "Use Prepayment Account"; Boolean)
        {
            Caption = 'Use Prepayment Account';
        }
        field(12401; "Advance Statement Nos."; Code[20])
        {
            Caption = 'Advance Statement Nos.';
            TableRelation = "No. Series";
        }
        field(12402; "Check Application Date"; Boolean)
        {
            Caption = 'Check Application Date';
        }
        field(12407; "Posted VAT Agent Invoice Nos."; Code[20])
        {
            Caption = 'Posted VAT Agent Invoice Nos.';
            TableRelation = "No. Series";
        }
        field(12410; "Transfer Posting Description"; Boolean)
        {
            Caption = 'Transfer Posting Description';
        }
        field(12425; "Posted PD Doc. Nos."; Code[20])
        {
            Caption = 'Posted PD Doc. Nos.';
            TableRelation = "No. Series";
        }
        field(12426; "PD Gains Condition Dim Value"; Code[20])
        {
            Caption = 'PD Gains Condition Dim Value';
            TableRelation = "Dimension Value".Code;

            trigger OnLookup()
            begin
                AmtDiffMgt.LookupTaxDim(0, "PD Gains Condition Dim Value");
            end;

            trigger OnValidate()
            begin
                AmtDiffMgt.ValidateTaxDim(0, "PD Gains Condition Dim Value");
            end;
        }
        field(12427; "PD Losses Condition Dim Value"; Code[20])
        {
            Caption = 'PD Losses Condition Dim Value';
            TableRelation = "Dimension Value".Code;

            trigger OnLookup()
            begin
                AmtDiffMgt.LookupTaxDim(0, "PD Losses Condition Dim Value");
            end;

            trigger OnValidate()
            begin
                AmtDiffMgt.ValidateTaxDim(0, "PD Losses Condition Dim Value");
            end;
        }
        field(12428; "PD Gains Kind Dim Value"; Code[20])
        {
            Caption = 'PD Gains Kind Dim Value';
            TableRelation = "Dimension Value".Code;

            trigger OnLookup()
            begin
                AmtDiffMgt.LookupTaxDim(1, "PD Gains Kind Dim Value");
            end;

            trigger OnValidate()
            begin
                AmtDiffMgt.ValidateTaxDim(1, "PD Gains Kind Dim Value");
            end;
        }
        field(12429; "PD Losses Kind Dim Value"; Code[20])
        {
            Caption = 'PD Losses Kind Dim Value';
            TableRelation = "Dimension Value".Code;

            trigger OnLookup()
            begin
                AmtDiffMgt.LookupTaxDim(1, "PD Losses Kind Dim Value");
            end;

            trigger OnValidate()
            begin
                AmtDiffMgt.ValidateTaxDim(1, "PD Losses Kind Dim Value");
            end;
        }
        field(12431; "PD Doc. Nos. Type"; Option)
        {
            Caption = 'PD Doc. Nos. Type';
            OptionCaption = 'Use No. Series,Add Symbol';
            OptionMembers = "Use No. Series","Add Symbol";
        }
        field(12432; "Symbol for PD Doc."; Text[5])
        {
            Caption = 'Symbol for PD Doc.';
        }
        field(12435; "Allow Alter Posting Groups"; Boolean)
        {
            Caption = 'Allow Alter Posting Groups';
        }
        field(12450; "TORG-1 Template Code"; Code[10])
        {
            Caption = 'TORG-1 Template Code';
            TableRelation = "Excel Template";
        }
        field(12451; "TORG-2 Template Code"; Code[10])
        {
            Caption = 'TORG-2 Template Code';
            TableRelation = "Excel Template";
        }
        field(12452; "M-7 Template Code"; Code[10])
        {
            Caption = 'M-7 Template Code';
            TableRelation = "Excel Template";
        }
        field(12453; "M-4 Template Code"; Code[10])
        {
            Caption = 'M-4 Template Code';
            TableRelation = "Excel Template";
        }
        field(12490; "Vendor Agreement Nos."; Code[20])
        {
            Caption = 'Vendor Agreement Nos.';
            TableRelation = "No. Series";
        }
        field(12491; "Synch. Agreement Dimension"; Boolean)
        {
            Caption = 'Synch. Agreement Dimension';
        }
        field(12492; "Vendor Agreement Dim. Code"; Code[20])
        {
            Caption = 'Vendor Agreement Dim. Code';
            TableRelation = Dimension;
        }
        field(12493; "Adv. Statement Template Code"; Code[10])
        {
            Caption = 'Adv. Statement Template Code';
            TableRelation = "Excel Template";
        }
        field(14703; "Adv. Stmt. Vendor Posting Gr."; Code[20])
        {
            Caption = 'Adv. Stmt. Vendor Posting Gr.';
            TableRelation = "Vendor Posting Group";
        }
        field(14704; "Adv. Stmt. Gen.Bus. Posting Gr"; Code[20])
        {
            Caption = 'Adv. Stmt. Gen.Bus. Posting Gr';
            TableRelation = "Gen. Business Posting Group";
        }
        field(14705; "Adv. Stmt. VAT Bus. Posting Gr"; Code[20])
        {
            Caption = 'Adv. Stmt. VAT Bus. Posting Gr';
            TableRelation = "VAT Business Posting Group";
        }
        field(14905; "Letter of Attorney Nos."; Code[20])
        {
            Caption = 'Letter of Attorney Nos.';
            TableRelation = "No. Series";
        }
        field(14906; "Released Letter of Attor. Nos."; Code[20])
        {
            Caption = 'Released Letter of Attor. Nos.';
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text001: Label 'Job Queue Priority must be zero or positive.';
        AmtDiffMgt: Codeunit PrepmtDiffManagement;
        RecordHasBeenRead: Boolean;

    procedure GetRecordOnce()
    begin
        if RecordHasBeenRead then
            exit;
        Get;
        RecordHasBeenRead := true;
    end;

    procedure JobQueueActive(): Boolean
    begin
        Get;
        exit("Post with Job Queue" or "Post & Print with Job Queue");
    end;

    [Scope('OnPrem')]
    procedure GetTaxDimValue(CorrType: Option Loss,Gain; DimType: Option Condition,Kind; PrepAdjmt: Boolean) DimValue: Code[20]
    begin
        Get;
        case DimType of
            DimType::Condition:
                case CorrType of
                    CorrType::Loss:
                        exit("PD Losses Condition Dim Value");
                    CorrType::Gain:
                        exit("PD Gains Condition Dim Value");
                end;
            DimType::Kind:
                case CorrType of
                    CorrType::Loss:
                        exit("PD Losses Kind Dim Value");
                    CorrType::Gain:
                        exit("PD Gains Kind Dim Value");
                end;
        end;
    end;

    [Scope('OnPrem')]
    procedure CheckPrepmtAdjmtSetup(CheckValue: Boolean)
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get();
        if GLSetup."Enable Russian Accounting" then
            if CheckValue then
                GLSetup.TestField("Cancel Curr. Prepmt. Adjmt.", false);
    end;
}
