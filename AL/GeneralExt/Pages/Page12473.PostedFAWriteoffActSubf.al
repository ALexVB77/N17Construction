pageextension 92473 "Posted FA Writeoff Act Sub Ext" extends "Posted FA Writeoff Act Subf"
{
    actions
    {
        addafter("FA Posted Writeoff Act FA-4a")
        {
            action("FA Posted Writeoff Act FA-4b")
            {
                ApplicationArea = FixedAssets;
                Caption = 'FA Posted Writeoff Act FA-4b';
                trigger OnAction()
                var
                    PostedFADocHeader: Record "Posted FA Doc. Header";
                    PostedFADocLine: Record "Posted FA Doc. Line";
                    FAPostedWriteoffActRep4b: Report "FA Write-off Act FA-4b";
                begin
                    SetFilters(PostedFADocHeader, PostedFADocLine);
                    FAPostedWriteoffActRep4b.SetTableView(PostedFADocHeader);
                    FAPostedWriteoffActRep4b.SetTableView(PostedFADocLine);
                    FAPostedWriteoffActRep4b.Run;
                end;
            }
        }
    }
    local procedure SetFilters(var PostedFADocHeader: Record "Posted FA Doc. Header"; var PostedFADocLine: Record "Posted FA Doc. Line")
    begin
        PostedFADocHeader.Get("Document Type", "Document No.");
        PostedFADocHeader.SetRecFilter;
        PostedFADocLine.Reset;
        PostedFADocLine.SetRange("Document Type", PostedFADocHeader."Document Type");
        PostedFADocLine.SetRange("Document No.", PostedFADocHeader."No.");
        if PostedFADocLine.FindFirst() then;
    end;
}