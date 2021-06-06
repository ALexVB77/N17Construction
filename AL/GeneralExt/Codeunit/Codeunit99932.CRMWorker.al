codeunit 99932 "CRM Worker"
{
    TableNo = "Web Request Queue";

    trigger OnRun()
    begin
        Code(Rec);
    end;


    local procedure Code(var WebRequestQueue: Record "Web Request Queue")
    var
        FetchedObjectBuff: Record "CRM Prefetched Object" temporary;
        InStrm: InStream;
        RequestBodyXmlText: Text;
    begin
        FetchedObjectBuff.Reset();
        FetchedObjectBuff.DeleteAll();
        WebRequestQueue.CalcFields("Request Body");
        WebRequestQueue."Request Body".CreateInStream(InStrm);
        InStrm.Read(RequestBodyXmlText);
        FetchObjects(FetchedObjectBuff, RequestBodyXmlText);
    end;

    local procedure FetchObjects(var FetchedObjectsTemp: Record "CRM Prefetched Object"; RequestBodyXmlText: Text): Text
    var
        XmlDoc: XmlDocument;
        XmlNodes: XmlNodeList;
        RootXmlElement: XmlElement;
        ObjXmlNode: XmlNode;
        XmlElem: XmlElement;
        c: Integer;
        tmp: Text;
        ObjXmlBase64: text;
    begin
        if not TryLoadXml(RequestBodyXmlText, XmlDoc) then
            Error('bad content body');

        if not XmlDoc.GetRoot(RootXmlElement) then
            Error('Root element of envelope is not found');

        if not RootXmlElement.SelectNodes('//crm_objects/object', XmlNodes) then
            Error('Wrong soap envelope structure');

        if XmlNodes.Count = 0 then
            Error('There are no CRM objects in request');

        foreach ObjXmlNode in XmlNodes do begin
            XmlElem := ObjXmlNode.AsXmlElement();
            ObjXmlBase64 := XmlElem.InnerText;
            GetObjectMeta(FetchedObjectsTemp, ObjXmlBase64);
        end;

    end;

    local procedure GetObjectMeta(var FetchedObjectsTemp: Record "CRM Prefetched Object"; Base64EncodedObjectXml: Text)
    var
        Base64Convert: Codeunit "Base64 Convert";
        ObjectXmlText: Text;
        XmlDoc: XmlDocument;
        RootXmlElement, XmlElem : XmlElement;
        XmlNode: XmlNode;
    begin
        ObjectXmlText := Base64Convert.FromBase64(Base64EncodedObjectXml);
        if not TryLoadXml(ObjectXmlText, XmlDoc) then
            Error('bad object xml');

        if not XmlDoc.GetRoot(RootXmlElement) then
            Error('Root element of object is not found');

        RootXmlElement.SelectSingleNode('Publisher/IntegrationInformation', XmlNode);
        XmlElem := XmlNode.AsXmlElement();
        Error('Object Type is %1', XmlElem.InnerText);
    end;

    [TryFunction]
    local procedure TryLoadXml(XmlText: Text; var XmlDoc: XmlDocument)
    begin
        XmlDocument.ReadFrom(XmlText, XmlDoc);
    end;

}
