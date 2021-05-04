codeunit 50010 "Payment Order Management"
{
    trigger OnRun()
    begin

    end;

    procedure FuncNewRec(PurchHeader: Record "Purchase Header"; ActTypeOption: enum "Purchase Act Type")
    var
        grUS: record "User Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        WhseEmployee: record "Warehouse Employee";
        grPurchHeader: Record "Purchase Header";
        Location: Record Location;
        // Text50000: Label 'У вас нет прав на создание документа. Данные права имеет контролер.';
        Text50000: Label 'You do not have permission to create the document. The controller has these rights.';
        Text50003: Label 'Warehouse document,Act/KS-2 for the service';
        Text50004: Label 'Select the type of document to create.';
        Text50005: Label 'It is required to select the type of document.';
        LocErrorText1: Label 'The estimator cannot create a document with the type Act!';
        Selected: Integer;
    begin
        grUS.GET(USERID);
        IF NOT (grUS."Status App Act" IN [grUS."Status App Act"::Сontroller, grUS."Status App Act"::Estimator]) then begin
            MESSAGE(Text50000);
            EXIT;
        end;
        if (ActTypeOption in [ActTypeOption::Act, ActTypeOption::"Act (Production)"]) and (grUS."Status App Act" = grUS."Status App Act"::Estimator) then
            ERROR(LocErrorText1);

        PurchSetup.GET;
        PurchSetup.TestField("Base Vendor No.");

        with grPurchHeader do begin
            RESET;
            INIT;
            "No." := '';
            "Document Type" := "Document Type"::Order;
            "Pre-booking Document" := TRUE;
            "Act Type" := ActTypeOption;
            INSERT(TRUE);
            VALIDATE("Buy-from Vendor No.", PurchSetup."Base Vendor No.");

            IF WhseEmployee.get(UserId) THEN BEGIN
                Selected := DIALOG.STRMENU(Text50003, 1, Text50004);
                CASE Selected OF
                    1:
                        BEGIN
                            "Location Document" := TRUE;
                            Storekeeper := USERID;
                            Location.GET(WhseEmployee.GetDefaultLocation('', TRUE));
                            Location.TESTFIELD("Bin Mandatory", FALSE);
                            VALIDATE("Location Code", Location.Code);
                        END;
                    2:
                        ;
                    ELSE
                        ERROR(Text50005);
                END;
            END;

            "Status App Act" := "Status App Act"::Controller;
            "Process User" := USERID;
            "Request Payment Doc Type" := TRUE;
            "Date Status App" := TODAY;
            Controller := USERID;
            if "Act Type" in ["Act Type"::"KC-2", "Act Type"::"KC-2 (Production)"] then
                if PurchSetup."Default Estimator" <> '' then
                    Estimator := PurchSetup."Default Estimator";
            grPurchHeader.MODIFY(TRUE);

            // COMMIT;
            // PAGE.RUNMODAL(PAGE::"Purchase Order Act", grPurchHeader);
            ERROR('Must open form "Purchase Order Act"');
        end;
    end;

}