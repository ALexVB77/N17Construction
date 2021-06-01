pageextension 80537 "Dimension Values Ext" extends "Dimension Values"
{
    layout
    {
        addafter("Consolidation Code")
        {
            field("Project Code"; Rec."Project Code")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}