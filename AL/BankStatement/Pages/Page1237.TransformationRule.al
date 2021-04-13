pageextension 99996 "Transformation Rules BS" extends "Transformation Rules"
{
    layout
    {
        addafter("Data Formatting Culture")
        {
            field("Custom Transformation Type"; Rec."Custom Transformation Type")
            {
                ApplicationArea = All;
            }
        }

    }
}