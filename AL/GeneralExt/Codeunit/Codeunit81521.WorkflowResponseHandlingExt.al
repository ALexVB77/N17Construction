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
        //ApprovalsMgmtExt.CreateApprovalRequestsPurchAct(RecRef, WorkflowStepInstance);
    end;

    local procedure ShowPurchActApproveMessage(Variant: Variant; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        PurchaseHeader: Record "Purchase Header";
        ERPCFunction: Codeunit "ERPC Funtions";
        RecRef: RecordRef;
        MessageText: Text;
    begin
        RecRef.GetTable(Variant);
        RecRef.SetTable(PurchaseHeader);
        MessageText := ERPCFunction.GetActStatusMessage(PurchaseHeader);
        Message(MessageText);
    end;

    local procedure ChangePurchActStatus(Variant: Variant; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        PurchaseHeader: Record "Purchase Header";
        PayOrderMgt: Codeunit "Payment Order Management";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        RecRef.SetTable(PurchaseHeader);
        PayOrderMgt.ApprovePurchaseOrderAct(PurchaseHeader);
    end;

    local procedure ApprovePurchActApprovalRequest(Variant: Variant; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        PurchaseHeader: Record "Purchase Header";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        RecRef.SetTable(PurchaseHeader);
        IF PurchaseHeader."Status App Act" IN [PurchaseHeader."Status App Act"::Checker] then
            ApprovalsMgmt.ApproveRecordApprovalRequest(RecRef.RecordId);
    end;

    procedure CreateApprovalRequestsActCode(): Code[128]
    begin
        exit(UpperCase('CreateApprovalRequestsAct'));
    end;

    procedure ShowPurchActApproveMessageCode(): Code[128]
    begin
        exit(UpperCase('ShowPurchActApproveMessage'));
    end;

    procedure ChangePurchActStatusCode(): Code[128]
    begin
        exit(UpperCase('ChangePurchActStatus'));
    end;

    procedure ApprovePurchActApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('ApprovePurchActApprovalRequestCode'));
    end;

}