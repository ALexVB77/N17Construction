page 70262 "Purchase List Act"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Payment Orders List';
    InsertAllowed = false;
    DeleteAllowed = false;
    DataCaptionFields = "Document Type";
    PageType = Worksheet;
    RefreshOnActivate = true;
    SourceTable = "Purchase Header";
    SourceTableView = SORTING("Document Type", "No.") WHERE("Act Type" = FILTER(<> ' '), "Status App" = FILTER(<> Payment), "Problem Type" = FILTER(<> "Act error"));
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            group(Filters)
            {
                ShowCaption = false;
                field(Selection; Filter2)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Selection';
                    OptionCaption = 'All documents,Documents in processing,Ready-to-pay documents,Paid documents,Problem documents';
                    trigger OnValidate()
                    begin
                        SetRecFilters;
                        CurrPage.UPDATE(FALSE);
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
                        CurrPage.UPDATE(FALSE);
                    end;
                }

                field(cFilter1; Filter1)
                {
                    ApplicationArea = All;
                    Caption = 'Scope';
                    Enabled = Filter1Enabled;
                    OptionCaption = 'My documents,All documents,My Approved';
                    trigger OnValidate()
                    begin
                        SetRecFilters;
                        CurrPage.UPDATE(FALSE);
                    end;
                }

                field(FilterActType; FilterActType)
                {
                    ApplicationArea = All;
                    Caption = 'Document Type';
                    OptionCaption = 'All,Act,KC-2,Act (Production),KC-2 (Production),Advance';
                    trigger OnValidate()
                    begin
                        SetRecFilters;
                        CurrPage.UPDATE(FALSE);
                    end;
                }

            }

            repeater(Repeater1237120003)
            {
                Editable = false;
                field("Problem Document"; Rec."Problem Document")
                {
                    ApplicationArea = All;
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        OpenActCard();
                    end;
                }
                field("Act Type"; "Act Type")
                {
                    ApplicationArea = All;
                }
                field("Approver"; PaymentOrderMgt.GetPurchActApproverFromDim("Dimension Set ID"))
                {
                    ApplicationArea = All;
                    Caption = 'Approver';
                    Editable = false;
                }
                field("Invoice No."; "Invoice No.")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        PurchaseHeader: record "Purchase Header";
                        PurchInvHeader: record "Purch. Inv. Header";
                    begin
                        //NC 22512 > DP
                        IF PurchaseHeader.GET(PurchaseHeader."Document Type"::Order, "Invoice No.") THEN BEGIN
                            PurchaseHeader.RESET;
                            PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Order);
                            PurchaseHeader.SETRANGE("No.", "Invoice No.");
                            PAGE.RUNMODAL(50, PurchaseHeader)
                        END ELSE
                            //NC 22512 < DP
                            //SWC004 AKA 040914
                            IF PurchaseHeader.GET(PurchaseHeader."Document Type"::Invoice, "Invoice No.") THEN BEGIN
                                PurchaseHeader.RESET;
                                PurchaseHeader.SETFILTER("Document Type", '%1', PurchaseHeader."Document Type"::Invoice);
                                PurchaseHeader.SETRANGE("No.", "Invoice No.");
                                PAGE.RUNMODAL(51, PurchaseHeader)
                            END ELSE BEGIN
                                IF PurchInvHeader.GET("Invoice No.") THEN BEGIN
                                    PurchInvHeader.RESET;
                                    PurchInvHeader.SETRANGE("No.", "Invoice No.");
                                    PAGE.RUNMODAL(138, PurchInvHeader);
                                END;
                            END;
                        //SWC004 AKA 040914 <<
                    end;
                }
                field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Invoice No."; "Vendor Invoice No.")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Vendor Name"; "Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = All;
                }
                field("Order Date"; "Order Date")
                {
                    ApplicationArea = All;
                }
                field("Paid Date Fact"; "Paid Date Fact")
                {
                    ApplicationArea = All;
                }
                field("Invoice Amount Incl. VAT"; "Invoice Amount Incl. VAT")
                {
                    ApplicationArea = All;
                }
                field("Статус утверждения"; "Status App Act")
                {
                    ApplicationArea = All;
                }
                field("Date Status App"; "Date Status App")
                {
                    ApplicationArea = All;
                }
                field("Process User"; "Process User")
                {
                    ApplicationArea = All;
                }
                field("Agreement No."; "Agreement No.")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Exists Comment"; Comment)
                {
                    Caption = 'Exists Comment';
                    ApplicationArea = All;
                }
                field("Exists Attachment"; "Exists Attachment")
                {
                    ApplicationArea = All;
                }
                field("Receive Account"; "Receive Account")
                {
                    ApplicationArea = All;
                }
                field("Location Document"; "Location Document")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(New)
            {
                Caption = 'New';
                Image = NewDocument;
                action(NewAct)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Act';
                    Enabled = NewActEnabled;
                    trigger OnAction()
                    begin
                        PaymentOrderMgt.FuncNewRec(Rec, NewActTypeOption::Act);
                    end;
                }
                action(NewKC2)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'KC-2';
                    Enabled = NewKC2Enabled;
                    trigger OnAction()
                    begin
                        PaymentOrderMgt.FuncNewRec(Rec, NewActTypeOption::"KC-2");
                    end;
                }

                /*
                action(NewActProd)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Act (Production)';
                    Enabled = NewActProdEnabled;
                    trigger OnAction()
                    begin
                        PaymentOrderMgt.FuncNewRec(Rec, NewActTypeOption::"Act (Production)");
                    end;
                }
                action(NewKC2Prod)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'KC-2 (Production)';
                    Enabled = NewKC2ProdEnabled;
                    trigger OnAction()
                    begin
                        PaymentOrderMgt.FuncNewRec(Rec, NewActTypeOption::"Act (Production)");
                    end;
                }
                */

                action(NewAdvance)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Advance';
                    Enabled = NewAdvanceEnabled;
                    trigger OnAction()
                    begin
                        PaymentOrderMgt.FuncNewRec(Rec, NewActTypeOption::Advance);
                    end;
                }
            }
            action(DocCard)
            {
                ApplicationArea = All;
                Caption = 'Edit';
                Image = Edit;

                trigger OnAction()
                begin
                    OpenActCard();
                end;
            }
            action(ApproveButton)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Approve';
                Enabled = ApproveButtonEnabled;
                Image = Approve;
                trigger OnAction()
                var
                    ApprovalsMgmtExt: Codeunit "Approvals Mgmt. (Ext)";
                begin


                    // if ApprovalsMgmtExt.CheckPurchOrderActApprovalPossible(Rec) then
                    //     ApprovalsMgmtExt.OnSendPurchOrderActForApproval(Rec);

                    Message('Pressed ApproveButton');

                    /*

                    //SWC380 AKA 200115
                    // SWC1023 DD 28.03.17 >>
                    CheckEmptyLines();
                    // SWC1023 DD 28.03.17 <<
                    StatusAppAct := PurchHeaderAdd.GetStatusAppAct("Document Type", "No.");

                    IF StatusAppAct = StatusAppAct::Approve THEN
                    BEGIN
                      ApprovalEntry.SETRANGE("Table ID",38);
                      ApprovalEntry.SETRANGE("Document Type",ApprovalEntry."Document Type"::Order);
                      ApprovalEntry.SETRANGE("Document No.","No.");
                      ApprovalEntry.SETRANGE("Approver ID",USERID);
                      //ApprovalEntry.SETRANGE("Approver ID", 'FIRUSKPT');
                      ApprovalEntry.SETRANGE(Status,ApprovalEntry.Status::Open);

                      IF ApprovalEntry.FIND('-') THEN
                      BEGIN
                        ApprovalMgt.ApproveApprovalRequest(ApprovalEntry);
                        IF ApprovalEntry."Table ID" = DATABASE::"Purchase Header" THEN BEGIN
                          IF PurchaseHeader.GET(ApprovalEntry."Document Type",ApprovalEntry."Document No.") THEN BEGIN
                            ApproverCheck := PurchHeaderAdd.GetCheckApprover("Document Type", "No."); //SWC380 AKA 190115
                            IF NOT ApproverCheck THEN                                                 //SWC380 AKA 190115
                            BEGIN                                                                     //SWC380 AKA 190115
                              PurchaseHeader."Process User":=gcERPC.GetCurrentAppr(PurchaseHeader);
                              PurchaseHeader."Date Status App":=TODAY;
                              PurchaseHeader.MODIFY;
                            END;                                                                      //SWC380 AKA 190115
                          END;
                        END;
                      END
                      // SWC1013 DD 27.03.17 >>
                      ELSE
                        ERROR('Утверждающий %1 не указан в таблице утверждения!',USERID);
                      // SWC1013 DD 27.03.17 <<
                    END
                    ELSE
                    BEGIN
                      //IF "Act Type" = "Act Type"::Act THEN                                                      //SWC630 AKA 150915
                      IF ("Act Type" = "Act Type"::Act) OR ("Act Type" = "Act Type"::"Act (Production)") THEN     //SWC630 AKA 150915
                        gcERPC.ChangeActStatus(Rec);
                      //IF "Act Type" = "Act Type"::"KC-2" THEN                                                   //SWC630 AKA 150915
                      IF ("Act Type" = "Act Type"::"KC-2") OR ("Act Type" = "Act Type"::"KC-2 (Production)") THEN //SWC630 AKA 150915
                        gcERPC.ChangeKC2Status(Rec);
                      // SWC1023 DD 28.03.17 >>
                      //CurrForm.CLOSE;
                      // SWC1023 DD 28.03.17 <<
                    END;
                    */
                end;
            }
            action(DelayButton)
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Enabled = DelayButtonEnabled;
                Image = Reject;
                trigger OnAction()
                begin

                    Message('Pressed DelayButton');
                    /*    
                    //SWC380 AKA 200115
                    //IF "Act Type" = "Act Type"::Act THEN                                                      //SWC631 AKA 220915
                    IF ("Act Type" = "Act Type"::Act) OR ("Act Type" = "Act Type"::"Act (Production)") THEN     //SWC631 AKA 220915
                      gcERPC.ChangeActStatusDown(Rec);
                    //IF "Act Type" = "Act Type"::"KC-2" THEN                                                   //SWC631 AKA 220915
                    IF ("Act Type" = "Act Type"::"KC-2") OR ("Act Type" = "Act Type"::"KC-2 (Production)") THEN //SWC631 AKA 220915
                      gcERPC.ChangeKC2StatusDown(Rec);
                    */
                end;
            }
        }
        area(Navigation)
        {
            action("Co&mments")
            {
                ApplicationArea = All;
                Caption = 'Co&mments';
                Image = ViewComments;
                RunObject = Page "Purch. Comment Sheet";
                RunPageLink = "Document Type" = FIELD("Document Type"),
                            "No." = FIELD("No."),
                            "Document Line No." = CONST(0);
            }
            action(DocAttach)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RunModal;
                end;
            }
            action(PaymentInvoices)
            {
                ApplicationArea = All;
                Caption = 'Payment Invoices';
                Image = Payment;
                RunObject = Page "Purch. Order Act PayReq. List";
                RunPageLink = "Document Type" = CONST(Order),
                                "IW Documents" = CONST(true),
                                "Linked Purchase Order Act No." = field("No.");
            }
        }
    }

    trigger OnOpenPage()
    begin
        grUserSetup.GET(USERID);

        // SWC968 DD 19.12.16 >>
        IF grUserSetup."Show All Acts KC-2" AND (Filter1 = Filter1::mydoc) THEN
            Filter1 := Filter1::all;
        // SWC968 DD 19.12.16 <<

        //--
        SetSortType;
        SetRecFilters;

        IF grUserSetup."Status App Act" = grUserSetup."Status App Act"::Checker THEN
            Filter1Enabled := FALSE;

        IF grUserSetup."Administrator IW" THEN
            Filter1Enabled := TRUE;
        //--

        //SWC380 AKA 200115 >>
        ApproveButtonEnabled := FALSE;
        DelayButtonEnabled := FALSE;
        // SWC1075 DD 28.07.17 >>
        IF NOT MyApproved THEN
            // SWC1075 DD 28.07.17 <<
            IF grUserSetup."Status App Act" = grUserSetup."Status App Act"::Approve THEN BEGIN
                ApproveButtonEnabled := TRUE;
                DelayButtonEnabled := TRUE;
            END;
        //SWC380 AKA 200115 <<


        //\\ DEBUG
        ApproveButtonEnabled := TRUE;
        DelayButtonEnabled := TRUE;


    end;

    //\\
    var
        grUserSetup: record "User Setup";
        PaymentOrderMgt: Codeunit "Payment Order Management";
        Filter1: option mydoc,all,approved;
        Filter1Enabled: Boolean;
        Filter2: option all,inproc,ready,pay,problem;
        SortType: option docno,postdate,vendor,statusapp,userproc;
        FilterActType: option all,act,"kc-2","act (production)","kc-2 (production)",advance;
        NewActTypeOption: Enum "Purchase Act Type";
        ApproveButtonEnabled: boolean;
        DelayButtonEnabled: boolean;
        MyApproved: boolean;
        NewActEnabled: Boolean;
        NewKC2Enabled: Boolean;
        NewActProdEnabled: Boolean;
        NewKC2ProdEnabled: Boolean;
        NewAdvanceEnabled: Boolean;

    local procedure OpenActCard()
    begin
        case Rec."Act Type" of
            Rec."Act Type"::Advance:
                ;
            else
                page.Runmodal(Page::"Purchase Order Act", Rec);
        end;
        CurrPage.Update(false);
    end;

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
            SortType::StatusApp:
                SETCURRENTKEY("Status App");
            SortType::UserProc:
                SETCURRENTKEY("Process User");
        END;
    end;

    local procedure SetRecFilters()
    var
        AE: record "Approval Entry";
        PH: record "Purchase Header";
    begin
        FILTERGROUP(2);

        SETRANGE("Process User");
        SETRANGE("Status App");
        SETRANGE("Problem Document");

        SETRANGE(Paid);

        // SWC1075 DD 28.07.17 >>
        MARKEDONLY(FALSE);
        CLEARMARKS;
        // SWC1075 DD 28.07.17 <<

        CASE Filter2 OF
            Filter2::InProc:
                SETFILTER("Status App", '<>%1', "Status App"::Payment);
            Filter2::Ready:
                BEGIN
                    SETRANGE("Status App", "Status App"::Payment);
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
                //NC 44119 > KGT
                // SETFILTER("Act Type",'%1|%2|%3|%4',"Act Type"::Act,"Act Type"::"KC-2","Act Type"::"Act (Production)",
                //"Act Type"::"KC-2 (Production)");
                SETFILTER("Act Type", '%1|%2|%3|%4|%5', "Act Type"::Act, "Act Type"::"KC-2", "Act Type"::"Act (Production)",
                    "Act Type"::"KC-2 (Production)", "Act Type"::Advance);
            //NC 44119 < KGT
            //SWC672 AKA 061015 <<
            //SWC630 AKA 150915 >>
            FilterActType::"Act (Production)":
                SETRANGE("Act Type", "Act Type"::"Act (Production)");
            FilterActType::"KC-2 (Production)":
                SETRANGE("Act Type", "Act Type"::"KC-2 (Production)");
            //SWC630 AKA 150915 <<
            //NC 44119 > KGT
            FilterActType::Advance:
                SETRANGE("Act Type", "Act Type"::Advance);
        //NC 44119 < KGT
        END;

        FILTERGROUP(0);

        NewActEnabled := FilterActType in [FilterActType::All, FilterActType::act];
        NewKC2Enabled := FilterActType in [FilterActType::All, FilterActType::"kc-2"];
        NewActProdEnabled := FilterActType in [FilterActType::All, FilterActType::"act (production)"];
        NewKC2ProdEnabled := FilterActType in [FilterActType::All, FilterActType::"kc-2 (production)"];
        NewAdvanceEnabled := FilterActType in [FilterActType::All, FilterActType::advance];
    end;

}