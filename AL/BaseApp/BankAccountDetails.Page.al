page 14933 "Bank Account Details"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Bank Account Details';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Bank Account Details";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1210000)
            {
                ShowCaption = false;
                field("Code"; Code)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the unique identification code associated with this bank account detail record.';
                }
                field("VAT Registration No."; "VAT Registration No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the bank''s VAT registration number. ';
                }
                field("Bank Account No."; "Bank Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the account number of the bank associated with this general ledger account bank operation.';
                }
                field("G/L Account"; "G/L Account")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the general ledger account number to which this bank information applies.';
                }
                field("G/L Account Name"; "G/L Account Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the general ledger account to which this bank information applies.';
                }
                field("KPP Code"; "KPP Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the KPP code associated with the bank operation.';
                }
                field("Bank BIC"; "Bank BIC")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the SWIFT BIC code of the recipient of the bank operation.';
                }
                field("Transit No."; "Transit No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the correlative bank account number of the general ledger account associated with the bank operation.';
                }
                field("Bank City"; "Bank City")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the bank city associated with the bank operation.';
                }
                field("Bank Name"; "Bank Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the bank associated with this bank operation.';
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of the related document.';
                }
            }
        }
    }

    actions
    {
    }
}

