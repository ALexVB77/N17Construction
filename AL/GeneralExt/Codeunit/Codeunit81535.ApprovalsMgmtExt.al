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

        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
        NothingToApproveErr: Label 'There is nothing to approve.';


    [IntegrationEvent(false, false)]
    procedure OnSendPurchOrderActForApproval(var PurchaseHeader: Record "Purchase Header")
    begin
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