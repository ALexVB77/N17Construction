page 50101 "Create ST Proj Budget Entries"
{
    PageType = List;
    // ApplicationArea = All;
    // UsageCategory = Lists;
    SourceTable = "Projects Budget Entry";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Cost Code"; Rec."Cost Code")
                {
                    ApplicationArea = All;
                }
                field("Contragent No."; Rec."Contragent No.")
                {
                    ApplicationArea = All;
                }
                field("Agreement No."; Rec."Agreement No.")
                {
                    ApplicationArea = All;
                }
                field("Without VAT (LCY)"; Rec."Without VAT (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Payment Description"; Rec."Payment Description")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    var
        gProjBudEntry: Record "Projects Budget Entry";

    procedure SetProjBudEntry(pPBE: Record "Projects Budget Entry")
    begin
        gProjBudEntry := pPBE;
    end;
}