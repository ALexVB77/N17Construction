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
        ParsingResult: Dictionary of [Text, Text];
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

        FetchedObjectBuff.Reset();
        FetchedObjectBuff.FindSet();
        repeat
            ParseObject(FetchedObjectBuff, ParsingResult);
            ImportObject(FetchedObjectBuff, ParsingResult);
        until FetchedObjectBuff.Next() = 0;
    end;

    local procedure FetchObjects(var FetchedObjectsTemp: Record "CRM Prefetched Object"; RequestBodyXmlText: Text): Text
    var
        XmlNodes: XmlNodeList;
        RootXmlElement: XmlElement;
        ObjXmlNode: XmlNode;
        XmlElem: XmlElement;
        c: Integer;
        tmp: Text;
        ObjXmlBase64: text;
    begin
        GetRootXmlElement(RequestBodyXmlText, RootXmlElement);
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
        RootXmlElement: XmlElement;
        XmlNode: XmlNode;
        ObjectXmlText: Text;
        ObjectType: Text;
        ObjectIdText: Text;
        ParentObjectIdText: Text;
        OutStrm: OutStream;
    begin
        ObjectXmlText := Base64Convert.FromBase64(Base64EncodedObjectXml);
        GetRootXmlElement(ObjectXmlText, RootXmlElement);
        RootXmlElement.SelectSingleNode('Publisher/IntegrationInformation', XmlNode);
        ObjectType := GetXmlElementText(XmlNode);
        case UpperCase(ObjectType) of
            'UNIT':
                begin
                    RootXmlElement.SelectSingleNode('NCCObjects/NCCObject/Unit/BaseData/ObjectID', XmlNode);
                    ObjectIdText := GetXmlElementText(XmlNode);
                end;
            'CONTACT':
                begin
                    RootXmlElement.SelectSingleNode('NCCObjects/NCCObject/Contact/BaseData/ObjectID', XmlNode);
                    ObjectIdText := GetXmlElementText(XmlNode);
                end;
            'CONTRACT':
                begin
                    RootXmlElement.SelectSingleNode('NCCObjects/NCCObject/Contract/BaseData/ObjectID', XmlNode);
                    ObjectIdText := GetXmlElementText(XmlNode);
                    RootXmlElement.SelectSingleNode('NCCObjects/NCCObject/Contract/BaseData/ObjectParentID', XmlNode);
                    ParentObjectIdText := GetXmlElementText(XmlNode);
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


    local procedure ParseObject(var FetchedObject: Record "CRM Prefetched Object"; var ParsingResult: Dictionary of [Text, Text])
    var
        ParsingRes: Dictionary of [Text, Text];
    begin
        case FetchedObject.Type of
            FetchedObject.Type::Unit:
                ParseUnitXml(FetchedObject, ParsingRes);
            FetchedObject.Type::Contact:
                ParseContactXml(FetchedObject, ParsingRes);
            FetchedObject.Type::Contract:
                ParseContractXml(FetchedObject, ParsingRes);
        end;
        ParsingResult := ParsingRes;
    end;

    local procedure ImportObject(var FetchedObject: Record "CRM Prefetched Object"; ParsingResult: Dictionary of [Text, Text])
    begin
        case FetchedObject.Type of
            FetchedObject.Type::Unit:
                ImportUnit(FetchedObject, ParsingResult);
            FetchedObject.Type::Contact:
                ImportContact(FetchedObject, ParsingResult);
            FetchedObject.Type::Contract:
                ImportContract(FetchedObject, ParsingResult);
        end;
    end;

    local procedure ParseUnitXml(var FetchedObject: Record "CRM Prefetched Object"; var ParsingResult: Dictionary of [Text, Text])
    var
        XmlElem: XmlElement;
        XmlNode: XmlNode;
        XmlNodeList: XmlNodeList;
        ElemText: Text;
        BaseDataNode, UnitNode : Text;
        BuyerNo: Integer;
        ExpectedRegDate, ActualDate, ExpectedDate : Text;
    begin
        UnitNode := 'NCCObjects/NCCObject/Unit/';
        BaseDataNode := 'NCCObjects/NCCObject/Unit/BaseData/';

        GetRootXmlElement(FetchedObject, XmlElem);
        if GetValue(XmlElem, BaseDataNode + 'ContactID', ElemText) then
            Error('ContactID is not found');
        ParsingResult.Add('ReservingContactGuid', ElemText);

        if GetValue(XmlElem, BaseDataNode + 'Name', ElemText) then
            Error('Object Of Investing is not found');
        ParsingResult.Add('ObjectOfInvesting', ElemText);

        if GetValue(XmlElem, UnitNode + 'KeyDates/ExpectedRegistrationPeriod', ElemText) then
            ExpectedRegDate := ElemText;
        if GetValue(XmlElem, UnitNode + 'KeyDates/Sales/ActualDate', ElemText) then
            ActualDate := ElemText;
        if GetValue(XmlElem, UnitNode + 'KeyDates/HandedOver/ExpectedDate', ElemText) then
            ExpectedDate := ElemText;

        if not XmlElem.SelectNodes(UnitNode + 'Buyers/Buyer', XmlNodeList) then
            exit;
        if XmlNodeList.Count = 0 then
            Error('No Buyers');
        BuyerNo := 1;
        foreach XmlNode in XmlNodeList do begin
            XmlElem := XmlNode.AsXmlElement();
            if not GetValue(XmlElem, 'BaseData/ObjectID', ElemText) then
                Error('Buyer has not BaseData/ObjectID');
            ParsingResult.Add(StrSubstNo('BuyerGuid%1', BuyerNo), ElemText);

            if not GetValue(XmlElem, 'BaseData/ContactID', ElemText) then
                Error('Buyer has not BaseData/ContactID');
            ParsingResult.Add(StrSubstNo('ContactGuid%1', BuyerNo), ElemText);

            if not GetValue(XmlElem, 'BaseData/ContractID', ElemText) then
                Error('Buyer has not BaseData/ContractID');
            ParsingResult.Add(StrSubstNo('ContractGuid%1', BuyerNo), ElemText);

            if GetValue(XmlElem, 'BaseData/OwnershipPercentage', ElemText) then
                ParsingResult.Add(StrSubstNo('OwnershipPercentage%1', BuyerNo), ElemText);

            ElemText := '';
            if GetValue(XmlElem, 'BaseData/IsActive', ElemText) then
                ParsingResult.Add(StrSubstNo('BuyerIsActive%1', BuyerNo), ElemText);
            if ElemText <> 'false' then begin
                ParsingResult.Add(StrSubstNo('ExpectedRegDate%1', BuyerNo), ExpectedRegDate);
                ParsingResult.Add(StrSubstNo('ActualDate%1', BuyerNo), ActualDate);
                ParsingResult.Add(StrSubstNo('ExpectedDate%1', BuyerNo), ExpectedDate);
            end;

            BuyerNo += 1;
        end;

    end;


    local procedure ParseContactXml(var FetchedObject: Record "CRM Prefetched Object"; var ParsingResult: Dictionary of [Text, Text])
    begin

    end;


    local procedure ParseContractXml(var FetchedObject: Record "CRM Prefetched Object"; var ParsingResult: Dictionary of [Text, Text])
    begin

    end;

    local procedure ImportUnit(var FetchedObject: Record "CRM Prefetched Object"; ParsingResult: Dictionary of [Text, Text])
    begin

    end;

    local procedure ImportContact(var FetchedObject: Record "CRM Prefetched Object"; ParsingResult: Dictionary of [Text, Text])
    begin

    end;

    local procedure ImportContract(var FetchedObject: Record "CRM Prefetched Object"; ParsingResult: Dictionary of [Text, Text])
    begin

    end;

    local procedure GenerateHash(InputText: Text) Hash: Text[40]
    var
        CM: Codeunit "Cryptography Management";
    begin
        exit(CopyStr(CM.GenerateHash(InputText, 1), 1, 40)); //SHA1
    end;


    [TryFunction]
    local procedure TryLoadXml(XmlText: Text; var XmlDoc: XmlDocument)
    begin
        XmlDocument.ReadFrom(XmlText, XmlDoc);
    end;

    [TryFunction]
    local procedure TryLoadXml(InStream: InStream; var XmlDoc: XmlDocument)
    begin
        XmlDocument.ReadFrom(InStream, XmlDoc);
    end;

    local procedure GetXmlElementText(XmlNode: XmlNode) Result: Text;
    var
        XmlElem: XmlElement;
    begin
        XmlElem := XmlNode.AsXmlElement();
        Result := XmlElem.InnerText;
    end;


    local procedure GetRootXmlElement(var FetchedObject: record "CRM Prefetched Object"; var RootXmlElement: XmlElement)
    var
        InStrm: InStream;
        XmlDoc: XmlDocument;
    begin
        FetchedObject.CalcFields(Xml);
        if not FetchedObject.xml.HasValue() then
            Error('There is no xml of object in CRM Prefetched Object');
        FetchedObject.Xml.CreateInStream(InStrm);
        if not TryLoadXml(InStrm, XmlDoc) then
            Error('Bad object xml');
        if not XmlDoc.GetRoot(RootXmlElement) then
            Error('Root element of object is not found');
    end;

    local procedure GetRootXmlElement(InputXmlText: Text; var RootXmlElement: XmlElement)
    var
        XmlDoc: XmlDocument;
    begin
        if not TryLoadXml(InputXmlText, XmlDoc) then
            Error('Bad object xml');
        if not XmlDoc.GetRoot(RootXmlElement) then
            Error('Root element of object is not found');
    end;

    local procedure GetValue(Root: XmlElement; xpath: Text; var Value: Text) result: Boolean
    var
        XmlNode: XmlNode;
    begin
        result := false;
        if not Root.SelectSingleNode(xpath, XmlNode) then
            exit;
        Value := GetXmlElementText(XmlNode);
        result := true;
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
