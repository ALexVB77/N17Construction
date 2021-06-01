report 50005 "Payment Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    dataset
    {

        dataitem(FBA; "Bank Account")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "Account Type", "No.";
            MaxIteration = 1;


        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(boolUnPost; boolUnPost)
                    {
                        ApplicationArea = All;
                        Caption = 'Unposted';
                    }
                    field(boolPost; boolPost)
                    {
                        ApplicationArea = All;
                        Caption = 'Posted';
                    }
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                    }
                }
            }
        }

    }

    var
        txtWind: Label 'Data #1#################### \ Progress @2@@@@@@@@@@@@';
        txtUnPost: Label 'Unpost. op.';
        txtPost: label 'Post. op.';
        txtFillDates: label 'Fill Period';
        txtLarger: label 'Start Date must be before End Date';
        txtCustomer: label 'Customer';
        txtVendor: label 'Vendor';
        txtGLAcc: label 'G/L Account';
        txtBA: label 'Bank Account';
        txtFA: label 'FA';
        UnPostStartDate: Date;
        UnPostEndDate: Date;
        PostStartDate: Date;
        PostEndDate: Date;

        tUnPost: Record "Gen. Journal Line";
        tPost: Record "Bank Account Ledger Entry";
        boolUnPost: Boolean;
        boolPost: Boolean;
        Wind: Dialog;
        Cnt: Integer;
        MaxCnt: Integer;
        Ps: Integer;
        tL: Text[30];
        OldtL: Text[30];
        txtNumberFormat: Text[30];
        tCustomer: Record Customer;
        tVendor: Record Vendor;
        tBankAcc: Record "Bank Account";
        tBA: Record "Bank Account";
        FirstFormulaItem: Text[30];
        tCustLedgEntry: Record "Cust. Ledger Entry";
        tVendLedgEntry: Record "Vendor Ledger Entry";
        txtPayment: Text[30];
        tGLAcc: Record "G/L Account";
        StartDate: Date;
        EndDate: Date;
        _BA: Record "Bank Account";
        tFA: Record "Fixed Asset";
        tBatch: Record "Gen. Journal Batch";
        GLSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        DimName1: Text[50];
        DimName2: Text[50];
}