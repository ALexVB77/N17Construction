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
        etsSrc: Record "Excel Template Sheet";
        etsdst: Record "Excel Template Sheet";


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

        etsSrc.ChangeCompany('CRONUS Россия ЗАО');
        if (etssrc.FindSet()) then begin
            repeat

                etsDst.Init();
                etsdst.TransferFields(etssrc);
                if (not etsdst.insert(true)) then;//etdst.modify(true);

            until (etssrc.Next() = 0);
        end;
        message('ok')
    end;




}