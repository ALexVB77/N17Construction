codeunit 99932 "CRM Worker"
{
    TableNo = "Web Request Queue";

    trigger OnRun()
    begin
        Code(Rec);
    end;

    var
        //All
        ObjectTypeX: Label 'Publisher/IntegrationInformation', Locked = true;
        SoapObjectContainerX: Label '//crm_objects/object', Locked = true;

        //Unit
        UnitX: Label 'NCCObjects/NCCObject/Unit/', Locked = true;
        UnitIdX: Label 'NCCObjects/NCCObject/Unit/BaseData/ObjectID', Locked = true;
        UnitProjectIdX: Label 'NCCObjects/NCCObject/Unit/BaseData/ObjectParentID', Locked = true;
        UnitBuyerNodesX: label 'Buyers/Buyer', Locked = true;
        UnitBaseDataX: Label 'NCCObjects/NCCObject/Unit/BaseData/', Locked = true;
        ObjectParentIdX: Label 'ObjectParentID', Locked = true;
        ReservingContactX: Label 'ContactID', Locked = true;
        InvestmentObjectX: Label 'Name', Locked = true;
        BlockNumberX: Label 'BlockNumber', Locked = True;
        ApartmentNumberX: Label 'ApartmentNumber', Locked = true;
        ApartmentOriginTypeX: Label 'ObjectAttributes/TypeOfBuildings/TypeOfBuilding/KeyName', Locked = true;
        ApartmentUnitAreaM2X: Label 'Measurements/UnitAreaM2/ActualValue', Locked = true;
        ExpectedRegDateX: Label 'KeyDates/ExpectedRegistrationPeriod', Locked = true;
        ActualDateX: Label 'KeyDates/Sales/ActualDate', Locked = true;
        ExpectedDateX: Label 'KeyDates/HandedOver/ExpectedDate', Locked = true;
        UnitBuyerX: Label 'BaseData/ObjectID', Locked = true;
        UnitBuyerContactX: Label 'BaseData/ContactID', Locked = true;
        UnitBuyerContractX: Label 'BaseData/ContractID', Locked = true;
        UnitBuyerOwnershipPrcX: Label 'BaseData/OwnershipPercentage', Locked = true;
        UnitBuyerIsActiveX: Label 'BaseData/IsActive', Locked = true;

        //Contact
        ContactX: Label 'NCCObjects/NCCObject/Contact/', Locked = true;
        ContactIdX: Label 'NCCObjects/NCCObject/Contact/BaseData/ObjectID', Locked = true;
        ContactBaseDataX: Label 'NCCObjects/NCCObject/Contact/BaseData/', Locked = true;
        PersonDataX: Label 'PersonData', Locked = true;
        LastNameX: Label 'LastName', Locked = true;
        FirstNameX: Label 'FirstName', Locked = true;
        MiddleNameX: Label 'MiddleName', Locked = true;
        PhysicalAddressX: Label 'PhysicalAddresses/PhysicalAddress', Locked = true;
        PostalCityX: Label 'PostalCity', Locked = true;
        CountryCodeX: Label 'CountryCode', Locked = true;
        AddressLineX: Label 'AddressLine', Locked = true;
        PostalCodeX: Label 'PostalCode', Locked = true;
        ElectronicAddressesX: Label 'ElectronicAddresses', Locked = true;
        ElectronicAddressX: Label 'ElectronicAddress', Locked = true;
        ProtocolX: Label 'Protocol', Locked = true;
        ContactPhoneX: Label 'Phone', Locked = true;
        ContactEmailX: Label 'Email', Locked = true;
        ContactAddressLine1X: Label 'ContactAddressLine1', Locked = true;

        //Contract
        ContractX: Label 'NCCObjects/NCCObject/Contract/', Locked = true;
        ContractIdX: Label 'NCCObjects/NCCObject/Contract/BaseData/ObjectID', Locked = true;
        ContractUnitIdX: Label 'NCCObjects/NCCObject/Contract/BaseData/ObjectParentID', Locked = true;
        ContractBaseDataX: Label 'NCCObjects/NCCObject/Contract/BaseData/', Locked = true;
        ContractNoX: Label 'Name', Locked = true;
        ContractTypeX: Label 'ObjectType', Locked = true;
        ContractStatusX: Label 'ObjectStatus/KeyName', Locked = true;
        ContractCancelStatusX: Label 'CancelStatus/KeyName', Locked = true;
        ContractIsActiveX: Label 'IsActive', Locked = true;
        ExtAgreementNoX: Label 'ObjectNumber', Locked = true;
        ApartmentAmountX: Label 'FinanceData/ContractPrice', Locked = true;
        FinishingInclX: Label 'FinanceData/FullFinishingPrice', Locked = true;
        ContractBuyerNodesX: Label 'Buyers/Buyer', Locked = true;
        ContractBuyerX: Label 'BaseData/ObjectID', Locked = true;

        //Errors
        BadSoapEnvFormatErr: Label 'Bad soap envelope format';
        KeyErr: Label 'No field key is specified!';
        NoObjectIdErr: Label 'No ObjectID in XML Document';
        NoParentObjectIdErr: Label 'No ParentObjectID in XML Document';
        ProjectNotFoundErr: Label 'ProjectId %1 is not found in %2';
        UnknownObjectTypeErr: Label 'Unknown type of Object %1';




    local procedure Code(var WebRequestQueue: Record "Web Request Queue")
    var
        FetchedObjectBuff: Record "CRM Prefetched Object" temporary;
        InStrm: InStream;
        RequestBodyXmlText: Text;
        ParsedObjects: Dictionary of [Guid, Dictionary of [Text, Text]];
        LogStatusEnum: Enum "CRM Log Status";
    begin
        WebRequestQueue.CalcFields("Request Body");
        WebRequestQueue."Request Body".CreateInStream(InStrm);
        InStrm.Read(RequestBodyXmlText);
        if not FetchObjects(WebRequestQueue.Id, RequestBodyXmlText, FetchedObjectBuff) then
            exit;
        PickupPrefetchedObjects(FetchedObjectBuff);
        ParseObjects(FetchedObjectBuff, ParsedObjects);
        ImportObjects(FetchedObjectBuff, ParsedObjects);
    end;


    local procedure FetchObjects(WebRequestQueueId: Guid; RequestBodyXmlText: Text; var FetchedObjectsTemp: Record "CRM Prefetched Object") Result: Boolean
    var
        XmlCrmObjectList: XmlNodeList;
        RootXmlElement: XmlElement;
        XmlCrmObject: XmlNode;
        ObjXmlBase64: text;
        LogStatusEnum: Enum "CRM Log Status";
    begin
        Result := false;
        FetchedObjectsTemp.Reset();
        FetchedObjectsTemp.DeleteAll();
        if not GetRootXmlElement(RequestBodyXmlText, RootXmlElement) then begin
            LogEvent(WebRequestQueueId, LogStatusEnum::Error, GetLastErrorText());
            exit;
        end;
        if not RootXmlElement.SelectNodes(SoapObjectContainerX, XmlCrmObjectList) then begin
            LogEvent(WebRequestQueueId, LogStatusEnum::Error, BadSoapEnvFormatErr);
            exit;
        end;
        foreach XmlCrmObject in XmlCrmObjectList do begin
            ObjXmlBase64 := GetXmlElementText(XmlCrmObject);
            if GetObjectMeta(FetchedObjectsTemp, ObjXmlBase64) then
                Result := true
            else
                LogEvent(WebRequestQueueId, LogStatusEnum::Error, GetLastErrorText());
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

    [TryFunction]
    local procedure GetObjectMeta(var FetchedObjectsTemp: Record "CRM Prefetched Object"; Base64EncodedObjectXml: Text)
    var
        Base64Convert: Codeunit "Base64 Convert";
        XmlDoc: XmlDocument;
        RootXmlElement: XmlElement;
        ObjectXmlText: Text;
        ObjectType: Text;
        ObjectIdText: Text;
        ParentObjectIdText: Text;
        OutStrm: OutStream;
    begin
        ObjectXmlText := Base64Convert.FromBase64(Base64EncodedObjectXml);
        GetRootXmlElement(ObjectXmlText, RootXmlElement);
        GetValue(RootXmlElement, ObjectTypeX, ObjectType);
        case UpperCase(ObjectType) of
            'UNIT':
                begin
                    GetValue(RootXmlElement, UnitIdX, ObjectIdText);
                    GetValue(RootXmlElement, UnitProjectIdX, ParentObjectIdText);
                end;
            'CONTACT':
                GetValue(RootXmlElement, ContactIdX, ObjectIdText);
            'CONTRACT':
                begin
                    GetValue(RootXmlElement, ContractIdX, ObjectIdText);
                    GetValue(RootXmlElement, ContractUnitIdX, ParentObjectIdText);
                end;
            else
                Error(UnknownObjectTypeErr, ObjectType);
        end;
        if ObjectIdText = '' then
            Error(NoObjectIdErr);
        if (UpperCase(ObjectType) in ['CONTRACT', 'UNIT']) and (ParentObjectIdText = '') then
            Error(NoParentObjectIdErr);
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


    local procedure ParseObjects(var FetchedObject: Record "CRM Prefetched Object"; var ParsedObjects: Dictionary of [Guid, Dictionary of [Text, Text]])
    var
        ParsingResult: Dictionary of [Text, Text];
        HasError: Boolean;
        LogStatusEnum: Enum "CRM Log Status";
    begin
        FetchedObject.Reset();
        FetchedObject.FindSet();
        repeat
            Clear(ParsingResult);
            case FetchedObject.Type of
                FetchedObject.Type::Unit:
                    hasError := not ParseUnitXml(FetchedObject, ParsingResult);
                FetchedObject.Type::Contact:
                    hasError := not ParseContactXml(FetchedObject, ParsingResult);
                FetchedObject.Type::Contract:
                    hasError := not ParseContractXml(FetchedObject, ParsingResult);
            end;
            if HasError then
                LogEvent(FetchedObject, LogStatusEnum::Error, GetLastErrorText())
            else
                if ParsingResult.Count <> 0 then
                    ParsedObjects.Add(FetchedObject.Id, ParsingResult);
        until FetchedObject.Next() = 0;
    end;

    local procedure ImportObjects(var FetchedObject: Record "CRM Prefetched Object"; var ParsedObjects: Dictionary of [Guid, Dictionary of [Text, Text]])
    var
        ParsingResult: Dictionary of [Text, Text];
        CrmCompany: Record "CRM Company";
        LogStatusEnum: Enum "CRM Log Status";
    begin
        FetchedObject.Reset();
        FetchedObject.SetRange(Type, FetchedObject.Type::Unit);
        FetchedObject.FindSet();
        repeat
            CrmCompany.Reset();
            CrmCompany.Setrange("Project Guid", FetchedObject.ParentId);
            if not CrmCompany.FindFirst() then
                LogEvent(FetchedObject, LogStatusEnum::Error, StrSubstNo(ProjectNotFoundErr, FetchedObject.ParentId, CrmCompany.TableCaption))
            else
                ImportUnit(FetchedObject, ParsingResult);
        until FetchedObject.Next() = 0;

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
        CRMCompany: Record "CRM Company";
        OK: Boolean;
        No: Text[2];
    begin
        Clear(ParsingResult);
        if ObjectAlreadyImported(FetchedObject) then
            exit;
        GetRootXmlElement(FetchedObject, XmlElem);
        GetValue(XmlElem, JoinX(UnitBaseDataX, ObjectParentIdX), ElemText);
        EVALUATE(CRMCompany."Project Guid", ElemText);
        CRMCompany.Find('=');
        if CRMCompany."Company Name" <> CompanyName() then
            exit;
        GetObjectField(XmlElem, JoinX(UnitBaseDataX, ReservingContactX), ParsingResult, ReservingContactX);
        GetObjectField(XmlElem, JoinX(UnitBaseDataX, InvestmentObjectX), ParsingResult, InvestmentObjectX);
        OK := GetObjectField(XmlElem, JoinX(UnitBaseDataX, BlockNumberX), ParsingResult, BlockNumberX);
        OK := GetObjectField(XmlElem, JoinX(UnitBaseDataX, ApartmentNumberX), ParsingResult, ApartmentNumberX);
        OK := GetObjectField(XmlElem, JoinX(UnitX, ApartmentOriginTypeX), ParsingResult, ApartmentOriginTypeX);
        OK := GetObjectField(XmlElem, JoinX(UnitX, ApartmentUnitAreaM2X), ParsingResult, ApartmentUnitAreaM2X);
        OK := GetObjectField(XmlElem, JoinX(UnitX, ExpectedRegDateX), ParsingResult, ExpectedRegDateX);
        OK := GetObjectField(XmlElem, JoinX(UnitX, ActualDateX), ParsingResult, ActualDateX);
        OK := GetObjectField(XmlElem, JoinX(UnitX, ExpectedDateX), ParsingResult, ExpectedDateX);
        if not XmlElem.SelectNodes(JoinX(UnitX, UnitBuyerNodesX), XmlNodeList) then
            exit;
        No := '1';
        foreach XmlNode in XmlNodeList do begin
            XmlElem := XmlNode.AsXmlElement();
            GetObjectField(XmlElem, UnitBuyerX, ParsingResult, UnitBuyerX + No);
            GetObjectField(XmlElem, UnitBuyerContactX, ParsingResult, UnitBuyerContactX + No);
            GetObjectField(XmlElem, UnitBuyerContractX, ParsingResult, UnitBuyerContractX + No);
            OK := GetObjectField(XmlElem, UnitBuyerOwnershipPrcX, ParsingResult, UnitBuyerOwnershipPrcX + No);
            OK := GetObjectField(XmlElem, UnitBuyerIsActiveX, ParsingResult, UnitBuyerIsActiveX + No);
            No := IncStr(No);
        end;
    end;

    [TryFunction]
    local procedure ParseContactXml(var FetchedObject: Record "CRM Prefetched Object"; var ParsingResult: Dictionary of [Text, Text])
    var
        XmlElem: XmlElement;
        XmlNode: XmlNode;
        XmlNodeList: XmlNodeList;
        OK: Boolean;
        BaseXPath: Text;
        ElemText, ElemText2 : Text;
    begin
        Clear(ParsingResult);
        if ObjectAlreadyImported(FetchedObject) then
            exit;
        GetRootXmlElement(FetchedObject, XmlElem);
        BaseXPath := JoinX(ContactX, PersonDataX);
        GetObjectField(XmlElem, JoinX(BaseXPath, LastNameX), ParsingResult, LastNameX);
        GetObjectField(XmlElem, JoinX(BaseXPath, FirstNameX), ParsingResult, FirstNameX);
        GetObjectField(XmlElem, JoinX(BaseXPath, MiddleNameX), ParsingResult, MiddleNameX);
        BaseXPath := JoinX(ContactX, PhysicalAddressX);
        if XmlNodeExists(XmlElem, BaseXPath) then begin
            ElemText2 := '';
            Ok := GetObjectField(XmlElem, JoinX(BaseXPath, PostalCityX), ParsingResult, PostalCityX);
            Ok := GetObjectField(XmlElem, JoinX(BaseXPath, CountryCodeX), ParsingResult, CountryCodeX);
            if GetValue(XmlElem, JoinX(BaseXPath, AddressLineX + '1'), ElemText) then
                ElemText2 := ElemText;
            if GetValue(XmlElem, JoinX(BaseXPath, AddressLineX + '2'), ElemText) then begin
                if ElemText2 <> '' then
                    ElemText2 += ' ';
                ElemText2 += ElemText;
            end;
            if GetValue(XmlElem, JoinX(BaseXPath, AddressLineX + '3'), ElemText) then begin
                if ElemText2 <> '' then
                    ElemText2 += ' ';
                ElemText2 += ElemText;
            end;
            if ElemText2 <> '' then
                ParsingResult.Add(AddressLineX, ElemText2);
            Ok := GetObjectField(XmlElem, JoinX(BaseXPath, PostalCodeX), ParsingResult, PostalCodeX);
        end;
        BaseXPath := JoinX(ContactX, ElectronicAddressesX);
        if not XmlElem.SelectNodes(JoinX(BaseXPath, ElectronicAddressX), XmlNodeList) then
            exit;
        foreach XmlNode in XmlNodeList do begin
            XmlElem := XmlNode.AsXmlElement();
            if GetValue(XmlElem, ProtocolX, ElemText) and (ElemText <> '') then begin
                GetValue(XmlElem, ContactAddressLine1X, ElemText2);
                Case ElemText of
                    ContactPhoneX:
                        begin
                            if ElemText2 <> '' then
                                ParsingResult.Add(ContactPhoneX, ElemText2);
                        end;
                    ContactEmailX:
                        begin
                            if ElemText2 <> '' then
                                ParsingResult.Add(ContactEmailX, ElemText2);
                        end;
                End
            end;
        end;
    end;

    [TryFunction]
    local procedure ParseContractXml(var FetchedObject: Record "CRM Prefetched Object"; var ParsingResult: Dictionary of [Text, Text])
    var
        XmlElem: XmlElement;
        XmlNode: XmlNode;
        XmlNodeList: XmlNodeList;
        OK: Boolean;
        No: Text[2];
    begin
        Clear(ParsingResult);
        if ObjectAlreadyImported(FetchedObject) then
            exit;
        GetRootXmlElement(FetchedObject, XmlElem);
        GetObjectField(XmlElem, JoinX(ContractBaseDataX, ContractNoX), ParsingResult, ContractNoX);
        GetObjectField(XmlElem, JoinX(ContractBaseDataX, ContractTypeX), ParsingResult, ContractTypeX);
        GetObjectField(XmlElem, JoinX(ContractBaseDataX, ContractStatusX), ParsingResult, ContractStatusX);
        GetObjectField(XmlElem, JoinX(ContractBaseDataX, ContractCancelStatusX), ParsingResult, ContractCancelStatusX);
        GetObjectField(XmlElem, JoinX(ContractBaseDataX, ContractIsActiveX), ParsingResult, ContractIsActiveX);
        GetObjectField(XmlElem, JoinX(ContractBaseDataX, ExtAgreementNoX), ParsingResult, ExtAgreementNoX);
        GetObjectField(XmlElem, JoinX(ContractX, ApartmentAmountX), ParsingResult, ApartmentAmountX);
        OK := GetObjectField(XmlElem, JoinX(ContractX, FinishingInclX), ParsingResult, FinishingInclX);
        if not XmlElem.SelectNodes(JoinX(ContractX, ContractBuyerNodesX), XmlNodeList) then
            exit;
        No := '1';
        foreach XmlNode in XmlNodeList do begin
            XmlElem := XmlNode.AsXmlElement();
            GetObjectField(XmlElem, ContractBuyerX, ParsingResult, ContractBuyerX + No);
            No := IncStr(No);
        end;
    end;

    local procedure ImportUnit(var FetchedObject: Record "CRM Prefetched Object"; ParsingResult: Dictionary of [Text, Text])
    var
        CRMBuyer: Record "CRM Buyers";
        Apartments: Record Apartments;
        Value: Text;
        TempDT: DateTime;
        No: Text[2];
    begin
        if ParsingResult.Count = 0 then
            exit;

        CRMBuyer.SetRange("Unit Guid", FetchedObject.Id);
        CRMBuyer.DeleteAll(true);

        CRMBuyer.Init();
        CRMBuyer."Unit Guid" := FetchedObject.Id;
        CRMBuyer."Version Id" := FetchedObject."Version Id";
        if ParsingResult.Get(ReservingContactX, Value) then
            Evaluate(CRMBuyer."Reserving Contact Guid", Value);
        if ParsingResult.Get(InvestmentObjectX, Value) then begin
            CRMBuyer."Object of Investing" := Value;
            Apartments."Object No." := CRMBuyer."Object of Investing";
            if ParsingResult.Get(BlockNumberX, Value) then
                Apartments.Description := Value.Trim();
            if ParsingResult.Get(ApartmentNumberX, Value) then begin
                if (Apartments.Description <> '') and (not Apartments.Description.EndsWith(' ')) then
                    Apartments.Description += ' ';
                Apartments.Description += Value.Trim();
            end;
            if ParsingResult.Get(ApartmentOriginTypeX, Value) then
                Apartments."Origin Type" := CopyStr(Format(Value), 1, MaxStrLen(Apartments."Origin Type"));
            if ParsingResult.Get(ApartmentUnitAreaM2X, Value) then
                if Evaluate(Apartments."Total Area (Project)", Value, 9) then;
            if not Apartments.Insert(True) then
                Apartments.Modify(True);
        end;
        No := '1';
        if not ParsingResult.Get(UnitBuyerX + No, Value) then begin
            CRMBuyer.Insert(true);
            exit;
        end;
        repeat
            Evaluate(CRMBuyer."Buyer Guid", Value);
            if ParsingResult.Get(UnitBuyerContactX + No, Value) then
                Evaluate(CRMBuyer."Contact Guid", Value);
            if ParsingResult.Get(UnitBuyerContractX + No, Value) then
                Evaluate(CRMBuyer."Contract Guid", Value);
            if ParsingResult.Get(UnitBuyerOwnershipPrcX + No, Value) then
                Evaluate(CRMBuyer."Ownership Percentage", Value, 9)
            Else
                CRMBuyer."Ownership Percentage" := 100;
            CRMBuyer."Buyer Is Active" := true;
            if ParsingResult.Get(UnitBuyerIsActiveX + No, Value) then begin
                if Value = 'false' then
                    CRMBuyer."Buyer Is Active" := false;
            end;
            if CRMBuyer."Buyer Is Active" then begin
                CRMBuyer."Expected Registration Period" := 0;
                if ParsingResult.Get(ExpectedRegDateX + No, Value) then
                    Evaluate(CRMBuyer."Expected Registration Period", Value, 9);
                CRMBuyer."Agreement Start" := 0D;
                if ParsingResult.Get(ActualDateX + No, Value) then
                    if Evaluate(TempDT, Value, 9) then
                        CRMBuyer."Agreement Start" := DT2Date(TempDT) - CRMBuyer."Expected Registration Period";
                CRMBuyer."Agreement End" := 0D;
                if ParsingResult.Get(ExpectedDateX + No, Value) then
                    if Evaluate(TempDT, Value, 9) then
                        CRMBuyer."Agreement End" := DT2Date(TempDT);
            end;
            CRMBuyer."Version Id" := FetchedObject."Version Id";
            CRMBuyer.Insert(true);
            No := IncStr(No);
            if not ParsingResult.Get(UnitBuyerX + No, Value) then
                exit
        until No = '99';
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
        TryLoadXml(InStrm, XmlDoc);
        XmlDoc.GetRoot(RootXmlElement);
    end;


    [TryFunction]
    local procedure GetRootXmlElement(InputXmlText: Text; var RootXmlElement: XmlElement)
    var
        XmlDoc: XmlDocument;
    begin
        TryLoadXml(InputXmlText, XmlDoc);
        XmlDoc.GetRoot(RootXmlElement);
    end;

    [TryFunction]
    local procedure XmlNodeExists(XmlElem: XmlElement; XPath: Text)
    var
        TempXmlNode: XmlNode;
    begin
        XmlElem.SelectSingleNode(XPath, TempXmlNode);
    end;

    [TryFunction]
    local procedure GetValue(XmlElem: XmlElement; xpath: Text; var Value: Text)
    var
        XmlNode: XmlNode;
    begin
        Value := '';
        XmlElem.SelectSingleNode(xpath, XmlNode);
        Value := GetXmlElementText(XmlNode);
    end;

    [TryFunction]
    local procedure GetObjectField(XmlElem: XmlElement; Xpath: Text; var ObjDataContainer: Dictionary of [Text, Text]; FieldKey: Text)
    var
        TempXmlElemValue: Text;
    begin
        GetValue(XmlElem, xpath, TempXmlElemValue);
        if FieldKey = '' then
            Error(KeyErr);
        ObjDataContainer.Add(FieldKey, TempXmlElemValue);
    end;

    [TryFunction]
    local procedure GetTargetCrmCompany(var FetchedObject: Record "CRM Prefetched Object"; var TargetCompanyName: Text)
    var
        CrmCompany: Record "CRM Company";
    begin
        TargetCompanyName := '';
        case FetchedObject.Type of
            FetchedObject.Type::Unit:
                begin
                    CrmCompany.SetRange("Project Guid", FetchedObject.ParentId);
                    if not CrmCompany.FindFirst() then
                        Error(ProjectNotFoundErr, FetchedObject.ParentId, CrmCompany.TableCaption)
                    else begin
                        CrmCompany.TestField("Company Name");
                        TargetCompanyName := CrmCompany."Company Name";
                    end;
                end;

        end
    end;

    local procedure ObjectAlreadyImported(var FetchedObject: record "CRM Prefetched Object") Result: Boolean
    var
        Cust: Record Customer;
        Agr: Record "Customer Agreement";
        CRMB: Record "CRM Buyers";
    begin
        case FetchedObject.Type of
            FetchedObject.Type::Unit:
                begin
                    CRMB.Reset();
                    CRMB.SetRange("Unit Guid", FetchedObject.Id);
                    CRMB.SetRange("Version Id", FetchedObject."Version Id");
                    Result := not CRMB.IsEmpty();
                end;

            FetchedObject.Type::Contact:
                begin
                    Cust.Reset();
                    Cust.Setrange("CRM GUID", FetchedObject.Id);
                    Cust.SetRange("Version Id", FetchedObject."Version Id");
                    Result := Not Cust.IsEmpty();
                end;

            FetchedObject.Type::Contract:
                begin
                    Agr.Reset();
                    Agr.SetRange("CRM GUID", FetchedObject.Id);
                    Agr.SetRange("Version Id", FetchedObject."Version Id");
                    result := not Agr.IsEmpty();
                end;
        end
    end;

    local procedure JoinX(RootXPath: Text; ChildXPath: Text) Result: Text
    begin
        if RootXPath <> '' then begin
            if not RootXPath.EndsWith('/') then
                RootXPath := RootXPath + '/'
        end;
        Result := RootXPath + ChildXPath;
    end;

    local procedure LogEvent(var FetchedObject: Record "CRM Prefetched Object"; LogStatusEnum: Enum "CRM Log Status"; MsgText: Text)
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
        Log.Status := LogStatusEnum;
        Log."Details Text 1" := CopyStr(MsgText, 1, MaxStrLen(Log."Details Text 1"));
        Log."Details Text 2" := CopyStr(MsgText, MaxStrLen(Log."Details Text 1") + 1, MaxStrLen(Log."Details Text 2"));
        Log.Insert();
    end;

    local procedure LogEvent(WrqId: Guid; LogStatusEnum: Enum "CRM Log Status"; MsgText: Text)
    var
        Log: Record "CRM Log";
    begin
        if not Log.FindLast() then
            Log."Entry No." := 1L
        else
            Log."Entry No." += 1;
        Log."Web Request Queue Id" := WrqId;
        Log.Datetime := CurrentDateTime;
        Log.Status := LogStatusEnum;
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
