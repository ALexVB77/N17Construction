page 17227 "Tax Register (2.4) Item"
{
    Caption = 'Tax Register (2.4) Item';
    DataCaptionExpression = FormTitle();
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SourceTable = "Tax Register Item Entry";
    SourceTableView = SORTING("Section Code", "Posting Date");

    layout
    {
        area(content)
        {
            repeater(Control100)
            {
                Editable = false;
                ShowCaption = false;
                field("Batch Date"; "Batch Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the batch date associated with this item entry.';
                }
                field("Appl. Entry No."; "Appl. Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the applied entry number associated with this item entry.';
                }
                field(UOMName; UOMName)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'UOM Name';
                }
                field("Credit Qty."; "Credit Qty.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the credit quantity associated with this item entry.';
                }
                field("Credit Amount"; "Credit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total of the ledger entries that represent credits.';
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the entry''s posting date.';
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the document description associated with this item entry.';
                }
                field("Debit Qty."; "Debit Qty.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the debit quantity associated with this item entry.';
                }
                field("Debit Amount"; "Debit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total of the ledger entries that represent debits.';
                }
                field("Outstand. Quantity"; "Outstand. Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the outstanding quantity associated with this item entry.';
                }
                field("Ledger Entry No."; "Ledger Entry No.")
                {
                    ToolTip = 'Specifies the ledger entry number associated with this item entry.';
                    Visible = false;
                }
            }
            field(PeriodType; PeriodType)
            {
                ApplicationArea = Basic, Suite;
                OptionCaption = ',,Month,Quarter,Year';
                ToolTip = 'Month';

                trigger OnValidate()
                begin
                    FindPeriod('');
                end;
            }
            field(AmountType; AmountType)
            {
                ApplicationArea = Basic, Suite;
                OptionCaption = 'Current Period,Tax Period';
                ToolTip = 'Current Period';

                trigger OnValidate()
                begin
                    FindPeriod('');
                end;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Previous Period")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Previous Period';
                Image = PreviousRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Previous Period';

                trigger OnAction()
                begin
                    FindPeriod('<=');
                end;
            }
            action("Next Period")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Next Period';
                Image = NextRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Next Period';

                trigger OnAction()
                begin
                    FindPeriod('>=');
                end;
            }
            action(Navigate)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Find entries...';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';

                trigger OnAction()
                begin
                    Navigating;
                end;
            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        if DateFilterText <> GetFilter("Date Filter") then
            ShowNewData;

        exit(Find(Which));
    end;

    trigger OnOpenPage()
    begin
        CopyFilter("Date Filter", Calendar."Period End");
        CopyFilter("Date Filter", "Posting Date");
        TaxRegMgt.SetPeriodAmountType(Calendar, DateFilterText, PeriodType, AmountType);
        Calendar.Reset();
    end;

    var
        Calendar: Record Date;
        TaxRegMgt: Codeunit "Tax Register Mgt.";
        DateFilterText: Text;
        PeriodType: Option ,,Month,Quarter,Year;
        AmountType: Option "Current Period","Tax Period";

    [Scope('OnPrem')]
    procedure ShowNewData()
    begin
        FindPeriod('');
        DateFilterText := GetFilter("Date Filter");

        SetFilter("Posting Date", DateFilterText);
        SetFilter("Date Filter", DateFilterText);
    end;

    local procedure FindPeriod(SearchText: Code[10])
    var
        Calendar: Record Date;
    begin
        if GetFilter("Date Filter") <> '' then begin
            Calendar."Period End" := GetRangeMax("Date Filter");
            if not TaxRegMgt.FindDate('', Calendar, PeriodType, AmountType) then
                TaxRegMgt.FindDate('', Calendar, PeriodType::Month, AmountType);
        end;
        TaxRegMgt.FindDate(SearchText, Calendar, PeriodType, AmountType);

        SetFilter("Posting Date", '%1..%2', Calendar."Period Start", Calendar."Period End");
        SetFilter("Date Filter", '%1..%2', Calendar."Period Start", Calendar."Period End");
    end;
}

