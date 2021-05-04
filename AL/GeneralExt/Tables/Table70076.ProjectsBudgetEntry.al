table 70076 "Projects Budget Entry"
{
    Caption = 'Projects Budget Entry';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(2; "Project Code"; Code[20])
        {
            Caption = 'Project Code';
            TableRelation = "Building project";
        }
        field(3; "Analysis Type"; Option)
        {
            Caption = 'Analysis Type';
            OptionCaption = 'Investment Calculation,Detailed Planning,Estimate Calculation';
            OptionMembers = "Investment Calculation","Detailed Planning","Estimate Calculation";
        }
        field(4; "Version Code"; Code[20])
        {
            Caption = 'Version Code';
        }
        field(5; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(6; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'OwnWorks,Subcontract,Materials,Income';
            OptionMembers = OwnWorks,Subcontract,Materials,Income;
        }
        field(7; Description; Text[250])
        {
            Caption = 'Description';
            NotBlank = true;
        }
        field(8; "Description 2"; Text[250])
        {
            Caption = 'Description 2';
        }
        field(9; "Amount"; Decimal)
        {
            Caption = 'Amount';
        }
        field(10; Curency; Code[20])
        {
            Caption = 'Currency';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                // IF Curency <> '' THEN
                //     UpdateCurrencyFactor
                // ELSE BEGIN
                //     "Currency Factor" := 0;
                //     "Currency Rate" := 0; //SWC390 SM 221214
                // END;
                // ExchangeFCYtoLCY;
                // // NCS-026 AP 110314 <<
            end;
        }
        field(11; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
        }
        field(13; Date; Date)
        {
            Caption = 'Date';

            trigger OnValidate()
            begin
                // //NC 27251 HR beg
                // //CheckUniqMonthCFLine;
                // //NC 27251 HR end

                // // NCS-026 AP 110314 >>
                // IF Curency <> '' THEN
                //     UpdateCurrencyFactor
                // ELSE
                //     "Currency Factor" := 0;
                // ExchangeFCYtoLCY;
                // // NCS-026 AP 110314 <<
            end;
        }
        field(14; "Transaction Type"; Code[20])
        {
            Caption = 'Transaction Type';
            InitValue = 'OUT PURCH';
            // TableRelation = "Cash Flow Transaction Type";
        }
        field(23; "Parent Entry"; Integer)
        {
            Caption = 'Parent Entry';
        }
        field(24; "Project Turn Code"; Code[20])
        {
            Caption = 'Project Turn Code';
            //TableRelation = "Building turn";
        }
        field(31; "Contragent No."; Code[20])
        {
            Caption = 'Contragent No.';
            TableRelation = if ("Contragent Type" = const(Vendor)) Vendor else
            if ("Contragent Type" = const(Customer)) Customer;
        }
        field(32; "Agreement No."; Code[20])
        {
            Caption = 'Agreement No.';
            TableRelation = if ("Contragent Type" = const(Vendor)) "Vendor Agreement"."No." where("Vendor No." = field("Contragent No."), Active = const(true)) else
            if ("Contragent Type" = const(Customer)) "Customer Agreement"."No." where("Customer No." = field("Contragent No."));
        }
        field(34; "Without VAT"; Decimal)
        {
            Caption = 'Amount Incl. VAT';
            NotBlank = true;

            trigger OnValidate()
            begin
                // // NCS-026 AP 110314 >>
                // Amount:="Without VAT";
                // ExchangeFCYtoLCY;
                // //"Amount (LCY)":="Without VAT"; // NCS-026 AP 110314 <<
                // IF "Currency Factor"<>0 THEN
                //   "Without VAT (LCY)":="Without VAT"*(1/"Currency Factor")
                // ELSE
                // "Without VAT (LCY)":="Without VAT"
                // // NCS-026 AP 110314 <<
            end;
        }
        field(35; "Including VAT"; Boolean)
        {
            Caption = 'Including VAT';
            Editable = false;
        }
        field(36; "Contragent Name"; Text[250])
        {
            Caption = 'Contragent Name';
            Description = 'NC 50085 PA';
        }
        field(37; "External Agreement No."; Text[30])
        {
            Caption = 'Contragent Name';
            Description = 'NC 50085 PA';
        }
        field(40; "Contragent Type"; Option)
        {
            Caption = 'Contragent Type';
            OptionMembers = "Vendor","Customer";
            OptionCaption = 'Vendor,Customer';
        }
        field(41; "Temp Line No."; Integer)
        {
            Caption = 'Temp Line No.';
        }
        field(44; Close; Boolean)
        {
            Caption = 'Close';

            // trigger OnValidate()
            // begin
            //     lrProjectsBudgetEntryLink.SETRANGE("Main Entry No.","Entry No.");
            //     lrProjectsBudgetEntryLink.SETRANGE("Project Code","Project Code");
            //     lrProjectsBudgetEntryLink.SETRANGE("Analysis Type","Analysis Type");
            //     lrProjectsBudgetEntryLink.SETRANGE("Version Code","Version Code");
            //     IF lrProjectsBudgetEntryLink.FINDFIRST THEN
            //     BEGIN
            //       REPEAT
            //         lrProjectsBudgetEntryLink.Close:=Close;
            //         lrProjectsBudgetEntryLink.MODIFY;
            //       UNTIL lrProjectsBudgetEntryLink.NEXT=0;
            //     END;
            // end;
        }
        field(45; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            // trigger OnValidate()
            // var
            //     ApprovalMgt: Codeunit "439";
            //     TemplateRec: Record "464";
            //     NextAppr: Code[20];
            // begin
            //     //NC 27251 HR beg
            //     //CheckUniqMonthCFLine;
            //     //NC 27251 HR end

            //     ValidateDimension1;
            // end;
        }
        field(46; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            // trigger OnValidate()
            // begin
            //     ValidateDimension2;
            // end;
        }
        field(47; "Building Turn"; Code[20])
        {
            Caption = 'Stage';
            NotBlank = true;
            // TableRelation = "Building turn";

            // trigger OnLookup()
            // begin
            //     IF ("Agreement No." <> '') AND ("Without VAT" <> 0) THEN EXIT;

            //     gvBuildingTurn.RESET;            
            //     IF "Project Code" <> '' THEN
            //         gvBuildingTurn.SETRANGE("Building project Code", "Project Code");

            //     IF gvBuildingTurn.FINDFIRST THEN BEGIN
            //         IF FORM.RUNMODAL(FORM::"Dev Building turn", gvBuildingTurn) = ACTION::LookupOK THEN BEGIN
            //             "Building Turn" := gvBuildingTurn.Code;
            //             VALIDATE("Shortcut Dimension 1 Code", gvBuildingTurn."Turn Dimension Code");
            //             "Building Turn All" := "Building Turn";
            //             "Project Turn Code" := "Building Turn";
            //             "Project Code" := gvBuildingTurn."Building project Code";
            //             IF "Version Code" = '' THEN
            //                 "Version Code" := GetDefVersion1("Project Code");
            //         END;
            //     END;
            // end;

            // trigger OnValidate()
            // begin
            //     "Building Turn All" := "Building Turn";
            //     "Project Turn Code" := "Building Turn";
            //     //NC 27251 HR beg
            //     //gvBuildingTurn.SETRANGE("Building project Code","Project Code");
            //     //gvBuildingTurn.SETRANGE(Code,"Building Turn");
            //     //IF gvBuildingTurn.FINDFIRST THEN
            //     //BEGIN
            //     //  VALIDATE("Shortcut Dimension 1 Code",gvBuildingTurn."Turn Dimension Code");
            //     //END;

            //     IF "Building Turn" = '' THEN BEGIN
            //         VALIDATE("Shortcut Dimension 1 Code", '');
            //         "Project Code" := '';
            //         "Version Code" := '';
            //     END ELSE BEGIN
            //         gvBuildingTurn.GET("Building Turn");
            //         VALIDATE("Shortcut Dimension 1 Code", gvBuildingTurn."Turn Dimension Code");
            //         "Project Code" := gvBuildingTurn."Building project Code";
            //         IF "Version Code" = '' THEN
            //             "Version Code" := GetDefVersion1("Project Code");
            //     END;
            //     //NC 27251 HR end
            // end;
        }
        field(48; "Cost Code"; Code[20])
        {
            Caption = 'Budget Item';
            NotBlank = true;

            // trigger OnLookup()
            // var
            //     ProjectsLineDimension: Record "70074";
            // begin
            //     //NC 29435 HR beg
            //     //IF ("Agreement No."<>'') AND ("Without VAT"<>0) THEN EXIT;
            //     IF ("Agreement No."<>'') AND ("Without VAT"<>0) AND (NOT IsProductionProject) THEN EXIT;
            //     //NC 29435 HR end

            //     grProjectsStructureLines1.SETRANGE("Project Code","Project Code");
            //     grProjectsStructureLines1.SETRANGE(Version,"Version Code");
            //     grProjectsStructureLines1.SETRANGE("Structure Post Type",grProjectsStructureLines1."Structure Post Type"::Posting);
            //     IF grProjectsStructureLines1.FINDFIRST THEN
            //     BEGIN
            //       IF "New Lines"=0 THEN
            //       BEGIN
            //         IF grProjectsStructureLines1.GET("Project Code","Analysis Type","Version Code","Line No.") THEN;
            //       END
            //       ELSE
            //         IF grProjectsStructureLines1.GET("Project Code","Analysis Type","Version Code","New Lines") THEN;

            //       IF FORM.RUNMODAL(FORM::"Projects Article List",grProjectsStructureLines1) = ACTION::LookupOK THEN
            //       BEGIN
            //         "Cost Code":=grProjectsStructureLines1.Code;
            //         ProjectsLineDimension.SETRANGE("Project No.","Project Code");
            //         ProjectsLineDimension.SETRANGE("Project Version No.","Version Code");
            //         ProjectsLineDimension.SETRANGE("Project Line No.",grProjectsStructureLines1."Line No.");
            //         ProjectsLineDimension.SETRANGE("Detailed Line No.",0);
            //         ProjectsLineDimension.SETRANGE("Dimension Code",'CC');
            //         IF ProjectsLineDimension.FINDFIRST THEN
            //         VALIDATE("Shortcut Dimension 2 Code",ProjectsLineDimension."Dimension Value Code");

            //         "New Lines":=grProjectsStructureLines1."Line No.";
            //         "Line No.":=grProjectsStructureLines1."Line No.";
            //         Code:=grProjectsStructureLines1.Code;
            //         Description:=grProjectsStructureLines1.Description;
            //       END;
            //     END;
            //     ChangeDate2;
            // end;

            // trigger OnValidate()
            // var
            //     ProjectsLineDimension: Record "70074";
            // begin
            //     grProjectsStructureLines1.SETRANGE("Project Code","Project Code");
            //     grProjectsStructureLines1.SETRANGE(Version,"Version Code");
            //     grProjectsStructureLines1.SETRANGE("Structure Post Type",grProjectsStructureLines1."Structure Post Type"::Posting);
            //     grProjectsStructureLines1.SETRANGE(Code,"Cost Code");
            //     //IF NOT grProjectsStructureLines1.FINDFIRST THEN
            //     //  ERROR(TEXT0006,"Cost Code");
            //     //ELSE BEGIN

            //     //NC 28666, 37278 HR 17-09-2019 beg
            //     //IF grProjectsStructureLines1.ISEMPTY THEN
            //     //  ERROR(TEXT0006, "Cost Code");
            //     //NC 28666, 37278 HR 17-09-2019 end

            //     IF grProjectsStructureLines1.FINDFIRST THEN BEGIN

            //       ProjectsLineDimension.SETRANGE("Project No.","Project Code");
            //       ProjectsLineDimension.SETRANGE("Project Version No.","Version Code");
            //       ProjectsLineDimension.SETRANGE("Project Line No.",grProjectsStructureLines1."Line No.");
            //       ProjectsLineDimension.SETRANGE("Detailed Line No.",0);
            //       ProjectsLineDimension.SETRANGE("Dimension Code",'CC');
            //       IF ProjectsLineDimension.FINDFIRST THEN
            //       VALIDATE("Shortcut Dimension 2 Code",ProjectsLineDimension."Dimension Value Code");
            //        "New Lines":=grProjectsStructureLines1."Line No.";
            //        "Line No.":=grProjectsStructureLines1."Line No.";
            //        Code:=grProjectsStructureLines1.Code;
            //        Description:=grProjectsStructureLines1.Description;
            //     END;
            // end;
        }
        field(50; "Not Run OnInsert"; Boolean)
        {
            Caption = 'Not Run OnInsert';
            Description = 'NC 50085 PA';
        }
        field(51; "Work Version"; Boolean)
        {
            Caption = 'Work Version';
            Description = 'NC 50085 PA';
        }
        field(52; Reserve; Boolean)
        {
            Caption = 'Reserve';
            Description = 'NC 50085 PA';

            trigger OnValidate()
            var
                myInt: Integer;
            begin
                lrProjectsBudgetEntryLink.SetRange("Main Entry No.", "Entry No.");
                lrProjectsBudgetEntryLink.SetRange("Project Code", "Project Code");
                lrProjectsBudgetEntryLink.SetRange("Analysis Type", "Analysis Type");
                lrProjectsBudgetEntryLink.SetRange("Version Code", "Version Code");
                if lrProjectsBudgetEntryLink.FindFirst() then begin
                    repeat
                        lrProjectsBudgetEntryLink.Reserv := Reserve;
                        lrProjectsBudgetEntryLink.Modify();
                    until lrProjectsBudgetEntryLink.Next() = 0;
                end;
            end;
        }
        field(53; "Building Turn All"; Code[20])
        {
            Caption = 'Building Turn All';
            Description = 'NC 50086 PA';
        }
        field(60; "Date Plan"; Date)
        {
            Caption = 'Date (Plan)';
        }
        field(61; "Payment Doc. No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Purchase Line"."Document No." where("Forecast Entry" = field("Entry No.")));
            Caption = 'Pay Request No.';
        }
        field(62; "Write Off Amount"; Decimal)
        {
            Caption = 'Write Off Amount';
            Description = 'NC 50085 PA';

            trigger OnValidate()
            var
                PBE: Record "Projects Budget Entry";
            begin
                WriteOffAmount := "Write Off Amount";

                if (AgrNo <> '') and ("Write Off Amount" > 0) then begin
                    PBE.SetCurrentKey("Work Version", "Agreement No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
                    PBE.SetFilter("Contragent No.", '%1|%2', "Contragent No.", '');
                    PBE.SetRange("Agreement No.", '');
                    PBE.SetRange("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
                    PBE.SetRange("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
                    PBE.SetRange(Close, FALSE);
                    PBE.SETRANGE(Reserve, FALSE);
                    PBE.SETFILTER("Without VAT", '<>%1', 0);
                    PBE.SETFILTER("Write Off Amount", '<>0');
                    PBE.SETFILTER("Entry No.", '<>%1', "Entry No.");
                    IF PBE.FINDSET THEN
                        REPEAT
                            WriteOffAmount += PBE."Write Off Amount";
                        UNTIL PBE.NEXT = 0;
                    CheckCF(VendNo, AgrNo, WriteOffAmount);
                END;
            end;
        }
        field(63; NotVisible; Boolean)
        {
            Caption = 'Not Visible';
            Description = 'NC 50085 PA';
        }
        field(71; "Without VAT (LCY)"; Decimal)
        {
            Caption = 'Without VAT (LCY)';
        }
        field(70001; "Problem Pmt. Document"; Boolean)
        {
            Description = 'NC 51373 AB';
            Editable = false;
            Caption = 'Problem Pmt. Document';

        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Date; Date)
        {
            Enabled = true;
            MaintainSqlIndex = true;
            MaintainSiftIndex = true;
        }
    }
    var
        gvCreateRepeat: Boolean;
        WriteOffAmount: Decimal;
        AgrNo: Code[20];
        VendNo: Code[20];
        lrProjectsBudgetEntryLink: Record "Projects Budget Entry Link";
        Text50000: Label 'The amount cannot be more than indicated in the "% 1" agreement card in the breakdown by letter!';


    procedure SetCreateRepeat(lvCreateRepeat: Boolean)
    begin
        gvCreateRepeat := lvCreateRepeat;
    end;

    procedure GetInvoiceNo() InvoiceNo: Code[20]
    var
        PurchaseLine: Record "Purchase Line";
        PurchaseHeader: Record "Purchase Header";
    begin
        if Close then begin
            PurchaseLine.SetCurrentKey("Forecast Entry");
            PurchaseLine.SetRange("Forecast Entry", "Entry No.");
            if PurchaseLine.FindFirst() then begin
                PurchaseHeader.SetRange("Document Type", PurchaseLine."Document Type");
                PurchaseHeader.SetRange("No.", PurchaseLine."Document No.");
                if PurchaseHeader.FindFirst() then begin
                    InvoiceNo := PurchaseHeader."No.";
                end;
            end;
        end;
        if InvoiceNo = '' then begin
            CalcFields("Payment Doc. No.");
            InvoiceNo := "Payment Doc. No.";
        end;
    end;

    procedure GetInvoiceDate() InvoiceDate: Date
    var
        PurchaseLine: Record "Purchase Line";
        PurchaseHeader: Record "Purchase Header";
    begin
        if Close then begin
            PurchaseLine.SetCurrentKey("Forecast Entry");
            PurchaseLine.SetRange("Forecast Entry", "Entry No.");
            if PurchaseLine.FindFirst() then begin
                PurchaseHeader.SetRange("Document Type", PurchaseLine."Document Type");
                PurchaseHeader.SetRange("No.", PurchaseLine."Document No.");
                if PurchaseHeader.FindFirst() then begin
                    InvoiceDate := PurchaseHeader."Paid Date Fact";
                end;
            end;
        end;
    end;

    procedure CheckCF(VendNo: Code[20]; AgrNo: Code[20]; CheckAmt: Decimal)
    var
        VAD: Record "Vendor Agreement Details";
        PBE: Record "Projects Budget Entry";
        Amt: Decimal;
        VendAgr: Record "Vendor Agreement";
        GLSetup: Record "General Ledger Setup";
    begin
        if not "Not Run OnInsert" then
            if VendAgr.Get(VendNo, AgrNo) and not VendAgr.WithOut and not VendAgr."Don't Check CashFlow" then begin
                VAD.SetCurrentKey("Vendor No.", "Agreement No.", "Global Dimension 1 Code");
                VAD.SetRange("Vendor No.", VendNo);
                VAD.SetRange("Agreement No.", AgrNo);
                VAD.SetRange("Global Dimension 1 Code", "Shortcut Dimension 1 Code");
                VAD.CalcSums(AmountLCY);
                Amt := VAD.AmountLCY;

                PBE.SetCurrentKey("Contragent No.", "Agreement No.");
                PBE.SetRange("Contragent No.", VendNo);
                PBE.SetRange("Agreement No.", AgrNo);
                PBE.SetRange("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");

                if PBE.FINDSET then
                    repeat
                        Amt -= PBE."Without VAT (LCY)";
                    until PBE.Next() = 0;

                GLSetup.Get;
                if CheckAmt > Amt + GLSetup."Allow Diff in Check" then
                    Error(Text50000, AgrNo);
            end;
    end;
}