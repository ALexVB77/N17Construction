pageextension 80370 "Bank Account Card Ext" extends "Bank Account Card"
{
    layout
    {
        addafter("Bank Acc. Posting Group")
        {
            field("Max Len. Pmt Purpose Text"; Rec."Max Len. Pmt Purpose Text")
            {
                ApplicationArea = Basic, Suite;
            }
        }

    }

    actions
    {

    }
}