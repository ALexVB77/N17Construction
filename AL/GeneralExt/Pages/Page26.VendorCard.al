pageextension 80026 "Vendor Card (Ext)" extends "Vendor Card"
{
    layout
    {
        addafter("Tax Authority No.")
        {
            field("Vat Agent Posting Group"; Rec."Vat Agent Posting Group")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addlast(Receiving)
        {
            field("Giv. Manuf. Location Code"; Rec."Giv. Manuf. Location Code")
            {
                ApplicationArea = All;
            }
            field("Giv. Manuf. Bin Code"; Rec."Giv. Manuf. Bin Code")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast("F&unctions")
        {
            action(CreateGivenedBin)
            {
                ApplicationArea = All;
                Caption = 'Create Giv. Bin';
                Image = CreateBins;
                Description = 'NC 51411 EP';

                trigger OnAction()
                begin
                    // SWC816 AK 190416 >>
                    Rec.CreateGivenedBin();
                    // SWC816 AK 190416 <<
                end;
            }
        }
    }
}