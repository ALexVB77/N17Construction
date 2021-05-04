page 70262 "Purchase List Act"
{
    ApplicationArea = Basic, Suite;
    UsageCategory = Tasks;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = "Purchase Header";
    SourceTableView = SORTING("Document Type", "No.") WHERE("Act Type" = FILTER(<> ' '), "Status App" = FILTER(<> Payment), "Problem Type" = FILTER(<> "Act error"));
    DataCaptionFields = "Document Type";
    PageType = Worksheet;
    //PageType = List;
    Caption = 'Payment Orders List';
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group(Filters)
            {
                Caption = 'Filters';
                ShowCaption = false;
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
                    Enabled = Filter1Enabled;
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
                    Caption = 'Document Type';
                    OptionCaption = 'All,Act,KC-2,Act (Production),KC-2 (Production)';
                    trigger OnValidate()
                    begin
                        SetRecFilters;
                        CurrPage.UPDATE;
                    end;
                }

            }

            repeater(Repeater1237120003)
            {
                Editable = false;
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
                field("Invoice No."; "Invoice No.")
                {
                    Editable = false;
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
                field("Статус утверждения"; "Status App Act")
                {
                    Editable = false;
                    ApplicationArea = All;
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
                field("Receive Account"; "Receive Account")
                {
                    Editable = false;
                    ShowCaption = false;
                    ApplicationArea = All;
                }
                field("Location Document"; "Location Document")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {

        area(Creation)
        {
            action(NewButton)
            {
                //if FilterActType = FilterActType::All

            }

        }

        area(Processing)
        {
            //group(Approval)
            //{
            //    Caption = 'Approval';
            //    Image = Approval;
            action(ApproveButton)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Approve';
                Enabled = ApproveButtonEnabled;
                Image = Approve;
                trigger OnAction()
                begin


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
                ApplicationArea = Basic, Suite;
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
            //}
        }
    }

    trigger OnOpenPage()
    begin
        grUserSetup.GET(USERID);

        // SWC968 DD 19.12.16 >>
        IF grUserSetup."Show All Acts KC-2" AND (Filter1 = 0) THEN
            Filter1 := 1;
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

        Filter1: option mydoc,all,approved;
        Filter1Enabled: Boolean;
        Filter2: option all,inproc,ready,pay,problem;
        SortType: option docno,postdate,vendor,userproc;
        FilterActType: option all,act,"kc-2","act (production)","kc-2 (production)";
        ApproveButtonEnabled: boolean;
        DelayButtonEnabled: boolean;
        MyApproved: boolean;
        NewActTypeSelectionEnabled: Boolean;


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

        NewActTypeSelectionEnabled := FilterActType <> FilterActType::All;
    end;

}