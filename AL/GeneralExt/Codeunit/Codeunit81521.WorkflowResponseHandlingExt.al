codeunit 81521 "Workflow Response Handling Ext"
{
    Permissions = TableData "Sales Header" = rm,
                  TableData "Purchase Header" = rm,
                  TableData "Notification Entry" = imd;

    trigger OnRun()
    begin
    end;

    procedure CreateApprovalRequestsCodeAct(): Code[128]
    begin
        exit(UpperCase('CreateApprovalRequestsAct'));
    end;

}