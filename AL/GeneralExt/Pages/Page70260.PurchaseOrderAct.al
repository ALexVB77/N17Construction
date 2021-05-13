page 70260 "Purchase Order Act"
{
    Caption = 'Purchase Order Act';
    PageType = Document;
    // PromotedActionCategories = 'New,Process,Report,Approve,Invoice,Posting,View,Request Approval,Incoming Document,Release,Navigate';
    RefreshOnActivate = true;
    SourceTable = "Purchase Header";
    SourceTableView = WHERE("Document Type" = FILTER(Order));
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Importance = Standard;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ShowMandatory = true;
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Exists Attachment"; Rec."Exists Attachment")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Invoice Amount Incl. VAT"; Rec."Invoice Amount Incl. VAT")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Invoice VAT Amount"; Rec."Invoice VAT Amount")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Invoice Amount"; Rec."Invoice Amount Incl. VAT" - Rec."Invoice VAT Amount")
                {
                    Caption = 'Invoice Amount';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Remaining Amount"; Rec."Invoice Amount Incl. VAT" - Rec."Payments Amount")
                {
                    Caption = 'Remaining Amount';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Problem Document"; Rec."Problem Document")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

            }
        }
    }

    var
        gcERPC: Codeunit "ERPC Funtions";


}