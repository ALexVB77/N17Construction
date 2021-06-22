codeunit 81521 "Workflow Response Handling Ext"
{
    Permissions = TableData "Sales Header" = rm,
                  TableData "Purchase Header" = rm,
                  TableData "Notification Entry" = imd;

    trigger OnRun()
    begin
    end;

    /*
    // NC AB - не нужно, пока агументы не используем
    [EventSubscriber(ObjectType::Table, 1502, 'OnAfterValidateEvent', 'Function Name', false, false)]
    local procedure OnWorkflowStepAfterValidateFunctionName(Rec: Record "Workflow Step"; xRec: Record "Workflow Step"; CurrFieldNo: Integer)
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        if (Rec.Type = Rec.Type::Response) and (Rec."Function Name" = CreateApprovalRequestsActCode) then
            if WorkflowStepArgument.Get(Rec.Argument) then
                if (WorkflowStepArgument."Approver Type" <> WorkflowStepArgument."Approver Type"::Approver) or
                    (WorkflowStepArgument."Approver Limit Type" <> WorkflowStepArgument."Approver Limit Type"::"Specific Approver")
                then begin
                    WorkflowStepArgument."Approver Type" := WorkflowStepArgument."Approver Type"::Approver;
                    WorkflowStepArgument."Approver Limit Type" := WorkflowStepArgument."Approver Limit Type"::"Specific Approver";
                    WorkflowStepArgument.Modify();
                end;
    end;
    */

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
            ShowPurchActApproveMessageCode:
                ShowPurchActApproveMessage(Variant, ResponseWorkflowStepInstance);
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

    local procedure ShowPurchActApproveMessage(Variant: Variant; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        PurchaseHeader: Record "Purchase Header";
        ERPCFunction: Codeunit "ERPC Funtions";
        RecRef: RecordRef;
        MessageText: Text;
    begin
        RecRef.SetTable(PurchaseHeader);
        MessageText := ERPCFunction.GetActStatusMessage(PurchaseHeader);
        Message(MessageText);
    end;

    procedure CreateApprovalRequestsActCode(): Code[128]
    begin
        exit(UpperCase('CreateApprovalRequestsAct'));
    end;

    procedure ShowPurchActApproveMessageCode(): Code[128]
    begin
        exit(UpperCase('ShowPurchActApproveMessage'));
    end;

}