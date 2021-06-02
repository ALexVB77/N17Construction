codeunit 99930 "CRM Integration API"
{
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;

    procedure ImportObject(crmObjects: XmlDocument)
    var
        content: Text;
    begin
        crmObjects.WriteTo(content);
        Message(content);
    end;
}
