codeunit 81521 "Workflow Response Handling Ext"
{
    Permissions = TableData "Sales Header" = rm,
                  TableData "Purchase Header" = rm,
                  TableData "Notification Entry" = imd;

    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, 1521, 'OnExecuteWorkflowResponse', '', false, false)]
    local procedure OnExecuteWorkflowResponse(var ResponseExecuted: Boolean; var Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowResponse: Record "Workflow Response";
    begin
        if not WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name") THEN
            exit;
        case WorkflowResponse."Function Name" of
            CreateApprovalRequestsActCode:
                CreateApprovalRequests(Variant, ResponseWorkflowStepInstance);
            MoveToNextActStatusCode:
                MoveToNextActStatus(Variant, ResponseWorkflowStepInstance);
            MoveToPrevActStatusCode:
                MoveToPrevActStatus(Variant, ResponseWorkflowStepInstance);
            else
                exit;
        end;
        ResponseExecuted := true;
    end;

    local procedure CreateApprovalRequests(Variant: Variant; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        ApprovalsMgmtExt: Codeunit "Approvals Mgmt. (Ext)";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        ApprovalsMgmtExt.CreateApprovalRequestsPurchAct(RecRef, WorkflowStepInstance);
    end;

    local procedure MoveToNextActStatus(Variant: Variant; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        ApprovalsMgmtExt: Codeunit "Approvals Mgmt. (Ext)";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        ApprovalsMgmtExt.MoveToNextPurchActStatus(RecRef, WorkflowStepInstance, false);
    end;

    local procedure MoveToPrevActStatus(Variant: Variant; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        ApprovalsMgmtExt: Codeunit "Approvals Mgmt. (Ext)";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        ApprovalsMgmtExt.MoveToNextPurchActStatus(RecRef, WorkflowStepInstance, true);
    end;

    procedure CreateApprovalRequestsActCode(): Code[128]
    begin
        exit(UpperCase('CreateApprovalRequestsAct'));
    end;

    procedure MoveToNextActStatusCode(): Code[128]
    begin
        exit(UpperCase('MoveToNextActStatus'));
    end;

    procedure MoveToPrevActStatusCode(): Code[128]
    begin
        exit(UpperCase('MoveToPrevActStatus'));
    end;

}