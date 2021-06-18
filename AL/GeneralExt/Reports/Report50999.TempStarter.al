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
    end;
}

