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
        ParsingResult: Dictionary of [Text, Text];
    begin
        WebRequestQueue.CalcFields("Request Body");
        WebRequestQueue."Request Body".CreateInStream(InStrm);
        InStrm.Read(RequestBodyXmlText);
        FetchObjects(FetchedObjectBuff, RequestBodyXmlText);

        PickupPrefetchedObjects(FetchedObjectBuff);

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
        RootXmlElement, XmlElem : XmlElement;
        ObjXmlNode: XmlNode;
        ObjXmlBase64: text;
    begin
        FetchedObjectsTemp.Reset();
        FetchedObjectsTemp.DeleteAll();
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

    local procedure PickupPrefetchedObjects(var FetchedObjectsTemp: Record "CRM Prefetched Object")
    var
        PrefetchedObj: Record "CRM Prefetched Object";
    begin
        PrefetchedObj.Reset();
        if PrefetchedObj.FindSet() then
            repeat
                FetchedObjectsTemp := PrefetchedObj;
                if FetchedObjectsTemp.Insert() then;
            until PrefetchedObj.Next() = 0;
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
        FetchedObjectsTemp."Version Id" := GenerateHash(ObjectXmlText);
        if not FetchedObjectsTemp.Insert() then
            FetchedObjectsTemp.Modify();
    end;


    local procedure ParseObject(var FetchedObject: Record "CRM Prefetched Object"; var ParsingResult: Dictionary of [Text, Text])
    var
        HasError: Boolean;
    begin
        case FetchedObject.Type of
            FetchedObject.Type::Unit:
                hasError := not ParseUnitXml(FetchedObject, ParsingResult);
            FetchedObject.Type::Contact:
                hasError := not ParseContactXml(FetchedObject, ParsingResult);
            FetchedObject.Type::Contract:
                hasError := not ParseContractXml(FetchedObject, ParsingResult);
        end;
        if HasError then;

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

    [TryFunction]
    local procedure ParseUnitXml(var FetchedObject: Record "CRM Prefetched Object"; var ParsingResult: Dictionary of [Text, Text])
    var
        XmlElem: XmlElement;
        XmlNode: XmlNode;
        XmlNodeList: XmlNodeList;
        ElemText, ElemText2 : Text;
        BuyerNo: Integer;
        ExpectedRegDate, ActualDate, ExpectedDate : Text;
        Res: Dictionary of [Text, Text];
        CRMBuyers: Record "CRM Buyers";
        CRMCompany: Record "CRM Company";

        UnitX: Label 'NCCObjects/NCCObject/Unit/', Locked = true;
        BuyerX: label 'Buyers/Buyer', Locked = true;
        BaseDataX: Label 'NCCObjects/NCCObject/Unit/BaseData/', Locked = true;
        ObjectParentIdX: Label 'ObjectParentID', Locked = true;
        ContactIdX: Label 'ContactID', Locked = true;
        NameX: Label 'Name', Locked = true;
        BlockNumberX: Label 'BlockNumber', Locked = True;
        ApartmentNumberX: Label 'ApartmentNumber', Locked = true;
        ApartmentOriginTypeX: Label 'ObjectAttributes/TypeOfBuildings/TypeOfBuilding/KeyName', Locked = true;
        ApartmentUnitAreaM2X: Label 'Measurements/UnitAreaM2/ActualValue', Locked = true;
        ExpectedRegDateX: Label 'KeyDates/ExpectedRegistrationPeriod', Locked = true;
        ActualDateX: Label 'KeyDates/Sales/ActualDate', Locked = true;
        ExpectedDateX: Label 'KeyDates/HandedOver/ExpectedDate', Locked = true;
        BuyerObjectIdX: Label 'BaseData/ObjectID', Locked = true;
        BuyerContactIdX: Label 'BaseData/ContactID', Locked = true;
        BuyerContractIdX: Label 'BaseData/ContractID', Locked = true;
        BuyerOwnPrcX: Label 'BaseData/OwnershipPercentage', Locked = true;
        BuyerIsActiveX: Label 'BaseData/IsActive', Locked = true;
    begin
        Clear(ParsingResult);

        CRMBuyers.Reset();
        CRMBuyers.SetRange("Unit Guid", FetchedObject.Id);
        CRMBuyers.SetRange("Version Id", FetchedObject."Version Id");
        if not CRMBuyers.IsEmpty() then
            exit;

        GetRootXmlElement(FetchedObject, XmlElem);
        GetValue(XmlElem, BaseDataX + ObjectParentIdX, ElemText);
        EVALUATE(CRMCompany."Project Guid", ElemText);
        CRMCompany.Find('=');
        if CRMCompany."Company Name" <> CompanyName() then
            exit;

        GetValue(XmlElem, BaseDataX + ContactIdX, ElemText);
        ParsingResult.Add('ReservingContactGuid', ElemText);
        GetValue(XmlElem, BaseDataX + NameX, ElemText);
        ParsingResult.Add('ObjectOfInvesting', ElemText);
        ElemText := '';
        ElemText2 := '';
        GetValue(XmlElem, BaseDataX + BlockNumberX, ElemText);
        GetValue(XmlElem, BaseDataX + ApartmentNumberX, ElemText2);
        if (ElemText + ElemText2) <> '' then
            ParsingResult.Add('ApartmentDescription', ElemText + ' ' + ElemText2);
        if GetValue(XmlElem, UnitX + ApartmentOriginTypeX, ElemText) then begin
            if ElemText <> '' then
                ParsingResult.Add('ApartmentOriginType', ElemText);
        end;
        if GetValue(XmlElem, UnitX + ApartmentUnitAreaM2X, ElemText) then begin
            if ElemText <> '' then
                ParsingResult.Add('ApartmentUnitAreaM2', ElemText);
        end;
        if GetValue(XmlElem, UnitX + ExpectedRegDateX, ElemText) then
            ExpectedRegDate := ElemText;
        if GetValue(XmlElem, UnitX + ActualDateX, ElemText) then
            ActualDate := ElemText;
        if GetValue(XmlElem, UnitX + ExpectedDateX, ElemText) then
            ExpectedDate := ElemText;

        if not XmlElem.SelectNodes(UnitX + BuyerX, XmlNodeList) then
            exit;
        if XmlNodeList.Count = 0 then
            exit;
        BuyerNo := 1;
        foreach XmlNode in XmlNodeList do begin
            XmlElem := XmlNode.AsXmlElement();
            GetValue(XmlElem, BuyerObjectIdX, ElemText);
            ParsingResult.Add(StrSubstNo('BuyerGuid%1', BuyerNo), ElemText);
            GetValue(XmlElem, BuyerContactIdX, ElemText);
            ParsingResult.Add(StrSubstNo('ContactGuid%1', BuyerNo), ElemText);
            GetValue(XmlElem, BuyerContractIdX, ElemText);
            ParsingResult.Add(StrSubstNo('ContractGuid%1', BuyerNo), ElemText);
            if GetValue(XmlElem, BuyerOwnPrcX, ElemText) then
                ParsingResult.Add(StrSubstNo('OwnershipPercentage%1', BuyerNo), ElemText);
            ElemText := '';
            if GetValue(XmlElem, BuyerIsActiveX, ElemText) then
                ParsingResult.Add(StrSubstNo('BuyerIsActive%1', BuyerNo), ElemText);
            if ElemText <> 'false' then begin
                ParsingResult.Add(StrSubstNo('ExpectedRegDate%1', BuyerNo), ExpectedRegDate);
                ParsingResult.Add(StrSubstNo('ActualDate%1', BuyerNo), ActualDate);
                ParsingResult.Add(StrSubstNo('ExpectedDate%1', BuyerNo), ExpectedDate);
            end;
            BuyerNo += 1;
        end;
    end;

    [TryFunction]
    local procedure ParseContactXml(var FetchedObject: Record "CRM Prefetched Object"; var ParsingResult: Dictionary of [Text, Text])
    var
        CRMBuyers: Record "CRM Buyers";
        Cust: Record Customer;
    begin
        Clear(ParsingResult);

        Cust.Reset();
        Cust.Setrange("CRM GUID", FetchedObject.Id);
        Cust.SetRange("Version Id", FetchedObject."Version Id");
        if Not Cust.IsEmpty then
            exit;

        CRMBuyers.Reset();
        CRMBuyers.SetRange("Contact Guid", FetchedObject.Id);
        if CRMBuyers.IsEmpty then begin
            CRMBuyers.Reset();
            CRMBuyers.Setrange("Reserving Contact Guid", FetchedObject.Id);
            if CRMBuyers.IsEmpty then
                exit;
        end;

    end;

    [TryFunction]
    local procedure ParseContractXml(var FetchedObject: Record "CRM Prefetched Object"; var ParsingResult: Dictionary of [Text, Text])
    begin

    end;

    local procedure ImportUnit(var FetchedObject: Record "CRM Prefetched Object"; ParsingResult: Dictionary of [Text, Text])
    var
        CRMBuyer: Record "CRM Buyers";
        Apartments: Record Apartments;
        Value: Text;
        BuyerNo: Integer;
        TempDT: DateTime;
    begin
        if ParsingResult.Count = 0 then
            exit;

        CRMBuyer.SetRange("Unit Guid", FetchedObject.Id);
        CRMBuyer.DeleteAll(true);

        CRMBuyer.Init();
        CRMBuyer."Unit Guid" := FetchedObject.Id;
        CRMBuyer."Version Id" := FetchedObject."Version Id";
        if ParsingResult.Get('ReservingContactGuid', Value) then
            Evaluate(CRMBuyer."Reserving Contact Guid", Value);

        if ParsingResult.Get('ObjectOfInvesting', Value) then begin
            CRMBuyer."Object of Investing" := Value;
            Apartments."Object No." := CRMBuyer."Object of Investing";
            if ParsingResult.Get('ApartmentDescription', Value) then
                Apartments.Description := Value;
            if ParsingResult.Get('ApartmentOriginType', Value) then
                Apartments."Origin Type" := CopyStr(Format(Value), 1, MaxStrLen(Apartments."Origin Type"));
            if ParsingResult.Get('ApartmentUnitAreaM2', Value) then
                if Evaluate(Apartments."Total Area (Project)", Value, 9) then;
            if not Apartments.Insert(True) then
                Apartments.Modify(True);
        end;

        if not ParsingResult.Get('BuyerGuid1', Value) then begin
            CRMBuyer.Insert(true);
            exit;
        end;

        BuyerNo := 1;
        repeat
            if not ParsingResult.Get(StrSubstNo('BuyerGuid%1', BuyerNo), Value) then
                exit
            else begin
                Evaluate(CRMBuyer."Buyer Guid", Value);
                if ParsingResult.Get(StrSubstNo('ContactGuid%1', BuyerNo), Value) then
                    Evaluate(CRMBuyer."Contact Guid", Value);
                if ParsingResult.Get(StrSubstNo('ContractGuid%1', BuyerNo), Value) then
                    Evaluate(CRMBuyer."Contract Guid", Value);
                if ParsingResult.Get(StrSubstNo('OwnershipPercentage%1', BuyerNo), Value) then
                    Evaluate(CRMBuyer."Ownership Percentage", Value, 9)
                Else
                    CRMBuyer."Ownership Percentage" := 100;
                CRMBuyer."Buyer Is Active" := true;
                if ParsingResult.Get(StrSubstNo('BuyerIsActive%1', BuyerNo), Value) then begin
                    if Value = 'false' then
                        CRMBuyer."Buyer Is Active" := false;
                end;
                if CRMBuyer."Buyer Is Active" then begin
                    CRMBuyer."Expected Registration Period" := 0;
                    if ParsingResult.Get(StrSubstNo('ExpectedRegDate%1', BuyerNo), Value) then
                        Evaluate(CRMBuyer."Expected Registration Period", Value, 9);
                    CRMBuyer."Agreement Start" := 0D;
                    if ParsingResult.Get(StrSubstNo('ActualDate%1', BuyerNo), Value) then
                        if Evaluate(TempDT, Value, 9) then
                            CRMBuyer."Agreement Start" := DT2Date(TempDT) - CRMBuyer."Expected Registration Period";
                    CRMBuyer."Agreement End" := 0D;
                    if ParsingResult.Get(StrSubstNo('ExpectedDate%1', BuyerNo), Value) then
                        if Evaluate(TempDT, Value, 9) then
                            CRMBuyer."Agreement End" := DT2Date(TempDT);
                end;
                CRMBuyer.Insert(true);
                BuyerNo += 1;
            end;
        until BuyerNo > 5;
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


    [TryFunction]
    local procedure GetRootXmlElement(var FetchedObject: record "CRM Prefetched Object"; var RootXmlElement: XmlElement)
    var
        InStrm: InStream;
        XmlDoc: XmlDocument;
    begin
        FetchedObject.CalcFields(Xml);
        FetchedObject.Testfield(xml);
        FetchedObject.Xml.CreateInStream(InStrm);
        if not TryLoadXml(InStrm, XmlDoc) then
            Error(GetLastErrorText());
        XmlDoc.GetRoot(RootXmlElement);
    end;


    [TryFunction]
    local procedure GetRootXmlElement(InputXmlText: Text; var RootXmlElement: XmlElement)
    var
        XmlDoc: XmlDocument;
    begin
        if not TryLoadXml(InputXmlText, XmlDoc) then
            Error(GetLastErrorText());
        XmlDoc.GetRoot(RootXmlElement);
    end;

    [TryFunction]
    local procedure GetValue(XmlElem: XmlElement; xpath: Text; var Value: Text)
    var
        XmlNode: XmlNode;
    begin
        XmlElem.SelectSingleNode(xpath, XmlNode);
        Value := GetXmlElementText(XmlNode);
    end;

    local procedure LogEvent(var FetchedObject: Record "CRM Prefetched Object"; LogStatus: Enum "CRM Log Status"; MsgText: Text)
    var
        Log: Record "CRM Log";
    begin
        if not Log.FindLast() then
            Log."Entry No." := 1L
        else
            Log."Entry No." += 1;
        Log."Object Id" := FetchedObject.Id;
        Log."Object Type" := FetchedObject.Type;
        Log."Object Xml" := FetchedObject.Xml;
        Log."Object Version Id" := FetchedObject."Version Id";
        Log."Web Request Queue Id" := FetchedObject."Web Request Queue Id";
        Log.Datetime := CurrentDateTime;
        Log.Status := LogStatus;
        Log."Details Text 1" := CopyStr(MsgText, 1, MaxStrLen(Log."Details Text 1"));
        Log."Details Text 2" := CopyStr(MsgText, MaxStrLen(Log."Details Text 1") + 1, MaxStrLen(Log."Details Text 2"));
        Log.Insert();
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
