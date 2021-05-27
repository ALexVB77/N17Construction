page 50100 "G/L Account Mapping"
{
    PageType = StandardDialog;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "G/L Account Mapping";
    Caption = 'G/L Account Mapping';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("New No."; Rec."New No.")
                {
                    ApplicationArea = All;
                }
                field("Old No."; Rec."Old No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ImportGLAccountMapping)
            {
                ApplicationArea = All;
                Caption = 'Import G\L Account Mapping';

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