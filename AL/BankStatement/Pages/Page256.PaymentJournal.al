pageextension 99990 "Payment Journal BS" extends "Payment Journal"
{
    actions
    {
        modify("Void Payment Order")
        {
            Visible = false;
        }
        modify("Void &All Payment Orders")
        {
            Visible = false;
        }
    }

}

