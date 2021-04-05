pageextension 99995 "Transformation Rule Card BS" extends "Transformation Rule Card"
{
    layout
    {
        addbefore(Test)
        {
            group(CustomTransformationTypeGroup)
            {
                ShowCaption = false;
                field("Custom Transformation Type"; Rec."Custom Transformation Type")
                {
                    ApplicationArea = Basic, Suite;
                    trigger OnValidate()
                    begin
                        Rec.TestField("Transformation Type", Rec."Transformation Type"::Custom);
                    end;
                }
                field("Min. Length"; rec."Min. Length")
                {
                    ApplicationArea = basic, suite;
                    trigger OnValidate()
                    begin
                        rec.TestField("Custom Transformation Type", rec."Custom Transformation Type"::CheckLength);
                    end;
                }
                field("Max. Length"; REc."Max. Length")
                {
                    ApplicationArea = basic, suite;
                    trigger OnValidate()
                    begin
                        rec.TestField("Custom Transformation Type", rec."Custom Transformation Type"::CheckLength);
                    END;
                }

            }
        }
        //addafter()
    }
}