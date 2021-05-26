tableextension 80014 "Location (Ext)" extends Location
{
    fields
    {
        field(50010; Blocked; Boolean)
        {
            Caption = 'Blocked';
            Description = 'NC22512,NC 51143 EP';
        }
        field(50020; "Def. Gen. Bus. Posting Group"; Code[20])
        {
            // NC 51143 > EP
            // Code[10] -> Code[20], потому что в
            // table "Gen. Business Posting Group" увеличилась длина ключа
            // NC 51143 < EP

            Caption = 'Def. Gen. Bus. Posting Group';
            Description = 'NC22512 DP,NC 51143 EP';
            TableRelation = "Gen. Business Posting Group";
        }
    }
}