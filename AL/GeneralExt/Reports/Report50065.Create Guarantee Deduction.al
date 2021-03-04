report 50065 "Create Guarantee Deduction"
{
    UsageCategory = None;
    Caption = 'Create Guarantee Deduction';
    ProcessingOnly = true;

    dataset
    {
        dataitem(VLE; "Vendor Ledger Entry")
        {
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    /*
                    field(Name; SourceExpression)
                    {
                        ApplicationArea = All;

                    }
                    */
                }
            }
        }
        trigger OnOpenPage()
        begin

        end;




    }
    procedure SetVLE(NewVLENo: Integer)
    begin
        VLENo := NewVLENo;
    end;

    var
        Template: Code[10];
        Batch: Code[10];
        GUAcc: Code[20];
        VendAcc: Code[20];
        GenJnlBatch: Record "Gen. Journal Batch";
        GLAccount: Record "G/L Account";
        GLEntry: Record "G/L Entry";
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DocNo: Code[20];
        VLENo: Integer;
        GUPostingGroupCode: Code[20];
        Vend: Record Vendor;


}