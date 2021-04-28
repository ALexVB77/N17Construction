page 70166 "Vendor Agreement Budget"
{
    Editable = true;
    InsertAllowed = true;
    DeleteAllowed = true;
    SourceTable = "Projects Budget Entry";
    DelayedInsert = true;
    PopulateAllFields = false;
    PageType = Worksheet;
    Caption = 'Forecast List';


    layout
    {
        area(content)
        {
            group(Unbound1237120002)
            {
                field(Rest; vAgreement."Agreement Amount" - GetAmount1)
                {
                    Editable = false;
                    ApplicationArea = All;
                    Caption = 'Rest';
                }

                field(GetAmount1_; GetAmount1)
                {
                    Editable = false;
                    ApplicationArea = All;
                    Caption = 'Amount';
                }
            }
            repeater(Repeater1237120003)
            {
                field("Entry No."; "Entry No.")
                {
                    Visible = false;
                    ApplicationArea = All;

                }

                field(Close; Close)
                {
                    Editable = true;
                    ShowCaption = false;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin

                        FieldOnAfterValidate; //navnav;
                    end;


                }

                field(Date; Date)
                {
                    NotBlank = true;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin

                        FieldOnAfterValidate; //navnav;
                    end;


                }

                field("Date Plan"; "Date Plan")
                {
                    Editable = false;
                    ApplicationArea = All;

                }

                field("Building Turn"; "Building Turn")
                {
                    Editable = false;
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        ProjectsLineDimension: record "Projects Line Dimension";
                        Buildingturn: record "Building turn";
                    begin
                        // Buildingturn.SETRANGE(Code,"Building Turn All");
                        // IF Buildingturn.FINDFIRST THEN "Shortcut Dimension 1 Code":=Buildingturn."Turn Dimension Code";

                        // IF "Shortcut Dimension 1 Code"<>'' THEN
                        // BEGIN
                        //   IF Buildingturn.FINDFIRST THEN
                        //   BEGIN
                        //     VALIDATE("Project Turn Code",Buildingturn.Code);

                        //     lrVersion.SETRANGE("Project Code",Buildingturn."Building project Code");
                        //     lrVersion.SETRANGE("Fixed Version",TRUE);
                        //     IF lrVersion.FINDFIRST THEN
                        //     BEGIN
                        //       "Project Code":=lrVersion."Project Code";
                        //       "Version Code":=lrVersion."Version Code";

                        //       IF "Shortcut Dimension 2 Code"<>'' THEN
                        //       BEGIN
                        //         ProjectsLineDimension.SETRANGE("Project No.",lrVersion."Project Code");
                        //         ProjectsLineDimension.SETRANGE("Project Version No.",lrVersion."Version Code");
                        //         ProjectsLineDimension.SETRANGE("Dimension Code",'CC');
                        //         ProjectsLineDimension.SETRANGE("Dimension Value Code","Shortcut Dimension 2 Code");
                        //         ProjectsLineDimension.SETRANGE("Detailed Line No.",0);
                        //         IF ProjectsLineDimension.FINDFIRST THEN
                        //         BEGIN
                        //           "Line No.":=ProjectsLineDimension."Project Line No.";
                        //         END;
                        //       END;
                        //     END
                        //     ELSE
                        //     BEGIN
                        //       "Project Code":='';
                        //       "Version Code":='';
                        //     END;
                        //   END;
                        // END;
                        // ChangeDate2;
                    end;


                }

                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Editable = false;
                    ApplicationArea = All;

                }

                field("Cost Code"; "Cost Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin

                        FieldOnAfterValidate; //navnav;
                    end;


                }

                field("Transaction Type"; "Transaction Type")
                {
                    ApplicationArea = All;

                }

                field("Without VAT"; "Without VAT")
                {
                    NotBlank = true;
                    ApplicationArea = All;
                    // trigger OnInputChange()
                    // begin
                    //     IF "Entry No." = 0 THEN
                    //       "Entry No." := GetNextEntryNo;
                    //     "Including VAT":=FALSE;
                    // end;

                    trigger OnValidate()
                    begin

                        FieldOnAfterValidate; //navnav;
                    end;


                }

                field("Without VAT (LCY)"; "Without VAT (LCY)")
                {
                    ApplicationArea = All;

                }

                field(Curency; Curency)
                {
                    ApplicationArea = All;

                }

                field(Description; Description)
                {
                    NotBlank = true;
                    ApplicationArea = All;
                    trigger OnAssistEdit()
                    var
                        lrPL: record "Purchase Line";
                        lrPH: record "Purchase Header";
                    begin
                        IF Close THEN BEGIN
                            lrPL.SETCURRENTKEY("Forecast Entry");
                            lrPL.SETRANGE("Forecast Entry", "Entry No.");
                            IF lrPL.FINDFIRST THEN BEGIN
                                lrPH.SETRANGE("Document Type", lrPL."Document Type");
                                lrPH.SETRANGE("No.", lrPL."Document No.");
                                IF lrPH.FINDFIRST THEN BEGIN
                                    PAGE.RUN(70000, lrPH);

                                END;
                            END;




                        END;
                    end;


                }

                field("Description 2"; "Description 2")
                {
                    ApplicationArea = All;

                }

                field("Invoice No"; GetInvoiceNo)
                {
                    Visible = false;
                    ApplicationArea = All;
                    Caption = 'Invoice No';
                }

                field("Invoice Date"; GetInvoiceDate)
                {
                    Visible = false;
                    ApplicationArea = All;
                    Caption = 'Invoice Date';
                }

                field("Payment Doc. No."; "Payment Doc. No.")
                {
                    Editable = false;
                    ApplicationArea = All;

                }



            }
        }
    }


    actions
    {
        area(navigation)
        {
            group("Command Buttons")
            {
                action("Untie from Agreement")
                {
                    Caption = 'Untie from Agreement';
                    trigger OnAction()
                    begin
                        IF Close THEN EXIT;
                        IF CheckCFIW THEN BEGIN
                            IF CONFIRM(TEXT0010) THEN BEGIN
                                VALIDATE("Contragent No.", '');
                                VALIDATE("Agreement No.", '');
                                MODIFY;
                            END;
                        END;
                    end;
                }
            }
        }
    }


    // trigger OnActivateForm()
    // begin
    //     IF vAgreement.GET("Contragent No.","Agreement No.") THEN;
    // end;

    trigger OnAfterGetRecord()
    var
        ProjectsLineDimension: record "Projects Line Dimension";
        Buildingturn: record "Building turn";
        ProjectsStructureLines: record "Projects Structure Lines";
    begin
        // IF ("Building Turn All" ='') AND ("Shortcut Dimension 1 Code"<>'') THEN
        // BEGIN
        //   Buildingturn.SETRANGE("Turn Dimension Code","Shortcut Dimension 1 Code");
        //   IF Buildingturn.FINDFIRST THEN "Building Turn All":=Buildingturn.Code;

        // END;
        // IF "Cost Code"='' THEN
        // BEGIN
        //   IF "Line No."<>0 THEN
        //   BEGIN
        //     ProjectsStructureLines.SETRANGE("Project Code","Project Code");
        //     ProjectsStructureLines.SETRANGE(Version,"Version Code");
        //     ProjectsStructureLines.SETRANGE("Line No.","Line No.");
        //     IF ProjectsStructureLines.FINDFIRST THEN
        //     BEGIN
        //       "Cost Code":=ProjectsStructureLines.Code;
        //     END;
        //   END;
        // END;
        // IF vAgreement.GET("Contragent No.","Agreement No.") THEN;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        // IF vAgreement.GET("Contragent No.","Agreement No.") THEN;
        // IF Close THEN
        // BEGIN
        //   //CurrForm.Close.EDITABLE:=FALSE;
        //   CurrPage.Date.EDITABLE:=FALSE;
        //   CurrPage.Description.EDITABLE:=FALSE;
        //   CurrPage."Description 2".EDITABLE:=FALSE;
        //   CurrPage."Without VAT".EDITABLE:=FALSE;
        // //  CurrForm."Building Turn".EDITABLE:=FALSE;
        // //  CurrForm."Cost Code".EDITABLE:=FALSE;
        // END
        // ELSE
        // BEGIN
        //   CurrPage.Close.EDITABLE:=TRUE;
        //   CurrPage.Date.EDITABLE:=TRUE;
        //   CurrPage.Description.EDITABLE:=TRUE;
        //   CurrPage."Description 2".EDITABLE:=TRUE;

        // ///  CurrForm."Building Turn".EDITABLE:=TRUE;
        // //  CurrForm."Cost Code".EDITABLE:=TRUE;
        //   IF "Without VAT"<>0 THEN  CurrPage."Without VAT".EDITABLE:=FALSE ELSE CurrPage."Without VAT".EDITABLE:=TRUE;
        // END ;
    end;

    // trigger OnBeforePutRecord()
    // begin
    //     Curency:=vAgreement."Currency Code"; //AP SWC026 310314 <<
    // end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        ProjectsLineDimension: record "Projects Line Dimension";
        Buildingturn: record "Building turn";
        lrVendor: record Vendor;
        lrVendorAgree: record "Vendor Agreement";
    begin
        // Curency:=vAgreement."Currency Code";//AP SWC026 310314 <<

        // "Work Version":=TRUE;

        // "Including VAT":=FALSE;
        // "Not Run OnInsert":=TRUE;
        // "Contragent No.":=gVendor;
        // "Agreement No.":=gAgr;

        // IF lrVendor.GET(gVendor) THEN
        //   "Contragent Name":=lrVendor.Name;

        // IF lrVendorAgree.GET(gVendor,gAgr) THEN
        //   "External Agreement No.":=lrVendorAgree."External Agreement No.";

        // IF gDim1<>'' THEN
        //   "Shortcut Dimension 1 Code":=gDim1;
        // IF gDim2<>'' THEN
        //   "Shortcut Dimension 2 Code":=gDim2;

        // Buildingturn.SETRANGE("Turn Dimension Code","Shortcut Dimension 1 Code");

        // IF "Shortcut Dimension 1 Code"<>'' THEN
        // BEGIN
        //   IF Buildingturn.FINDFIRST THEN
        //   BEGIN
        //     VALIDATE("Project Turn Code",Buildingturn.Code);
        //     VALIDATE("Building Turn",Buildingturn.Code);
        //     "Project Code":=Buildingturn."Building project Code";
        //     "Version Code":=GetDefVersion1("Project Code");
        //   END;
        // END;
        // IF DimV.GET('CC',"Shortcut Dimension 2 Code") THEN
        //   Description:=DimV.Name;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        // //IF ("Without VAT"=0) OR (Date=0D){ OR ("Shortcut Dimension 1 Code"='') OR ("Shortcut Dimension 2 Code"='') }THEN ERROR('');
        // "Including VAT":=FALSE;
        // "Not Run OnInsert":=TRUE;

        // IF Close THEN
        // BEGIN
        //   US.GET(USERID);
        //   IF NOT US."Administrator PRJ" THEN
        //   BEGIN
        //     ERROR(TEXT0014);
        //   END;
        // END;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        // IF "Payment Doc. No."<>'' THEN ERROR('Нельзя удалить запись.');
        // US.GET(USERID);
        // IF NOT US."Administrator PRJ" THEN ERROR('Нельзя удалить запись.');
    end;

    trigger OnOpenPage()
    begin
        IF vAgreement.GET("Contragent No.", "Agreement No.") THEN;

        FieldOnFormat; //navnav;

        FieldOnFormat; //navnav;

        FieldOnFormat; //navnav;

        FieldOnFormat; //navnav;

        FieldOnFormat; //navnav;
    end;



    var
        Agr: record "Vendor Agreement";
        gVendor: code[20];
        gAgr: code[20];
        gDim1: code[20];
        gDim2: code[20];
        // lrVersion: record "Project Version";
        DimV: record "Dimension Value";
        vAgreement: record "Vendor Agreement";
        Delta: decimal;
        US: record "User Setup";
        TEXT0004: Label 'You must specify the Project Code!';
        TEXT0005: Label 'You must ask a Budget Item!';
        TEXT0008: Label 'You must select the Cash Flow records from which you want to write off this amount.';
        TEXT0009: Label 'Canceled by the user.';
        TEXT0010: Label 'Unlink the payment from the supplier and the contract (transfer to level 1)?';
        TEXT0012: Label 'The operation is tied to the IW document \ Amount available for transfer to the 1st level';
        TEXT0013: Label 'The operation is tied to the IW document \ Amount available for transfer to the 1st level';
        CurrTrType: code[20];
        TEXT0014: Label 'You are not allowed to copy the actual transactions.';


    procedure ChangeDate()
    var
        lrProjectsBudgetEntry: record "Projects Budget Entry";
        lrProjectsBudgetEntryLink: record "Projects Budget Entry Link";
        lvAmount: decimal;
    begin
        EXIT;
        // IF xRec.Date<>0D THEN
        // BEGIN
        //   lrProjectsBudgetEntry.INIT;
        //   lrProjectsBudgetEntry.COPY(Rec);
        //   lrProjectsBudgetEntry."Create Date":=TODAY;
        //   lrProjectsBudgetEntry.Date:=xRec.Date;
        //   lrProjectsBudgetEntry."Entry No.":=0;
        //   lrProjectsBudgetEntry."Not Run OnInsert":=TRUE;
        //   lrProjectsBudgetEntry.INSERT(TRUE);




        //   lrProjectsBudgetEntryLink.SETRANGE("Main Entry No.","Entry No.");
        //   lrProjectsBudgetEntryLink.SETRANGE("Project Code","Project Code");
        //   lrProjectsBudgetEntryLink.SETRANGE("Analysis Type","Analysis Type");
        //   lrProjectsBudgetEntryLink.SETRANGE("Version Code","Version Code");
        //   IF lrProjectsBudgetEntryLink.FINDFIRST THEN
        //   BEGIN
        //     lrProjectsBudgetEntryLink.MODIFYALL("Main Entry No.",lrProjectsBudgetEntry."Entry No.");
        //     lrProjectsBudgetEntryLink.MODIFYALL(Date,lrProjectsBudgetEntry.Date);

        //   END;
        //  // lrProjectsBudgetEntry.CALCFIELDS(Amount);
        //   lvAmount:=lrProjectsBudgetEntry.Amount;
        //   lrProjectsBudgetEntry.VALIDATE(Amount,0);

        //   VALIDATE(Amount,lvAmount);
        // END;
        // ChangeDate2;
    end;

    local procedure GetNextEntryNo(): Integer
    var
        GLBudgetEntry: record "Projects Budget Entry";
    begin
        GLBudgetEntry.SETCURRENTKEY("Entry No.");
        IF GLBudgetEntry.FIND('+') THEN
            EXIT(GLBudgetEntry."Entry No." + 1)
        ELSE
            EXIT(1);
    end;

    procedure SetData(pVendor: code[20]; pAgr: code[20]; Dim1: code[20]; Dim2: code[20])
    begin
        gVendor := pVendor;
        gAgr := pAgr;
        gDim1 := Dim1;
        gDim2 := Dim2;
    end;

    procedure ChangeDate1()
    var
        lrProjectsBudgetEntry: record "Projects Budget Entry";
        lrProjectsBudgetEntryLink: record "Projects Budget Entry Link";
        lvAmount: decimal;
    begin
        EXIT;
        // IF xRec.Date<>0D THEN
        // BEGIN
        //   lrProjectsBudgetEntry.INIT;
        //   lrProjectsBudgetEntry.COPY(Rec);
        //   lrProjectsBudgetEntry."Create Date":=TODAY;
        //   lrProjectsBudgetEntry.Date:=xRec.Date;
        //   lrProjectsBudgetEntry."Entry No.":=0;
        //   lrProjectsBudgetEntry."Not Run OnInsert":=TRUE;
        //   lrProjectsBudgetEntry.INSERT(TRUE);




        //   lrProjectsBudgetEntryLink.SETRANGE("Main Entry No.","Entry No.");
        //   lrProjectsBudgetEntryLink.SETRANGE("Project Code","Project Code");
        //   lrProjectsBudgetEntryLink.SETRANGE("Analysis Type","Analysis Type");
        //   lrProjectsBudgetEntryLink.SETRANGE("Version Code","Version Code");
        //   IF lrProjectsBudgetEntryLink.FINDFIRST THEN
        //   BEGIN
        //     lrProjectsBudgetEntryLink.MODIFYALL("Main Entry No.",lrProjectsBudgetEntry."Entry No.");
        //     lrProjectsBudgetEntryLink.MODIFYALL(Date,lrProjectsBudgetEntry.Date);

        //   END;
        //  // lrProjectsBudgetEntry.CALCFIELDS(Amount);
        //   lvAmount:=lrProjectsBudgetEntry.Amount;
        //   lrProjectsBudgetEntry.VALIDATE(Amount,0);

        //   VALIDATE(Amount,lvAmount);
        // END;
    end;

    procedure ChangeDate2()
    var
        lrProjectsBudgetEntry: record "Projects Budget Entry";
        lrProjectsBudgetEntryLink: record "Projects Budget Entry Link";
        lvAmount: decimal;
    begin
        EXIT;
        //IF xRec.Date<>0D THEN
        BEGIN

            lrProjectsBudgetEntryLink.SETRANGE("Main Entry No.", "Entry No.");
            IF lrProjectsBudgetEntryLink.FINDFIRST THEN BEGIN
                lrProjectsBudgetEntryLink.MODIFYALL("Project Code", "Project Code");
                lrProjectsBudgetEntryLink.MODIFYALL("Version Code", "Version Code");
                lrProjectsBudgetEntryLink.MODIFYALL("Line No.", "Line No.");
                lrProjectsBudgetEntryLink.MODIFYALL("Project Turn Code", "Project Turn Code");
            END;
        END;
    end;

    procedure GetAmount(vAgrNo: code[20]) Ret: Decimal
    var
        VendorAgreementDetails: record "Projects Budget Entry";
    begin
        /*VendorAgreementDetails.COPY(Rec);
        IF VendorAgreementDetails.FINDSET THEN
        BEGIN
          REPEAT
           // VendorAgreementDetails.CALCFIELDS("Without VAT");
            Ret:=Ret+VendorAgreementDetails."Without VAT";
          UNTIL VendorAgreementDetails.NEXT=0;
        END;  */

        VendorAgreementDetails.SETRANGE("Contragent No.", "Contragent No.");
        VendorAgreementDetails.SETRANGE("Agreement No.", vAgrNo);
        VendorAgreementDetails.SETFILTER("Entry No.", '<>%1', "Entry No.");
        //MESSAGE(VendorAgreementDetails.GETFILTERS);
        IF VendorAgreementDetails.FINDSET THEN BEGIN
            REPEAT
                Ret := Ret + VendorAgreementDetails."Without VAT";
            UNTIL VendorAgreementDetails.NEXT = 0;
        END;
    end;

    procedure GetAmount1() Ret: Decimal
    var
        VendorAgreementDetails: record "Projects Budget Entry";
    begin
        VendorAgreementDetails.COPY(Rec);
        IF VendorAgreementDetails.FINDSET THEN BEGIN
            REPEAT
                IF vAgreement."Currency Code" <> '' THEN
                    Ret := Ret + VendorAgreementDetails."Without VAT"  //AP SWC026 250814 <<
                ELSE
                    Ret := Ret + VendorAgreementDetails."Without VAT (LCY)"// AP SWC026 160414 <<
            UNTIL VendorAgreementDetails.NEXT = 0;
        END;
    end;

    procedure ClearSum()
    var
        lrProjectsBudgetEntry: record "Projects Budget Entry";
    begin
        // lrProjectsBudgetEntry.SETRANGE("Project Code","Project Code");
        // lrProjectsBudgetEntry.SETRANGE("Project Turn Code","Project Turn Code");
        // lrProjectsBudgetEntry.SETRANGE("Cost Code","Cost Code");
        // lrProjectsBudgetEntry.SETFILTER("Contragent No.",'%1|%2','',"Contragent No.");
        // lrProjectsBudgetEntry.SETRANGE("Agreement No.",'');
        // lrProjectsBudgetEntry.SETFILTER("Without VAT",'<>%1',0);
        // lrProjectsBudgetEntry.SETFILTER("Entry No.",'<>%1',"Entry No.");
        // IF lrProjectsBudgetEntry.FINDSET THEN
        // BEGIN
        //   REPEAT
        //     lrProjectsBudgetEntry."Write Off Amount":=0;
        //     lrProjectsBudgetEntry.MODIFY;
        //   UNTIL lrProjectsBudgetEntry.NEXT=0;
        // END;
    end;

    procedure CheckCFIW() Ret: Boolean
    var
        lrPL: record "Purchase Line";
        vAmount: decimal;
        lrProjectsBudgetEntry: record "Projects Budget Entry";
    begin
        vAmount := 0;
        Ret := TRUE;
        lrPL.SETCURRENTKEY("Forecast Entry");
        lrPL.SETRANGE("Forecast Entry", "Entry No.");
        IF lrPL.FINDSET THEN BEGIN
            REPEAT
                vAmount := vAmount + GetLineAmount(lrPL);

            UNTIL lrPL.NEXT = 0;

            IF vAmount <> 0 THEN BEGIN
                Ret := FALSE;
                IF "Without VAT" = vAmount THEN BEGIN
                    MESSAGE(STRSUBSTNO(TEXT0013, ("Without VAT" - vAmount)));
                END
                ELSE BEGIN
                    IF CONFIRM(STRSUBSTNO(TEXT0012, ("Without VAT" - vAmount))) THEN BEGIN
                        lrProjectsBudgetEntry.INIT;
                        lrProjectsBudgetEntry.TRANSFERFIELDS(Rec);
                        lrProjectsBudgetEntry.VALIDATE("Without VAT", ("Without VAT" - vAmount));
                        lrProjectsBudgetEntry."Entry No." := 0;
                        lrProjectsBudgetEntry.VALIDATE("Contragent No.", '');
                        lrProjectsBudgetEntry.VALIDATE("Agreement No.", '');
                        lrProjectsBudgetEntry.INSERT(TRUE);
                        VALIDATE("Without VAT", vAmount);
                        MODIFY;
                    END;
                END;
            END;
        END;
    end;

    procedure GetLineAmount(pPH: record "Purchase Line") Ret: Decimal
    var
        lrPL: record "Purchase Line";
        Amount: decimal;
        AmountWOVAT: decimal;
        AmountVAT: decimal;
        AmountWVAT: decimal;
        lrPH: record "Purchase Header";
    begin
        AmountWOVAT := 0;
        AmountVAT := 0;
        AmountWVAT := 0;

        lrPH.GET(pPH."Document Type", pPH."Document No.");
        lrPL.SETRANGE("Document Type", pPH."Document Type");
        lrPL.SETRANGE("Document No.", pPH."Document No.");
        lrPL.SETRANGE("Line No.", pPH."Line No.");

        IF lrPL.FIND('-') THEN BEGIN
            REPEAT
                Amount := lrPL."Line Amount";
                IF lrPH."Prices Including VAT" THEN BEGIN
                    IF lrPL."VAT %" <> 0 THEN BEGIN
                        AmountVAT := AmountVAT + ROUND(Amount - (Amount / ((100 + lrPL."VAT %") / 100)), 0.01);
                        AmountWOVAT := AmountWOVAT + (Amount - ROUND(Amount - (Amount / ((100 + lrPL."VAT %") / 100)), 0.01));
                        AmountWVAT := AmountWVAT + Amount;
                    END
                    ELSE BEGIN
                        AmountWOVAT := AmountWOVAT + Amount;
                        AmountWVAT := AmountWVAT + Amount;
                    END;
                END
                ELSE BEGIN
                    IF lrPL."VAT %" <> 0 THEN BEGIN
                        AmountVAT := AmountVAT + (ROUND(Amount * ((100 + lrPL."VAT %") / 100), 0.01) - Amount);
                        AmountWOVAT := AmountWOVAT + Amount;
                        AmountWVAT := AmountWVAT + (Amount + (ROUND(Amount * ((100 + lrPL."VAT %") / 100), 0.01) - Amount));
                    END
                    ELSE BEGIN
                        AmountWOVAT := AmountWOVAT + Amount;
                        AmountWVAT := AmountWVAT + Amount;
                    END;
                END;
            UNTIL lrPL.NEXT = 0;
        END;
        Ret := AmountWVAT;
    end;

    procedure SetSum()
    var
        lrProjectsBudgetEntry: record "Projects Budget Entry";
        MaxAmount: decimal;
    begin
        // lrProjectsBudgetEntry.SETRANGE("Project Code","Project Code");
        // lrProjectsBudgetEntry.SETRANGE("Project Turn Code","Project Turn Code");
        // lrProjectsBudgetEntry.SETRANGE("Cost Code","Cost Code");
        // lrProjectsBudgetEntry.SETFILTER("Contragent No.",'%1|%2','',"Contragent No.");
        // lrProjectsBudgetEntry.SETRANGE("Agreement No.",'');
        // lrProjectsBudgetEntry.SETFILTER("Without VAT",'<>%1',0);
        // lrProjectsBudgetEntry.SETFILTER("Entry No.",'<>%1',"Entry No.");
        // IF lrProjectsBudgetEntry.FINDSET THEN
        // BEGIN
        //   REPEAT
        //     lrProjectsBudgetEntry.VALIDATE("Without VAT",lrProjectsBudgetEntry."Without VAT"-lrProjectsBudgetEntry."Write Off Amount");
        //     IF MaxAmount<lrProjectsBudgetEntry."Write Off Amount" THEN
        //     BEGIN
        //       MaxAmount:=lrProjectsBudgetEntry."Write Off Amount";
        //       CurrTrType:=lrProjectsBudgetEntry."Transaction Type";
        //     END;

        //     lrProjectsBudgetEntry."Write Off Amount":=0;
        //     IF lrProjectsBudgetEntry."Without VAT" = 0 THEN
        //       lrProjectsBudgetEntry.NotVisible:=TRUE;
        //      lrProjectsBudgetEntry.MODIFY;
        //   UNTIL lrProjectsBudgetEntry.NEXT=0;
        // END;
    end;

    local procedure FieldOnFormat()
    begin
        // IF "Contragent No."='' THEN CurrPage."Description 2".UPDATEFORECOLOR:=16711680;
        // IF Close THEN CurrPage."Description 2".UPDATEFORECOLOR:=32768;
    end;

    local procedure FieldOnAfterValidate()
    var
        TEXT001: Label 'The amount of the Balance under the Agreement has been exceeded!';
        lrProjectsBudgetEntry: record "Projects Budget Entry";
    // lfCFCorrection: page "Forecast List Analisys Correct";
    begin



        // Delta:=Amount;//-xRec.Amount;
        // IF Delta>ROUND(vAgreement."Agreement Amount"-GetAmount("Agreement No."),0.01) THEN
        // BEGIN
        //   MESSAGE(TEXT001);
        //   VALIDATE("Without VAT",0);
        // END;


        // CurrPage.SAVERECORD;
        // IF "Without VAT"<>0 THEN
        //       BEGIN
        //   IF "Building Turn" = '' THEN
        //         BEGIN
        //     MESSAGE(TEXT0004);
        //     "Without VAT":=0;
        //     EXIT;
        //         END;
        //   IF "Cost Code"  = '' THEN
        //   BEGIN
        //     MESSAGE(TEXT0005);
        //     "Without VAT":=0;
        //     EXIT;
        //       END;
        //     END;
        // COMMIT;
        // IF "Without VAT"<>0 THEN
        // BEGIN
        //     MESSAGE(TEXT0008);
        //     CLEAR(lfCFCorrection);
        //     lfCFCorrection.LOOKUPMODE:=TRUE;
        //     lrProjectsBudgetEntry.SETCURRENTKEY(Date);
        //     lrProjectsBudgetEntry.SETRANGE("Project Code","Project Code");
        //     lrProjectsBudgetEntry.SETRANGE("Project Turn Code","Project Turn Code");
        //     lrProjectsBudgetEntry.SETRANGE("Cost Code","Cost Code");
        //     lrProjectsBudgetEntry.SETFILTER("Contragent No.",'%1|%2','',"Contragent No.");
        //     lrProjectsBudgetEntry.SETRANGE("Agreement No.",'');
        //     lrProjectsBudgetEntry.SETRANGE(NotVisible,FALSE);
        //     lrProjectsBudgetEntry.SETFILTER("Entry No.",'<>%1',"Entry No.");
        //     IF lrProjectsBudgetEntry.FINDFIRST THEN;
        //     lfCFCorrection.SETTABLEVIEW(lrProjectsBudgetEntry);
        //     lfCFCorrection.SetData(Rec);
        //     IF lfCFCorrection.RUNMODAL = ACTION::LookupOK THEN
        //     BEGIN
        //       SetSum;
        //       "Transaction Type":=CurrTrType;
        //     END
        //     ELSE
        //     BEGIN
        //       ClearSum;
        //       VALIDATE("Without VAT",0);
        //       MESSAGE(TEXT0009);
        //   END;

        // END;
    end;


}

