tableextension 92472 "Posted FA Doc. Line (Ext)" extends "Posted FA Doc. Line"
{
    fields
    {
        field(47; "New FA Posting Group"; Code[20])
        {
            Caption = 'New FA Posting Group';
            TableRelation = "FA Posting Group";
        }
        modify("New FA No.")
        {
            TableRelation = "Fixed Asset";
        }
        modify("New Depreciation Book Code")
        {
            TableRelation = "Depreciation Book";
        }
    }
}