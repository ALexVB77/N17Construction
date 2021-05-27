page 70091 "Investment Agreement Card"
{
    Caption = 'Investment Agreement Card';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Customer Agreement";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }

                field("Agreement Type"; Rec."Agreement Type")
                {
                    ApplicationArea = All;
                }

                field("Agreement Sub Type"; Rec."Agreement Sub Type")
                {
                    ApplicationArea = All;
                }

                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = All;
                }

                field("Apartment Amount"; Rec."Apartment Amount")
                {
                    ApplicationArea = All;
                }

                field("Installment (LCY)"; Rec."Agreement Amount" - Rec."Apartment Amount")
                {
                    Caption = 'Installment (LCY)';
                    BlankZero = true;
                    DecimalPlaces = 2;
                    Editable = false;
                    ApplicationArea = All;
                }

                field("Agreement Amount"; Rec."Agreement Amount")
                {
                    ApplicationArea = All;
                }

                field("Balance (LCY)"; Rec."Balance (LCY)")
                {
                    ApplicationArea = All;
                }

                field("Remaining Amount (LCY)"; Rec."Agreement Amount" + Rec."Balance (LCY)")
                {
                    Caption = 'Remaining Amount (LCY)';
                    BlankZero = true;
                    DecimalPlaces = 2;
                    Editable = false;
                    ApplicationArea = All;
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }

                field("Hand over status"; gcduERPC.GetAgreementActStatus(Rec."No."))
                {
                    ApplicationArea = All;
                    Caption = 'Hand over status';
                }

                //Shareholder 1
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }

                field("Customer 1 Name"; Rec."Customer 1 Name")
                {
                    ApplicationArea = All;
                }

                field("Balance Cust 1 (LCY)"; Rec."Balance Cust 1 (LCY)")
                {
                    ApplicationArea = All;
                }

                group(Shareholder2)
                {
                    Caption = 'Shareholder 2';
                    Visible = ShareHolder2InfoVisible;

                    field("Customer 2 No."; Rec."Customer 2 No.")
                    {
                        ApplicationArea = All;
                    }

                    field("Customer 2 Name"; Rec."Customer 2 Name")
                    {
                        ApplicationArea = All;
                    }

                    field("Balance Cust 2 (LCY)"; Rec."Balance Cust 2 (LCY)")
                    {
                        ApplicationArea = All;
                    }

                }


                group(Shareholder3)
                {
                    Caption = 'Shareholder 3';
                    Visible = ShareHolder3InfoVisible;

                    field("Customer 3 No."; Rec."Customer 3 No.")
                    {
                        ApplicationArea = All;
                    }

                    field("Customer 3 Name"; Rec."Customer 3 Name")
                    {
                        ApplicationArea = All;
                    }

                    field("Balance Cust 3 (LCY)"; Rec."Balance Cust 3 (LCY)")
                    {
                        ApplicationArea = All;
                    }

                }


                group(Shareholder4)
                {
                    Caption = 'Shareholder 4';
                    Visible = ShareHolder4InfoVisible;

                    field("Customer 4 No."; Rec."Customer 4 No.")
                    {
                        ApplicationArea = All;
                    }

                    field("Customer 4 Name"; Rec."Customer 4 Name")
                    {
                        ApplicationArea = All;
                    }

                    field("Balance Cust 4 (LCY)"; Rec."Balance Cust 4 (LCY)")
                    {
                        ApplicationArea = All;
                    }
                }

                group(Shareholder5)
                {
                    Caption = 'Shareholder 5';
                    Visible = ShareHolder5InfoVisible;

                    field("Customer 5 No."; Rec."Customer 5 No.")
                    {
                        ApplicationArea = All;
                    }

                    field("Customer 5 Name"; Rec."Customer 5 Name")
                    {
                        ApplicationArea = All;
                    }

                    field("Balance Cust 5 (LCY)"; Rec."Balance Cust 5 (LCY)")
                    {
                        ApplicationArea = All;
                    }
                }


            }

            group(InvestingObject)
            {
                Caption = 'Investment object';

                field("Investing Object"; Rec."Object of Investing")
                {
                    ApplicationArea = All;
                }

                field("Investing Object Description"; lrApartments.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                }

                field("Apartment Amount IO"; Rec."Apartment Amount")
                {
                    ApplicationArea = All;
                }

                field(Finishing; Rec.Finishing)
                {
                    ApplicationArea = All;
                }

                field("Including Finishing Price"; Rec."Including Finishing Price")
                {
                    ApplicationArea = All;
                }

                field("CRM GUID"; Rec."CRM GUID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

            }

            group(ShareholdersDetails)
            {
                Caption = 'Shareholders details';

                field("Contact 1"; Rec."Contact 1")
                {
                    ApplicationArea = All;
                }
                field("C1 Name"; Rec."C1 Name")
                {
                    ApplicationArea = All;
                }

                field("C1 Telephone"; Rec."C1 Telephone")
                {
                    ApplicationArea = All;
                }

                field("C1 Passport Series"; Rec."C1 Passport Series")
                {
                    ApplicationArea = All;
                }

                field("C1 Delivery of passport"; Rec."C1 Delivery of passport")
                {
                    ApplicationArea = All;
                }

                field("C1 Passport No."; Rec."C1 Passport No.")
                {
                    ApplicationArea = All;
                }

                field("C1 Registration"; Rec."C1 Registration")
                {
                    ApplicationArea = All;
                }

                //долевой взнос %/сумма
                field("Amount part 1"; Rec."Amount part 1")
                {
                    ApplicationArea = All;
                }
                field("Amount part 1 Amount"; rec."Amount part 1 Amount")
                {
                    ApplicationArea = All;
                }

                //рассрочка % год/сумма
                field("Installment plan 1 %"; Rec."Installment plan 1 %")
                {
                    ApplicationArea = All;
                }


                field("BalanceCust1Req"; Rec."Balance Cust 1 (LCY)")
                {
                    ApplicationArea = All;
                }

                //"Amount part 1 Amount"+"Installment plan 1 Amount"+"Balance Cust 1 (LCY)"
                field("RemainingAmtLCYReq"; "Amount part 1 Amount" + "Balance Cust 1 (LCY)")
                {
                    ApplicationArea = All;
                }

                field("C1 Place and BirthDate"; Rec."C1 Place and BirthDate")
                {
                    ApplicationArea = All;
                }

                group(Shareholder2Req)
                {
                    Caption = 'Shareholder 2 details';

                    field("Contact 2"; Rec."Contact 2")
                    {
                        ApplicationArea = All;
                    }

                    field("C2 name"; Rec."C2 name")
                    {
                        ApplicationArea = All;
                    }

                    field(C2TelephoneReq; Rec."C2 Telephone")
                    {
                        ApplicationArea = All;
                    }


                    field("Amount part 2"; Rec."Amount part 2")
                    {
                        ApplicationArea = All;
                    }

                    field("Amount part 2 Amount"; Rec."Amount part 2 Amount")
                    {
                        ApplicationArea = All;
                    }

                    field(BalanceCust2LCYReq; Rec."Balance Cust 2 (LCY)")
                    {
                        ApplicationArea = All;
                    }

                }

                group(Shareholder3Req)
                {
                    Caption = 'Shareholder 3 details';

                    field("Contact 3"; Rec."Contact 3")
                    {
                        ApplicationArea = All;
                    }

                    field("C3 name"; Rec."C3 name")
                    {
                        ApplicationArea = All;
                    }

                    field(C3TelephoneReq; Rec."C3 Telephone")
                    {
                        ApplicationArea = All;
                    }


                    field("Amount part 3"; Rec."Amount part 3")
                    {
                        ApplicationArea = All;
                    }

                    field("Amount part 3 Amount"; Rec."Amount part 3 Amount")
                    {
                        ApplicationArea = All;
                    }

                    field(BalanceCust3LCYReq; Rec."Balance Cust 3 (LCY)")
                    {
                        ApplicationArea = All;
                    }

                }

                group(Shareholder4Req)
                {
                    Caption = 'Shareholder 4 details';

                    field("Contact 4"; Rec."Contact 4")
                    {
                        ApplicationArea = All;
                    }

                    field("C4 name"; Rec."C4 name")
                    {
                        ApplicationArea = All;
                    }

                    field(C4TelephoneReq; Rec."C4 Telephone")
                    {
                        ApplicationArea = All;
                    }


                    field("Amount part 4"; Rec."Amount part 4")
                    {
                        ApplicationArea = All;
                    }

                    field("Amount part 4 Amount"; Rec."Amount part 4 Amount")
                    {
                        ApplicationArea = All;
                    }

                    field(BalanceCust4LCYReq; Rec."Balance Cust 4 (LCY)")
                    {
                        ApplicationArea = All;
                    }

                }

                group(Shareholder5Req)
                {
                    Caption = 'Shareholder 5 details';

                    field("Contact 5"; Rec."Contact 5")
                    {
                        ApplicationArea = All;
                    }

                    field("C5 name"; Rec."C5 name")
                    {
                        ApplicationArea = All;
                    }

                    field(C5TelephoneReq; Rec."C5 Telephone")
                    {
                        ApplicationArea = All;
                    }


                    field("Amount part 5"; Rec."Amount part 5")
                    {
                        ApplicationArea = All;
                    }

                    field("Amount part 5 Amount"; Rec."Amount part 5 Amount")
                    {
                        ApplicationArea = All;
                    }

                    field(BalanceCust5LCYReq; Rec."Balance Cust 5 (LCY)")
                    {
                        ApplicationArea = All;
                    }

                }


            }
        }
    }

    actions
    {
    }


    trigger OnAfterGetRecord()
    begin
        //BC to-do
        /*
        CanDelete := FALSE;

        IF Finishing THEN
            CurrPage."Including Finishing Price".EDITABLE := TRUE ELSE
            CurrPage."Including Finishing Price".EDITABLE := FALSE;

        IF Status <> Status::Procesed THEN SetEditable(FALSE) ELSE SetEditable(TRUE);
        IF Status = Status::"Change conditions" THEN SetEditable(TRUE);

        grUS.GET(USERID);
        grUS.TESTFIELD("Salespers./Purch. Code");
        grSP.SETRANGE(Code, grUS."Salespers./Purch. Code");
        IF grSP.FIND('-') THEN BEGIN
            // MESSAGE(FORMAT(grSP."Super Sale"));
            IF grSP."Super Sale" THEN SetEditable(TRUE);
        END;

        IF (Status <> Status::Procesed) AND (Status <> Status::"Change conditions") THEN BEGIN
            CurrPage.Cr1.VISIBLE := FALSE;
            //CurrForm.Cr2.VISIBLE:=FALSE;
            //CurrForm.Cr3.VISIBLE:=FALSE;
            CurrPage.RList.VISIBLE := FALSE;
            CurrPage.BList.VISIBLE := FALSE;
            CurrPage.UpdatePrice.VISIBLE := FALSE;
        END
        ELSE BEGIN
            CurrPage.Cr1.VISIBLE := TRUE;
            //CurrForm.Cr2.VISIBLE:=TRUE;
            //CurrForm.Cr3.VISIBLE:=TRUE;
            CurrPage.RList.VISIBLE := TRUE;
            CurrPage.BList.VISIBLE := TRUE;
            CurrPage.UpdatePrice.VISIBLE := TRUE;
        END;


        GetObjValue;

        IF "Share in property 3" = "Share in property 3"::Owner2 THEN BEGIN
            CurrPage.c2n.VISIBLE := TRUE;
            CurrPage.c2name.VISIBLE := TRUE;
            CurrPage.d2fr.VISIBLE := TRUE;
            CurrPage.bAL2.VISIBLE := TRUE;
            CurrPage.sep1.VISIBLE := TRUE;

            CurrPage.c3n.VISIBLE := FALSE;
            CurrPage.c3name.VISIBLE := FALSE;
            CurrPage.d3fr.VISIBLE := FALSE;
            CurrPage.sep2.VISIBLE := FALSE;
            CurrPage.bal3.VISIBLE := FALSE;

            CurrPage."Amount part 1".EDITABLE := TRUE;
            CurrPage."Amount part 1 Amount".EDITABLE := TRUE;
        END;

        IF "Share in property 3" = "Share in property 3"::Owner3 THEN BEGIN
            CurrPage.c2n.VISIBLE := TRUE;
            CurrPage.c2name.VISIBLE := TRUE;
            CurrPage.bAL2.VISIBLE := TRUE;
            CurrPage.d2fr.VISIBLE := TRUE;
            CurrPage.sep1.VISIBLE := TRUE;
            CurrPage."Amount part 1".EDITABLE := TRUE;
            CurrPage."Amount part 1 Amount".EDITABLE := TRUE;
            CurrPage.c3n.VISIBLE := TRUE;
            CurrPage.c3name.VISIBLE := TRUE;
            CurrPage.bal3.VISIBLE := TRUE;
            CurrPage.d3fr.VISIBLE := TRUE;
            CurrPage.sep2.VISIBLE := TRUE;
        END;


        IF "Share in property 3" = "Share in property 3"::pNo THEN BEGIN
            CurrPage.c2n.VISIBLE := FALSE;
            CurrPage.c2name.VISIBLE := FALSE;
            CurrPage.bAL2.VISIBLE := FALSE;
            CurrPage.d2fr.VISIBLE := FALSE;
            CurrPage.sep1.VISIBLE := FALSE;

            CurrPage.c3n.VISIBLE := FALSE;
            CurrPage.c3name.VISIBLE := FALSE;
            CurrPage.bal3.VISIBLE := FALSE;
            CurrPage.d3fr.VISIBLE := FALSE;
            CurrPage.sep2.VISIBLE := FALSE;

            CurrPage."Amount part 1".EDITABLE := FALSE;
            CurrPage."Amount part 1 Amount".EDITABLE := FALSE;
        END;

        // SWC1117 DD 17.11.17 >>
        CurrPage.c4n.VISIBLE := "Share in property 3" >= "Share in property 3"::Owner4;
        CurrPage.c4name.VISIBLE := "Share in property 3" >= "Share in property 3"::Owner4;
        CurrPage.d4fr.VISIBLE := "Share in property 3" >= "Share in property 3"::Owner4;
        CurrPage.sep4.VISIBLE := "Share in property 3" >= "Share in property 3"::Owner4;
        CurrPage.bal4.VISIBLE := "Share in property 3" >= "Share in property 3"::Owner4;

        CurrPage.c5n.VISIBLE := "Share in property 3" = "Share in property 3"::Owner5;
        CurrPage.c5name.VISIBLE := "Share in property 3" = "Share in property 3"::Owner5;
        CurrPage.d5fr.VISIBLE := "Share in property 3" = "Share in property 3"::Owner5;
        CurrPage.sep5.VISIBLE := "Share in property 3" = "Share in property 3"::Owner5;
        CurrPage.bal5.VISIBLE := "Share in property 3" = "Share in property 3"::Owner5;
        // SWC1117 DD 17.11.17 >>
        */
    end;

    trigger OnNewRecord(BelowxRec: boolean)
    begin
        Rec."Agreement Type" := "Agreement Type"::"Investment Agreement";
    end;

    trigger OnDeleteRecord(): boolean
    begin
        //BC to-do
        //IF NOT CanDelete THEN ERROR(TEXT0007);
    end;

    trigger OnOpenPage()
    begin
    end;


    var
        gcduERPC: Codeunit "ERPC Funtions";
        lrApartments: record Apartments;
        ShareholderView: array[5] of Boolean;
        ShareHolder2InfoVisible: Boolean;
        ShareHolder3InfoVisible: Boolean;
        ShareHolder4InfoVisible: Boolean;
        ShareHolder5InfoVisible: Boolean;

    procedure GetObjValue()
    var
        lrContact: record Contact;
        lrVendor: record Vendor;
    begin
        CLEAR(lrApartments);
        IF "Object of Investing" <> '' THEN
        //NCS-441
        BEGIN
            IF NOT
            //-NCS-441
            lrApartments.GET("Object of Investing")
            //NCS-441
            THEN BEGIN
                CLEAR(lrApartments);
            END;
        END
        //-NCS-441
        ELSE
            CLEAR(lrApartments);

        //BC out
        /*
        IF "Bank Creditor"<>'' THEN BEGIN
          lrVendor.GET("Bank Creditor");
          VendName:=lrVendor."Full Name";
          VendAddress:=lrVendor.Address;
        END;
        */
    end;


}