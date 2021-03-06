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
        TargetCompanyNameX: Label '@Target CRM CompanyName', Locked = true;

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
        ContactUpdateExistingX: Label '@ContactUpdateExisting', Locked = true;

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
        ContactUnitNotFoundErr: Label 'Unit of Contact or Reserving Contact is not found';
        ContractUnitNotFoundErr: Label 'Unit %1 of Contract is not found';
        BadSoapEnvFormatErr: Label 'Bad soap envelope format';
        KeyErr: Label 'No field key is specified!';
        NoObjectIdErr: Label 'No ObjectID in XML Document';
        NoParentObjectIdErr: Label 'No ParentObjectID in XML Document';
        ProjectNotFoundErr: Label 'ProjectId %1 is not found in %2';
        UnknownObjectTypeErr: Label 'Unknown type of Object %1';


        //Messages
        ContactUpToDateMsg: Label 'Customer No. %1 is up to date';
        ContactProcessedMsg: Label 'Customer No. %1';
        EmptyHttpRequestBody: Label 'Http request body is empty';
        NoInvestObjectMsg: Label 'Investment object is not specified';
        InvestmentObjectCreatedMsg: label 'Investment object %1 was created';
        InvestmentObjectUpdatedMsg: label 'Investment object %1 was updated';
        UnitCreatedMsg: Label 'Unit was created';
        UnitUpdatedMsg: Label 'Unit was updated';
        UnitUpToDateMsg: label 'Unit is up to date';

    local procedure Code(var WebRequestQueue: Record "Web Request Queue")
    var
        FetchedObjectBuff: Record "CRM Prefetched Object" temporary;
        FetchedObject: Record "CRM Prefetched Object";
        AllObjectData: Dictionary of [Guid, List of [Dictionary of [Text, Text]]];
    begin
        PickupPrefetchedObjects(FetchedObjectBuff);
        if not FetchObjects(WebRequestQueue, FetchedObjectBuff) then
            exit;

        ParseObjects(FetchedObjectBuff, AllObjectData);
        SetTargetCompany(FetchedObjectBuff, AllObjectData);
        FetchedObjectBuff.Reset();
        if not FetchedObjectBuff.FindSet() then
            exit;
        repeat
            FetchedObjectBuff.CalcFields(Xml);
            FetchedObject := FetchedObjectBuff;
            if not FetchedObject.Insert(true) then
                FetchedObject.Modify(true);
        until FetchedObjectBuff.Next() = 0;
    end;

    local procedure SetTargetCompany(var FetchedObject: Record "CRM Prefetched Object"; var AllObjectData: Dictionary of [Guid, List of [Dictionary of [Text, Text]]])
    var
        CrmInteractCompanies: List of [Text];
        BuyerToContractMap, UnitBuyerToContact, ObjectDataElement : Dictionary of [Text, Text];
        ObjectData: List of [Dictionary of [Text, Text]];
        C, I : Integer;
        TextKey, ContactId, BuyerId, ContractId, UnitId : Text;
        DbgList: List of [Text];
        DbgVal, DbgErr : Text;
    begin
        if AllObjectData.Count() = 0 then
            exit;
        FetchedObject.Reset();
        FetchedObject.SetFilter(Type, '%1|%2', FetchedObject.Type::Unit, FetchedObject.Type::Contract);
        if FetchedObject.FindSet() then begin
            repeat
                AllObjectData.Get(FetchedObject.Id, ObjectData);

                //walkthrough of object head(I=1) and buyres (I>1)    
                C := ObjectData.Count;
                if C > 1 then begin
                    for I := 1 to C do begin
                        ObjectDataElement := ObjectData.Get(I);
                        case FetchedObject.Type of
                            FetchedObject.Type::Unit:
                                begin
                                    if I = 1 then begin
                                        ObjectDataElement.Get(UnitIdX, UnitId)
                                    end else begin
                                        if ObjectDataElement.Get(UnitBuyerX, BuyerId) and ObjectDataElement.Get(UnitBuyerContactX, ContactId) then begin
                                            TextKey := UnitId + '@' + BuyerId;
                                            UnitBuyerToContact.Add(TextKey, ContactId);
                                        end;
                                    end;
                                end;
                            FetchedObject.Type::Contract:
                                begin
                                    if I = 1 then begin
                                        ObjectDataElement.Get(ContractIdX, ContractId);
                                    end else begin
                                        ObjectDataElement.Get(ContractBuyerX, BuyerId);
                                        BuyerToContractMap.Add(BuyerId, ContractId);
                                    end;
                                end;
                        end
                    end;
                end;
            until FetchedObject.Next() = 0;
        end;

        GetCrmInteractCompanyList(CrmInteractCompanies);
        FetchedObject.Reset();
        FetchedObject.SetFilter("Company name", '%1', '');
        if FetchedObject.FindSet() then begin
            repeat
                FetchedObject."Company name" :=
                    SuggestTargetCompany(FetchedObject, AllObjectData, BuyerToContractMap, UnitBuyerToContact, CrmInteractCompanies);
                if FetchedObject."Company name" <> '' then
                    FetchedObject.Modify();
            until FetchedObject.Next() = 0;
        end;
    end;

    local procedure SuggestTargetCompany(var FetchedObject: Record "CRM Prefetched Object";
        var AllObjectData: Dictionary of [Guid, List of [Dictionary of [Text, Text]]];
        BuyerToContractMap: Dictionary of [Text, Text];
        UnitBuyerToContact: Dictionary of [Text, Text];
        CrmInteractCompanyList: List of [Text]) Result: Text[60]
    var
        LogStatusEnum: Enum "CRM Log Status";
        CrmCompany: Record "CRM Company";
        TempFetchedObject: Record "CRM Prefetched Object" temporary;
        CrmBuyer: Record "CRM Buyers";
        TempGuid, TempUnitGuid, ProjectId : Guid;
        ObjectData: List of [Dictionary of [Text, Text]];
        ObjectDataElement: Dictionary of [Text, Text];
        NewCompanyName, TempContactIdText, TempContractBuyerIdText, TempUnitIdText : Text;
        TempKey, TempValue : Text;
        TempKeyList: List of [Text];
    begin
        Result := '';
        TempFetchedObject := FetchedObject;

        case TempFetchedObject.Type of
            TempFetchedObject.Type::Unit:
                begin
                    if CrmCompany.Get(TempFetchedObject.ParentId) then
                        Result := CrmCompany."Company Name"
                    else
                        LogEvent(FetchedObject, LogStatusEnum::Error, StrSubstNo(ProjectNotFoundErr, TempFetchedObject.ParentId))
                end;
            TempFetchedObject.Type::Contact:
                begin
                    if UnitBuyerToContact.Count <> 0 then begin
                        TempKeyList := UnitBuyerToContact.Keys();
                        foreach TempKey in TempKeyList do begin
                            UnitBuyerToContact.Get(TempKey, TempContactIdText);
                            Evaluate(TempGuid, TempContactIdText);
                            if TempGuid = TempFetchedObject.Id then begin
                                TempContractBuyerIdText := TempKey.Split('@').Get(2);
                                if BuyerToContractMap.Get(TempContractBuyerIdText, TempValue) then begin
                                    TempUnitIdText := TempKey.Split('@').Get(1);
                                    Evaluate(TempUnitGuid, TempUnitIdText);
                                    if FetchedObject.Get(TempUnitGuid) then begin
                                        if CrmCompany.Get(FetchedObject.ParentId) then begin
                                            Result := CrmCompany."Company Name";
                                            break;
                                        end else begin
                                            LogEvent(FetchedObject, LogStatusEnum::Error, StrSubstNo(ProjectNotFoundErr, FetchedObject.ParentId))
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                    if Result = '' then begin
                        foreach NewCompanyName in CrmInteractCompanyList do begin
                            CrmBuyer.Reset();
                            CrmBuyer.ChangeCompany(NewCompanyName);
                            CrmBuyer.SetRange("Contact Guid", TempFetchedObject.id);
                            if not CrmBuyer.IsEmpty then
                                Result := NewCompanyName
                            else begin
                                CrmBuyer.SetRange("Contact Guid");
                                CrmBuyer.SetRange("Reserving Contact Guid", TempFetchedObject.id);
                                if not CrmBuyer.IsEmpty then
                                    Result := NewCompanyName;
                            end;
                            if Result <> '' then
                                break;
                        end;
                    end;
                end;
            TempFetchedObject.Type::Contract:
                begin
                    if AllObjectData.Get(TempFetchedObject.ParentId, ObjectData) then begin
                        FetchedObject.Get(TempFetchedObject.ParentId);
                        if CrmCompany.Get(FetchedObject.ParentId) then
                            Result := CrmCompany."Company Name"
                        else
                            LogEvent(FetchedObject, LogStatusEnum::Error, StrSubstNo(ProjectNotFoundErr, FetchedObject.ParentId));
                    end;
                    if Result = '' then begin
                        foreach NewCompanyName in CrmInteractCompanyList do begin
                            CrmBuyer.Reset();
                            CrmBuyer.ChangeCompany(NewCompanyName);
                            CrmBuyer.SetRange("Contract Guid", TempFetchedObject.id);
                            if not CrmBuyer.IsEmpty then
                                Result := NewCompanyName
                            else begin
                                CrmBuyer.SetRange("Contract Guid");
                                CrmBuyer.SetRange("Reserving Contract Guid", TempFetchedObject.id);
                                if not CrmBuyer.IsEmpty then
                                    Result := NewCompanyName;
                            end;
                            if Result <> '' then
                                break;
                        end;
                    end;

                end;
        end;

        FetchedObject := TempFetchedObject;
    end;

    local procedure FetchObjects(var WRQ: Record "Web Request Queue"; var FetchedObjectsTemp: Record "CRM Prefetched Object") Result: Boolean
    var
        XmlCrmObjectList: XmlNodeList;
        RootXmlElement: XmlElement;
        XmlCrmObject: XmlNode;
        RequestBodyXmlText, ObjXmlBase64, TempValue : text;
        LogStatusEnum: Enum "CRM Log Status";
        ObjectMetadata: Dictionary of [Text, Text];
        OutStrm: OutStream;
        InStrm: InStream;
        UnitToProjectMap: Dictionary of [Guid, Guid];
        ContactToUnitsMap: Dictionary of [Guid, List of [Guid]];
        ContractToUnitMap: Dictionary of [Guid, Guid];
    begin
        Result := false;
        Clear(ObjectMetadata);
        ObjectMetadata.Add(FetchedObjectsTemp.FieldName("WRQ Id"), WRQ.Id);
        ObjectMetadata.Add(FetchedObjectsTemp.FieldName("WRQ Source Company Name"), CompanyName());
        WRQ.CalcFields("Request Body");
        if not WRQ."Request Body".HasValue() then begin
            LogEvent(ObjectMetadata, EmptyHttpRequestBody);
            exit;
        end;
        WRQ."Request Body".CreateInStream(InStrm, TextEncoding::UTF8);
        InStrm.Read(RequestBodyXmlText);

        FetchedObjectsTemp.Reset();
        FetchedObjectsTemp.DeleteAll();
        if not GetRootXmlElement(RequestBodyXmlText, RootXmlElement) then begin
            LogEvent(ObjectMetadata, GetLastErrorText());
            exit;
        end;
        if not RootXmlElement.SelectNodes(SoapObjectContainerX, XmlCrmObjectList) then begin
            LogEvent(ObjectMetadata, BadSoapEnvFormatErr);
            exit;
        end;
        foreach XmlCrmObject in XmlCrmObjectList do begin
            Clear(ObjectMetadata);
            ObjectMetadata.Add(FetchedObjectsTemp.FieldName("WRQ Id"), WRQ.Id);
            ObjectMetadata.Add(FetchedObjectsTemp.FieldName("WRQ Source Company Name"), CompanyName());
            ObjXmlBase64 := GetXmlElementText(XmlCrmObject);
            if not GetObjectMetadata(ObjXmlBase64, ObjectMetadata) then
                LogEvent(ObjectMetadata, GetLastErrorText())
            else begin
                Result := true;
                FetchedObjectsTemp.Init();
                ObjectMetadata.Get(FetchedObjectsTemp.FieldName(Id), TempValue);
                Evaluate(FetchedObjectsTemp.Id, TempValue);
                ObjectMetadata.Get(FetchedObjectsTemp.FieldName(Type), TempValue);
                Evaluate(FetchedObjectsTemp.Type, TempValue);
                if ObjectMetadata.Get(FetchedObjectsTemp.FieldName(ParentId), TempValue) then
                    Evaluate(FetchedObjectsTemp.ParentId, TempValue);
                ObjectMetadata.Get(FetchedObjectsTemp.FieldName(Xml), TempValue);
                FetchedObjectsTemp.Xml.CreateOutStream(OutStrm, TextEncoding::UTF8);
                OutStrm.WriteText(TempValue);
                ObjectMetadata.Get(FetchedObjectsTemp.FieldName("Version Id"), FetchedObjectsTemp."Version Id");
                FetchedObjectsTemp."WRQ Id" := WRQ.id;
                FetchedObjectsTemp."WRQ Source Company Name" := CompanyName();
                FetchedObjectsTemp."Prefetch Datetime" := CurrentDateTime();
                if not FetchedObjectsTemp.Insert() then
                    FetchedObjectsTemp.Modify();
            end;
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
    local procedure GetObjectMetadata(Base64EncodedObjectXml: Text; var NewObjectMetadata: Dictionary of [Text, Text])
    var
        Base64Convert: Codeunit "Base64 Convert";
        XmlDoc: XmlDocument;
        RootXmlElement: XmlElement;
        ObjectXmlText, ObjectType, ObjectIdText, ParentObjectIdText : Text;
        OutStrm: OutStream;
        T: Record "CRM Prefetched Object" temporary;
    begin
        ObjectXmlText := Base64Convert.FromBase64(Base64EncodedObjectXml);
        NewObjectMetadata.Add(T.FieldName(Xml), ObjectXmlText);
        NewObjectMetadata.Add(T.FieldName("Version Id"), GenerateHash(ObjectXmlText));
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
        NewObjectMetadata.Add(T.FieldName(id), ObjectIdText);
        NewObjectMetadata.Add(T.FieldName(Type), ObjectType);
        if ParentObjectIdText <> '' then
            NewObjectMetadata.Add(T.FieldName(ParentId), ParentObjectIdText);
        if ObjectIdText = '' then
            Error(NoObjectIdErr);
        if (UpperCase(ObjectType) in ['CONTRACT', 'UNIT']) and (ParentObjectIdText = '') then
            Error(NoParentObjectIdErr);

    end;

    local procedure ParseObjects(var FetchedObject: Record "CRM Prefetched Object"; var AllObjectData: Dictionary of [Guid, List of [Dictionary of [Text, Text]]])
    var
        ParsingResult: Dictionary of [Text, Text];
        ObjectData: List of [Dictionary of [Text, Text]];
        HasError: Boolean;
        LogStatusEnum: Enum "CRM Log Status";
    begin
        FetchedObject.Reset();
        FetchedObject.FindSet();
        repeat
            Clear(ParsingResult);
            case FetchedObject.Type of
                FetchedObject.Type::Unit:
                    hasError := not ParseUnitXml(FetchedObject, ObjectData);
                FetchedObject.Type::Contact:
                    hasError := not ParseContactXml(FetchedObject, ObjectData);
                FetchedObject.Type::Contract:
                    hasError := not ParseContractXml(FetchedObject, ObjectData);
            end;
            if not HasError then begin
                if ObjectData.Count <> 0 then
                    AllObjectData.Add(FetchedObject.Id, ObjectData);
            end else begin
                LogEvent(FetchedObject, LogStatusEnum::Error, GetLastErrorText());
                FetchedObject.Delete();
            end;

        until FetchedObject.Next() = 0;
    end;

    local procedure ImportObjects(var FetchedObject: Record "CRM Prefetched Object"; var ParsedObjects: Dictionary of [Guid, Dictionary of [Text, Text]])
    var
        Params: Dictionary of [Text, Text];
        CrmCompany: Record "CRM Company";
        LogStatusEnum: Enum "CRM Log Status";
        CrmInteractCompanies: List of [Text];
        TargetCompany: Text;
    begin
        GetCrmInteractCompanyList(CrmInteractCompanies);

        //units import
        FetchedObject.Reset();
        FetchedObject.SetRange(Type, FetchedObject.Type::Unit);
        if FetchedObject.FindSet() then begin
            repeat
                if not GetTargetCrmCompany(FetchedObject, CrmInteractCompanies, TargetCompany) then
                    LogEvent(FetchedObject, LogStatusEnum::Error, GetLastErrorText())
                else begin
                    ParsedObjects.Get(FetchedObject.Id, Params);
                    Params.Add(TargetCompanyNameX, TargetCompany);
                    if not ImportUnit(FetchedObject, Params) then
                        LogEvent(FetchedObject, LogStatusEnum::Error, GetLastErrorText())
                end;
            until FetchedObject.Next() = 0;
        end;

        //update existing contacts
        FetchedObject.SetRange(Type, FetchedObject.Type::Contact);
        FetchedObject.FindSet();
        repeat
            ParsedObjects.Get(FetchedObject.Id, Params);
            Params.Add(ContactUpdateExistingX, ContactUpdateExistingX);
            ImportContact(FetchedObject, Params);
        //LogEvent(FetchedObject, LogStatusEnum::Error, GetLastErrorText())
        until FetchedObject.Next() = 0;

        //import contracts with creating necessary contacts
        FetchedObject.SetRange(Type, FetchedObject.Type::Contract);
        if FetchedObject.FindSet() then begin
            repeat
                if not GetTargetCrmCompany(FetchedObject, CrmInteractCompanies, TargetCompany) then
                    LogEvent(FetchedObject, LogStatusEnum::Error, GetLastErrorText())
                else begin
                    ParsedObjects.Get(FetchedObject.Id, Params);
                    Params.Add(TargetCompanyNameX, TargetCompany);
                    if not ImportContract(FetchedObject, Params) then
                        LogEvent(FetchedObject, LogStatusEnum::Error, GetLastErrorText())
                    else
                        Commit();
                end;
            until FetchedObject.Next() = 0;
        end;
    end;

    [TryFunction]
    local procedure ParseUnitXml(var FetchedObject: Record "CRM Prefetched Object"; var ObjectData: List of [Dictionary of [Text, Text]])
    var
        XmlElem: XmlElement;
        XmlBuyer: XmlNode;
        XmlBuyerList: XmlNodeList;
        ElemText, ElemText2 : Text;
        BuyerNo: Integer;
        ExpectedRegDate, ActualDate, ExpectedDate : Text;
        OK: Boolean;
        ObjDataElement: Dictionary of [Text, Text];
        RetObjectData: List of [Dictionary of [Text, Text]];
    begin
        ObjectData := RetObjectData;
        CreateObjDataElement(ObjectData, ObjDataElement);
        FetchedObject.CalcFields(Xml);
        GetRootXmlElement(FetchedObject, XmlElem);
        GetValue(XmlElem, JoinX(UnitBaseDataX, ObjectParentIdX), ElemText);
        GetObjectField(XmlElem, UnitIdX, ObjDataElement, UnitIdX);
        GetObjectField(XmlElem, JoinX(UnitBaseDataX, ReservingContactX), ObjDataElement, ReservingContactX);
        GetObjectField(XmlElem, JoinX(UnitBaseDataX, InvestmentObjectX), ObjDataElement, InvestmentObjectX);
        OK := GetObjectField(XmlElem, JoinX(UnitBaseDataX, BlockNumberX), ObjDataElement, BlockNumberX);
        OK := GetObjectField(XmlElem, JoinX(UnitBaseDataX, ApartmentNumberX), ObjDataElement, ApartmentNumberX);
        OK := GetObjectField(XmlElem, JoinX(UnitX, ApartmentOriginTypeX), ObjDataElement, ApartmentOriginTypeX);
        OK := GetObjectField(XmlElem, JoinX(UnitX, ApartmentUnitAreaM2X), ObjDataElement, ApartmentUnitAreaM2X);
        OK := GetObjectField(XmlElem, JoinX(UnitX, ExpectedRegDateX), ObjDataElement, ExpectedRegDateX);
        OK := GetObjectField(XmlElem, JoinX(UnitX, ActualDateX), ObjDataElement, ActualDateX);
        OK := GetObjectField(XmlElem, JoinX(UnitX, ExpectedDateX), ObjDataElement, ExpectedDateX);
        if not XmlElem.SelectNodes(JoinX(UnitX, UnitBuyerNodesX), XmlBuyerList) then
            exit;
        foreach XmlBuyer in XmlBuyerList do begin
            XmlElem := XmlBuyer.AsXmlElement();
            CreateObjDataElement(ObjectData, ObjDataElement);
            GetObjectField(XmlElem, UnitBuyerX, ObjDataElement, UnitBuyerX);
            GetObjectField(XmlElem, UnitBuyerContactX, ObjDataElement, UnitBuyerContactX);
            GetObjectField(XmlElem, UnitBuyerContractX, ObjDataElement, UnitBuyerContractX);
            OK := GetObjectField(XmlElem, UnitBuyerOwnershipPrcX, ObjDataElement, UnitBuyerOwnershipPrcX);
            OK := GetObjectField(XmlElem, UnitBuyerIsActiveX, ObjDataElement, UnitBuyerIsActiveX);
        end;
    end;

    [TryFunction]
    local procedure ImportUnit(var FetchedObject: Record "CRM Prefetched Object"; ParsingResult: Dictionary of [Text, Text])
    var
        CRMBuyer: Record "CRM Buyers";
        Apartments: Record Apartments;
        Value, TargetCompanyName : Text;
        TempDT: DateTime;
        No: Text[2];
        LogStatusEnum: Enum "CRM Log Status";
        ImportAction: Option Create,Update;

    begin
        if ParsingResult.Count = 0 then
            exit;

        if not ParsingResult.Get(TargetCompanyNameX, TargetCompanyName) then
            TargetCompanyName := '';
        if (TargetCompanyName <> CompanyName()) and (TargetCompanyName <> '') then begin
            CRMBuyer.ChangeCompany(TargetCompanyName);
            Apartments.ChangeCompany(TargetCompanyName);
        end;
        CRMBuyer.SetRange("Unit Guid", FetchedObject.Id);
        if CRMBuyer.IsEmpty() then
            ImportAction := ImportAction::Create
        else begin
            CRMBuyer.SetRange("Version Id", FetchedObject."Version Id");
            if not CRMBuyer.IsEmpty then begin
                LogEvent(FetchedObject, LogStatusEnum::Skipped, UnitUpToDateMsg);
                exit;
            end;
            CRMBuyer.SetRange("Version Id");
            ImportAction := ImportAction::Update;
        end;
        CRMBuyer.DeleteAll(true);

        CRMBuyer.Init();
        CRMBuyer."Unit Guid" := FetchedObject.Id;
        CRMBuyer."Version Id" := FetchedObject."Version Id";
        if ParsingResult.Get(ReservingContactX, Value) then
            Evaluate(CRMBuyer."Reserving Contact Guid", Value);
        if not ParsingResult.Get(InvestmentObjectX, Value) then
            LogEvent(FetchedObject, LogStatusEnum::Warning, NoInvestObjectMsg)
        else begin
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
            if Apartments.Insert(True) then begin
                LogEvent(FetchedObject, LogStatusEnum::Done, StrSubstNo(InvestmentObjectCreatedMsg, Apartments."Object No."));
            end else begin
                Apartments.Modify(True);
                LogEvent(FetchedObject, LogStatusEnum::Done, StrSubstNo(InvestmentObjectUpdatedMsg, Apartments."Object No."));
            end;
        end;
        No := '1';
        if not ParsingResult.Get(UnitBuyerX + No, Value) then begin
            CRMBuyer.Insert(true);
            Commit();
            LogEvent(FetchedObject, LogStatusEnum::Done, UnitCreatedMsg);
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
            Commit();
            if ImportAction = ImportAction::Create then
                LogEvent(FetchedObject, LogStatusEnum::Done, UnitCreatedMsg)
            else
                LogEvent(FetchedObject, LogStatusEnum::Done, UnitUpdatedMsg);
            No := IncStr(No);
            if not ParsingResult.Get(UnitBuyerX + No, Value) then
                exit
        until No = '99';
    end;


    [TryFunction]
    local procedure ParseContractXml(var FetchedObject: Record "CRM Prefetched Object"; var ObjectData: List of [Dictionary of [Text, Text]])
    var
        XmlElem: XmlElement;
        XmlBuyer: XmlNode;
        XmlBuyerList: XmlNodeList;
        OK: Boolean;
        ObjDataElement: Dictionary of [Text, Text];
        RetObjectData: List of [Dictionary of [Text, Text]];
    begin
        ObjectData := RetObjectData;
        CreateObjDataElement(ObjectData, ObjDataElement);
        FetchedObject.CalcFields(Xml);
        GetRootXmlElement(FetchedObject, XmlElem);
        GetObjectField(XmlElem, ContractIdX, ObjDataElement, ContractIdX);
        GetObjectField(XmlElem, JoinX(ContractBaseDataX, ContractNoX), ObjDataElement, ContractNoX);
        GetObjectField(XmlElem, JoinX(ContractBaseDataX, ContractTypeX), ObjDataElement, ContractTypeX);
        GetObjectField(XmlElem, JoinX(ContractBaseDataX, ContractStatusX), ObjDataElement, ContractStatusX);
        GetObjectField(XmlElem, JoinX(ContractBaseDataX, ContractCancelStatusX), ObjDataElement, ContractCancelStatusX);
        GetObjectField(XmlElem, JoinX(ContractBaseDataX, ContractIsActiveX), ObjDataElement, ContractIsActiveX);
        GetObjectField(XmlElem, JoinX(ContractBaseDataX, ExtAgreementNoX), ObjDataElement, ExtAgreementNoX);
        GetObjectField(XmlElem, JoinX(ContractX, ApartmentAmountX), ObjDataElement, ApartmentAmountX);
        OK := GetObjectField(XmlElem, JoinX(ContractX, FinishingInclX), ObjDataElement, FinishingInclX);
        if XmlElem.SelectNodes(JoinX(ContractX, ContractBuyerNodesX), XmlBuyerList) then begin
            foreach XmlBuyer in XmlBuyerList do begin
                XmlElem := XmlBuyer.AsXmlElement();
                CreateObjDataElement(ObjectData, ObjDataElement);
                GetObjectField(XmlElem, ContractBuyerX, ObjDataElement, ContractBuyerX);
            end;
        end;
    end;

    [TryFunction]
    local procedure ParseContactXml(var FetchedObject: Record "CRM Prefetched Object"; var ObjectData: List of [Dictionary of [Text, Text]])
    var
        XmlElem: XmlElement;
        XmlNode: XmlNode;
        XmlNodeList: XmlNodeList;
        OK: Boolean;
        BaseXPath: Text;
        ElemText, ElemText2 : Text;
        ObjDataElement: Dictionary of [Text, Text];
        RetObjectData: List of [Dictionary of [Text, Text]];
    begin
        ObjectData := RetObjectData;
        CreateObjDataElement(ObjectData, ObjDataElement);
        FetchedObject.CalcFields(Xml);
        GetRootXmlElement(FetchedObject, XmlElem);
        BaseXPath := JoinX(ContactX, PersonDataX);
        GetObjectField(XmlElem, ContactIdX, ObjDataElement, ContactIdX);
        GetObjectField(XmlElem, JoinX(BaseXPath, LastNameX), ObjDataElement, LastNameX);
        GetObjectField(XmlElem, JoinX(BaseXPath, FirstNameX), ObjDataElement, FirstNameX);
        GetObjectField(XmlElem, JoinX(BaseXPath, MiddleNameX), ObjDataElement, MiddleNameX);
        BaseXPath := JoinX(ContactX, PhysicalAddressX);
        if XmlNodeExists(XmlElem, BaseXPath) then begin
            ElemText2 := '';
            Ok := GetObjectField(XmlElem, JoinX(BaseXPath, PostalCityX), ObjDataElement, PostalCityX);
            Ok := GetObjectField(XmlElem, JoinX(BaseXPath, CountryCodeX), ObjDataElement, CountryCodeX);
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
                ObjDataElement.Add(AddressLineX, ElemText2);
            Ok := GetObjectField(XmlElem, JoinX(BaseXPath, PostalCodeX), ObjDataElement, PostalCodeX);
        end;
        BaseXPath := JoinX(ContactX, ElectronicAddressesX);
        if not XmlElem.SelectNodes(JoinX(BaseXPath, ElectronicAddressX), XmlNodeList) then
            exit;
        foreach XmlNode in XmlNodeList do begin
            XmlElem := XmlNode.AsXmlElement();
            if GetValue(XmlElem, ProtocolX, ElemText) and (ElemText <> '') then begin
                if GetValue(XmlElem, AddressLineX + '1', ElemText2) then begin
                    Case ElemText of
                        ContactPhoneX:
                            begin
                                if ElemText2 <> '' then
                                    ObjDataElement.Add(ContactPhoneX, ElemText2);
                            end;
                        ContactEmailX:
                            begin
                                if ElemText2 <> '' then
                                    ObjDataElement.Add(ContactEmailX, ElemText2);
                            end;
                    End
                end;
            end;
        end;

    end;

    local procedure ImportContact(var FetchedObject: Record "CRM Prefetched Object"; ObjectParams: Dictionary of [Text, Text])
    var
        Customer: Record Customer;
        CustTemp: Record Customer temporary;
        CrmSetup: Record "CRM Integration Setup";
        UpdateContFromCust: Codeunit "CustCont-Update";
        ContBusRelation: Record "Contact Business Relation";
        Value, TargetCompanyName : Text;
        TempStr: Text;
        TempDT: DateTime;
        No: Text[2];
        LogStatusEnum: Enum "CRM Log Status";
        ActionEnum: Enum "CRM Import Action";

    begin
        if ObjectParams.Count() = 0 then
            exit;

        if not ObjectParams.Get(TargetCompanyNameX, TargetCompanyName) then
            TargetCompanyName := '';
        if (TargetCompanyName <> CompanyName()) and (TargetCompanyName <> '') then begin
            Customer.ChangeCompany(TargetCompanyName);
            CrmSetup.ChangeCompany(TargetCompanyName);
            ContBusRelation.ChangeCompany(TargetCompanyName);
        end;

        Customer.Reset();
        Customer.SetRange("CRM GUID", FetchedObject.Id);
        if not Customer.FindFirst() then begin
            ActionEnum := ActionEnum::Create;
            if ObjectParams.Get(ContactUpdateExistingX, Value) then
                exit;
        end else begin
            Customer.SetRange("Version Id", FetchedObject."Version Id");
            if Customer.FindFirst() then begin
                LogEvent(FetchedObject, LogStatusEnum::Skipped, StrSubstNo(ContactUpToDateMsg, Customer."No."));
                exit;
            end;
            ActionEnum := ActionEnum::Update;
        end;

        CustTemp.Init();
        ObjectParams.Get(LastNameX, Value);
        TempStr := Value;
        ObjectParams.Get(FirstNameX, Value);
        TempStr += ' ' + Value;
        ObjectParams.Get(MiddleNameX, Value);
        TempStr += ' ' + Value;
        CustTemp.Name := CopyStr(TempStr, 1, MaxStrLen(CustTemp.Name));
        if MaxStrLen(CustTemp.Name) < StrLen(TempStr) then
            CustTemp."Name 2" := CopyStr(TempStr, MaxStrLen(CustTemp.Name) + 1, MaxStrLen(CustTemp."Name 2"));
        TempStr := '';
        if ObjectParams.Get(PostalCityX, Value) then
            CustTemp.City := CopyStr(Value, 1, MaxStrLen(CustTemp.City));
        if ObjectParams.Get(CountryCodeX, Value) then
            CustTemp."Country/Region Code" := CopyStr(Value, 1, MaxStrLen(CustTemp."Country/Region Code"));
        if ObjectParams.Get(PostalCodeX, Value) then
            CustTemp."Post Code" := CopyStr(Value, 1, MaxStrLen(CustTemp."Post Code"));
        TempStr := '';
        if ObjectParams.Get(AddressLineX, Value) then
            TempStr := Value;
        TempStr := TempStr + StrSubstNo(' ,%1, %2', CustTemp.City, CustTemp."Country/Region Code");
        CustTemp.Address := CopyStr(TempStr, 1, MaxStrLen(CustTemp.Address));
        If MaxStrLen(CustTemp.Address) < StrLen(TempStr) then
            CustTemp."Address 2" := CopyStr(TempStr, MaxStrLen(CustTemp.Address) + 1, MaxStrLen(CustTemp."Address 2"));
        if ObjectParams.Get(ContactPhoneX, Value) then
            CustTemp."Phone No." := CopyStr(Value, 1, MaxStrLen(CustTemp."Phone No."));
        if ObjectParams.Get(ContactEmailX, Value) then
            CustTemp."E-Mail" := CopyStr(Value, 1, MaxStrLen(CustTemp."E-Mail"));

        Customer.Reset();
        case ActionEnum of
            ActionEnum::Create:
                begin
                    Customer.Init();
                    Customer."No." := '';
                    Customer.Insert(true);
                end;
            ActionEnum::Update:
                begin
                    Customer.SetRange("CRM GUID", FetchedObject.id);
                    Customer.SetRange("Version Id");
                    Customer.FindFirst();
                end;
            else
                exit;
        end;

        Customer.Validate(Name, CustTemp.Name);
        Customer.Validate("Name 2", CustTemp."Name 2");
        Customer.Validate(City, CustTemp.City);
        Customer.Validate("Country/Region Code", CustTemp."Country/Region Code");
        Customer.Validate("Post Code", CustTemp."Post Code");
        Customer.Validate(Address, CustTemp.Address);
        Customer.Validate("Address 2", CustTemp."Address 2");
        Customer.Validate("Phone No.", CustTemp."Phone No.");
        Customer.Validate("E-Mail", CustTemp."E-Mail");
        Customer."Version Id" := FetchedObject."Version Id";
        if ActionEnum = ActionEnum::Create then begin
            Customer."CRM GUID" := FetchedObject.Id;
            CrmSetup.Get;
            if Customer."Customer Posting Group" = '' then
                Customer.Validate("Customer Posting Group", CrmSetup."Customer Posting Group");
            if Customer."Gen. Bus. Posting Group" = '' then
                Customer.Validate("Gen. Bus. Posting Group", CrmSetup."Gen. Bus. Posting Group");
            if Customer."VAT Bus. Posting Group" = '' then
                Customer.Validate("VAT Bus. Posting Group", CrmSetup."VAT Bus. Posting Group");
        end;
        Customer.Modify;

        //to-do
        ContBusRelation.SETCURRENTKEY("Link to Table", "No.");
        ContBusRelation.SetRange("Link to Table", ContBusRelation."Link to Table"::Customer);
        ContBusRelation.SetRange("No.", Customer."No.");
        IF NOT ContBusRelation.FindFirst() THEN BEGIN
            UpdateContFromCust.InsertNewContact(Customer, FALSE);
        END;

        LogEvent(FetchedObject, TargetCompanyName, LogStatusEnum::Done, ActionEnum, StrSubstNo(ContactProcessedMsg, Customer."No."), '');
        Commit();
    end;

    [TryFunction]
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
        FetchedObject.Xml.CreateInStream(InStrm, TextEncoding::UTF8);
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
    local procedure GetTargetCrmCompany(var FetchedObject: Record "CRM Prefetched Object"; SearchInCrmInteractCompanyList: List of [Text]; var TargetCompanyName: Text)
    var
        CrmCompany: Record "CRM Company";
        CrmB: Record "CRM Buyers";
        CrmCompanyName: Text;
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
            FetchedObject.Type::Contract:
                begin
                    foreach CrmCompanyname in SearchInCrmInteractCompanyList do begin
                        CrmB.ChangeCompany(CrmCompanyName);
                        CrmB.SetRange("Unit Guid", FetchedObject.ParentId);
                        if CrmB.FindFirst() then begin
                            TargetCompanyName := CrmCompanyName;
                            break;
                        end;
                    end;
                    if TargetCompanyName = '' then
                        Error(ContractUnitNotFoundErr, FetchedObject.ParentId);
                end;
            FetchedObject.Type::Contact:
                begin
                    foreach CrmCompanyname in SearchInCrmInteractCompanyList do begin
                        CrmB.Reset();
                        CrmB.ChangeCompany(CrmCompanyName);
                        CrmB.SetRange("Contact Guid", FetchedObject.Id);
                        if CrmB.FindFirst() then begin
                            TargetCompanyName := CrmCompanyName;
                            break;
                        end;
                        CrmB.SetRange("Contact Guid");
                        CrmB.SetRange("Reserving Contact Guid", FetchedObject.Id);
                        if CrmB.FindFirst() then begin
                            TargetCompanyName := CrmCompanyName;
                            break;
                        end;
                    end;
                    if TargetCompanyName = '' then
                        Error(ContactUnitNotFoundErr);
                end;
        end
    end;

    local procedure GetCrmInteractCompanyList(var CrmInteractCompanyList: List of [Text])
    var
        CrmCompany: Record "CRM Company";
    begin
        Clear(CrmInteractCompanyList);
        CrmCompany.Reset();
        CrmCompany.FindSet();
        repeat
            if CrmCompany."Company Name" <> '' then begin
                if not CrmInteractCompanyList.Contains(CrmCompany."Company Name") then
                    CrmInteractCompanyList.Add(CrmCompany."Company Name");
            end;
        until CrmCompany.Next() = 0;
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

    local procedure LogEvent(var FetchedObject: Record "CRM Prefetched Object";
        LogToCompany: Text[60];
        LogStatusEnum: Enum "CRM Log Status";
        LogImportActionEnum: Enum "CRM Import Action";
        MsgText1: Text;
        MsgText2: Text)
    var
        Log: Record "CRM Log";
    begin
        if (LogToCompany <> '') and (LogToCompany <> CompanyName()) then
            Log.ChangeCompany(LogToCompany);
        if not Log.FindLast() then
            Log."Entry No." := 1L
        else
            Log."Entry No." += 1;
        Log."Object Id" := FetchedObject.Id;
        Log."Object Type" := FetchedObject.Type;
        Log."Object Xml" := FetchedObject.Xml;
        Log."Object Version Id" := FetchedObject."Version Id";
        Log."WRQ Id" := FetchedObject."WRQ Id";
        Log."WRQ Source Company Name" := FetchedObject."WRQ Source Company Name";
        Log.Datetime := CurrentDateTime;
        Log.Status := LogStatusEnum;
        Log.Action := LogImportActionEnum;
        MsgText1 := MsgText1.Trim();
        if MsgText1 <> '' then
            Log."Details Text 1" := CopyStr(MsgText1, 1, MaxStrLen(Log."Details Text 1"))
        else begin
            if LogStatusEnum = LogStatusEnum::Error then
                Log."Details Text 1" := CopyStr(GetLastErrorText(), 1, MaxStrLen(Log."Details Text 1"));
        end;
        MsgText2 := MsgText2.Trim();
        if MsgText2 <> '' then
            Log."Details Text 2" := CopyStr(MsgText2, 1, MaxStrLen(Log."Details Text 2"))
        else begin
            if LogStatusEnum = LogStatusEnum::Error then
                Log."Details Text 2" := CopyStr(GetLastErrorCallStack(), 1, MaxStrLen(Log."Details Text 2"));
        end;
        Log.Insert();
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
        Log."WRQ Id" := FetchedObject."WRQ Id";
        Log.Datetime := CurrentDateTime;
        Log.Status := LogStatusEnum;
        Log."Details Text 1" := CopyStr(MsgText, 1, MaxStrLen(Log."Details Text 1"));
        Log."Details Text 2" := CopyStr(MsgText, MaxStrLen(Log."Details Text 1") + 1, MaxStrLen(Log."Details Text 2"));
        Log.Insert();
        Commit();
    end;

    local procedure LogEvent(InputObjectMetadata: Dictionary of [Text, Text]; MsgText: Text)
    var
        T: Record "CRM Prefetched Object" temporary;
        StatusEnum: Enum "CRM Log Status";
        ActionEnum: Enum "CRM Import Action";
        TempValue: Text;
        OK: Boolean;
        OutStrm: OutStream;
    begin
        T.Init();
        if InputObjectMetadata.Count <> 0 then begin
            if InputObjectMetadata.Get(T.FieldName(Id), TempValue) then
                OK := Evaluate(T.id, TempValue);
            if InputObjectMetadata.Get(T.FieldName(Type), TempValue) then
                OK := Evaluate(T.Type, TempValue);
            if InputObjectMetadata.Get(T.FieldName(Xml), TempValue) then begin
                T.Xml.CreateOutStream(OutStrm);
                OutStrm.Write(TempValue);
            end;
            if InputObjectMetadata.Get(T.FieldName("Version Id"), TempValue) then
                T."Version Id" := TempValue;
            if InputObjectMetadata.Get(T.FieldName("WRQ Id"), TempValue) then
                OK := Evaluate(T."WRQ Id", TempValue);
            if InputObjectMetadata.Get(T.FieldName("WRQ Source Company Name"), TempValue) then
                T."WRQ Source Company Name" := TempValue;
        end;
        StatusEnum := StatusEnum::Error;
        ActionEnum := ActionEnum::" ";
        LogEvent(T, CompanyName(), StatusEnum, ActionEnum, MsgText, '');
    end;

    local procedure CreateObjDataElement(var ObjList: List of [Dictionary of [Text, Text]]; var NewElement: Dictionary of [Text, Text])
    var
        SomeDict: Dictionary of [Text, Text];
    begin
        NewElement := SomeDict;
        ObjList.Add(NewElement);
    end;
}
