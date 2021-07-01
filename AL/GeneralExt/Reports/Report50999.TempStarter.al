report 50999 "TempStarter"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'TempStarter';
    ProcessingOnly = true;

    trigger OnPreReport()
    var
        WEH: Codeunit "Workflow Event Handling";
        //WEHExt: Codeunit "Workflow Event Handling (Ext)";
        WRPH: Codeunit "Workflow Request Page Handling";
        WRH: Codeunit "Workflow Response Handling";
        WRHExt: Codeunit "Workflow Response Handling Ext";

        WSA: Record "Workflow Step Argument";
        WR: Record "Workflow Response";
    begin

        SelectLatestVersion();

        // Для всех

        WRH.AddResponsePredecessor(WRH.SendApprovalRequestForApprovalCode(), WEH.RunWorkflowOnRejectApprovalRequestCode());

        // Акты и заявки

        WRH.AddResponseToLibrary(
            WRHExt.CreateApprovalRequestsActCode(),
            0,
            'Создать запрос утверждения для Акта, КС-2 и Заявки на оплату', 'GROUP 10');
        WRH.AddResponsePredecessor(WRHExt.CreateApprovalRequestsActCode(), WEH.RunWorkflowOnSendPurchaseDocForApprovalCode());

        WRH.AddResponseToLibrary(
            WRHExt.MoveToNextActStatusCode(),
            0,
            'Перейти к следующему статусу утверждения Акта, КС-2 и Заявки на оплату', 'GROUP 10');
        WRH.AddResponsePredecessor(WRHExt.MoveToNextActStatusCode(), WEH.RunWorkflowOnApproveApprovalRequestCode());

        WRH.AddResponseToLibrary(
            WRHExt.MoveToPrevActStatusCode(),
            0,
            'Вернуться к предыдущему статусу утверждения Акта, КС-2 и Заявки на оплату', 'GROUP 10');
        WRH.AddResponsePredecessor(WRHExt.MoveToPrevActStatusCode(), WEH.RunWorkflowOnRejectApprovalRequestCode());

    end;
}

