tableextension 94901 "Vendor Agreement (Ext)" extends "Vendor Agreement"
{
    fields
    {
        field(50000; "Vat Agent Posting Group"; code[20])
        {
            Caption = 'Vat Agent Posting Group';
            TableRelation = "Vendor Posting Group";
            Description = '50067';
        }
        field(60000; "Original No."; Code[20])
        {
            Caption = 'Original No.';
            Description = '50085';
        }
        field(60088; "Original Company"; Code[2])
        {
            Caption = 'Original Company';
            Description = '50085';
        }
        field(70001; "Agreement Amount"; Decimal)
        {
            Caption = 'Agreement Amount';
            Description = '50085';

            trigger OnValidate()
            begin
                "Amount Without VAT" := "Agreement Amount" - "VAT Amount";
            end;
        }
        field(70002; "Exists Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST("Vendor Agreement"),
                                                      "No." = FIELD("No.")));
            Caption = 'Exists Comment';
            Description = '50085';
        }
        field(70003; "Exists Attachment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Document Attachment" WHERE("Table ID" = CONST(14901),
                                                       "No." = FIELD("No."),
                                                       "PK Key 2" = field("Vendor No.")));
            Caption = 'Exists Attachment';
            Description = '50085';

        }

        field(70004; "Project Dimension Code"; Code[20])
        {
            Caption = 'Project Dimension Code';
            Description = '50085';
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('ПРОЕКТ'));

            //trigger OnLookup()
            //begin
            //grDevSetup.GET;
            //grDevSetup.TESTFIELD("Project Dimension Code");

            //grDimValue.SETRANGE("Dimension Code", grDevSetup."Project Dimension Code");
            //IF grDimValue.FindFirst() THEN BEGIN
            //    IF PAGE.RUNMODAL(PAGE::"Dimension Values", grDimValue) = ACTION::LookupOK THEN
            //        "Project Dimension Code" := grDimValue.Code;
            //END
            //end;
        }
        field(70008; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount';
            Description = '50085';

            trigger OnValidate()
            begin
                "Amount Without VAT" := "Agreement Amount" - "VAT Amount";
            end;
        }
        field(70009; "Amount Without VAT"; Decimal)
        {
            Caption = 'Amount Without VAT';
            Description = '50085';
        }
        field(70011; WithOut; Boolean)
        {
            Caption = 'With Out';

            trigger OnValidate()
            begin
                UpdateCommitedDetail();
            end;
        }
        field(70013; "Paid With VAT"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("Vendor No."),
                                                                                  "Agreement No." = FIELD("No."),
                                                                                  "Document Type" = FILTER(" " | Payment | Refund),
                                                                                  "Entry Type" = FILTER("Initial Entry" | "Unrealized Loss" | "Unrealized Gain" | "Realized Loss" | "Realized Gain" | "Payment Discount" | "Payment Discount (VAT Excl.)" | "Payment Discount (VAT Adjustment)" | "Payment Tolerance" | "Payment Discount Tolerance" | "Payment Tolerance (VAT Excl.)" | "Payment Tolerance (VAT Adjustment)" | "Payment Discount Tolerance (VAT Excl.)" | "Payment Discount Tolerance (VAT Adjustment)"),
                                                                                  "Posting Date" = FIELD(FILTER("Paid With VAT Date Filter"))));
            Caption = 'Paid With VAT';
            Description = '50085';
        }
        field(70018; "Unbound Cost"; Decimal)
        {
            Caption = 'Unbound Cost';
        }
        field(70020; "Check Limit Starting Date"; Date)
        {
            Caption = 'Check Limit Starting Date';
            Description = 'NC 51432 PA';

            trigger OnValidate()
            begin
                CheckDatesForLimit();
            end;
        }
        field(70021; "Check Limit Ending Date"; Date)
        {
            Caption = 'Check Limit Ending Date';
            Description = 'NC 51432 PA';

            trigger OnValidate()
            begin
                CheckDatesForLimit();
            end;
        }
        field(70022; "Check Limit Amount (LCY)"; Decimal)
        {
            Caption = 'Check Limit Amount (LCY)';
            Description = 'NC 51432 PA';
        }
        field(70023; "Purch. Original Amt. (LCY)"; Decimal)
        {
            Caption = 'Purch. Original Amt. (LCY)';
            Description = 'NC 51432 PA';
            FieldClass = FlowField;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" where("Entry Type" = filter("Initial Entry"),
                                                                                   "Document Type" = filter(Invoice | "Credit Memo"),
                                                                                   "Vendor No." = field("Vendor No."),
                                                                                   "Agreement No." = field("No."),
                                                                                   "Posting Date" = field("Check Limit Date Filter")));
        }
        field(70024; "Check Limit Date Filter"; Date)
        {
            Caption = 'Check Limit Date Filter';
            Description = 'NC 51432 PA';
            FieldClass = FlowFilter;
        }

        field(70025; "Paid With VAT Date Filter"; Date)
        {
            Caption = 'Paid With VAT Date Filter';
            Description = '50085';
            FieldClass = FlowFilter;
        }
        field(70040; "Don't Check CashFlow"; Boolean)
        {
            Caption = 'Don''t Check CashFlow';
            Description = '50085';
        }

        modify("Vendor Posting Group")
        {
            trigger OnAfterValidate()
            var
                VendLedgEntry: Record "Vendor Ledger Entry";
                UserSetup: Record "User Setup";
                PurchSetup: Record "Purchases & Payables Setup";
                LabelPstGrChanging: Label 'You cannot change %1 till you set up %2 of %3';
            begin
                IF "Vendor Posting Group" <> xRec."Vendor Posting Group" THEN BEGIN
                    VendLedgEntry.RESET;
                    VendLedgEntry.SETCURRENTKEY("Vendor No.", "Agreement No.");
                    VendLedgEntry.SETRANGE("Vendor No.", "Vendor No.");
                    VendLedgEntry.SETRANGE("Agreement No.", "No.");
                    IF NOT VendLedgEntry.ISEMPTY THEN BEGIN
                        PurchSetup.GET;
                        IF NOT PurchSetup."Allow Alter Posting Groups" THEN
                            ERROR(LabelPstGrChanging, FIELDCAPTION("Vendor Posting Group"),
                              PurchSetup.FIELDCAPTION("Allow Alter Posting Groups"), PurchSetup.TABLECAPTION);
                        UserSetup.GET(USERID);
                        IF NOT UserSetup."Change Agreem. Posting Group" THEN
                            ERROR(LabelPstGrChanging + '->>%4; %5; %6', FIELDCAPTION("Vendor Posting Group"),
                              UserSetup.FIELDCAPTION("Change Agreem. Posting Group"), UserSetup.TABLECAPTION,
                              UserSetup."User ID", UserId(),
                              UserSetup."Change Agreem. Posting Group");
                    END;
                END;
            end;
        }
    }
    var
        grDimValue: Record "Dimension Value";
        grDevSetup: Record "Development Setup";
        Text12402: Label '%1 should be later than %2.';

    procedure UpdateCommitedDetail()
    var
        CommitedDetail: Record "Commited Detail";
    begin

        CommitedDetail.SETRANGE("Vendor No.", "Vendor No.");
        CommitedDetail.SETRANGE("Agreement No.", "No.");
        IF CommitedDetail.FINDSET THEN
            REPEAT
                CommitedDetail.ByOrder := WithOut;
                CommitedDetail.MODIFY();
            UNTIL CommitedDetail.NEXT = 0;
    end;

    local procedure CheckDatesForLimit()
    begin
        if ("Check Limit Ending Date" <> 0D) and
           ("Check Limit Starting Date" <> 0D) and
           ("Check Limit Ending Date" < "Check Limit Starting Date") then
            Error(Text12402, FieldCaption("Check Limit Ending Date"), FieldCaption("Check Limit Starting Date"));
    end;

    procedure GetLimitDateFilter(): Text
    begin
        if ("Check Limit Starting Date" = 0D) and ("Check Limit Ending Date" = 0D) then
            exit('');

        if ("Check Limit Starting Date" = 0D) and ("Check Limit Ending Date" <> 0D) then
            exit(StrSubstNo('..%1', "Check Limit Ending Date"));

        if ("Check Limit Starting Date" <> 0D) and ("Check Limit Ending Date" = 0D) then
            exit(StrSubstNo('%1..', "Check Limit Starting Date"));

        if ("Check Limit Starting Date" <> 0D) and ("Check Limit Ending Date" <> 0D) then
            exit(STRSUBSTNO('%1..%2', "Check Limit Starting Date", "Check Limit Ending Date"));
    end;

    procedure GetLineColor(): Text
    var
        CompanyInfo: Record "Company Information";
        Vend: Record "Vendor";
        CheckLimitDateFilter: Text[250];
    begin
        CompanyInfo.Get;
        if not CompanyInfo."Use RedFlags in Agreements" then
            exit('None');

        if not Vend.Get("Vendor No.") then
            Clear(Vend);

        CheckLimitDateFilter := GetLimitDateFilter();
        if CheckLimitDateFilter <> '' then
            SetFilter("Check Limit Date Filter", CheckLimitDateFilter)
        else
            SetRange("Check Limit Date Filter");
        CalcFields("Purch. Original Amt. (LCY)");

        if ("Agreement Group" in ['РАМОЧНЫЙ', 'РАМОЧНЫЙ ПОЗАКАЗНЫЙ']) and
           (("Check Limit Amount (LCY)" - "Purch. Original Amt. (LCY)" < 0) or ("Check Limit Amount (LCY)" = 0)) and
           ("Expire Date" >= WORKDATE) and
           Active and
           not (Vend."Vendor Type" = Vend."Vendor Type"::"Resp. Employee") and
           not (Vend."Vendor Type" = Vend."Vendor Type"::"Tax Authority") then
            exit('Attention')
        else
            exit('None');
    end;

    procedure SendVendAgrMail(VendAgr: Record "Vendor Agreement"; RecipientType: Option Creator,Controller)
    var
        CompanyInfo: Record "Company Information";
        UserSetupRecip: Record "User Setup";
        UserSetupSend: Record "User Setup";
        //TempPath: Text;
        //TemplateFile: File;
        //InStreamTemplate: InStream;
        SenderAddress: Text;
        Purchaser: Record "Salesperson/Purchaser";
        UserDesc: Text;
        RecipList: Text;
        Subject: Text;
        Body: Text;
        //InSReadChar: Text;
        //CharNo: Text;
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        MessageBody: Text;
        //i: Integer;
        //ExcelTemplate: Record "Excel Template";
        //PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        Text091: Label 'Check vendor agreements';
        //Text092: Label 'MESSAGE FROM NAV AGREEMENT SYSTEM CONTROL';
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
    begin
        CompanyInfo.GET;
        if not CompanyInfo."Use RedFlags in Agreements" then
            exit;

        UserSetupRecip.Reset();
        if RecipientType = RecipientType::Creator then
            UserSetupRecip.SetRange("Vend. Agr. Creator Notif.", true)
        else
            UserSetupRecip.SetRange("Vend. Agr. Controller Notif.", true);

        if UserSetupRecip.IsEmpty then
            exit;

        //PurchasesPayablesSetup.Get();
        //PurchasesPayablesSetup.TestField("Check Vend. Agr. Template Code");
        //TempPath := ExcelTemplate.OpenTemplate(PurchasesPayablesSetup."Check Vend. Agr. Template Code");

        //TemplateFile.TextMode(true);
        //TemplateFile.Open(TempPath);
        //TemplateFile.CreateInStream(InStreamTemplate);

        UserSetupSend.Get(UserId);
        UserSetupSend.TestField("E-Mail");
        UserSetupSend.TestField("Salespers./Purch. Code");
        SenderAddress := UserSetupSend."E-Mail";

        Purchaser.Get(UserSetupSend."Salespers./Purch. Code");
        UserDesc := Purchaser.Code + ' (' + Purchaser.Name + ')';

        RecipList := '';
        UserSetupRecip.FindSet();
        repeat
            UserSetupRecip.TestField("E-Mail");
            if StrPos(RecipList, UserSetupRecip."E-Mail") = 0 then begin
                if RecipList <> '' then
                    RecipList += ';' + UserSetupRecip."E-Mail"
                else
                    RecipList := UserSetupRecip."E-Mail"
            end;
        until
          UserSetupRecip.Next() = 0;

        Subject := Text091;
        TempBlob.CreateOutStream(OutStr);
        if RecipientType = RecipientType::Creator then
            MessageBody := CreateMessageBodyCreator(UserDesc, VendAgr)
        else
            MessageBody := CreateMessageBodyController(VendAgr);
        OutStr.WriteText(MessageBody);
        CopyStream(OutStr, InStr);
        //TempBlob.CreateInStream(InStr);
        //InStr.ReadText(Body);
        Body := '';

        //Body := StrSubstNo(Text092, CompanyName);
        //Body := '';
        //while InStreamTemplate.Read(InSReadChar, 1) <> 0 do begin
        //    if InSReadChar = '%' then begin
        //        MessageBody := Body;
        //        Body := InSReadChar;
        //        if InStreamTemplate.Read(InSReadChar, 1) <> 0 then;
        //        if (InSReadChar >= '0') and (InSReadChar <= '9') then begin
        //           Body := Body + '1';
        //           CharNo := InSReadChar;
        //           while (InSReadChar >= '0') and (InSReadChar <= '9') do begin
        //               if InStreamTemplate.Read(InSReadChar, 1) <> 0 then;
        //               if (InSReadChar >= '0') and (InSReadChar <= '9') then
        //                   CharNo := CharNo + InSReadChar;
        //           end;
        //       end else
        //           Body := Body + InSReadChar;
        //      FillCheckVendAgrTemplate(Body, CharNo, UserDesc, VendAgr, RecipientType);
        //     MessageBody := MessageBody + Body;
        //      Body := InSReadChar;
        //   end else begin
        //       Body := Body + InSReadChar;
        //       i := i + 1;
        //       IF i = 500 then begin
        //           MessageBody := MessageBody + Body;
        //           Body := '';
        //           i := 0;
        //       end;
        //   end;
        //end;

        //MessageBody := MessageBody + Body;
        EmailMessage.Create(RecipList, Subject, Body);
        //EmailMessage.AddAttachment('', 'HTML', InStr);
        EmailMessage.Attachments_GetContent(InStr);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        //TemplateFile.Close();
    end;

    // local procedure FillCheckVendAgrTemplate(var Body: Text; TextNo: Text; UserDesc: Text; VendAgr: Record "Vendor Agreement"; RecipientType: Option Creator,Controller)
    // var
    //     Vend: Record "Vendor";
    //     Text093: Label 'User %1 created a new agreement with number %2 for vendor %3';
    //     Text094: Label 'It is necessary to fill in the information on the control of the purchase limit';
    //     Text095: Label 'Click this link to open document';
    //     Text096: Label 'For the agreement with number %1 for the vendor %2, the purchase limit has been exceeded';
    //     Text097: Label 'Control is needed';
    //     locText001: Label 'RUS="&target=Form 14902%1view=SORTING(Field1,Field2)%2WHERE(Field1=1(%3))%1position=Field1=0(%3),Field2=0(%4)"';
    // begin
    //     case TextNo of
    //         '1':
    //             begin
    //                 Vend.GET(VendAgr."Vendor No.");
    //                 if RecipientType = RecipientType::Creator then
    //                     Body := StrSubstNo(Body, StrSubstNo(Text093, UserDesc, VendAgr."No.", Vend."No." + ' ' + Vend."Full Name"))
    //                 else
    //                     Body := StrSubstNo(Body, StrSubstNo(Text096, VendAgr."No.", Vend."No." + ' ' + Vend."Full Name"));
    //             end;
    //         '2':
    //             begin
    //                 if RecipientType = RecipientType::Creator then
    //                     Body := StrSubstNo(Body, Text094)
    //                 else
    //                     Body := StrSubstNo(Body, Text097);
    //             end;
    //         '3':
    //             Body := StrSubstNo(Body, GetUrl(ClientType::Current) + StrSubstNo(locText001, '%26', '%20', VendAgr."Vendor No.", VendAgr."No."));
    //         '4':
    //             Body := StrSubstNo(Body, Text095);
    //     end;
    // end;

    local procedure CreateMessageBodyCreator(UserDesc: Text; var VendAgr: Record "Vendor Agreement") MessageBody: Text
    var
        Vend: Record "Vendor";
        Reference: Text;
    begin
        MessageBody := '<html>';
        MessageBody := MessageBody + '<head>';
        MessageBody := MessageBody + '<style>';
        MessageBody := MessageBody + 'h1 {';
        MessageBody := MessageBody + 'font-family: arial;';
        MessageBody := MessageBody + 'font-size: 100%;';
        MessageBody := MessageBody + 'text-align:center;';
        MessageBody := MessageBody + '}';
        MessageBody := MessageBody + 'h2 {';
        MessageBody := MessageBody + 'color: MediumAquamarine;';
        MessageBody := MessageBody + 'font-family: arial;';
        MessageBody := MessageBody + 'font-size: 120%;';
        MessageBody := MessageBody + 'text-align:center;';
        MessageBody := MessageBody + '}';
        MessageBody := MessageBody + 'p {';
        MessageBody := MessageBody + 'font-family: arial;';
        MessageBody := MessageBody + 'font-size: 90%;';
        MessageBody := MessageBody + '}';
        MessageBody := MessageBody + '</style>';
        MessageBody := MessageBody + '</head>';
        MessageBody := MessageBody + '<body>';
        MessageBody := MessageBody + '<br><h1>СООБЩЕНИЕ ОТ СИСТЕМЫ КОНТРОЛЯ ДОГОВОРОВ BUSINESS CENTRAL</h1>';
        MessageBody := MessageBody + '<h2>' + Format(CompanyName) + '<br>';
        MessageBody := MessageBody + '<p>< Пользователь <b>' + Format(UserDesc) + '</b> создал новый договор с номером <b>' + Format(VendAgr."No.") + '</b>';
        Vend.GET(VendAgr."Vendor No.");
        MessageBody := MessageBody + 'по поставщику <b>' + Format(Vend."No." + ' ' + Vend."Full Name") + '</b>.';
        MessageBody := MessageBody + '<br><br> Необходимо заполнить информацию по контролю лимита закупки.';
        Reference := GetUrl(ClientType::Current, CompanyName, ObjectType::Page, 14902, VendAgr);
        MessageBody := MessageBody + '<br><p><a href="' + Format(Reference) + '">';
        MessageBody := MessageBody + ' Нажмите на эту ссылку, чтобы открыть документ</a></p>';
        MessageBody := MessageBody + '</body>';
        MessageBody := MessageBody + '</html>';
    end;

    local procedure CreateMessageBodyController(var VendAgr: Record "Vendor Agreement") MessageBody: Text
    var
        Vend: Record "Vendor";
        Reference: Text;
    begin
        MessageBody := '<html>';
        MessageBody := MessageBody + '<head>';
        MessageBody := MessageBody + '<style>';
        MessageBody := MessageBody + 'h1 {';
        MessageBody := MessageBody + 'font-family: arial;';
        MessageBody := MessageBody + 'font-size: 100%;';
        MessageBody := MessageBody + 'text-align:center;';
        MessageBody := MessageBody + '}';
        MessageBody := MessageBody + 'h2 {';
        MessageBody := MessageBody + 'color: MediumAquamarine;';
        MessageBody := MessageBody + 'font-family: arial;';
        MessageBody := MessageBody + 'font-size: 120%;';
        MessageBody := MessageBody + 'text-align:center;';
        MessageBody := MessageBody + '}';
        MessageBody := MessageBody + 'p {';
        MessageBody := MessageBody + 'font-family: arial;';
        MessageBody := MessageBody + 'font-size: 90%;';
        MessageBody := MessageBody + '}';
        MessageBody := MessageBody + '</style>';
        MessageBody := MessageBody + '</head>';
        MessageBody := MessageBody + '<body>';
        MessageBody := MessageBody + '<br><h1>СООБЩЕНИЕ ОТ СИСТЕМЫ КОНТРОЛЯ ДОГОВОРОВ BUSINESS CENTRAL</h1>';
        MessageBody := MessageBody + '<h2>' + Format(CompanyName) + '<br>';
        MessageBody := MessageBody + '<p> По договору с номером <b>' + Format(VendAgr."No.") + '</b> по поставщику ';
        Vend.GET(VendAgr."Vendor No.");
        MessageBody := MessageBody + '<b>' + Format(Vend."No." + ' ' + Vend."Full Name") + '</b>';
        MessageBody := MessageBody + 'превышен лимит закупки.<br><br> Необходим контроль.<p>';
        Reference := GetUrl(ClientType::Current, CompanyName, ObjectType::Page, 14902, VendAgr);
        MessageBody := MessageBody + '<br><p><a href="' + Format(Reference) + '">';
        MessageBody := MessageBody + ' Нажмите на эту ссылку, чтобы открыть документ</a></p>';
        MessageBody := MessageBody + '</body>';
        MessageBody := MessageBody + '</html>';
    end;
}
