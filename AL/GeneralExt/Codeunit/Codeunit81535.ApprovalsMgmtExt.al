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

    [IntegrationEvent(false, false)]
    procedure OnSendPurchOrderActForApproval(var PurchaseHeader: Record "Purchase Header")
    begin
    end;

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

}