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
            Caption = 'COST TYPE';


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
            // CalcFormula = Sum("Projects Budget Entry"."Without VAT" WHERE (Agreement No.=FIELD(Agreement No.),
            //                                                                Project Code=FIELD(Project Code),
            //                                                                Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Code),
            //                                                                Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Code),
            //                                                                Close=CONST(Yes)));
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
        TEXT0001: Label 'Необходимо определить объект строительства';
        TEXT0002: Label 'Для объекта строительства %1 не найдена статья %2';
        Text50000: Label 'У проекта %1 с типом Production поля Сумма с НДС и Сумма без НДС д.б. оба заполнены, либо оба равны 0!';
        Text50001: Label 'Сумма с НДС и Сумма без НДС не должны быть равны 0 для CostPlace %1!';

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

}