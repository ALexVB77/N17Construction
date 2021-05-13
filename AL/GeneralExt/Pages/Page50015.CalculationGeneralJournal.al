page 50015 "Calculation General Journal"
{
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "Calculation Journal Line";
    SourceTableView = SORTING(Year, Month, "Journal Template Name", "Journal Batch Name", "Line No.") ORDER(Ascending);
    DataCaptionExpression = 'CalcMonth.Name';
    InsertAllowed = false;
    ModifyAllowed = true;
    SaveValues = true;
    DelayedInsert = true;
    Permissions = TableData "G/L Entry" = rd, TableData "G/L Register" = rimd, TableData "Bank Account Ledger Entry" = rid, TableData "Value Entry" = rimd;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = All;

                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;

                }
                field("Calculate Record"; Rec."Calculate Record")
                {
                    ApplicationArea = All;
                }
                field("Etry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Calculation Type"; Rec."Calculation Type")
                {
                    ApplicationArea = All;
                }
                field("BegEndSaldo"; Rec.BegEndSaldo)
                {
                    ApplicationArea = All;
                }
                field("Description"; Rec.Description)
                {
                    ApplicationArea = All;
                }
                /*field("Description"; debType)
                {
                    ApplicationArea = All;
                }*/
                field("Debit Account No."; Rec."Debit Account No.")
                {
                    ApplicationArea = All;
                }
                field("An.View Dimension 1 Filter"; Rec."An.View Dimension 1 Filter")
                {
                    ApplicationArea = All;
                }
                /*field("Description"; CreType)
                {
                    ApplicationArea = All;
                }*/
                field("Credit Account No."; Rec."Credit Account No.")
                {
                    ApplicationArea = All;
                }
                field("Calc Some Accounts"; Rec."Calc Some Accounts")
                {
                    ApplicationArea = All;
                }
                /*field("Description"; TypeExtRt)
                {
                    ApplicationArea = All;
                }*/
                field("Dim. Allocation"; Rec."Dim. Allocation")
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field("Last Run Date"; Rec."Last Run Date")
                {
                    ApplicationArea = All;
                }
                field("Analysis View Code"; Rec."Analysis View Code")
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
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}