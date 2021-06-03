page 70005 "Payment Request Card"
{
    Caption = 'Payment Request Card';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Approve,Invoice,Posting,View,Request Approval,Incoming Document,Release,Navigate';
    RefreshOnActivate = true;
    SourceTable = "Gen. Journal Line";
    layout
    {
        area(content)
        {
            group(General)
            {
                field(ReceivedDate; PaymentInvHdr."Document Date")
                {
                    ApplicationArea = All;
                    Caption = 'RECEIVED (DATE)';
                    Editable = false;
                }
                group(Checked)
                {
                    Caption = 'CHECKED';
                    field(CHDate; 'chdate')
                    {
                        ApplicationArea = All;
                        Caption = 'DATE';
                        Editable = false;
                    }
                    field(CHUser; 'chuser')
                    {
                        ApplicationArea = All;
                        Caption = 'NAME';
                        Editable = false;
                    }
                }
                field(Supplier; PaymentInvHdr."Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                    Caption = 'SUPPLIER';
                    Editable = false;
                }
                field(OrderNo; "Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'PURCHASE ORDER No.';
                    Editable = false;
                }
                field(DueDate; PaymentInvHdr."Due Date")
                {
                    ApplicationArea = All;
                    Caption = 'DUE DATE';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        PaymentInvHdr.Modify(true);
                    end;
                }
                group(Approved)
                {
                    Caption = 'APPROVED';
                    field(ApprDate; 'GetApprDate')
                    {
                        ApplicationArea = All;
                        Caption = 'DATE';
                        Editable = false;
                    }
                    field(ApprUser; 'GetApprUser')
                    {
                        ApplicationArea = All;
                        Caption = 'NAME';
                        Editable = false;
                    }
                }
                field(Contract; PaymentInvHdr."External Agreement No. (Calc)")
                {
                    ApplicationArea = All;
                    Caption = 'CONTRACT';
                    Editable = false;
                }
                field(InvoiceNo; PaymentInvHdr."Vendor Invoice No.")
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
                SubPageLink = "Document No." = FIELD("Document No.");
            }

            group(Amounts)
            {
                Caption = 'Amounts';
                field(InvoiceVATAmt; PaymentInvHdr."Invoice VAT Amount")
                {
                    ApplicationArea = All;
                    Caption = 'TOTAL VAT AMOUNT, RUB';
                    Editable = false;
                }
                field(InvoiceAmtIncVAT; PaymentInvHdr."Invoice Amount Incl. VAT")
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
        area(Processing)
        {
            action(DocCard)
            {
                ApplicationArea = All;
                Caption = 'Edit';
                Image = Edit;

                trigger OnAction()
                begin
                    page.Runmodal(Page::"Purchase Order App", Rec);
                    CurrPage.Update(false);
                end;
            }
            action(ViewAttachDoc)
            {
                ApplicationArea = All;
                Caption = 'Documents View';
                Enabled = ShowDocEnabled;
                Image = Export;

                trigger OnAction()
                var
                    DocumentAttachment: Record "Document Attachment";
                    RecRef: RecordRef;
                begin
                    PaymentInvHdr.CalcFields("Exists Attachment");
                    PaymentInvHdr.TestField("Exists Attachment");
                    DocumentAttachment.SetRange("Table ID", DATABASE::"Purchase Header");
                    DocumentAttachment.SetRange("Document Type", PaymentInvHdr."Document Type");
                    DocumentAttachment.SetRange("No.", PaymentInvHdr."No.");
                    DocumentAttachment.FindFirst();
                    DocumentAttachment.Export(true);
                end;
            }
        }
        area(Navigation)
        {
            action(VendorCard)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Vendor';
                Enabled = VendorCardEnabled;
                Image = EditLines;
                RunObject = Codeunit "Gen. Jnl.-Show Card";
                ShortCutKey = 'Shift+F7';
            }
            action(Dimensions)
            {
                AccessByPermission = TableData Dimension = R;
                ApplicationArea = Dimensions;
                Caption = 'Dimensions';
                Image = Dimensions;
                ShortCutKey = 'Alt+D';

                trigger OnAction()
                begin
                    ShowDimensions();
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
                                "No." = FIELD("Document No."),
                                "Document Line No." = CONST(0);
            }
            action(DocAttach)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;

                trigger OnAction()
                var
                    PurchHeader: Record "Purchase Header";
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    PurchHeader.Get(PurchHeader."Document Type"::Order, "Document No.");
                    RecRef.GetTable(PurchHeader);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RunModal;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        PaymentInvHdr.GET(PaymentInvHdr."Document Type"::Order, "Document No.");
        PaymentInvHdr.CALCFIELDS("External Agreement No. (Calc)", "Exists Attachment");
        VendorCardEnabled := (Rec."Account Type" = Rec."Account Type"::Vendor) AND (Rec."Account No." <> '');
        ShowDocEnabled := PaymentInvHdr."Exists Attachment";
    end;

    var
        PaymentInvHdr: Record "Purchase Header";
        VendorCardEnabled: Boolean;
        ShowDocEnabled: Boolean;

}