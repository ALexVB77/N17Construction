codeunit 70000 "ERPC Funtions"
{
    trigger OnRun()
    begin
    end;

    procedure PostForecastEntry(grPH: Record "Purchase Header")
    begin
        message('Call function PostForecastEntry() in CU 70000 ERPC Funtions')
    end;

    procedure UnpostForecastEntry(grPH: Record "Purchase Header")
    begin
        message('Call function UppostForecastEntry() in CU 70000 ERPC Funtions')
    end;
}