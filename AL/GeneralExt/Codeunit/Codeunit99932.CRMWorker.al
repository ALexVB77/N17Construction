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
        PrefetchedObj: Record "CRM Prefetched Object";
        InStrm: InStream;
        RequestBodyXmlText: Text;
    begin
        FetchedObjectBuff.Reset();
        FetchedObjectBuff.DeleteAll();
        WebRequestQueue.CalcFields("Request Body");
        WebRequestQueue."Request Body".CreateInStream(InStrm);
        InStrm.Read(RequestBodyXmlText);
        FetchObjects(FetchedObjectBuff, RequestBodyXmlText);

        if PrefetchedObj.FindSet() then
            repeat
                FetchedObjectBuff := PrefetchedObj;
                if FetchedObjectBuff.Insert() then;
            until PrefetchedObj.Next() = 0;
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
        XmlDoc: XmlDocument;
        RootXmlElement, XmlElem : XmlElement;
        XmlNode: XmlNode;
        ObjectXmlText: Text;
        ObjectType: Text;
        ObjectIdText: Text;
        ParentObjectIdText: Text;
        OutStrm: OutStream;

    begin
        ObjectXmlText := Base64Convert.FromBase64(Base64EncodedObjectXml);
        if not TryLoadXml(ObjectXmlText, XmlDoc) then
            Error('Bad object xml');
        if not XmlDoc.GetRoot(RootXmlElement) then
            Error('Root element of object is not found');
        RootXmlElement.SelectSingleNode('Publisher/IntegrationInformation', XmlNode);
        XmlElem := XmlNode.AsXmlElement();
        ObjectType := XmlElem.InnerText;
        case UpperCase(ObjectType) of
            'UNIT':
                begin
                    RootXmlElement.SelectSingleNode('NCCObjects/NCCObject/Unit/BaseData/ObjectID', XmlNode);
                    XmlElem := XmlNode.AsXmlElement();
                    ObjectIdText := XmlElem.InnerText;
                end;
            'CONTACT':
                begin
                    RootXmlElement.SelectSingleNode('NCCObjects/NCCObject/Contact/BaseData/ObjectID', XmlNode);
                    XmlElem := XmlNode.AsXmlElement();
                    ObjectIdText := XmlElem.InnerText;
                end;
            'CONTRACT':
                begin
                    RootXmlElement.SelectSingleNode('NCCObjects/NCCObject/Contract/BaseData/ObjectID', XmlNode);
                    XmlElem := XmlNode.AsXmlElement();
                    ObjectIdText := XmlElem.InnerText;
                    RootXmlElement.SelectSingleNode('NCCObjects/NCCObject/Contract/BaseData/ObjectParentID', XmlNode);
                    XmlElem := XmlNode.AsXmlElement();
                    ParentObjectIdText := XmlElem.InnerText;
                end;
            else
                Error('Unknown Object Type %1', ObjectType);
        end;
        if ObjectIdText = '' then
            Error('No Object Id');
        if (UpperCase(ObjectType) = 'CONTRACT') and (ParentObjectIdText = '') then
            Error('No ParentObjectId for contract');
        FetchedObjectsTemp.Init();
        Evaluate(FetchedObjectsTemp.Id, ObjectIdText);
        Evaluate(FetchedObjectsTemp.Type, ObjectType);
        if ParentObjectIdText <> '' then
            Evaluate(FetchedObjectsTemp.ParentId, ParentObjectIdText);
        FetchedObjectsTemp.Xml.CreateOutStream(OutStrm);
        OutStrm.Write(ObjectXmlText);
        FetchedObjectsTemp.Checksum := GenerateHash(ObjectXmlText);
        if not FetchedObjectsTemp.Insert() then
            FetchedObjectsTemp.Modify();
    end;

    [TryFunction]
    local procedure TryLoadXml(XmlText: Text; var XmlDoc: XmlDocument)
    begin
        XmlDocument.ReadFrom(XmlText, XmlDoc);
    end;

    local procedure GenerateHash(InputText: Text) Hash: Text[40]
    var
        CM: Codeunit "Cryptography Management";
    begin
        exit(CopyStr(CM.GenerateHash(InputText, 1), 1, 40)); //SHA1
    end;

    local procedure DebugPrint(XmlText: Text; Tag: Text)
    var
        Log: Record "CRM Log";
        OutStrm: OutStream;
    begin
        Log.Init();
        if not Log.FindLast() then
            Log."Entry No." := 1L
        else
            Log."Entry No." += 1;
        Log.Datetime := CurrentDateTime;
        Log."Details Text 1" := Tag;
        Log."Object Xml".CreateOutStream(OutStrm);
        OutStrm.Write(XmlText);
        Log.Insert(true);
        Commit();
    end;

}
