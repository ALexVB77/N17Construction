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
        WorkflowEventHandlingExt: Codeunit "Workflow Event Handling (Ext)";
        WorkflowResponceHandling: Codeunit "Workflow Response Handling Ext";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";

        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
        NothingToApproveErr: Label 'There is nothing to approve.';
        UserIdNotInSetupErr: Label 'User ID %1 does not exist in the Approval User Setup window.', Comment = 'User ID NAVUser does not exist in the Approval User Setup window.';

    [IntegrationEvent(false, false)]
    procedure OnSendPurchOrderActForApproval(var PurchaseHeader: Record "Purchase Header")
    begin
    end;

    /*
    // NC AB - не нужно
    [EventSubscriber(ObjectType::Codeunit, 1535, 'OnAfterPopulateApprovalEntryArgument', '', false, false)]
    local procedure OnAfterPopulateApprovalEntryArgument(WorkflowStepInstance: Record "Workflow Step Instance"; var ApprovalEntryArgument: Record "Approval Entry"; var IsHandled: Boolean)
    var
        PurchHeader: Record "Purchase Header";
        ERPCFunction: Codeunit "ERPC Funtions";
    begin
        if (ApprovalEntryArgument."Table ID" = DATABASE::"Purchase Header") and
            (WorkflowStepInstance."Function Name" = WorkflowResponceHandling.CreateApprovalRequestsActCode)
        then begin
            PurchHeader.Get(ApprovalEntryArgument."Document Type", ApprovalEntryArgument."Document No.");
            ApprovalEntryArgument."Approver ID" := ERPCFunction.GetActApprover(PurchHeader);
        end;
    end;
    */

    procedure CheckPurchOrderActApprovalPossible(var PurchaseHeader: Record "Purchase Header"): Boolean
    begin
        if not IsPurchOrderActApprovalsWorkflowEnabled(PurchaseHeader) then
            Error(NoWorkflowEnabledErr);

        if not PurchaseHeader.PurchLinesExist then
            Error(NothingToApproveErr);

        exit(true);
    end;

    procedure IsPurchOrderActApprovalsWorkflowEnabled(var PurchaseHeader: Record "Purchase Header"): Boolean
    begin
        exit(WorkflowManagement.CanExecuteWorkflow(PurchaseHeader, WorkflowEventHandlingExt.RunWorkflowOnSendPurchOrderActForApprovalCode));
    end;

    procedure CreateApprovalRequestsPurchAct(RecRef: RecordRef; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        ApprovalEntryArgument: Record "Approval Entry";
        PurchHeader: Record "Purchase Header";
        ERPCFunction: Codeunit "ERPC Funtions";
    begin
        PopulateApprovalEntryArgumentPurchAct(RecRef, WorkflowStepInstance, ApprovalEntryArgument);

        PurchHeader.Get(ApprovalEntryArgument."Document Type", ApprovalEntryArgument."Document No.");
        if PurchHeader."Status App Act" = PurchHeader."Status App Act"::Checker then begin
            PurchHeader.TestField(Controller);
            CreateApprovalRequestForSpecificUser(WorkflowStepArgument, ApprovalEntryArgument, PurchHeader.Controller);
        end;

        // DEBUG
        // CreateApprovalRequestForSpecificUser(WorkflowStepArgument, ApprovalEntryArgument, ERPCFunction.GetActApprover(PurchHeader));
        CreateApprovalRequestForSpecificUser(WorkflowStepArgument, ApprovalEntryArgument, 'NAV-BONAVA\TESTUSER');
51374
        if WorkflowStepArgument."Show Confirmation Message" then
            ApprovalsMgmt.InformUserOnStatusChange(RecRef, WorkflowStepInstance.ID);
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

}