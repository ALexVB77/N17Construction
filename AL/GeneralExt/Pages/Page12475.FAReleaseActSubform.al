pageextension 92475 "FA Release Act Subform (Ext)" extends "FA Release Act Subform"
{
    layout
    {
        modify("Shortcut Dimension 1 Code")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = true;
        }
    }
    actions
    {
        modify("&Print")
        {
            Visible = false;
        }

        addafter("&Line")
        {
            group("Print")
            {
                Caption = 'Print';
                Image = Print;
                action("FA Release Act FA-1")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'FA Release Act FA-1';
                    ToolTip = 'Prepare to print the FA Release Act FA-1 document. A report request window for the document opens where you can specify what to include on the print-out.';
                    trigger OnAction()
                    var
                        FADocHeader: Record "FA Document Header";
                        FADocLine: Record "FA Document Line";
                        FAReleaseActRep: Report "FA Release Act FA-1";
                    begin
                        FADocHeader.Get("Document Type", "Document No.");
                        FADocHeader.SetRecFilter;
                        FADocLine := Rec;
                        FADocLine.SetRecFilter;
                        FAReleaseActRep.SetTableView(FADocHeader);
                        FAReleaseActRep.SetTableView(FADocLine);
                        FAReleaseActRep.Run;
                    end;
                }
                action("FA Release Act FA-1a")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'FA Release Act FA-1a';
                    ToolTip = 'Prepare to print the FA Release Act FA-1a document. A report request window for the document opens where you can specify what to include on the print-out.';
                    trigger OnAction()
                    var
                        FADocHeader: Record "FA Document Header";
                        FADocLine: Record "FA Document Line";
                        PostedFADocHeader: Record "Posted FA Doc. Header";
                        PostedFADocLine: Record "Posted FA Doc. Line";
                        FAReleaseActRep: Report "FA Release Act FA-1a";
                    begin
                        PostedFADocHeader.Reset();
                        PostedFADocLine.Reset();

                        FADocHeader.Get("Document Type", "Document No.");
                        FADocHeader.SetRecFilter;
                        FADocLine := Rec;
                        FADocLine.SetRecFilter;

                        FAReleaseActRep.SetTableView(FADocHeader);
                        FAReleaseActRep.SetTableView(FADocLine);
                        // We have "SaveValues" property turned to true and need to reset prev. run parametrs
                        FAReleaseActRep.SetTableView(PostedFADocHeader);
                        FAReleaseActRep.SetTableView(PostedFADocLine);

                        FAReleaseActRep.Run;
                    end;
                }
            }
        }

    }
}