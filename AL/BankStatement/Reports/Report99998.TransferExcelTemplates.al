report 99998 TransferExcelTemplates
{
    UsageCategory = Administration;
    caption = 'TransfeExcelTemplates';
    ApplicationArea = All;
    ProcessingOnly = true;

    trigger OnPostReport()
    var
        etSrc: Record "Excel Template";
        etDst: Record "Excel Template";
    begin
        etSrc.ChangeCompany('CRONUS Россия ЗАО');
        if (etsrc.FindSet()) then begin
            repeat
                etSrc.CalcFields(BLOB);
                etDst.Init();
                etdst.TransferFields(etsrc);
                if (not etdst.insert(true)) then etdst.modify(true);

            until (etsrc.Next() = 0);
        end;
    end;




}