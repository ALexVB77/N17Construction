page 70164 "Vendor Agreement Details"
{
    PageType = ListPart;
    Permissions = TableData 380 = r;
    MultipleNewLines = false;
    SourceTable = "Vendor Agreement Details";
    AutoSplitKey = true;
    DelayedInsert = true;
    UsageCategory = Lists;


    layout
    {
        area(Content)
        {
            repeater(MainRep)
            {
                field("Building Turn All"; "Building Turn All")
                {
                    ApplicationArea = All;

                }

                field("Project Code"; "Project Code")
                {
                    Editable = false;
                    ApplicationArea = All;

                }

                field("Cost Code"; "Cost Code")
                {
                    ApplicationArea = All;

                }

                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    Editable = false;
                    ApplicationArea = All;

                }

                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    Visible = false;
                    Editable = false;
                    ApplicationArea = All;

                }

                field("Cost Type"; "Cost Type")
                {
                    Visible = true;
                    ApplicationArea = All;

                }

                field(Description; Description)
                {
                    ApplicationArea = All;

                }

                field("На Утверждении"; GetPlaneAmount(FALSE))
                {
                    ApplicationArea = All;
                    Caption = 'На Утверждении';
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        IF GetPlaneAmount(TRUE) = 0 THEN;
                    end;


                }

                field("Неучтенные Счета с НДС"; CalcInvoice(TRUE))
                {
                    ApplicationArea = All;
                    Caption = 'Неучтенные Счета с НДС';
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        ShowInvoice;
                    end;


                }

                field("Учтенные Счета с НДС"; CalcPostedInvoice(TRUE))
                {
                    // Name = PostInvVAT;
                    Visible = true;
                    ApplicationArea = All;
                    Caption = 'Учтенные Счета с НДС';
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        ShowPostedInvoice;
                    end;


                }

                field("Сумма Остатка"; GetRemainAmt)
                {
                    ApplicationArea = All;
                    Caption = 'Сумма Остатка';
                    trigger OnAssistEdit()
                    begin
                        GetRemainAmt2;
                    end;


                }

                field("Учтенные Счета, без НДС"; CalcPostedInvoice(FALSE))
                {
                    // Name = PostInv;
                    Visible = false;
                    ApplicationArea = All;
                    Caption = 'Учтенные Счета, без НДС';
                    trigger OnValidate()
                    begin
                        CalcSum; // NCS-57 AP 180414 <<
                    end;

                    trigger OnAssistEdit()
                    begin
                        ShowPostedInvoice;
                    end;


                }

                // field("Выплачено по договору, без НДС"; gcduERPC.GetCommited("Agreement No.","Global Dimension 1 Code","Global Dimension 2 Code"))
                // {
                //     Visible = false;
                //     ApplicationArea = All;
                //     Caption = 'Выплачено по договору, без НДС';

                // }   

                // field("Не разбито"; Amount-gcduERPC.GetCommited("Agreement No.","Global Dimension 1 Code","Global Dimension 2 Code"))
                // {
                //     Visible = false;
                //     ApplicationArea = All;
                //     Caption = 'Не разбито';

                // }   

                field("Сумма договора без НДС"; Amount)
                {
                    Visible = true;
                    ApplicationArea = All;
                    Caption = 'Сумма договора без НДС';
                    // trigger OnValidate()
                    // var 
                    //     Delta: decimal;
                    // begin
                    //     // SWC1004 DD 18.02.17 >>
                    //     // модифицировал и перенес из Amount - OnAfterValidate()
                    //     CI.GET;
                    //     IF CI."Company Type"=CI."Company Type"::Housing THEN
                    //     BEGIN
                    //       Delta:=Amount-xRec.Amount;
                    //       IF Delta>(ROUND(vAgreement."Agreement Amount"-GetAmount,0.01)) THEN
                    //       BEGIN
                    //         //MESSAGE(TEXT001);
                    //         ERROR(TEXT001);
                    //         Amount:=xRec.Amount;
                    //         EXIT;
                    //       END;
                    //       vAgreement."Unbound Cost":=ROUND(vAgreement."Agreement Amount"-(GetAmount+Delta),0.01);
                    //       vAgreement.MODIFY;
                    //     END
                    //     ELSE
                    //     BEGIN
                    //       Delta:=Amount-xRec.Amount;
                    //       IF Delta>(ROUND(vAgreement."Amount Without VAT"-GetAmount,0.01)) THEN
                    //       BEGIN
                    //         //MESSAGE(TEXT001);
                    //         ERROR(TEXT001);
                    //         Amount:=xRec.Amount;
                    //         EXIT;
                    //       END;
                    //       vAgreement."Unbound Cost":=ROUND(vAgreement."Amount Without VAT"-(GetAmount+Delta),0.01);
                    //       vAgreement.MODIFY;
                    //     END;
                    //     // SWC1004 DD 18.02.17 <<
                    // end;

                    trigger OnAssistEdit()
                    begin
                        ProjectsCostControlEntry.SETRANGE("Agreement No.", "Agreement No.");
                        ProjectsCostControlEntry.SETRANGE("Shortcut Dimension 1 Code", "Global Dimension 1 Code");
                        ProjectsCostControlEntry.SETRANGE("Shortcut Dimension 2 Code", "Global Dimension 2 Code");
                        IF ProjectsCostControlEntry.FINDFIRST THEN
                            PAGE.RUNMODAL(70186, ProjectsCostControlEntry);
                    end;


                }

                field("Amount Without VAT"; "Amount Without VAT")
                {
                    ApplicationArea = All;

                }

                field("Payed by Agreement"; "Payed by Agreement")
                {
                    ApplicationArea = All;

                }

                field("Сумма Договора, с НДС (руб)"; AmountLCY)
                {
                    Visible = false;
                    Editable = false;
                    ApplicationArea = All;
                    Caption = 'Сумма Договора, с НДС (руб)';

                }

                field("Currency Code"; "Currency Code")
                {
                    Visible = false;
                    Editable = true;
                    ApplicationArea = All;

                }

                field("Actual Costs Project (VAT)"; gActuals)
                {
                    // Name = Actuals;
                    Visible = false;
                    Editable = false;
                    ApplicationArea = All;
                    Caption = 'Actual Costs Project (VAT)';
                    trigger OnValidate()
                    begin
                        CalcSum; // NCS-57 AP 180414 <<
                    end;

                    trigger OnDrillDown()
                    begin
                        // NCS-21 AP 240214 >>
                        ProjectsCostControlEntry.RESET;
                        ProjectsCostControlEntry.SETRANGE("Project Code", "Project Code");
                        //ProjectsCostControlEntry.SETRANGE("Analysis Type","Analysis Type");
                        ProjectsCostControlEntry.SETRANGE("Line No.", "Project Line No.");
                        ProjectsCostControlEntry.SETRANGE("Agreement No.", "Agreement No.");
                        ProjectsCostControlEntry.SETRANGE("Analysis Type", ProjectsCostControlEntry."Analysis Type"::Actuals);
                        ProjectsCostControlEntry.SETRANGE("Shortcut Dimension 1 Code", "Global Dimension 1 Code");
                        ProjectsCostControlEntry.SETRANGE("Shortcut Dimension 2 Code", "Global Dimension 2 Code");
                        ProjectsCostControlEntry.SETRANGE("Cost Type", "Cost Type");

                        PAGE.RUN(PAGE::"Projects CC Entry Constr 2", ProjectsCostControlEntry);
                        // NCS-21 AP 240214 <<
                    end;


                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                Caption = 'Остальные комбинации Actuals';
                trigger OnAction()
                var
                    ProjectsCostControlEntry: record "Projects Cost Control Entry";
                    VendorAgreementDetailsLoc: record "Vendor Agreement Details";
                    ProjCostControlEntryBuf: record "Proj. Cost Control Entry Buf.";
                    PCCEForm: page "Proj. Cost Control Entry Buf.";
                    Window: dialog;
                begin
                    //SWC076 AKA 220414 >>
                    ProjCostControlEntryBuf.RESET;
                    ProjCostControlEntryBuf.DELETEALL;

                    VendorAgreementDetailsLoc.SETCURRENTKEY("Vendor No.", "Agreement No.", "Line No.");
                    VendorAgreementDetailsLoc.SETRANGE("Vendor No.", "Vendor No.");
                    VendorAgreementDetailsLoc.SETRANGE("Agreement No.", "Agreement No.");

                    ProjectsCostControlEntry.SETCURRENTKEY("Analysis Type", "Contragent No.", "Agreement No.", "Project Turn Code", "Line No.",
                      "Cost Type");
                    ProjectsCostControlEntry.SETRANGE("Contragent No.", "Vendor No.");
                    ProjectsCostControlEntry.SETRANGE("Agreement No.", "Agreement No.");
                    ProjectsCostControlEntry.SETRANGE("Analysis Type", ProjectsCostControlEntry."Analysis Type"::Actuals);
                    IF ProjectsCostControlEntry.FINDSET THEN
                        REPEAT
                            ProjCostControlEntryBuf.INIT;
                            ProjCostControlEntryBuf.TRANSFERFIELDS(ProjectsCostControlEntry);
                            ProjCostControlEntryBuf.INSERT();
                        UNTIL ProjectsCostControlEntry.NEXT = 0;

                    IF VendorAgreementDetailsLoc.FINDSET THEN
                        REPEAT
                            ProjCostControlEntryBuf.SETRANGE("Project Code", VendorAgreementDetailsLoc."Project Code");
                            ProjCostControlEntryBuf.SETRANGE("Line No.", VendorAgreementDetailsLoc."Project Line No.");
                            ProjCostControlEntryBuf.SETRANGE("Agreement No.", VendorAgreementDetailsLoc."Agreement No.");
                            ProjCostControlEntryBuf.SETRANGE("Analysis Type", ProjCostControlEntryBuf."Analysis Type"::Actuals);
                            ProjCostControlEntryBuf.SETRANGE("Shortcut Dimension 1 Code", VendorAgreementDetailsLoc."Global Dimension 1 Code");
                            ProjCostControlEntryBuf.SETRANGE("Shortcut Dimension 2 Code", VendorAgreementDetailsLoc."Global Dimension 2 Code");
                            ProjCostControlEntryBuf.SETRANGE("Cost Type", VendorAgreementDetailsLoc."Cost Type");
                            ProjCostControlEntryBuf.DELETEALL;
                        UNTIL VendorAgreementDetailsLoc.NEXT = 0;

                    PCCEForm.RUN();
                    //SWC076 AKA 220414 <<
                end;
            }
        }
    }
    var
        // gcduERPC: codeunit "ERPC Funtions";
        vAgreement: record "Vendor Agreement";
        ProjectsCostControlEntry: record "Projects Cost Control Entry";
        CI: record "Company Information";
        AgrAmount: decimal;
        // ProjecstLinesView: record "Projects Lines View";
        SumAmount: decimal;
        "Vendor Agreement Details": record "Vendor Agreement Details";
        gActuals: decimal;
        SortInit: boolean;
        Calc: boolean;
        "TEMP Vendor Agreement Details": record "Vendor Agreement Details" temporary;
        BuildingProject: record "Building project";
        TEXT001: Label 'Превышена Сумма Остатка!';

    procedure GetAmount() Ret: Decimal
    var
        VendorAgreementDetails: record "Vendor Agreement Details";
    begin
        VendorAgreementDetails.COPY(Rec);
        IF VendorAgreementDetails.FINDSET THEN BEGIN
            REPEAT
                Ret := Ret + VendorAgreementDetails.Amount;
            UNTIL VendorAgreementDetails.NEXT = 0;
        END;
    end;

    procedure CalcSum()
    begin
    end;

    procedure SumPostedInvoice() ret: Decimal
    begin
        // AP SWC057 310314 >>
        IF Calc THEN BEGIN // NCS-72 AP 250414 <<
            "Vendor Agreement Details".RESET;
            "Vendor Agreement Details".SETRANGE("Vendor No.", vAgreement."Vendor No.");
            "Vendor Agreement Details".SETRANGE("Agreement No.", vAgreement."No.");

            IF "Vendor Agreement Details".FINDSET THEN
                REPEAT
                    ret += CalcSumPostedInvoice;
                UNTIL "Vendor Agreement Details".NEXT = 0;
        END;
        // AP SWC057 310314 <<
    end;

    procedure CalcSumPostedInvoice() ret: Decimal
    var
        PIH: record "Purch. Inv. Header";
        PIL: record "Purch. Inv. Line";
        PIHC: record "Purch. Cr. Memo Hdr.";
        PILC: record "Purch. Cr. Memo Line";
    begin
        PIH.SETRANGE("Pay-to Vendor No.", "Vendor Agreement Details"."Vendor No.");
        PIH.SETRANGE("Agreement No.", "Vendor Agreement Details"."Agreement No.");
        IF PIH.FINDSET THEN BEGIN
            REPEAT
                PIL.SETCURRENTKEY("Document No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Cost Type");
                PIL.SETRANGE("Document No.", PIH."No.");
                PIL.SETRANGE("Shortcut Dimension 1 Code", "Vendor Agreement Details"."Global Dimension 1 Code");
                PIL.SETRANGE("Shortcut Dimension 2 Code", "Vendor Agreement Details"."Global Dimension 2 Code");
                PIL.SETRANGE("Cost Type", "Vendor Agreement Details"."Cost Type");
                // AP SWC072 180414 >>
                //IF PIL.FINDSET THEN
                //BEGIN
                //  REPEAT
                //    Ret:=Ret+PIL.Amount;
                //   UNTIL PIL.NEXT=0;
                // END;
                PIL.CALCSUMS(Amount);
                Ret += PIL.Amount;
            // AP SWC072 180414 <<
            UNTIL PIH.NEXT = 0;
        END;

        PIHC.SETRANGE("Pay-to Vendor No.", "Vendor Agreement Details"."Vendor No.");
        PIHC.SETRANGE("Agreement No.", "Vendor Agreement Details"."Agreement No.");
        IF PIHC.FINDSET THEN BEGIN
            REPEAT
                PILC.SETCURRENTKEY("Document No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Cost Type");
                PILC.SETRANGE("Document No.", PIHC."No.");
                PILC.SETRANGE("Shortcut Dimension 1 Code", "Vendor Agreement Details"."Global Dimension 1 Code");
                PILC.SETRANGE("Shortcut Dimension 2 Code", "Vendor Agreement Details"."Global Dimension 2 Code");
                PILC.SETRANGE("Cost Type", "Vendor Agreement Details"."Cost Type");
                //IF PILC.FINDSET THEN
                //BEGIN
                //  REPEAT
                //    Ret:=Ret-PILC.Amount;
                //   UNTIL PILC.NEXT=0;
                //  END;
                PILC.CALCSUMS(Amount);
                Ret -= PIL.Amount;

            UNTIL PIHC.NEXT = 0;
        END;
    end;
}