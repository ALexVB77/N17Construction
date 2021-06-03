codeunit 99930 "CRM Integration API"
{
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;

    procedure ImportObject(crmObjects: Text): Text
    var
        XmlDoc: XmlDocument;
        XmlNodes: XmlNodeList;
        RootXmlElement: XmlElement;
        ObjXmlNode: XmlNode;
        XmlElem: XmlElement;
        c: Integer;
        tmp: Text;
    begin
        if not TryLoadXml(crmObjects, XmlDoc) then
            Error('bad content body');

        if not XmlDoc.GetRoot(RootXmlElement) then
            Error('There is not root');

        if not RootXmlElement.SelectNodes('//crm_objects/object', XmlNodes) then
            Error('Wrong xpath');

        if XmlNodes.Count = 0 then
            Error('There are no Objects xml');

        foreach ObjXmlNode in XmlNodes do begin
            XmlElem := ObjXmlNode.AsXmlElement();

            Tmp += CopyStr(XmlElem.InnerText, 14744, 10) + '----';

        end;
        //c := XmlNodes.Count;
        exit(StrSubstNo('Ok %1', Tmp));
    end;


    [TryFunction]
    local procedure TryLoadXml(XmlText: Text; var XmlDoc: XmlDocument)
    begin
        XmlDocument.ReadFrom(XmlText, XmlDoc);
    end;


}
