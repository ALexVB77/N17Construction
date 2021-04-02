codeunit 50005 "Code Monkey Translation"
{
    trigger OnRun()
    begin
        
    end;
    var
        ErrText001: Label 'Unknown text constant - "%1".';
    procedure ConstOther(ConstantNameP: Text) Result: Text
    begin
        case ConstantNameP of
            'CC': Result := 'CC';
            else Error(ErrText001, ConstantNameP);
        end;

    end;
    procedure ConstOther(ConstantNameP: Date) Result: Date
    begin
        case ConstantNameP of
            20170628D: Result := 20170628D;
            20190101D: Result := 20190101D;
            else Error(ErrText001, Format(ConstantNameP));
        end
    end;
}