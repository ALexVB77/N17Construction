codeunit 99930 "CRM Integration API"
{
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;

    procedure ImportObject(crmObjects: Text): Text
    var
        content: Text;
    begin
        exit(crmObjects);
    end;
}
