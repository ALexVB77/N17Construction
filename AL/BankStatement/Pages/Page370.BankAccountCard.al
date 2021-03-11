pageextension 99999 "Bank Account Card BS" extends "Bank Account Card"
{
    layout
    {
        addafter(Transfer)
        {
            group(ClientBank)
            {
                Caption = 'Client Bank';
                field("Check Description for Import"; Rec."Check Description for Import")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

}