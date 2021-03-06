page 12497 "FA Sheet"
{
    ApplicationArea = FixedAssets;
    Caption = 'Fixed Asset Sheet';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "FA Depreciation Book";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field(PeriodType; PeriodType)
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'View by';
                    OptionCaption = 'Day,Week,Month,Quarter,Year,Accounting Period';
                    ToolTip = 'Specifies by which period amounts are displayed.';

                    trigger OnValidate()
                    begin
                        FindPeriod('');
                    end;
                }
                field(AmountType; AmountType)
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'View as';
                    Description = '000627';
                    OptionCaption = 'Net Change,Balance at Date';
                    ToolTip = 'Specifies how amounts are displayed. Net Change: The net change in the balance for the selected period. Balance at Date: The balance as of the last day in the selected period.';

                    trigger OnValidate()
                    begin
                        FindPeriod('');
                    end;
                }
            }
            repeater(Matrix)
            {
                Editable = false;
                field("FA No."; "FA No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number of the related fixed asset. ';
                }
                field("FA.Description"; FA.Description)
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'FA Description';
                    ToolTip = 'Specifies a description of the fixed asset.';
                }
                field("FA.""Undepreciable FA"""; FA."Undepreciable FA")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Undepr. FA';
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = FixedAssets;
                    BlankZero = true;
                    ToolTip = 'Specifies the quantity of the fixed asset.';
                }
                field("FA Posting Group"; "FA Posting Group")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies which posting group is used for the depreciation book when posting fixed asset transactions.';
                    Visible = false;
                }
                field("Acquisition Date"; "Acquisition Date")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the FA posting date of the first posted acquisition cost.';
                }
                field("Depreciation Method"; "Depreciation Method")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies how depreciation is calculated for the depreciation book.';
                    Visible = false;
                }
                field("Depreciation Starting Date"; "Depreciation Starting Date")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the date on which depreciation of the fixed asset starts.';
                }
                field("Depreciation Ending Date"; "Depreciation Ending Date")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the date on which depreciation of the fixed asset ends.';
                }
                field("No. of Depreciation Years"; "No. of Depreciation Years")
                {
                    ApplicationArea = FixedAssets;
                    BlankZero = true;
                    ToolTip = 'Specifies the length of the depreciation period, expressed in years.';
                }
                field("Disposal Date"; "Disposal Date")
                {
                    ApplicationArea = FixedAssets;
                }
                field(Depreciation; Depreciation)
                {
                    ApplicationArea = FixedAssets;
                    BlankZero = true;
                }
                field("Acquisition Cost"; "Acquisition Cost")
                {
                    ApplicationArea = FixedAssets;
                    BlankZero = true;
                    ToolTip = 'Specifies the total percentage of acquisition cost that can be allocated when acquisition cost is posted.';
                }
                field("Book Value"; "Book Value")
                {
                    ApplicationArea = FixedAssets;
                    BlankZero = true;
                    ToolTip = 'Specifies the book value for the fixed asset.';
                }
                field("Proceeds on Disposal"; "Proceeds on Disposal")
                {
                    ApplicationArea = FixedAssets;
                    BlankZero = true;
                    ToolTip = 'Specifies the total proceeds on disposal for the fixed asset.';
                }
                field("Gain/Loss"; "Gain/Loss")
                {
                    ApplicationArea = FixedAssets;
                    BlankZero = true;
                    ToolTip = 'Specifies the total gain (credit) or loss (debit) for the fixed asset.';
                }
                field("Write-Down"; "Write-Down")
                {
                    ApplicationArea = FixedAssets;
                    BlankZero = true;
                }
                field(Appreciation; Appreciation)
                {
                    ApplicationArea = FixedAssets;
                    BlankZero = true;
                }
                field("Custom 1"; "Custom 1")
                {
                    ApplicationArea = FixedAssets;
                    BlankZero = true;
                    ToolTip = 'Specifies the total LCY amount for custom 1 entries for the fixed asset.';
                }
                field("Custom 2"; "Custom 2")
                {
                    ApplicationArea = FixedAssets;
                    BlankZero = true;
                    ToolTip = 'Specifies the total LCY amount for custom 2 entries for the fixed asset.';
                }
                field("Salvage Value"; "Salvage Value")
                {
                    ApplicationArea = FixedAssets;
                    BlankZero = true;
                    ToolTip = 'Specifies the estimated residual value of a fixed asset when it can no longer be used.';
                }
                field("Book Value on Disposal"; "Book Value on Disposal")
                {
                    ApplicationArea = FixedAssets;
                    BlankZero = true;
                    ToolTip = 'Specifies the total amount of entries posted with the Book Value on Disposal posting type. Entries of this kind are created when you post disposal of a fixed asset to a depreciation book where the Gross method has been selected in the Disposal Calculation Method field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Fixed Asset")
            {
                Caption = '&Fixed Asset';
                Image = FixedAssets;
                action(Card)
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Fixed Asset Card";
                    RunPageLink = "No." = FIELD("FA No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or edit details about the selected entity.';
                }
            }
        }
        area(processing)
        {
            action("Previous Period")
            {
                ApplicationArea = FixedAssets;
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
                ApplicationArea = FixedAssets;
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
            group("&Print")
            {
                Caption = '&Print';
                Image = Print;
                action("FA Sheet")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'FA Sheet';
                    Image = FixedAssets;
                    Promoted = true;
                    PromotedCategory = "Report";
                    ToolTip = 'View or edit fixed asset turnover information based on the fixed asset depreciation books. This window shows information similar to the FA Turnover report.';

                    trigger OnAction()
                    begin
                        Clear(FATurnover);
                        FATurnover.SetParameters(Rec);
                        FATurnover.Run;
                    end;
                }
            }
        }
        area(reporting)
        {
        }
    }

    trigger OnAfterGetRecord()
    begin
        if FA.Get("FA No.") then;
    end;

    trigger OnOpenPage()
    begin
        DateFilter := GetFilter("FA Posting Date Filter");
        if DateFilter = '' then begin
            if PeriodType = PeriodType::"Accounting Period" then
                FindPeriodUser('')
            else
                FindPeriod('');
        end;

        if DeprBookFilter = '' then begin
            FASetup.Get();
            DeprBookFilter := FASetup."Default Depr. Book";
        end;
        SetRange("Depreciation Book Code", DeprBookFilter);
    end;

    var
        FA: Record "Fixed Asset";
        UserPeriods: Record "User Setup";
        FASetup: Record "FA Setup";
        FATurnover: Report "FA Turnover";
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        DateFilter: Text;
        DeprBookFilter: Text[30];
        AmountType: Option "Net Change","Balance at Date";

    local procedure FindPeriod(SearchText: Code[10])
    var
        Calendar: Record Date;
        PeriodFormManagement: Codeunit PeriodFormManagement;
    begin
        if GetFilter("FA Posting Date Filter") <> '' then begin
            Calendar.SetFilter("Period Start", GetFilter("FA Posting Date Filter"));
            if not PeriodFormManagement.FindDate('+', Calendar, PeriodType) then
                PeriodFormManagement.FindDate('+', Calendar, PeriodType::Day);
            Calendar.SetRange("Period Start");
        end;
        PeriodFormManagement.FindDate(SearchText, Calendar, PeriodType);
        if AmountType = AmountType::"Net Change" then begin
            SetRange("FA Posting Date Filter", Calendar."Period Start", Calendar."Period End");
            if GetRangeMin("FA Posting Date Filter") = GetRangeMax("FA Posting Date Filter") then
                SetRange("FA Posting Date Filter", GetRangeMin("FA Posting Date Filter"));
        end else
            SetRange("FA Posting Date Filter", 0D, Calendar."Period End");
    end;

    local procedure FindPeriodUser(SearchText: Code[10])
    var
        Calendar: Record Date;
        PeriodFormManagement: Codeunit PeriodFormManagement;
    begin
        if UserPeriods.Get(UserId) then begin
            SetRange("FA Posting Date Filter", UserPeriods."Allow Posting From", UserPeriods."Allow Posting To");
            if GetRangeMin("FA Posting Date Filter") = GetRangeMax("FA Posting Date Filter") then
                SetRange("FA Posting Date Filter", GetRangeMin("FA Posting Date Filter"));
        end else begin
            if GetFilter("FA Posting Date Filter") <> '' then begin
                Calendar.SetFilter("Period Start", GetFilter("FA Posting Date Filter"));
                if not PeriodFormManagement.FindDate('+', Calendar, PeriodType) then
                    PeriodFormManagement.FindDate('+', Calendar, PeriodType::Day);
                Calendar.SetRange("Period Start");
            end;
            PeriodFormManagement.FindDate(SearchText, Calendar, PeriodType);
            if AmountType = AmountType::"Net Change" then begin
                SetRange("FA Posting Date Filter", Calendar."Period Start", Calendar."Period End");
                if GetRangeMin("FA Posting Date Filter") = GetRangeMax("FA Posting Date Filter") then
                    SetRange("FA Posting Date Filter", GetRangeMin("FA Posting Date Filter"));
            end else
                SetRange("FA Posting Date Filter", 0D, Calendar."Period End");
        end;
    end;
}

