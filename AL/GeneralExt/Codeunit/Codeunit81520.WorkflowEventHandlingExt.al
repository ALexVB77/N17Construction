codeunit 81520 "Workflow Event Handling (Ext)"
{

    trigger OnRun()
    begin
    end;

    var
        WorkflowManagement: Codeunit "Workflow Management";

    [EventSubscriber(ObjectType::Codeunit, 81535, 'OnSendPurchOrderActForApproval', '', false, false)]
    procedure RunWorkflowOnSendPurchOrderActForApproval(var PurchaseHeader: Record "Purchase Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendPurchOrderActForApprovalCode, PurchaseHeader);
    end;

    procedure RunWorkflowOnSendPurchOrderActForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendPurchOrderActForApproval'));
    end;

}