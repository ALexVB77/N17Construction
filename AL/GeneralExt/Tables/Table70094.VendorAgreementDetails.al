table 70094 "Vendor Agreement Details"
{
    DataClassification = ToBeClassified;
    // DrillDownFormID = Form70216;
    // LookupFormID = Form70216;
    // Permissions = TableData 380 = r;
    fields
    {
        field(1; "Agreement No."; Code[20])
        {
            Caption = 'Agreement No.';
            TableRelation = "Vendor Agreement"."No.";

            trigger OnValidate()
            begin
                IF VendorAgreement.GET("Vendor No.", "Agreement No.") THEN
                    "Currency Code" := VendorAgreement."Currency Code";
            end;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(4; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            NotBlank = true;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(5; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            NotBlank = true;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                GeneralLedgerSetup.GET;
                IF DimensionValue.GET(GeneralLedgerSetup."Global Dimension 2 Code", "Global Dimension 2 Code") THEN
                    Description := DimensionValue.Name;
            end;
        }
        field(6; Amount; Decimal)
        {
            // CaptionClass = GetCaption;
            Caption = 'Agreemnet Amount, with VAT';

            trigger OnValidate()
            begin

                IF NOT VendorAgreement.GET("Vendor No.", "Agreement No.") OR (VendorAgreement."Agreement Date" = 0D) THEN
                    VendorAgreement."Agreement Date" := WORKDATE;
                IF "Currency Code" <> '' THEN
                    AmountLCY := Amount * (1 / CurrExchRate.ExchangeRate(VendorAgreement."Agreement Date", "Currency Code"))
                ELSE
                    AmountLCY := Amount;


            end;
        }
        field(7; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';

            trigger OnValidate()
            begin
                //SWC026 AP 150814 >>
                IF VendorAgreement.GET("Vendor No.", "Agreement No.") THEN
                    "Currency Code" := VendorAgreement."Currency Code";
                //SWC026 AP 150814 <<
            end;
        }
        field(11; "Agreement Description"; Text[250])
        {
            Caption = 'Description';
        }
        field(12; "External Agreement No."; Text[30])
        {
            CalcFormula = Lookup("Vendor Agreement"."External Agreement No." WHERE("Vendor No." = FIELD("Vendor No."),
                                                                                    "No." = FIELD("Agreement No.")));
            Caption = 'External Agreement No.';
            FieldClass = FlowField;
        }
        field(13; "Agreement Date"; Date)
        {
            Caption = 'Agreement Date';
        }
        field(70001; "Agreement Amount"; Decimal)
        {
            Caption = 'Agreement Amount';
        }
        field(70005; "Vendor Name"; Text[250])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Vendor No.")));
            Caption = 'Vendor Name';
            FieldClass = FlowField;
        }
        field(70008; "VAT Amount"; Decimal)
        {
            Caption = 'Agreement VAT Amount';

        }
        field(70009; "Amount Without VAT"; Decimal)
        {
            Caption = 'Agreement Amount without VAT';

        }
        field(70010; "Building Turn All"; Code[20])
        {
            Caption = 'Stage';
            // TableRelation = "Building turn";


            trigger OnValidate()
            var
            // ProjectsLineDimension: Record "70074";
            // Buildingturn: Record "70051";
            begin
                // IF Buildingturn.GET("Building Turn All") THEN
                // BEGIN
                //   "Project Code":=Buildingturn."Building project Code";
                //   VALIDATE("Global Dimension 1 Code",Buildingturn."Turn Dimension Code");
                //   grProjectsStructureLines1.SETRANGE("Project Code","Project Code");
                //   grProjectsStructureLines1.SETRANGE("Structure Post Type",grProjectsStructureLines1."Structure Post Type"::Posting);
                //   grProjectsStructureLines1.SETFILTER(Code,'%1&<>%2',"Cost Code",'');
                //   IF grProjectsStructureLines1.FINDFIRST THEN
                //   BEGIN
                //     ProjectsLineDimension.SETRANGE("Project No.","Project Code");
                //     ProjectsLineDimension.SETRANGE("Project Line No.",grProjectsStructureLines1."Line No.");
                //     ProjectsLineDimension.SETRANGE("Detailed Line No.",0);
                //     ProjectsLineDimension.SETRANGE("Dimension Code",'CC');
                //     IF ProjectsLineDimension.FINDFIRST THEN
                //     VALIDATE("Global Dimension 2 Code",ProjectsLineDimension."Dimension Value Code");
                //     "Project Line No.":=grProjectsStructureLines1."Line No.";
                //   END;
                // END;
            end;
        }
        field(70011; "Cost Code"; Code[20])
        {
            Caption = 'Budget Item';


            trigger OnLookup()
            var
            // ProjectsLineDimension: Record "70074";
            begin
                // grProjectsStructureLines1.RESET;
                // grProjectsStructureLines1.SETRANGE("Project Code","Project Code");
                // //grProjectsStructureLines1.SETRANGE("Structure Post Type",grProjectsStructureLines1."Structure Post Type"::Posting);
                // IF grProjectsStructureLines1.FINDFIRST THEN
                // BEGIN
                //   IF FORM.RUNMODAL(FORM::"Projects Article List",grProjectsStructureLines1) = ACTION::LookupOK THEN
                //   BEGIN
                //     "Cost Code":=grProjectsStructureLines1.Code;
                //     ProjectsLineDimension.SETRANGE("Project No.","Project Code");
                //     ProjectsLineDimension.SETRANGE("Project Line No.",grProjectsStructureLines1."Line No.");
                //     ProjectsLineDimension.SETRANGE("Detailed Line No.",0);
                //     ProjectsLineDimension.SETRANGE("Dimension Code",'CC');
                //     IF ProjectsLineDimension.FINDFIRST THEN
                //     VALIDATE("Global Dimension 2 Code",ProjectsLineDimension."Dimension Value Code");

                //     "Project Line No.":=grProjectsStructureLines1."Line No.";
                //      Description:=grProjectsStructureLines1.Description;
                //   END;
                // END;
            end;

            trigger OnValidate()
            var
            // ProjectsLineDimension: Record "70074";
            // Buildingturn: Record "70051";
            begin
                // IF "Project Code" = '' THEN ERROR(TEXT0001);
                // grProjectsStructureLines1.RESET;
                // grProjectsStructureLines1.SETRANGE("Project Code","Project Code");
                // grProjectsStructureLines1.SETRANGE(Code,"Cost Code");
                // IF grProjectsStructureLines1.FINDFIRST THEN
                // BEGIN
                //     ProjectsLineDimension.SETRANGE("Project No.","Project Code");
                //     ProjectsLineDimension.SETRANGE("Project Line No.",grProjectsStructureLines1."Line No.");
                //     ProjectsLineDimension.SETRANGE("Detailed Line No.",0);
                //     ProjectsLineDimension.SETRANGE("Dimension Code",'CC');
                //     IF ProjectsLineDimension.FINDFIRST THEN
                //     VALIDATE("Global Dimension 2 Code",ProjectsLineDimension."Dimension Value Code");

                //     "Project Line No.":=grProjectsStructureLines1."Line No.";
                //      Description:=grProjectsStructureLines1.Description;
                // END
                // ELSE
                // BEGIN
                //   ERROR(TEXT0002,"Project Code","Cost Code");

                // END;
            end;
        }
        field(70012; "Project Code"; Code[20])
        {
            // TableRelation = "Building project";

        }

        field(70015; "Project Line No."; Integer)
        {
            Caption = 'Project Line No.';

        }
        field(70016; "Cost Type"; Code[20])
        {
            Caption = 'Cost Type';

            trigger OnLookup()
            var
                GLS: Record "General Ledger Setup";
                DimensionValue: Record "Dimension Value";
            begin
                GLS.GET;
                // DimensionValue.SETRANGE("Dimension Code",GLS."Cost Type Dimension Code");
                // IF DimensionValue.FINDFIRST THEN
                // BEGIN
                //   IF DimensionValue.GET(GLS."Cost Type Dimension Code","Cost Type") THEN;

                //   IF PAGE.RUNMODAL(PAGE::"Dimension Value List",DimensionValue) = ACTION::LookupOK THEN
                //   BEGIN
                //     "Cost Type" := DimensionValue.Code;
                //   END;
                // END;
            end;
        }
        field(70017; "Original Amount"; Decimal)
        {

        }
        field(70019; ByOrder; Boolean)
        {
            Caption = 'By Order';
        }
        field(70034; "Close Commitment"; Boolean)
        {

        }
        field(70035; "Close Ordered"; Boolean)
        {

        }
        field(70036; AmountLCY; Decimal)
        {
            Caption = 'Agreement Amount with VAT (LCY)';

        }
        field(70037; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';

        }
        field(70050; "Payed by Agreement"; Decimal)
        {
            CalcFormula = sum("Projects Budget Entry"."Without VAT" where("Agreement No." = field("Agreement No."),
                                                                           "Project Code" = field("Project Code"),
                                                                           "Shortcut Dimension 1 Code" = field("Global Dimension 1 Code"),
                                                                           "Shortcut Dimension 2 Code" = field("Global Dimension 2 Code"),
                                                                           Close = const(true)));
            Caption = 'Payed by Agreement with VAT';
            Editable = false;
            FieldClass = FlowField;

        }
    }

    keys
    {
        key(Key1; "Vendor No.", "Agreement No.", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        GeneralLedgerSetup: Record "general ledger setup";
        DimensionValue: Record "Dimension Value";
        // grProjectsStructureLines1: Record "70073";
        // gvBuildingTurn: Record "70051";
        CI: Record "Company Information";
        VendorAgreement: Record "Vendor Agreement";
        CurrencyDate: Date;
        CurrencyFactor: Decimal;
        CurrExchRate: Record "Currency Exchange Rate";
        CurrencyCode: Code[10];
        // BuildingProject: Record "70050";
        SkipChekEmptyAmount: Boolean;
        TEXT0001: Label 'It is necessary to determine the construction object';
        TEXT0002: Label 'No article% 2 found for construction object% 1';
        Text50000: Label 'For the project% 1 with the Production type, the fields Amount with VAT and Amount without VAT, etc. both are filled, or both are 0!';
        Text50001: Label 'Amount with VAT and Amount without VAT must not be equal to 0 for CostPlace% 1!';

    trigger OnInsert()
    begin
        // SkipChekEmptyAmount := TRUE; //SWC880 KAE 100816
        // IF "Line No." = 0 THEN
        //   "Line No." := GetNextEntryNo;

        // IF BuildingProject.GET("Project Code") THEN      //SWC318 AKA 081014
        //   IF NOT BuildingProject."Without Details" THEN  //SWC318 AKA 081014
        //     TESTFIELD("Building Turn All");              //SWC0078 AKA 240414

        // //SWC026 AP 150814 >>
        // IF VendorAgreement.GET("Vendor No.","Agreement No.") THEN
        //     "Currency Code":=VendorAgreement."Currency Code";
        // //SWC026 AP 150814 <<
        // VALIDATE(Amount); //SWC862 KAE 140716
        // //SWC880 KAE 100816 >>
        // //SkipChekEmptyAmount := FALSE;
        // //MODIFY(TRUE); //чтоб проверки прошли
        // //SWC880 KAE 100816 <<
    end;

    trigger OnModify()
    begin
        // //SWC630 AKA 160915 >>
        // IF BuildingProject.GET("Project Code") THEN
        //   IF BuildingProject."Development/Production" = BuildingProject."Development/Production"::Production THEN
        //   BEGIN
        //     IF NOT SkipChekEmptyAmount THEN //SWC880 KAE 100816
        //       //SWC880 KAE 030816 >>
        //       IF VendorAgreement.GET("Vendor No.", "Agreement No.") THEN
        //         IF (NOT VendorAgreement.WithOut) AND
        //                (VendorAgreement."Agreement Group" = 'РАМОЧНЫЙ') THEN
        //       //SWC880 KAE 030816 <<
        //           IF ((Amount <> 0) AND ("Amount Without VAT" = 0)) OR ((Amount = 0) AND ("Amount Without VAT" <> 0)) THEN
        //             ERROR(Text50000, "Project Code");
        //   END;


        // //SWC882 DP 090816 >>
        // /*
        // IF NOT SkipChekEmptyAmount THEN //SWC880 KAE 100816
        //   IF COPYSTR("Global Dimension 1 Code", 10, 1) = 'P' THEN
        //     IF (Amount = 0) OR ("Amount Without VAT" = 0) THEN
        //       ERROR(Text50001, "Global Dimension 1 Code");
        //   */
        // //SWC882 DP 090816 <<
        // //SWC630 AKA 160915 <<

        // VALIDATE(Amount); //SWC862 KAE 140716
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure CalcGActuals(SortInit: Boolean; ProjectCode: Code[50]; LineNo: Integer; AgrNo: Code[50]; Dim1: Code[50]; Dim2: Code[50]; CostType: Code[50]; AnType: Boolean) gActuals: Decimal
    var
        ProjectsCostControlEntry: Record "Projects Cost Control Entry";
    begin
        gActuals := 0;

        if not SortInit then
            InitCostControlEntrySort(SortInit);

        ProjectsCostControlEntry.SetCurrentKey("Project Code", "Line No.", "Agreement No.", "Analysis Type", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Cost Type");
        ProjectsCostControlEntry.SetRange("Project Code", ProjectCode);
        ProjectsCostControlEntry.SetRange("Line No.", LineNo);
        ProjectsCostControlEntry.SetRange("Agreement No.", AgrNo);

        if AnType then begin
            ProjectsCostControlEntry."Analysis Type" := ProjectsCostControlEntry."Analysis Type"::Actuals;
            ProjectsCostControlEntry.SetCurrentKey("Analysis Type", ProjectsCostControlEntry."Analysis Type");
        end;

        ProjectsCostControlEntry.SetRange("Shortcut Dimension 1 Code", Dim1);
        ProjectsCostControlEntry.SetRange("Shortcut Dimension 1 Code", Dim2);
        ProjectsCostControlEntry.SetRange("Cost Type", CostType);

        if not ProjectsCostControlEntry.IsEmpty then begin
            ProjectsCostControlEntry.FindSet();
            repeat
                gActuals += ProjectsCostControlEntry."Amount Including VAT 2";
            until ProjectsCostControlEntry.Next() = 0;
        end;
    end;

    local procedure InitCostControlEntrySort(SortInit: Boolean)
    var
        ProjectsCostControlEntry: Record "Projects Cost Control Entry";
    begin
        SortInit := true;
        ProjectsCostControlEntry.Reset();
        ProjectsCostControlEntry.SetCurrentKey("Project Code", "Line No.", "Agreement No.", "Analysis Type", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Cost Type");
    end;

    procedure CalcPostedInvoice2(VendorNo: Code[20]; AgrNo: Code[20]; GlobDim1: Code[20]; GlobDim2: Code[20]; CostType: Code[20]) PostedInvoiceAmount: Decimal
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
    begin
        PurchInvHeader.SetRange("Pay-to Vendor No.", VendorNo);
        PurchInvHeader.SetRange("Agreement No.", AgrNo);
        if PurchInvHeader.FindSet() then begin
            repeat
                PurchInvLine.SetCurrentKey("Document No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Cost Type");
                PurchInvLine.SetRange("Document No.", PurchInvHeader."No.");
                PurchInvLine.SetRange("Shortcut Dimension 1 Code", GlobDim1);
                PurchInvLine.SetRange("Shortcut Dimension 2 Code", GlobDim2);
                PurchInvLine.SetRange("Cost Type", CostType);
                PurchInvLine.CalcSums(Amount);
            until PurchInvHeader.Next() = 0;
        end;

        PurchCrMemoHdr.SetRange("Pay-to Vendor No.", VendorNo);
        PurchCrMemoHdr.SetRange("Agreement No.", AgrNo);
        if PurchCrMemoHdr.FindSet() then begin
            repeat
                PurchCrMemoLine.SetCurrentKey("Document No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Cost Type");
                PurchCrMemoLine.SetRange("Document No.", PurchCrMemoHdr."No.");
                PurchCrMemoLine.SetRange("Shortcut Dimension 1 Code", GlobDim1);
                PurchCrMemoLine.SetRange("Shortcut Dimension 2 Code", GlobDim2);
                PurchCrMemoLine.SetRange("Cost Type", CostType);
                PurchCrMemoLine.CalcSums(Amount);
                PostedInvoiceAmount += PurchCrMemoLine.Amount;
            until PurchCrMemoHdr.Next() = 0;
        end;
    end;

    procedure GetCommited(pAgreement: Code[20]; pCP: Code[20]; pCC: Code[20]) ReturnValue: Decimal
    var
        lrProjectsBudgetEntry: Record "Projects Budget Entry";
    begin
        lrProjectsBudgetEntry.SetCurrentKey("Work Version", "Agreement No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        lrProjectsBudgetEntry.SetRange("Work Version", true);
        lrProjectsBudgetEntry.SetRange("Agreement No.", pAgreement);
        if pCP <> '' then
            lrProjectsBudgetEntry.SetRange("Shortcut Dimension 1 Code", pCP);
        if pCC <> '' then
            lrProjectsBudgetEntry.SetRange("Shortcut Dimension 2 Code", pCC);
        lrProjectsBudgetEntry.CalcSums("Without VAT");
        ReturnValue += lrProjectsBudgetEntry."Without VAT";
    end;

    procedure GetPlaneAmount(Lookup: Boolean) Amt: Decimal
    var
        PL: Record "Purchase Line";
        PH: Record "Purchase Header";
        // PHA: Record "70141";
        PLt: Record "Purchase Line" temporary;
        // gcduERPC: Codeunit "70000";
        Buff: Record "Inventory Buffer" temporary;
    begin
        // SWC1000 DD 12.02.17 >>
        // PL.SETCURRENTKEY("Buy-from Vendor No.","Agreement No.");
        // PL.SETRANGE("Buy-from Vendor No.","Vendor No.");
        // PL.SETRANGE("Agreement No.","Agreement No.");
        // PL.SETRANGE("Shortcut Dimension 1 Code","Global Dimension 1 Code");
        // PL.SETRANGE("Shortcut Dimension 2 Code","Global Dimension 2 Code");
        // PL.SETRANGE("Cost Type","Cost Type");
        // //PL.SETFILTER("Status App",'%1|%2|%3',PL."Status App"::Checker,PL."Status App"::Approve,PL."Status App"::Payment);
        // PL.SETRANGE(Paid,FALSE);
        // PL.SETRANGE(Pay,FALSE);
        // PL.SETRANGE(IW,FALSE);
        // IF PL.FINDSET THEN
        // REPEAT
        //   IF PHA.GetStatusAppAct(PL."Document Type", PL."Document No.") IN [PHA."Status App Act"::Checker,
        //   //PHA."Status App Act"::Accountant,
        //     PHA."Status App Act"::Approve,PHA."Status App Act"::Signing] THEN
        //   IF PH.GET(PL."Document Type",PL."Document No.") AND NOT PH."Problem Document" THEN BEGIN
        //     IF Lookup THEN BEGIN
        //       PLt := PL;
        //       PLt.INSERT;
        //     END ELSE
        //       //IF PL."Amount Including VAT" = 0 THEN
        //       //  Amt += PL."Outstanding Amount (LCY)"+PL."VAT Difference"
        //       //ELSE
        //       //  Amt += PL."Amount Including VAT"+PL."VAT Difference";

        //       //IF NOT Buff.GET(PL."Shortcut Dimension 1 Code",PL."Shortcut Dimension 2 Code") THEN BEGIN
        //       //  Buff."Item No." := PL."Shortcut Dimension 1 Code";
        //       //  Buff."Variant Code" := PL."Shortcut Dimension 2 Code";
        //       //  Buff.INSERT;
        //         Amt+=gcduERPC.GetLinesDocumentsAmount(PL);
        //       //END;
        //   END;
        // UNTIL PL.NEXT = 0;

        // IF Lookup THEN
        //   Page.RUNMODAL(0,PLt);
        // // SWC1000 DD 12.02.17 <<
    end;


    procedure GetRemainAmt(): Decimal
    var
        VAD: Record "Vendor Agreement Details";
    begin
        // SWC1000 DD 12.02.17 >>
        VAD.SETCURRENTKEY("Agreement No.", "Vendor No.", "Global Dimension 1 Code");
        VAD.SETRANGE("Vendor No.", "Vendor No.");
        VAD.SETRANGE("Agreement No.", "Agreement No.");
        VAD.SETRANGE("Global Dimension 1 Code", "Global Dimension 1 Code");
        VAD.SETRANGE("Global Dimension 2 Code", "Global Dimension 2 Code");
        VAD.SETRANGE("Cost Type", "Cost Type");
        IF VAD.ISEMPTY THEN
            VAD.SETRANGE("Cost Type");
        VAD.CALCSUMS(AmountLCY);
        EXIT(VAD.AmountLCY - CalcInvoice(TRUE) - CalcPostedInvoice(TRUE) - GetPlaneAmount(FALSE));
        // SWC1000 DD 12.02.17 <<
    end;


    procedure CalcPostedInvoice(WithVAT: Boolean) Ret: Decimal
    var
        PIH: Record "Purch. Inv. Header";
        PIL: Record "Purch. Inv. Line";
        PIHC: Record "Purch. Cr. Memo Hdr.";
        PILC: Record "Purch. Cr. Memo Line";
    begin
        PIH.SETRANGE("Pay-to Vendor No.", "Vendor No.");
        PIH.SETRANGE("Agreement No.", "Agreement No.");
        IF PIH.FINDSET THEN BEGIN
            REPEAT
                PIL.SETCURRENTKEY("Document No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Cost Type");
                PIL.SETRANGE("Document No.", PIH."No.");
                PIL.SETRANGE("Shortcut Dimension 1 Code", "Global Dimension 1 Code");
                PIL.SETRANGE("Shortcut Dimension 2 Code", "Global Dimension 2 Code");
                PIL.SETRANGE("Cost Type", "Cost Type");
                // SWC1000 DD 21.02.17 >>
                IF WithVAT THEN BEGIN
                    PIL.CALCSUMS("Amount Including VAT");
                    Ret += PIL."Amount Including VAT";
                END ELSE BEGIN
                    // SWC1000 DD 21.02.17 <<
                    PIL.CALCSUMS(Amount);
                    Ret += PIL.Amount;
                END;
            UNTIL PIH.NEXT = 0;
        END;

        PIHC.SETRANGE("Pay-to Vendor No.", "Vendor No.");
        PIHC.SETRANGE("Agreement No.", "Agreement No.");
        IF PIHC.FINDSET THEN BEGIN
            REPEAT
                PILC.SETCURRENTKEY("Document No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Cost Type");
                PILC.SETRANGE("Document No.", PIHC."No.");
                PILC.SETRANGE("Shortcut Dimension 1 Code", "Global Dimension 1 Code");
                PILC.SETRANGE("Shortcut Dimension 2 Code", "Global Dimension 2 Code");
                PILC.SETRANGE("Cost Type", "Cost Type");
                // SWC1000 DD 21.02.17 >>
                IF WithVAT THEN BEGIN
                    PILC.CALCSUMS("Amount Including VAT");
                    Ret -= PILC."Amount Including VAT";
                END ELSE BEGIN
                    // SWC1000 DD 21.02.17 <<
                    PILC.CALCSUMS(Amount);
                    Ret -= PILC.Amount;
                END;
            UNTIL PIHC.NEXT = 0;
        END;
    end;


    procedure CalcInvoice(WithVAT: Boolean) Ret: Decimal
    var
        PH: Record "Purchase Header";
        PL: Record "Purchase Line";
    // gcduERPC: Codeunit "70000";
    begin
        // SWC DD 25.05.17 >>
        // PH.SETRANGE("Document Type",PH."Document Type"::Invoice);
        // PH.SETRANGE("Pay-to Vendor No.","Vendor No.");
        // PH.SETRANGE("Agreement No.","Agreement No.");
        // IF PH.FINDSET THEN
        // BEGIN
        //   REPEAT
        //     PL.SETCURRENTKEY("Document No.","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code","Cost Type");
        //     PL.SETRANGE("Document No.",PH."No.");
        //     PL.SETRANGE("Document Type",PH."Document Type");
        //     PL.SETRANGE("Shortcut Dimension 1 Code","Global Dimension 1 Code");
        //     PL.SETRANGE("Shortcut Dimension 2 Code","Global Dimension 2 Code");
        //     PL.SETRANGE("Cost Type","Cost Type");
        //     IF WithVAT THEN BEGIN
        //       IF PL.FINDSET THEN
        //       REPEAT
        //         Ret+=gcduERPC.GetLinesDocumentsAmount(PL);
        //       UNTIL PL.NEXT = 0;
        //     END ELSE BEGIN
        //       PL.CALCSUMS(Amount);
        //       Ret+=PL.Amount;
        //     END;
        //   UNTIL PH.NEXT=0;
        // END;
        // SWC DD 25.05.17 <<
    end;


    procedure ShowPostedInvoice()
    var
        PIH: Record "Purch. Inv. Header";
        PIL: Record "Purch. Inv. Line";
        PIHC: Record "Purch. Cr. Memo Hdr.";
        PILC: Record "Purch. Cr. Memo Line";
    // InvoiceDetail: Record "70132" temporary;
    begin
        // PIH.SETRANGE("Pay-to Vendor No.","Vendor No.");
        // PIH.SETRANGE("Agreement No.","Agreement No.");
        // IF PIH.FINDSET THEN
        // BEGIN
        //   REPEAT
        //     PIL.SETRANGE("Document No.",PIH."No.");
        //     PIL.SETRANGE("Shortcut Dimension 1 Code","Global Dimension 1 Code");
        //     PIL.SETRANGE("Shortcut Dimension 2 Code","Global Dimension 2 Code");
        //     PIL.SETRANGE("Cost Type","Cost Type");
        //     IF PIL.FINDSET THEN
        //     BEGIN
        //       REPEAT
        //         InvoiceDetail."Document Type":=0;
        //         InvoiceDetail."Document No.":=PIL."Document No.";
        //         InvoiceDetail."Line No.":=PIL."Line No.";
        //         InvoiceDetail.Description:=PIL.Description;
        //         InvoiceDetail.Amount:=PIL.Amount;
        //         // SWC1000 DD 21.02.17 >>
        //         InvoiceDetail."Amount with VAT" := PIL."Amount Including VAT";
        //         // SWC1000 DD 21.02.17 <<

        //         //NC 33707 HR beg
        //         InvoiceDetail."Document Date" := PIH."Document Date";
        //         //NC 33707 HR end
        //         InvoiceDetail.INSERT;
        //       UNTIL PIL.NEXT=0;
        //     END;
        //   UNTIL PIH.NEXT=0;
        // END;

        // PIHC.SETRANGE("Pay-to Vendor No.","Vendor No.");
        // PIHC.SETRANGE("Agreement No.","Agreement No.");
        // IF PIHC.FINDSET THEN
        // BEGIN
        //   REPEAT
        //     PILC.SETRANGE("Document No.",PIHC."No.");
        //     PILC.SETRANGE("Shortcut Dimension 1 Code","Global Dimension 1 Code");
        //     PILC.SETRANGE("Shortcut Dimension 2 Code","Global Dimension 2 Code");
        //     PILC.SETRANGE("Cost Type","Cost Type");
        //     IF PILC.FINDSET THEN
        //     BEGIN
        //       REPEAT
        //         InvoiceDetail."Document Type":=1;
        //         InvoiceDetail."Document No.":=PILC."Document No.";
        //         InvoiceDetail."Line No.":=PILC."Line No.";
        //         InvoiceDetail.Description:=PILC.Description;
        //         InvoiceDetail.Amount:=-PILC.Amount;
        //         // SWC1000 DD 21.02.17 >>
        //         InvoiceDetail."Amount with VAT" := -PILC."Amount Including VAT";
        //         // SWC1000 DD 21.02.17 <<

        //         //NC 33707 HR beg
        //         InvoiceDetail."Document Date" := PIHC."Document Date";
        //         //NC 33707 HR end

        //         InvoiceDetail.INSERT;
        //       UNTIL PILC.NEXT=0;
        //     END;
        //   UNTIL PIHC.NEXT=0;
        // END;
        // Page.RUN(70243,InvoiceDetail);
    end;


    procedure GetRemainAmt2(): Decimal
    var
        VAD: Record "Vendor Agreement Details";
    begin
        // SWC1000 DD 12.02.17 >>
        VAD.SETCURRENTKEY("Agreement No.", "Vendor No.", "Global Dimension 1 Code");
        VAD.SETRANGE("Vendor No.", "Vendor No.");
        VAD.SETRANGE("Agreement No.", "Agreement No.");
        VAD.SETRANGE("Global Dimension 1 Code", "Global Dimension 1 Code");
        VAD.SETRANGE("Global Dimension 2 Code", "Global Dimension 2 Code");
        VAD.SETRANGE("Cost Type", "Cost Type");
        VAD.CALCSUMS(AmountLCY);
        MESSAGE('%1 = Сумма 70094: %2, Счета: %3, Учт. Счета: %4, На Утверждении: %5',
        VAD.AmountLCY - CalcInvoice(TRUE) - CalcPostedInvoice(TRUE) - GetPlaneAmount(FALSE),
        VAD.AmountLCY, -CalcInvoice(TRUE), -CalcPostedInvoice(TRUE), -GetPlaneAmount(FALSE));
        // SWC1000 DD 12.02.17 <<
    end;

    procedure ShowInvoice()
    var
        PH: Record "Purchase Header";
        PL: Record "Purchase Line";
    // gcduERPC: Codeunit "70000";
    begin
        // SWC DD 03.11.17 >>
        // PH.SETRANGE("Document Type",PH."Document Type"::Invoice);
        // PH.SETRANGE("Pay-to Vendor No.","Vendor No.");
        // PH.SETRANGE("Agreement No.","Agreement No.");
        // IF PH.FINDSET THEN
        // BEGIN
        //   REPEAT
        //     PL.SETCURRENTKEY("Document No.","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code","Cost Type");
        //     PL.SETRANGE("Document No.",PH."No.");
        //     PL.SETRANGE("Document Type",PH."Document Type");
        //     PL.SETRANGE("Shortcut Dimension 1 Code","Global Dimension 1 Code");
        //     PL.SETRANGE("Shortcut Dimension 2 Code","Global Dimension 2 Code");
        //     PL.SETRANGE("Cost Type","Cost Type");
        //     IF PL.FINDSET THEN
        //       PH.MARK(TRUE);
        //   UNTIL PH.NEXT=0;
        // END;
        // PH.MARKEDONLY(TRUE);
        // Page.RUNMODAL(0,PH);
        // SWC DD 03.11.17 <<
    end;
}