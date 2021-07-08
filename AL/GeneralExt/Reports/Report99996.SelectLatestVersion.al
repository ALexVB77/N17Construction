report 99996 "Select Latest Version"
{
    Caption = 'Select Latest Version';
    ProcessingOnly = true;
    UsageCategory = Administration;
    ApplicationArea = Basic, Suite;

    trigger OnPreReport()

    begin
        SelectLatestVersion();
        Message('Latest version selected');
    end;

}