tableextension 80091 "User Setup (Ext)" extends "User Setup"
{
    fields
    {
        field(50000; "Change Agreem. Posting Group"; Boolean)
        {
            Caption = 'Allow changing agr. posting group';

        }

        field(70001; "Status App"; enum "User Setup Approval Status")
        {
            Description = 'NC 51378 AB';
            Caption = 'Approval Status';
        }
        field(70003; Absents; Boolean)
        {
            Description = 'NC 51373 AB';
            Caption = 'Absents';
        }
        field(70005; "Administrator IW"; Boolean)
        {
            Description = 'NC 51373 AB';
            Caption = 'Administrator IW';
        }
        field(70008; "Administrator PRJ"; Boolean)
        {
            Description = 'NC 50086 PA';
            Caption = 'Administrator PRJ';
        }
        field(70010; "Vend. Agr. Creator Notif."; Boolean)
        {
            Description = 'NC 51432 PA';
            Caption = 'Vend. Agr. Creator Notif.';
        }
        field(70011; "Vend. Agr. Controller Notif."; Boolean)
        {
            Description = 'NC 51432 PA';
            Caption = 'Vend. Agr. Controller Notif.';
        }
        field(70015; "Status App Act"; enum "User Setup Act Approval Status")
        {
            Description = 'NC 51373 AB';
            Caption = 'Act Approval Status';
        }
        field(70024; "Master Approver (Development)"; Boolean)
        {
            Description = 'NC 51374 AB';
            Caption = 'Master Approver (Development)';

            trigger OnValidate()
            begin
                if "Master Approver (Development)" then begin
                    UserSetup.Reset();
                    UserSetup.SetFilter("User ID", '<>%1', Rec."User ID");
                    UserSetup.SetRange("Master Approver (Development)", true);
                    if UserSetup.FindFirst() then begin
                        if not Confirm(ConfText001, false, UserSetup."User ID", Rec.FieldCaption("Master Approver (Development)"), Rec."User ID") then
                            error('');
                        UserSetup."Master Approver (Development)" := false;
                        UserSetup.Modify();
                    end;
                end;
            end;
        }
        field(70025; "Master Approver (Production)"; Boolean)
        {
            Description = 'NC 51374 AB';
            Caption = 'Master Approver (Production)';

            trigger OnValidate()
            begin
                if "Master Approver (Production)" then begin
                    UserSetup.Reset();
                    UserSetup.SetFilter("User ID", '<>%1', Rec."User ID");
                    UserSetup.SetRange("Master Approver (Production)", true);
                    if UserSetup.FindFirst() then begin
                        if not Confirm(ConfText001, false, UserSetup."User ID", Rec.FieldCaption("Master Approver (Production)"), Rec."User ID") then
                            error('');
                        UserSetup."Master Approver (Production)" := false;
                        UserSetup.Modify();
                    end;
                end;
            end;
        }
        /*field(70023; "Allow Edit DenDoc Dimension"; Boolean)
        {
            Description = 'NC 51676';
            Caption = 'Allow Edit DenDoc Dimension';
        }*/
        field(70030; "Show All Pay Inv"; Boolean)
        {
            Description = 'NC 51378 AB';
            Caption = 'Show all Payment Invoices';
        }
        field(70040; "Show All Acts KC-2"; Boolean)
        {
            Description = 'NC 51373 AB';
            Caption = 'Show All Acts KC-2';
        }
        field(71000; "CF Allow Long Entries Edit"; Boolean)
        {
            Description = 'NC 51381';
            Caption = 'CF Allow Long Term Entries Edit';
        }
        field(71010; "CF Allow Short Entries Edit"; Boolean)
        {
            Description = 'NC 51381';
            Caption = 'CF Allow Short Term Entries Edit';
        }
    }

    var
        UserSetup: Record "User Setup";
        ConfText001: Label 'User %1 has status %2 now. Do you want to change to %3?';
}
