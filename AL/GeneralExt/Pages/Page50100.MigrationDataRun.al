page 50100 "Migration Data Run"
{
    PageType = StandardDialog;
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {

    }

    actions
    {
        area(Processing)
        {
            action(GLAccountMappingMigrationRun)
            {
                ApplicationArea = All;
                Caption = 'Run G\L Account Mapping Migration';

                trigger OnAction()
                var
                    GLAccountMappingMigration: Codeunit "G/L Account Mapping Migration";
                begin
                    GLAccountMappingMigration.Run();
                end;
            }
        }
    }
}