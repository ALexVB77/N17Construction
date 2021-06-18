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
    begin
        //Codeunit.run(Codeunit::"Notification Entry Dispatcher");

        WEH.AddEventToLibrary(
            WEHExt.RunWorkflowOnSendPurchOrderActForApprovalCode(),
            Database::"Purchase Header",
            'Запрошено утверждение Акта или КС-2.',
            0,
            false);
    end;
}

