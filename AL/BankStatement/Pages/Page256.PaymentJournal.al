pagecustomization "Payment Journal BS" customizes "Payment Journal"
{
    actions
    {
        // Add changes to page actions here
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