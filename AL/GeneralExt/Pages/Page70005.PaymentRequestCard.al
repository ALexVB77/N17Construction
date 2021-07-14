page 70005 "Payment Request Card"
{
    Caption = 'Payment Request Card';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Payment Request,Request Approval,Approve';
    RefreshOnActivate = true;
    SourceTable = "Purchase Header";
    layout
    {
        area(content)
        {
            group(General)
            {
                field(ReceivedDate; "Document Date")
                {
                    ApplicationArea = All;
                    Caption = 'RECEIVED (DATE)';
                    Editable = false;
                }
                field(DueDate; "Due Date")
                {
                    ApplicationArea = All;
                    Caption = 'DUE DATE';
                    Editable = false;
                }
                group(Checked)
                {
                    Caption = 'CHECKED';
                    field(CHDate; CHDate)
                    {
                        ApplicationArea = All;
                        Caption = 'DATE';
                        Editable = false;
                    }
                    field(CHUser; CHUser)
                    {
                        ApplicationArea = All;
                        Caption = 'NAME';
                        Editable = false;
                    }
                }
                group(Approved)
                {
                    Caption = 'APPROVED';
                    field(ApprDate; ApprDate)
                    {
                        ApplicationArea = All;
                        Caption = 'DATE';
                        Editable = false;
                    }
                    field(ApprUser; ApprUser)
                    {
                        ApplicationArea = All;
                        Caption = 'NAME';
                        Editable = false;
                    }
                }
                field(Supplier; "Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                    Caption = 'SUPPLIER';
                    Editable = false;
                }
                field(OrderNo; "No.")
                {
                    ApplicationArea = All;
                    Caption = 'PURCHASE ORDER No.';
                    Editable = false;
                }
                field(Contract; "External Agreement No. (Calc)")
                {
                    ApplicationArea = All;
                    Caption = 'CONTRACT';
                    Editable = false;
                }
                field(InvoiceNo; "Vendor Invoice No.")
                {
                    ApplicationArea = All;
                    Caption = 'INVOICE No.';
                    Editable = false;
                }
            }
            part(DetailLines; "Req Subform")
            {
                ApplicationArea = All;
                Editable = false;
                SubPageLink = "Document No." = FIELD("No.");
            }
            group(Amounts)
            {
                Caption = 'Amounts';
                field(InvoiceVATAmt; "Invoice VAT Amount")
                {
                    ApplicationArea = All;
                    Caption = 'TOTAL VAT AMOUNT, RUB';
                    Editable = false;
                }
                field(InvoiceAmtIncVAT; "Invoice Amount Incl. VAT")
                {
                    ApplicationArea = All;
                    Caption = 'TOTAL INVOICE AMOUNT, RUB';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group(PaymentRequest)
            {
                Caption = 'Payment Request';
                Image = Payment;
                action(DocCard)
                {
                    ApplicationArea = All;
                    Caption = 'Order';
                    Image = Order;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Purchase Order App";
                    RunPageLink = "No." = field("No.");
                }
                action(ViewAttachDoc)
                {
                    ApplicationArea = All;
                    Caption = 'Documents View';
                    Enabled = ShowDocEnabled;
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        DocumentAttachment: Record "Document Attachment";
                        RecRef: RecordRef;
                    begin
                        CalcFields("Exists Attachment");
                        TestField("Exists Attachment");
                        DocumentAttachment.SetRange("Table ID", DATABASE::"Purchase Header");
                        DocumentAttachment.SetRange("Document Type", "Document Type");
                        DocumentAttachment.SetRange("No.", "No.");
                        DocumentAttachment.FindFirst();
                        DocumentAttachment.Export(true);
                    end;
                }
                action(VendorCard)
                {
                    ApplicationArea = Suite;
                    Caption = 'Vendor';
                    Enabled = "Buy-from Vendor No." <> '';
                    Image = Vendor;
                    RunObject = Page "Vendor Card";
                    RunPageLink = "No." = FIELD("Buy-from Vendor No."),
                                  "Date Filter" = FIELD("Date Filter");
                    ShortCutKey = 'Shift+F7';
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Alt+D';
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        ShowDocDim;
                        CurrPage.SaveRecord;
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Purch. Comment Sheet";
                    RunPageLink = "Document Type" = const(Order),
                                "No." = FIELD("No."),
                                "Document Line No." = CONST(0);
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                }
                action(DocAttach)
                {
                    ApplicationArea = All;
                    Caption = 'Attachments';
                    Image = Attach;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

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
                action(Approvals)
                {
                    AccessByPermission = TableData "Approval Entry" = R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        WorkflowsEntriesBuffer: Record "Workflows Entries Buffer";
                    begin
                        WorkflowsEntriesBuffer.RunWorkflowEntriesPage(
                            RecordId, DATABASE::"Purchase Header", "Document Type".AsInteger(), "No.");
                    end;
                }
            }
        }
        area(processing)
        {
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = Suite;
                    Caption = 'Approve';
                    Enabled = ApproveButtonEnabled;
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        MessageIfPurchLinesNotExist;
                        if not ("Status App" in ["Status App"::Checker, "Status App"::Approve]) then
                            FieldError("Status App");
                        ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Suite;
                    Caption = 'Reject';
                    Enabled = RejectButtonEnabled;
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if not ("Status App" in ["Status App"::Approve]) then
                            FieldError("Status App");
                        ApprovalsMgmtExt.RejectPurchActAndPayInvApprovalRequest(RECORDID);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = Suite;
                    Caption = 'Delegate';
                    Enabled = DelegateButtonEnabled;
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if not ("Status App" in ["Status App"::Approve]) then
                            FieldError("Status App");
                        ApprovalsMgmt.DelegateRecordApprovalRequest(RecordId);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = Suite;
                    Caption = 'Comments';
                    Enabled = ApproveButtonEnabled or RejectButtonEnabled;
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category6;

                    trigger OnAction()
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CALCFIELDS("External Agreement No. (Calc)", "Exists Attachment");
        ShowDocEnabled := "Exists Attachment";

        ApproveButtonEnabled := false;
        RejectButtonEnabled := false;
        DelegateButtonEnabled := false;

        if ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId) then begin
            ApproveButtonEnabled := "Status App" in ["Status App"::Checker, "Status App"::Approve];
            RejectButtonEnabled := "Status App" in ["Status App"::Approve];
            DelegateButtonEnabled := RejectButtonEnabled;
        end;

        FillAppoveInfo();
    end;

    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ApprovalsMgmtExt: Codeunit "Approvals Mgmt. (Ext)";
        ShowDocEnabled: Boolean;
        ApproveButtonEnabled, RejectButtonEnabled, DelegateButtonEnabled : Boolean;
        CHDate, ApprDate : date;
        CHUser, ApprUser : Code[50];

    local procedure FillAppoveInfo()
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        CHDate := 0D;
        CHUser := '';

        ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.", "Record ID to Approve");
        ApprovalEntry.SetRange("Table ID", Database::"Purchase Header");
        ApprovalEntry.SetRange("Record ID to Approve", Rec.RecordId);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
        ApprovalEntry.SetRange("Status App", ApprovalEntry."Status App"::Checker);
        if ApprovalEntry.FindLast() then begin
            CHDate := DT2Date(ApprovalEntry."Last Date-Time Modified");
            CHUser := ApprovalEntry."Approver ID";
        end;

        ApprDate := 0D;
        ApprUser := '';

        ApprovalEntry.SetRange("Status App", ApprovalEntry."Status App"::Approve);
        if ApprovalEntry.FindLast() then begin
            ApprDate := DT2Date(ApprovalEntry."Last Date-Time Modified");
            ApprUser := ApprovalEntry."Approver ID";
        end;
    end;

}