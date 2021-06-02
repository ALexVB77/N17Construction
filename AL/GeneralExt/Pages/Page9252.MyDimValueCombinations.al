pageextension 80539 "MyDim Value Comb Ext" extends "MyDim Value Combinations"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addlast(processing)
        {
            /*action(Tetbutton)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Message(MatrixRecord.Code);
                end;
            }*/

        }

    }

    var
        MatrixRecord: Record "Dimension Value";
}