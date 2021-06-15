pageextension 94913 "Vendor Agreements (Ext)" extends "Vendor Agreements"
{
    layout
    {
        modify("No.")
        {
            StyleExpr = LineColor;
        }
        modify("External Agreement No.")
        {
            StyleExpr = LineColor;
        }
        modify(Active)
        {
            StyleExpr = LineColor;
        }
        modify("Currency Code")
        {
            StyleExpr = LineColor;
        }
        modify(Description)
        {
            StyleExpr = LineColor;
        }
        modify(Priority)
        {
            StyleExpr = LineColor;
        }
        modify("Agreement Date")
        {
            StyleExpr = LineColor;
        }
        modify("Starting Date")
        {
            StyleExpr = LineColor;
        }
        modify("Expire Date")
        {
            StyleExpr = LineColor;
        }
        modify(Blocked)
        {
            StyleExpr = LineColor;
        }

        addlast(Control1210002)
        {
            field("Check Limit Starting Date"; Rec."Check Limit Starting Date")
            {
                ApplicationArea = Basic, Suite;
                StyleExpr = LineColor;
            }
            field("Check Limit Ending Date"; Rec."Check Limit Ending Date")
            {
                ApplicationArea = Basic, Suite;
                StyleExpr = LineColor;
            }
            field("Check Limit Amount (LCY)"; Rec."Check Limit Amount (LCY)")
            {
                ApplicationArea = Basic, Suite;
                StyleExpr = LineColor;
            }
            field("Purch. Original Amt. (LCY)"; Rec."Purch. Original Amt. (LCY)")
            {
                ApplicationArea = Basic, Suite;
                StyleExpr = LineColor;
            }
            field("Deviation (LCY)"; Rec."Check Limit Amount (LCY)" - Rec."Purch. Original Amt. (LCY)")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Deviation (LCY)';
                StyleExpr = LineColor;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        LineColor := Rec.GetLineColor();
    end;

    var
        LineColor: Text;
}