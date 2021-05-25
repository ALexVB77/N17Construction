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