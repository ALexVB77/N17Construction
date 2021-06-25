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


        WRH.AddResponseToLibrary(
            WRHExt.CreateApprovalRequestsActCode(),
            0,
            'Создать запрос утверждения для Акта, КС-2', 'GROUP 10');
        WRH.AddResponsePredecessor(WRHExt.CreateApprovalRequestsActCode(), WEH.RunWorkflowOnSendPurchaseDocForApprovalCode());



        /*

        WEH.AddEventToLibrary(
            WEHExt.RunWorkflowOnSendPurchOrderActForApprovalCode(),
            Database::"Purchase Header",
            'Запрошено утверждение Акта или КС-2.',
            0,
            false);

        WEH.AddEventPredecessor(WEH.RunWorkflowOnApproveApprovalRequestCode(), WEHExt.RunWorkflowOnSendPurchOrderActForApprovalCode);
        WRH.AddResponsePredecessor(WRH.SendApprovalRequestForApprovalCode, WEHExt.RunWorkflowOnSendPurchOrderActForApprovalCode);

        WRPH.CreateEntitiesAndFields();
        WRPH.AssignEntitiesToWorkflowEvents();

        WRH.AddResponseToLibrary(
            WRHExt.CreateApprovalRequestsActCode(),
            0,
            'Создать запрос утверждения для Акта, КС-2', 'GROUP 10');
        WRH.AddResponsePredecessor(WRHExt.CreateApprovalRequestsActCode, WEHExt.RunWorkflowOnSendPurchOrderActForApprovalCode);

        WRH.AddResponseToLibrary(
            WRHExt.MoveToNextActStatusCode(),
            0,
            'Утвердить текущий статус Акта, КС-2 и перейти к следующему', 'GROUP 11');
        WRH.AddResponsePredecessor(WRHExt.MoveToNextActStatusCode, WEH.RunWorkflowOnApproveApprovalRequestCode());

        */

        /*
         WRH.AddResponseToLibrary(
             WRHExt.CreateApprovalRequestsActCode(),
             0,
             'Создать запрос утверждения для Акта, КС-2', 'GROUP 10');
         WRH.AddResponsePredecessor(WRHExt.CreateApprovalRequestsActCode, WEHExt.RunWorkflowOnSendPurchOrderActForApprovalCode);


         WR.SetFilter("Function Name", '%1|%2|%3',
             WRHExt.ShowPurchActApproveMessageCode(),
             WRHExt.ChangePurchActStatusCode(),
             WRHExt.ApprovePurchActApprovalRequestCode());
         WR.DeleteAll(true);

         WRH.AddResponseToLibrary(
             WRHExt.ShowPurchActApproveMessageCode(),
             0,
             'Вывод сообщения о изменении статуса для Акта, КС-2', 'GROUP 0');

         WRH.AddResponseToLibrary(
             WRHExt.ChangePurchActStatusCode(),
             0,
             'Проверка и изменение статуса для Акта, КС-2', 'GROUP 0');

         WRH.AddResponseToLibrary(
             WRHExt.ApprovePurchActApprovalRequestCode(),
             0,
             'Утвердить запрос на утверждение для Акта, КС-2', 'GROUP 0');

         WRH.AddResponsePredecessor(WRH.SendApprovalRequestForApprovalCode, WEHExt.RunWorkflowOnSendPurchOrderActForApprovalCode);
         WRH.AddResponsePredecessor(WRHExt.ShowPurchActApproveMessageCode, WEHExt.RunWorkflowOnSendPurchOrderActForApprovalCode);
         WRH.AddResponsePredecessor(WRHExt.ChangePurchActStatusCode, WEHExt.RunWorkflowOnSendPurchOrderActForApprovalCode);
         WRH.AddResponsePredecessor(WRHExt.ApprovePurchActApprovalRequestCode, WEHExt.RunWorkflowOnSendPurchOrderActForApprovalCode);

         //WEH.AddEventPredecessor(WEH.RunWorkflowOnApproveApprovalRequestCode(), WEHExt.RunWorkflowOnSendPurchOrderActForApprovalCode);
         */


    end;
}

