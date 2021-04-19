page 70213 "Projects CC Entry Constr 2"
{

    ApplicationArea = Basic, Suite;
    Caption = 'Projects CC Entry Constr 2';
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Projects Cost Control Entry";
    UsageCategory = Administration;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Contragent No."; Rec."Contragent No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Contragent Name"; Rec."Contragent Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Doc No."; Rec."Doc No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Without VAT"; Rec."Without VAT")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Amount Including VAT 2"; Rec."Amount Including VAT 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Amount 2"; Rec."VAT Amount 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Cost Type"; Rec."Cost Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Agrrement No."; Rec."Agreement No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("External Agreement No."; Rec."External Agreement No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(ID; Rec.ID)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Building Turn"; Rec."Building Turn")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Project Code"; Rec."Project Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Project Turn Code"; Rec."Project Turn Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Create User"; Rec."Create User")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Create Date"; Rec."Create Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Project Storno"; Rec."Project Storno")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Analysis Type"; Rec."Analysis Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Reserve; Rec.Reserve)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Original Date"; Rec."Original Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Original Company"; Rec."Original Company")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Original Ammount"; Rec."Original Ammount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Changed; Rec.Changed)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Estimate Line No."; Rec."Estimate Line No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Estimate Quantity"; Rec."Estimate Quantity")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Estimate Unit Price"; Rec."Estimate Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Estimate Unit of Measure"; Rec."Estimate Unit of Measure")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Estimate Line ID"; Rec."Estimate Line ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Estimate Subproject Code"; Rec."Estimate Subproject Code")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

}
