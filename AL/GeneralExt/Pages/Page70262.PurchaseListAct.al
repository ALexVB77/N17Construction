page 70262 "Purchase List Act"
{
    ApplicationArea = Basic, Suite;
    UsageCategory = Tasks;
    Editable = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = "Purchase Header";
    SourceTableView = SORTING("Document Type", "No.") WHERE("Act Type" = FILTER(<> ' '), "Status App NEW" = FILTER(<> Payment), "Problem Type" = FILTER(<> "Act error"));
    DataCaptionFields = "Document Type";
    PageType = Worksheet;
    Caption = 'Payment Orders List';

    layout
    {
        area(content)
        {
            group(Filters)
            {
                Caption = 'Filters';
                field(Selection; Filter2)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Selection';
                    OptionCaption = 'All documents,Documents in processing,Ready-to-pay documents,Paid documents,Problem documents';
                    trigger OnValidate()
                    begin
                        SetRecFilters;
                        CurrPage.UPDATE;
                    end;
                }

                field("Sorting"; SortType)
                {
                    ApplicationArea = All;
                    Caption = 'Sorting';
                    OptionCaption = 'Document No.,Postng Date,Buy-from Vendor Name,Status App,Process User';
                    trigger OnValidate()
                    begin
                        SetSortType;
                        CurrPage.UPDATE;
                    end;
                }

                field(cFilter1; Filter1)
                {
                    ApplicationArea = All;
                    Caption = 'Scope';
                    OptionCaption = 'My documents,All documents,My Approved';
                    trigger OnValidate()
                    begin
                        SetRecFilters;
                        CurrPage.UPDATE;
                    end;
                }

                field(FilterActType; FilterActType)
                {
                    ApplicationArea = All;
                    Caption = 'Тип документа';
                    OptionCaption = 'Все,Акт,КС-2,Акт (Production),КС-2 (Production)';
                    trigger OnValidate()
                    begin
                        SetRecFilters;
                        CurrPage.UPDATE;
                    end;
                }

            }

            repeater(Repeater1237120003)
            {
                field("Problem Document"; "Problem Document")
                {
                    Editable = false;
                    ShowCaption = false;
                    ApplicationArea = All;
                }
                field("No."; "No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Act Type"; "Act Type")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Approver; Approver)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(InvoiceNo; InvoiceNo)
                {
                    Editable = false;
                    ApplicationArea = All;
                    Caption = 'Счет покупки';
                    trigger OnDrillDown()
                    var
                        PurchaseHeader: record "Purchase Header";
                        PurchInvHeader: record "Purch. Inv. Header";
                    begin
                        //NC 22512 > DP
                        IF PurchaseHeader.GET(PurchaseHeader."Document Type"::Order, InvoiceNo) THEN BEGIN
                            PurchaseHeader.RESET;
                            PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Order);
                            PurchaseHeader.SETRANGE("No.", InvoiceNo);
                            PAGE.RUNMODAL(50, PurchaseHeader)
                        END ELSE
                            //NC 22512 < DP
                            //SWC004 AKA 040914
                            IF PurchaseHeader.GET(PurchaseHeader."Document Type"::Invoice, InvoiceNo) THEN BEGIN
                                PurchaseHeader.RESET;
                                PurchaseHeader.SETFILTER("Document Type", '%1', PurchaseHeader."Document Type"::Invoice);
                                PurchaseHeader.SETRANGE("No.", InvoiceNo);
                                PAGE.RUNMODAL(51, PurchaseHeader)
                            END ELSE BEGIN
                                IF PurchInvHeader.GET(InvoiceNo) THEN BEGIN
                                    PurchInvHeader.RESET;
                                    PurchInvHeader.SETRANGE("No.", InvoiceNo);
                                    PAGE.RUNMODAL(138, PurchInvHeader);
                                END;
                            END;
                        //SWC004 AKA 040914 <<
                    end;
                }
                field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Vendor Invoice No."; "Vendor Invoice No.")
                {
                    Visible = true;
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Buy-from Vendor Name"; "Buy-from Vendor Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Document Date"; "Document Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Order Date"; "Order Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Paid Date Fact"; "Paid Date Fact")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Invoice Amount Incl. VAT"; "Invoice Amount Incl. VAT")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Статус утверждения"; StatusAppAct)
                {
                    Editable = false;
                    ApplicationArea = All;
                    Caption = 'Статус утверждения';
                }
                field("Date Status App"; "Date Status App")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Process User"; "Process User")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Agreement No."; "Agreement No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Visible = true;
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Visible = true;
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Exists Comment"; Comment)
                {
                    Editable = false;
                    ShowCaption = false;
                    ApplicationArea = All;
                }
                field("Exists Attachment"; "Exists Attachment")
                {
                    Editable = false;
                    ShowCaption = false;
                    ApplicationArea = All;
                }
                field(ReceiveAcc; ReceiveAcc)
                {
                    Editable = false;
                    ShowCaption = false;
                    ApplicationArea = All;
                    Caption = 'Передано в Бухгалтерию';
                }
                field(LocationDocument; LocationDocument)
                {
                    Editable = false;
                    ShowCaption = false;
                    ApplicationArea = All;
                    Caption = 'LocationDocument';

                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin


        // NC AB >>
        // #CHECKLATER    

        /* 

        StatusAppAct := PurchHeaderAdd.GetStatusAppAct("Document Type", Rec."No.");
        InvoiceNo := PurchHeaderAdd.GetInvoiceNo("Document Type", Rec."No.");       //SWC004 AKA 050914
        ReceiveAcc := PurchHeaderAdd.GetReceiveAccount("Document Type", Rec."No."); //SWC380 AKA 260215

        //NC 22512 > DP
        LocationDocument := PurchHeaderAdd.GetLocationDocument("Document Type", Rec."No.");
        //NC 22512 < DP

        */

    end;

    trigger OnOpenPage()
    begin

        // NC AB >>
        // #CHECKLATER    

        /*    

        grUserSetup.GET(USERID);
        // SWC968 DD 19.12.16 >>
        IF grUserSetup."Show All Acts KC-2" AND (Filter1 = 0) THEN
            Filter1 := 1;
        // SWC968 DD 19.12.16 <<

        SetSortType;
        SetRecFilters;

        IF grUserSetup."Status App Act" = grUserSetup."Status App Act"::Checker THEN;
        CurrPage.cFilter1.ENABLED := FALSE;

        IF grUserSetup."Administrator IW" THEN;
        CurrPage.cFilter1.ENABLED := TRUE;
        //--;

        //SWC380 AKA 200115 >>;
        US.GET(USERID);
        CurrPage.ApproveButton.VISIBLE := FALSE;
        CurrPage.DelayButton.VISIBLE := FALSE;
        // SWC1075 DD 28.07.17 >>;
        IF NOT MyApproved THEN;
        // SWC1075 DD 28.07.17 <<;
        IF US."Status App Act" = US."Status App Act"::Approve THEN;
        BEGIN
            ;
            CurrPage.ApproveButton.VISIBLE := TRUE;
            CurrPage.DelayButton.VISIBLE := TRUE;
        END;
        //SWC380 AKA 200115 <<;

        */
    end;

    var
        //DimMgt: codeunit DimensionManagement;
        grPurchHeader: record "Purchase Header";
        //gcduERPCF: codeunit "ERPC Funtions";
        grUserSetup: record "User Setup";
        pCheckDocDate: boolean;
        active: boolean;
        grUS: record "User Setup";
        grUS1: record "User Setup";
        ShowOther: boolean;
        grPH: record "Purchase Header";
        grAttachment: record "Attachment";
        //gfAttachment: page "Attacments List";
        grPurchPay: record "Purchases & Payables Setup";
        //grPaymentRequest: report "Payment Request";
        SortType: option docno,postdate,vendor,userproc;
        Filter1: option mydoc,all,approved;
        Filter2: option all,inproc,ready,pay,problem;
        r: text[30];
        i: integer;
        //gcERPC: codeunit "ERPC Funtions";
        //PurchHeaderAdd: record "Purchase Header Additional";
        StatusAppAct: enum "Purchase Act Approval Status";
        FilterActType: option all,act,"kc-2","act (production)","kc-2 (production)";
        Window: dialog;
        // ActTypeOption: option акт,кс-2,"акт (production)","кс-2 (production)";
        InvoiceNo: code[20];
        US: record "User Setup";
        ApprovalEntry: record "Approval Entry";
        //ApprovalMgt: codeunit "Approvals Management";
        PurchaseHeader: record "Purchase Header";
        ApproverCheck: boolean;
        ReceiveAcc: boolean;
        MyApproved: boolean;
        Text50000: Label 'Данные по бюджетам будут удалены. Добавить документ в архив проблемных документов?';
        Text50001: Label 'Добавить документ в архив проблемных документов?';
        LocationDocument: boolean;
        Text50002: Label 'Отсутствует настройка Кладовщик склад для текущего пользователя. Обратитесь к администратору.';
        Text50003: Label 'Складской документ,Акт/КС-2 на услугу';
        Text50004: Label 'Выберите тип создаваемого документа';
        Text50005: Label 'Требуется выбрать тип документа';

    local procedure SetSortType()
    begin
        //--
        CASE SortType OF
            SortType::DocNo:
                // SWC1075 DD 28.07.17 >>
                //SETCURRENTKEY("No.");
                SETCURRENTKEY("Document Type", "No.");
            // SWC1075 DD 28.07.17 <<
            SortType::PostDate:
                SETCURRENTKEY("Posting Date");
            SortType::Vendor:
                SETCURRENTKEY("Buy-from Vendor Name");
            SortType::UserProc:
                SETCURRENTKEY("Process User");
        END;
    end;

    local procedure SetRecFilters()
    var
        AE: record "Approval Entry";
        PH: record "Purchase Header";
    begin
        //--
        FILTERGROUP(0);
        SETRANGE("Process User");
        SETRANGE("Status App NEW");
        SETRANGE("Problem Document");

        SETRANGE(Paid);

        // SWC1075 DD 28.07.17 >>
        MARKEDONLY(FALSE);
        CLEARMARKS;
        // SWC1075 DD 28.07.17 <<

        CASE Filter2 OF
            Filter2::InProc:
                SETFILTER("Status App NEW", '<>%1', "Status App NEW"::Payment);
            Filter2::Ready:
                BEGIN
                    SETRANGE("Status App NEW", "Status App NEW"::Payment);
                    SETRANGE(Paid, FALSE);
                END;
            Filter2::Pay:
                SETRANGE(Paid, TRUE);
            Filter2::Problem:
                SETRANGE("Problem Document", TRUE);
        END;

        CASE Filter1 OF
            Filter1::MyDoc:
                SETRANGE("Process User", USERID);
            // SWC1075 DD 28.07.17 >>
            Filter1::Approved:
                BEGIN
                    PH := Rec;
                    AE.SETCURRENTKEY("Approver ID", Status);
                    AE.SETRANGE("Approver ID", USERID);
                    AE.SETRANGE(Status, AE.Status::Approved);
                    IF AE.FINDSET THEN
                        REPEAT
                            IF GET(AE."Document Type", AE."Document No.") THEN
                                MARK(TRUE);
                        UNTIL AE.NEXT = 0;
                    Rec := PH;
                    MARKEDONLY(TRUE);
                END;
        // SWC1075 DD 28.07.17 <<
        END;

        CASE FilterActType OF
            FilterActType::Act:
                SETRANGE("Act Type", "Act Type"::Act);
            FilterActType::"KC-2":
                SETRANGE("Act Type", "Act Type"::"KC-2");
            FilterActType::All:                                        //SWC004 AKA 080714
                                                                       //SWC672 AKA 061015 >>
                                                                       //SETRANGE("Act Type","Act Type"::Act,"Act Type"::"KC-2");  //SWC004 AKA 080714
                SETFILTER("Act Type", '%1|%2|%3|%4', "Act Type"::Act, "Act Type"::"KC-2", "Act Type"::"Act (Production)",
                  "Act Type"::"KC-2 (Production)");
            //SWC672 AKA 061015 <<
            //SWC630 AKA 150915 >>
            FilterActType::"Act (Production)":
                SETRANGE("Act Type", "Act Type"::"Act (Production)");
            FilterActType::"KC-2 (Production)":
                SETRANGE("Act Type", "Act Type"::"KC-2 (Production)");
        //SWC630 AKA 150915 <<
        END;

        FILTERGROUP(2);
    end;

}