codeunit 70000 "ERPC Funtions"
{
    trigger OnRun()
    begin
    end;

    procedure PostForecastEntry(grPH: Record "Purchase Header")
    begin
        message('Call function PostForecastEntry() in CU 70000 ERPC Funtions')
    end;

    procedure UnpostForecastEntry(grPH: Record "Purchase Header")
    begin
        message('Call function UppostForecastEntry() in CU 70000 ERPC Funtions')
    end;

    procedure GetCommited(pAgreement: Code[20]; pCP: Code[20]; pCC: Code[20]) ReturnValue: Decimal
    var
        lrProjectsBudgetEntry: Record "Projects Budget Entry";
    begin
        lrProjectsBudgetEntry.SETCURRENTKEY("Work Version", "Agreement No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        lrProjectsBudgetEntry.SETRANGE("Work Version", TRUE);
        lrProjectsBudgetEntry.SETRANGE("Agreement No.", pAgreement);

        IF pCP <> '' THEN
            lrProjectsBudgetEntry.SETRANGE("Shortcut Dimension 1 Code", pCP);
        IF pCC <> '' THEN
            lrProjectsBudgetEntry.SETRANGE("Shortcut Dimension 2 Code", pCC);

        lrProjectsBudgetEntry.CALCSUMS("Without VAT");

        ReturnValue += lrProjectsBudgetEntry."Without VAT";
    end;
}