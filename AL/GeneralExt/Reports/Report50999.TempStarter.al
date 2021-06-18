report 50999 "TempStarter"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'TempStarter';
    ProcessingOnly = true;

    trigger OnPreReport()
    begin
        Codeunit.run(Codeunit::"Notification Entry Dispatcher");
    end;
}

