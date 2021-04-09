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
            //Caption = 'FA Release Act FA-1';
            //ToolTip = 'Prepare to print the FA Release Act FA-1 document. A report request window for the document opens where you can specify what to include on the print-out.';
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
                        FAReleaseActRep: Report "FA Release Act FA-1a";
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
            }
        }

    }
}