Page 70160 "Problem Document Set"
{
    Caption = 'Problem Document Set';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Purchase Header";
    SourceTableView = WHERE("Document Type" = FILTER(Order));
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; "No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Buy-from Vendor Name"; "Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    Editable = false;
                }
                field("Order Date"; "Order Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Purchaser Code"; "Purchaser Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                group(Problem)
                {
                    Caption = 'Problem';
                    field("Problem Document"; "Problem Document")
                    {
                        ApplicationArea = All;
                    }
                    field("Problem Type"; "Problem Type")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("Problem Description"; ProblemDescription)
                    {
                        ApplicationArea = All;
                        Editable = Rec."Problem Document";

                        trigger OnValidate()
                        begin
                            SetProblemDescription(ProblemDescription);
                        end;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Approval)
            {
                Caption = 'Approval';
                action(Comment)
                {
                    ApplicationArea = Suite;
                    Caption = 'Comments';
                    Enabled = "Problem Document";
                    Image = ViewComments;
                    Promoted = true;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ProblemDescription := GetProblemDescription;
    end;

    var
        ProblemDescription: text[80];

    local procedure GetProblemDescription(): Text;
    var
        ApprovalEntry: Record "Approval Entry";
        ApprCommentLine: Record "Approval Comment Line";
    begin
        ApprovalEntry.SetCurrentKey("Entry No.");
        ApprovalEntry.SetRange("Record ID to Approve", Rec.RecordId);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Rejected);
        if not ApprovalEntry.FindLast() then
            exit('');
        ApprCommentLine.SetCurrentKey("Linked Approval Entry No.");
        ApprCommentLine.SetRange("Linked Approval Entry No.", ApprovalEntry."Entry No.");
        if ApprCommentLine.FindLast() then
            exit(ApprCommentLine.Comment);
    end;

    local procedure SetProblemDescription(NewDescription: text[80]);
    var
        ApprovalEntry: Record "Approval Entry";
        ApprCommentLine: Record "Approval Comment Line";
        NewApprCommentLine: Record "Approval Comment Line";
        LocText001: Label 'Could not find a comment related to returning a document for revision.';
    begin
        ApprovalEntry.SetCurrentKey("Entry No.");
        ApprovalEntry.SetRange("Record ID to Approve", Rec.RecordId);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Rejected);
        if not ApprovalEntry.FindLast() then
            error(LocText001);
        ApprCommentLine.SetCurrentKey("Linked Approval Entry No.");
        ApprCommentLine.SetRange("Linked Approval Entry No.", ApprovalEntry."Entry No.");
        ApprCommentLine.SetRange("User ID", UserId);
        if ApprCommentLine.FindLast() then
            NewApprCommentLine := ApprCommentLine
        else begin
            ApprCommentLine.SetRange("User ID");
            if not ApprCommentLine.FindLast() then
                error(LocText001);
            NewApprCommentLine.SetRange("Table ID", ApprCommentLine."Table ID");
            NewApprCommentLine.SetRange("Record ID to Approve", ApprCommentLine."Record ID to Approve");
            NewApprCommentLine := ApprCommentLine;
            NewApprCommentLine."Entry No." := 0;
            NewApprCommentLine.Comment := '';
            NewApprCommentLine.Insert(true);
        end;
        ApprCommentLine.Validate(Comment, NewDescription);
        ApprCommentLine.Modify(true);
    end;

}