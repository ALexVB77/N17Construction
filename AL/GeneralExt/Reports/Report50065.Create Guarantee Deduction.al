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

                    field(Template; Template)
                    {
                        ApplicationArea = All;
                        Caption = 'Template Code';
                        TableRelation = "Gen. Journal Template";
                    }
                    field(Batch; Batch)
                    {
                        ApplicationArea = All;
                        Caption = 'Batch Code';
                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            GenJnlBatch.SetRange("Journal Template Name", Template);
                            if (page.RunModal(0, GenJnlBatch) = Action::LookupOK) then
                                Batch := GenJnlBatch.Name;
                        end;
                    }
                    field(GUPostingGroupCode; GUPostingGroupCode)
                    {
                        ApplicationArea = All;
                        Caption = 'GD - Posting Group Code';
                        TableRelation = "Vendor Posting Group";
                    }
                    field(DocNo; DocNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Operation GD Document Number';
                    }

                }
            }
        }
        trigger OnOpenPage()
        begin
            IF VLENo = 0 THEN
                ERROR(Text005);

            VLE.GET(VLENo);
            DocNo := VLE."Document No." + '_GU';
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
        Text001: Label 'Posting group is not specified';
        Text002: Label '%1/GD_execute job';
        Text003: Label 'Template code is not specified';
        Text004: Label 'Batch code is not specified';
        Text005: Label 'Must be executed from Vendor Ledger Entries';
        Text006: Label 'Created Gen. Journal Lines for GD. %1 %2, %3 %4.';
        Text007: Label 'Document number for GD operation is not specified.';
}