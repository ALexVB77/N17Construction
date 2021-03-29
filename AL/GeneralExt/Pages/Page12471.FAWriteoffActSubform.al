pageextension 92471 "FA Writeoff Act Subform (Ext)" extends "FA Writeoff Act Subform"
{
    actions
    {
        addafter("FA Writeoff Act FA-4a")
        {
            action("FA Write-off Act FA-4b")
            {
                ApplicationArea = FixedAssets;
                Caption = 'FA Write-off Act FA-4b';
                trigger OnAction()
                var
                    FADocHeader: Record "FA Document Header";
                    FADocLine: Record "FA Document Line";
                    FAWriteoffActRep: Report "FA Write-off Act FA-4b";
                begin
                    SetFilters(FADocHeader, FADocLine);
                    FAWriteoffActRep.SetTableView(FADocHeader);
                    FAWriteoffActRep.SetTableView(FADocLine);
                    FAWriteoffActRep.Run;
                end;
            }
        }
    }
    local procedure SetFilters(var FADocHeader: Record "FA Document Header"; var FADocLine: Record "FA Document Line")
    begin
        FADocHeader.Get(Rec."Document Type", Rec."Document No.");
        FADocHeader.SetRecFilter;
        FADocLine.Reset;
        FADocLine.SetRange("Document Type", FADocHeader."Document Type");
        FADocLine.SetRange("Document No.", FADocHeader."No.");
        if FADocLine.FindFirst() then;
    end;
}