report 50999 "TempStarter"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'TempStarter';
    ProcessingOnly = true;

    trigger OnPreReport()
    var
        WEH: Codeunit "Workflow Event Handling";
        WEHExt: Codeunit "Workflow Event Handling (Ext)";
        WRPH: Codeunit "Workflow Request Page Handling";
        WRH: Codeunit "Workflow Response Handling";
        WRHExt: Codeunit "Workflow Response Handling Ext";

        WSA: Record "Workflow Step Argument";
    begin
        //Codeunit.run(Codeunit::"Notification Entry Dispatcher");

        WEH.AddEventToLibrary(
            WEHExt.RunWorkflowOnSendPurchOrderActForApprovalCode(),
            Database::"Purchase Header",
            'Запрошено утверждение Акта или КС-2.',
            0,
            false);

        WRPH.CreateEntitiesAndFields();
        WRPH.AssignEntitiesToWorkflowEvents();

        WRH.AddResponseToLibrary(
            WRHExt.CreateApprovalRequestsActCode(),
            0,
            'Создать запрос утверждения для Акта, КС-2', 'GROUP 10');

        WRH.AddResponseToLibrary(
            WRHExt.ShowPurchActApproveMessageCode(),
            0,
            'Вывод сообщения о изменении статуса для Акта, КС-2', 'GROUP 0');

        WRH.AddResponseToLibrary(
            WRHExt.ChangePurchActStatusCode(),
            0,
            'Проверка и изменение статуса для Акта, КС-2', 'GROUP 0');

        // WSA.SetRange("Response Function Name", WRHExt.CreateApprovalRequestsActCode);
        // WSA.ModifyAll("Approver Type", WSA."Approver Type"::Approver);
        // WSA.ModifyAll("Approver Limit Type", WSA."Approver Limit Type"::"Specific Approver");

        WRH.AddResponsePredecessor(WRHExt.CreateApprovalRequestsActCode, WEHExt.RunWorkflowOnSendPurchOrderActForApprovalCode);
        WRH.AddResponsePredecessor(WRH.SendApprovalRequestForApprovalCode, WEHExt.RunWorkflowOnSendPurchOrderActForApprovalCode);
        WRH.AddResponsePredecessor(WRHExt.ShowPurchActApproveMessageCode, WEHExt.RunWorkflowOnSendPurchOrderActForApprovalCode);
        WRH.AddResponsePredecessor(WRHExt.ChangePurchActStatusCode, WEHExt.RunWorkflowOnSendPurchOrderActForApprovalCode);

        WEH.AddEventPredecessor(WEH.RunWorkflowOnApproveApprovalRequestCode(), WEHExt.RunWorkflowOnSendPurchOrderActForApprovalCode);

    end;
}

