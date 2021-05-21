pageextension 80460 "Purchases & Payab. Setup (Ext)" extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("M-4 Template Code")
        {
            field("Vendor Agreement Template Code"; Rec."Vendor Agreement Template Code")
            {
                ApplicationArea = All;
            }
        }
        addlast("content")
        {
            group("Payment requests")
            {
                Caption = 'Payment requests';
                field("Base Vendor No."; Rec."Base Vendor No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Default Estimator"; Rec."Default Estimator")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Payment Delay Period"; Rec."Payment Delay Period")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Cost Place Dimension"; Rec."Cost Place Dimension")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Skip Check CF Forecast Filter"; Rec."Skip Check CF Forecast Filter")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Zero VAT Prod. Posting Group"; Rec."Zero VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
}