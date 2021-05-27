page 70090 "Investment Agreements"
{
    Editable = false;
    SourceTable = "Customer Agreement";
    PopulateAllFields = true;
    SourceTableView = SORTING("Customer No.", "No.") WHERE("Agreement Type" = FILTER("Investment Agreement" | "Reserving Agreement"));
    PageType = List;
    CardPageId = "Investment Agreement Card";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Investment Agreements';

    layout
    {
        area(content)
        {
            repeater(Repeater12370003)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                }

                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;

                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;

                }

                field("Agreement Date"; Rec."Agreement Date")
                {
                    ApplicationArea = All;

                }

                field("Agreement Type"; Rec."Agreement Type")
                {
                    ApplicationArea = All;

                }



            }
        }
    }


    actions
    {
        area(navigation)
        {
            group(Agreement)
            {
                action("Ledger Entries")
                {
                    ShortCutKey = 'Ctrl+F5';
                    RunObject = Page "Customer Ledger Entries";
                    Caption = 'Ledger E&ntries';
                    RunPageView = SORTING("Customer No.");
                    RunPageLink = "Customer No." = FIELD("Customer No."), "Agreement No." = FIELD("No.");
                }

                action(Comments)
                {
                    RunObject = page "Comment Sheet";
                    Caption = 'Co&mments';
                    RunPageLink = "Table Name" = CONST("Customer Agreement"), "No." = FIELD("No.");
                }

                action(Statistics)
                {
                    ShortCutKey = 'F9';
                    RunObject = page "Customer Statistics";
                    Caption = 'Statistics';
                    RunPageLink = "No." = FIELD("Customer No."), "Agreement Filter" = FIELD("No.");

                }

                // action("Statistics by Currencies")
                // {
                //     RunObject = page "Customer Stats. by Currencies";
                //     Caption = 'Statistics by C&urrencies';
                //     RunPageLink = No.=FIELD(Customer No.), Agreement Filter=FIELD(No.);
                // }   

                action("Entry Statistics")
                {
                    RunObject = page "Customer Entry Statistics";
                    Caption = 'Entry Statistics';
                    RunPageLink = "No." = FIELD("Customer No."), "Agreement Filter" = FIELD("No.");
                }

                action(CustomerSales)
                {
                    RunObject = page "Customer Sales";
                    Caption = 'S&ales';
                    RunPageLink = "No." = FIELD("Customer No."), "Agreement Filter" = FIELD("No.");
                }
            }
        }
    }







}

