pageextension 81173 "Document Attachments (Ext)" extends "Document Attachment Details"
{
    layout
    {
        addafter("Attached Date")
        {
            field("Attachment Link"; Rec."Attachment Link")
            {
                ApplicationArea = All;

                trigger OnAssistEdit()
                begin
                    if "Attachment Link" <> '' then
                        Hyperlink("Attachment Link");
                end;
            }
        }
    }
}