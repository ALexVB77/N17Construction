codeunit 99933 "CRM Import Objects"
{
    trigger OnRun()
    begin
        Code
    end;

    var
        CrmWorker: Codeunit "CRM Worker";

    local procedure Code()
    var
        FetchedObject: Record "CRM Prefetched Object";
    begin
        FetchedObject.Setrange("Company name");

    end;
}
