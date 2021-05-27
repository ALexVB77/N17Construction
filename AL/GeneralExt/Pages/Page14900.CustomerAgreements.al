pageextension 84900 "Customer Agreements (Ext)" extends "Customer Agreements"
{
    layout
    {
        addfirst(Control1210002)
        {
            field("Agreement Type"; Rec."Agreement Type")
            {
                ApplicationArea = All;
            }
        }

        addlast(Control1210002)
        {
            field("CRM GUID"; Rec."CRM GUID")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}