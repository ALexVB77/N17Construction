codeunit 81535 "Approvals Mgmt. (Ext)"
{
    Permissions = TableData "Approval Entry" = imd,
                  TableData "Approval Comment Line" = imd,
                  TableData "Posted Approval Entry" = imd,
                  TableData "Posted Approval Comment Line" = imd,
                  TableData "Overdue Approval Entry" = imd,
                  TableData "Notification Entry" = imd;

    trigger OnRun()
    begin
    end;

    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowResponceHandling: Codeunit "Workflow Response Handling Ext";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
        NothingToApproveErr: Label 'There is nothing to approve.';
        UserIdNotInSetupErr: Label 'User ID %1 does not exist in the Approval User Setup window.', Comment = 'User ID NAVUser does not exist in the Approval User Setup window.';

    [EventSubscriber(ObjectType::Codeunit, 1535, 'OnBeforeApprovalEntryInsert', '', false, false)]
    local procedure OnBeforeApprovalEntryInsert(var ApprovalEntry: Record "Approval Entry"; ApprovalEntryArgument: Record "Approval Entry")
    begin
        ApprovalEntry."Status App Act" := ApprovalEntryArgument."Status App Act";
        ApprovalEntry."Act Type" := ApprovalEntryArgument."Act Type";
        if (ApprovalEntry."Act Type" <> ApprovalEntry."Act Type"::" ") and
           (ApprovalEntry."Status App Act".AsInteger() > ApprovalEntry."Status App Act"::Controller.AsInteger()) and
           (ApprovalEntry."Approver ID" = UserId) and ApprovalEntryArgument.Reject
        then
            ApprovalEntry.Status := ApprovalEntry.Status::Created;
    end;

    procedure CreateApprovalRequestsPurchAct(RecRef: RecordRef; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        ApprovalEntryArgument: Record "Approval Entry";
        PurchHeader: Record "Purchase Header";
        PayOrderMgt: Codeunit "Payment Order Management";
    begin
        RecRef.SetTable(PurchHeader);
        PayOrderMgt.ChangePurchaseOrderAct(PurchHeader, false);
        PurchHeader.TestField("Process User");

        PopulateApprovalEntryArgumentPurchAct(RecRef, WorkflowStepInstance, ApprovalEntryArgument);
        ApprovalEntryArgument."Act Type" := PurchHeader."Act Type";
        ApprovalEntryArgument."Status App Act" := ApprovalEntryArgument."Status App Act"::Controller;
        CreateApprovalRequestForSpecificUser(WorkflowStepArgument, ApprovalEntryArgument, PurchHeader.Controller);

        ApprovalEntryArgument."Status App Act" := PurchHeader."Status App Act";
        CreateApprovalRequestForSpecificUser(WorkflowStepArgument, ApprovalEntryArgument, PurchHeader."Process User");

        if UserID = PurchHeader."Process User" then
            MoveToNextPurchActStatus(RecRef, WorkflowStepInstance, false)
        else
            Message(PayOrderMgt.GetPurchaseOrderActChangeStatusMessage(PurchHeader, false));
    end;

    procedure MoveToNextPurchActStatus(RecRef: RecordRef; WorkflowStepInstance: Record "Workflow Step Instance"; Reject: Boolean)
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        ApprovalEntryArgument: Record "Approval Entry";
        ApprovalEntry: Record "Approval Entry";
        PurchHeader: Record "Purchase Header";
        PayOrderMgt: Codeunit "Payment Order Management";
        RecRef2: RecordRef;
    begin
        if RecRef.Number = DATABASE::"Approval Entry" then begin
            RecRef.SetTable(ApprovalEntry);
            PurchHeader.Get(ApprovalEntry."Document Type", ApprovalEntry."Document No.");
        end else begin
            RecRef.SetTable(PurchHeader);
            PurchHeader.Get(PurchHeader."Document Type", PurchHeader."No.");
        end;

        PurchHeader.TestField("Process User", USERID);
        RecRef2.GetTable(PurchHeader);

        PayOrderMgt.ChangePurchaseOrderAct(PurchHeader, Reject);

        if ((not Reject) and (PurchHeader."Status App Act" = PurchHeader."Status App Act"::Accountant)) or
            (Reject and (PurchHeader."Status App Act" = PurchHeader."Status App Act"::Controller))
        then
            Message(PayOrderMgt.GetPurchaseOrderActChangeStatusMessage(PurchHeader, Reject))
        else begin
            PurchHeader.TestField("Process User");
            PopulateApprovalEntryArgumentPurchAct(RecRef2, WorkflowStepInstance, ApprovalEntryArgument);
            ApprovalEntryArgument."Act Type" := PurchHeader."Act Type";
            ApprovalEntryArgument."Status App Act" := PurchHeader."Status App Act";
            ApprovalEntryArgument.Reject := Reject;
            CreateApprovalRequestForSpecificUser(WorkflowStepArgument, ApprovalEntryArgument, PurchHeader."Process User");
            if (UserID = PurchHeader."Process User") and (not Reject) then
                MoveToNextPurchActStatus(RecRef, WorkflowStepInstance, Reject)
            else
                Message(PayOrderMgt.GetPurchaseOrderActChangeStatusMessage(PurchHeader, Reject));
        end;
    end;

    local procedure PopulateApprovalEntryArgumentPurchAct(RecRef: RecordRef; WorkflowStepInstance: Record "Workflow Step Instance"; var ApprovalEntryArgument: Record "Approval Entry")
    var
        PurchaseHeader: Record "Purchase Header";
        EnumAssignmentMgt: Codeunit "Enum Assignment Management";
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
    begin
        ApprovalEntryArgument.Init();
        ApprovalEntryArgument."Table ID" := RecRef.Number;
        ApprovalEntryArgument."Record ID to Approve" := RecRef.RecordId;
        ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::" ";
        ApprovalEntryArgument."Approval Code" := WorkflowStepInstance."Workflow Code";
        ApprovalEntryArgument."Workflow Step Instance ID" := WorkflowStepInstance.ID;

        RecRef.SetTable(PurchaseHeader);
        ApprovalsMgmt.CalcPurchaseDocAmount(PurchaseHeader, ApprovalAmount, ApprovalAmountLCY);
        ApprovalEntryArgument."Document Type" := EnumAssignmentMgt.GetPurchApprovalDocumentType(PurchaseHeader."Document Type");
        ApprovalEntryArgument."Document No." := PurchaseHeader."No.";
        ApprovalEntryArgument."Salespers./Purch. Code" := PurchaseHeader."Purchaser Code";
        ApprovalEntryArgument.Amount := ApprovalAmount;
        ApprovalEntryArgument."Amount (LCY)" := ApprovalAmountLCY;
        ApprovalEntryArgument."Currency Code" := PurchaseHeader."Currency Code";
    end;

    local procedure CreateApprovalRequestForSpecificUser(WorkflowStepArgument: Record "Workflow Step Argument"; ApprovalEntryArgument: Record "Approval Entry"; ApprovalUserID: code[50])
    var
        UserSetup: Record "User Setup";
        SequenceNo: Integer;
    begin
        SequenceNo := ApprovalsMgmt.GetLastSequenceNo(ApprovalEntryArgument);

        if not UserSetup.Get(ApprovalUserID) then
            Error(UserIdNotInSetupErr, ApprovalUserID);

        SequenceNo += 1;
        ApprovalsMgmt.MakeApprovalEntry(ApprovalEntryArgument, SequenceNo, ApprovalUserID, WorkflowStepArgument);
    end;

    procedure RejectPurchActApprovalRequest(RecordID: RecordID)
    var
        ApprovalEntry: Record "Approval Entry";
        NoReqToRejectErr: Label 'There is no approval request to reject.';
    begin
        if not ApprovalsMgmt.FindOpenApprovalEntryForCurrUser(ApprovalEntry, RecordID) then
            Error(NoReqToRejectErr);

        ApprovalEntry.SetRecFilter;
        RejectApprovalRequests(ApprovalEntry);
    end;

    local procedure RejectApprovalRequests(var ApprovalEntry: Record "Approval Entry")
    var
        ApprovalEntryToUpdate: Record "Approval Entry";
    begin
        if ApprovalEntry.FindSet() then
            repeat
                ApprovalEntryToUpdate := ApprovalEntry;
                RejectSelectedApprovalRequest(ApprovalEntryToUpdate);
            until ApprovalEntry.Next = 0;
    end;

    local procedure RejectSelectedApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        UserSetup: Record "User Setup";
        RejectOnlyOpenRequestsErr: Label 'You can only reject open approval entries.';
    begin
        if ApprovalEntry.Status <> ApprovalEntry.Status::Open then
            Error(RejectOnlyOpenRequestsErr);

        if ApprovalEntry."Approver ID" <> UserId then begin
            UserSetup.Get(UserId);
            UserSetup.TestField("Approval Administrator");
        end;

        ApprovalEntry.Get(ApprovalEntry."Entry No.");
        ApprovalEntry.Validate(Status, ApprovalEntry.Status::Rejected);
        ApprovalEntry.Modify(true);

        ApprovalsMgmt.OnRejectApprovalRequest(ApprovalEntry);
    end;

}