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
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
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
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Date := Today;
        Rec."Project Code" := gProjBudEntry."Project Code";
        Rec."Shortcut Dimension 1 Code" := gProjBudEntry."Shortcut Dimension 1 Code";
        Rec."Parent Entry" := gProjBudEntry."Entry No.";
        if gProjBudEntry."Shortcut Dimension 2 Code" <> '' then
            rec."Shortcut Dimension 2 Code" := gProjBudEntry."Shortcut Dimension 2 Code";
        if gProjBudEntry."Contragent No." <> '' then begin
            Rec."Contragent Type" := gProjBudEntry."Contragent Type";
            Rec."Contragent No." := gProjBudEntry."Contragent No.";
            rec."Contragent Name" := gProjBudEntry."Contragent Name";
        end;
        if gProjBudEntry."Agreement No." <> '' then begin
            Rec."Agreement No." := gProjBudEntry."Agreement No.";
            Rec."External Agreement No." := gProjBudEntry."External Agreement No.";
        end;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = Action::LookupOK then
            CreateSTLines();
    end;

    var
        gProjBudEntry: Record "Projects Budget Entry";
        gAmount: decimal;

    procedure SetProjBudEntry(pPBE: Record "Projects Budget Entry")
    begin
        gProjBudEntry := pPBE;
        gAmount := pPBE."Without VAT (LCY)";
    end;

    procedure GetResultAmount(): decimal
    begin
        exit(gAmount);
    end;

    procedure CreateSTLines()
    var
        lPBE: Record "Projects Budget Entry";
        lTextErr001: Label 'Parent Entry amount %1 exeeded by %2';
    begin
        if Rec.FindSet() then
            repeat
                lPBE := Rec;
                lPBE.insert(true);
                gAmount := gAmount - Rec."Without VAT (LCY)";
            until Rec.Next() = 0;
        if gAmount < 0 then
            Error(lTextErr001, gProjBudEntry."Without VAT (LCY)", Abs(gAmount));
    end;
}