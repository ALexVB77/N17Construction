tableextension 80079 "Company Information (Ext)" extends "Company Information"
{
    fields
    {
        field(50001; "Company Type"; Option)
        {
            Caption = 'Company Type';
            OptionMembers = Housing,Construction;
            OptionCaption = 'Housing,Construction';
            Description = '50086';
        }
    }
}