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

                field("Hand over status"; gcduERPC.GetAgreementActStatus("No."))
                {
                    ApplicationArea = All;
                    Caption = 'Hand over status';
                }

            }
        }
    }

    actions
    {
    }

    var
        gcduERPC: Codeunit "ERPC Funtions";
}