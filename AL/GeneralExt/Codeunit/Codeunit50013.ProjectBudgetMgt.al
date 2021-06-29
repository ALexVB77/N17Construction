codeunit 50013 "Project Budget Management"
{
    trigger OnRun()
    begin

    end;

    procedure DeleteSTLine(pPrBudEntry: Record "Projects Budget Entry")
    var
        lUS: Record "User Setup";
        lPrBudEntry: Record "Projects Budget Entry";
        lTextErr001: Label 'Deleting long-term entries denied!';
        lTextErr002: Label 'Entry %1 is linked to payment document %2. Deleting denied!';
        lTextErr003: Label 'You do not have sufficient rights to perform the action!';

    begin
        lUS.Get(UserId);
        if not (lUS."CF Allow Long Entries Edit" or lUS."CF Allow Short Entries Edit") then
            Error(lTextErr003);

        if pPrBudEntry.GetFilters = '' then
            exit;
        if pPrBudEntry.FindSet() then
            repeat
                if (pPrBudEntry."Parent Entry" = 0) or (pPrBudEntry."Parent Entry" = pPrBudEntry."Entry No.") then
                    Error(lTextErr001);
                pPrBudEntry.CalcFields("Payment Doc. No.");
                if pPrBudEntry."Payment Doc. No." <> '' then
                    Error(lTextErr002);
                lPrBudEntry.Get(pPrBudEntry."Parent Entry");
                lPrBudEntry."Without VAT (LCY)" := lPrBudEntry."Without VAT (LCY)" + pPrBudEntry."Without VAT (LCY)";
                lPrBudEntry.Modify(false);
                pPrBudEntry.Delete(true);
            until pPrBudEntry.Next() = 0;
    end;
}