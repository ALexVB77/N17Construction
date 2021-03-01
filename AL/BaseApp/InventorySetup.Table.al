table 313 "Inventory Setup"
{
    Caption = 'Inventory Setup';
    Permissions = TableData "Inventory Adjmt. Entry (Order)" = m;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Automatic Cost Posting"; Boolean)
        {
            Caption = 'Automatic Cost Posting';

            trigger OnValidate()
            var
                GLSetup: Record "General Ledger Setup";
            begin
                if "Automatic Cost Posting" then begin
                    if GLSetup.Get then
                        if not GLSetup."Use Legacy G/L Entry Locking" then
                            Message(Text006,
                              FieldCaption("Automatic Cost Posting"),
                              "Automatic Cost Posting",
                              GLSetup.FieldCaption("Use Legacy G/L Entry Locking"),
                              GLSetup.TableCaption,
                              GLSetup."Use Legacy G/L Entry Locking");
                end;
            end;
        }
        field(3; "Location Mandatory"; Boolean)
        {
            AccessByPermission = TableData Location = R;
            Caption = 'Location Mandatory';
        }
        field(4; "Item Nos."; Code[20])
        {
            Caption = 'Item Nos.';
            TableRelation = "No. Series";
        }
        field(30; "Automatic Cost Adjustment"; Option)
        {
            Caption = 'Automatic Cost Adjustment';
            OptionCaption = 'Never,Day,Week,Month,Quarter,Year,Always';
            OptionMembers = Never,Day,Week,Month,Quarter,Year,Always;

            trigger OnValidate()
            begin
                if "Automatic Cost Adjustment" <> "Automatic Cost Adjustment"::Never then begin
                    Item.SetCurrentKey("Cost is Adjusted", "Allow Online Adjustment");
                    Item.SetRange("Cost is Adjusted", false);
                    Item.SetRange("Allow Online Adjustment", false);

                    UpdateInvtAdjmtEntryOrder;

                    InvtAdjmtEntryOrder.SetCurrentKey("Cost is Adjusted", "Allow Online Adjustment");
                    InvtAdjmtEntryOrder.SetRange("Cost is Adjusted", false);
                    InvtAdjmtEntryOrder.SetRange("Allow Online Adjustment", false);
                    InvtAdjmtEntryOrder.SetRange("Is Finished", true);

                    if not (Item.IsEmpty and InvtAdjmtEntryOrder.IsEmpty) then
                        Message(Text000);
                end;
            end;
        }
        field(40; "Prevent Negative Inventory"; Boolean)
        {
            Caption = 'Prevent Negative Inventory';
        }
        field(50; "Skip Prompt to Create Item"; Boolean)
        {
            Caption = 'Skip Prompt to Create Item';
            DataClassification = SystemMetadata;
        }
        field(51; "Copy Item Descr. to Entries"; Boolean)
        {
            Caption = 'Copy Item Descr. to Entries';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            var
                UpdateNameInLedgerEntries: Codeunit "Update Name In Ledger Entries";
            begin
                if "Copy Item Descr. to Entries" then
                    UpdateNameInLedgerEntries.NotifyAboutBlankNamesInLedgerEntries(RecordId);
            end;
        }
        field(5700; "Transfer Order Nos."; Code[20])
        {
            AccessByPermission = TableData "Transfer Header" = R;
            Caption = 'Transfer Order Nos.';
            TableRelation = "No. Series";
        }
        field(5701; "Posted Transfer Shpt. Nos."; Code[20])
        {
            AccessByPermission = TableData "Transfer Header" = R;
            Caption = 'Posted Transfer Shpt. Nos.';
            TableRelation = "No. Series";
        }
        field(5702; "Posted Transfer Rcpt. Nos."; Code[20])
        {
            AccessByPermission = TableData "Transfer Header" = R;
            Caption = 'Posted Transfer Rcpt. Nos.';
            TableRelation = "No. Series";
        }
        field(5703; "Copy Comments Order to Shpt."; Boolean)
        {
            AccessByPermission = TableData "Transfer Header" = R;
            Caption = 'Copy Comments Order to Shpt.';
            InitValue = true;
        }
        field(5704; "Copy Comments Order to Rcpt."; Boolean)
        {
            AccessByPermission = TableData "Transfer Header" = R;
            Caption = 'Copy Comments Order to Rcpt.';
            InitValue = true;
        }
        field(5718; "Nonstock Item Nos."; Code[20])
        {
            AccessByPermission = TableData "Nonstock Item" = R;
            Caption = 'Catalog Item Nos.';
            TableRelation = "No. Series";
        }
        field(5790; "Outbound Whse. Handling Time"; DateFormula)
        {
            AccessByPermission = TableData Location = R;
            Caption = 'Outbound Whse. Handling Time';
        }
        field(5791; "Inbound Whse. Handling Time"; DateFormula)
        {
            AccessByPermission = TableData Location = R;
            Caption = 'Inbound Whse. Handling Time';
        }
        field(5800; "Expected Cost Posting to G/L"; Boolean)
        {
            Caption = 'Expected Cost Posting to G/L';

            trigger OnValidate()
            var
                ChangeExpCostPostToGL: Codeunit "Change Exp. Cost Post. to G/L";
            begin
                if "Expected Cost Posting to G/L" <> xRec."Expected Cost Posting to G/L" then
                    if ItemLedgEntry.FindFirst then begin
                        ChangeExpCostPostToGL.ChangeExpCostPostingToGL(Rec, "Expected Cost Posting to G/L");
                        Find;
                    end;
            end;
        }
        field(5801; "Default Costing Method"; Enum "Costing Method")
        {
            Caption = 'Default Costing Method';
        }
        field(5804; "Average Cost Calc. Type"; Option)
        {
            Caption = 'Average Cost Calc. Type';
            InitValue = "Item & Location & Variant";
            NotBlank = true;
            OptionCaption = ' ,Item,Item & Location & Variant';
            OptionMembers = " ",Item,"Item & Location & Variant";

            trigger OnValidate()
            begin
                TestField("Average Cost Calc. Type");
                if "Average Cost Calc. Type" <> xRec."Average Cost Calc. Type" then
                    UpdateAvgCostItemSettings(FieldCaption("Average Cost Calc. Type"), Format("Average Cost Calc. Type"));
            end;
        }
        field(5805; "Average Cost Period"; Option)
        {
            Caption = 'Average Cost Period';
            InitValue = Day;
            NotBlank = true;
            OptionCaption = ' ,Day,Week,Month,Quarter,Year,Accounting Period';
            OptionMembers = " ",Day,Week,Month,Quarter,Year,"Accounting Period";

            trigger OnValidate()
            begin
                TestField("Average Cost Period");
                if "Average Cost Period" <> xRec."Average Cost Period" then
                    UpdateAvgCostItemSettings(FieldCaption("Average Cost Period"), Format("Average Cost Period"));
            end;
        }
        field(5875; "Phys. Invt. Order Nos."; Code[20])
        {
            AccessByPermission = TableData "Phys. Invt. Order Header" = R;
            Caption = 'Phys. Invt. Order Nos.';
            TableRelation = "No. Series";
        }
        field(5876; "Posted Phys. Invt. Order Nos."; Code[20])
        {
            AccessByPermission = TableData "Phys. Invt. Order Header" = R;
            Caption = 'Posted Phys. Invt. Order Nos.';
            TableRelation = "No. Series";
        }
        field(7101; "Item Group Dimension Code"; Code[20])
        {
            Caption = 'Item Group Dimension Code';
            TableRelation = Dimension;
        }
        field(7300; "Inventory Put-away Nos."; Code[20])
        {
            AccessByPermission = TableData "Posted Invt. Put-away Header" = R;
            Caption = 'Inventory Put-away Nos.';
            TableRelation = "No. Series";
        }
        field(7301; "Inventory Pick Nos."; Code[20])
        {
            AccessByPermission = TableData "Posted Invt. Pick Header" = R;
            Caption = 'Inventory Pick Nos.';
            TableRelation = "No. Series";
        }
        field(7302; "Posted Invt. Put-away Nos."; Code[20])
        {
            AccessByPermission = TableData "Posted Invt. Put-away Header" = R;
            Caption = 'Posted Invt. Put-away Nos.';
            TableRelation = "No. Series";
        }
        field(7303; "Posted Invt. Pick Nos."; Code[20])
        {
            AccessByPermission = TableData "Posted Invt. Pick Header" = R;
            Caption = 'Posted Invt. Pick Nos.';
            TableRelation = "No. Series";
        }
        field(7304; "Inventory Movement Nos."; Code[20])
        {
            AccessByPermission = TableData "Whse. Internal Put-away Header" = R;
            Caption = 'Inventory Movement Nos.';
            TableRelation = "No. Series";
        }
        field(7305; "Registered Invt. Movement Nos."; Code[20])
        {
            AccessByPermission = TableData "Whse. Internal Put-away Header" = R;
            Caption = 'Registered Invt. Movement Nos.';
            TableRelation = "No. Series";
        }
        field(7306; "Internal Movement Nos."; Code[20])
        {
            AccessByPermission = TableData "Whse. Internal Put-away Header" = R;
            Caption = 'Internal Movement Nos.';
            TableRelation = "No. Series";
        }
        field(12400; "Item Receipt Nos."; Code[20])
        {
            Caption = 'Item Receipt Nos.';
            TableRelation = "No. Series";
        }
        field(12401; "Posted Item Receipt Nos."; Code[20])
        {
            Caption = 'Posted Item Receipt Nos.';
            TableRelation = "No. Series";
        }
        field(12402; "Item Shipment Nos."; Code[20])
        {
            Caption = 'Item Shipment Nos.';
            TableRelation = "No. Series";
        }
        field(12403; "Posted Item Shipment Nos."; Code[20])
        {
            Caption = 'Posted Item Shipment Nos.';
            TableRelation = "No. Series";
        }
        field(12404; "CD Header Nos."; Code[20])
        {
            Caption = 'CD Header Nos.';
            TableRelation = "No. Series";
        }
        field(12405; "Posted Direct Transfer Nos."; Code[20])
        {
            Caption = 'Posted Direct Transfer Nos.';
            TableRelation = "No. Series";
        }
        field(12406; "Copy Comments to Item Doc."; Boolean)
        {
            Caption = 'Copy Comments to Item Doc.';
        }
        field(12408; "Check Application Date"; Boolean)
        {
            Caption = 'Check Application Date';
        }
        field(12410; "Unit of Measure Mandatory"; Boolean)
        {
            Caption = 'Unit of Measure Mandatory';
        }
        field(12411; "Automatic Posting Date Adjmt."; Option)
        {
            Caption = 'Automatic Posting Date Adjmt.';
            OptionCaption = 'None,Item Cost Only,Item Cost and Charge';
            OptionMembers = "None","Item Cost Only","Item Cost and Charge";
        }
        field(12412; "Employee No. Mandatory"; Boolean)
        {
            Caption = 'Employee No. Mandatory';
        }
        field(12414; "Adjmt. Rounding as Correction"; Boolean)
        {
            Caption = 'Adjmt. Rounding as Correction';
        }
        field(12415; "Enable Red Storno"; Boolean)
        {
            Caption = 'Enable Red Storno';

            trigger OnValidate()
            var
                ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
            begin
                if "Enable Red Storno" then begin
                    if Confirm(Text12400) then
                        ItemJnlPostLine.EnableRedStorno
                    else
                        Error('');
                end else
                    if Confirm(Text12401) then
                        ItemJnlPostLine.DisableRedStorno
                    else
                        Error('');
            end;
        }
        field(12416; "Check CD No. Format"; Boolean)
        {
            Caption = 'Check CD No. Format';
        }
        field(12450; "TORG-13 Template Code"; Code[10])
        {
            Caption = 'TORG-13 Template Code';
            TableRelation = "Excel Template";
        }
        field(12451; "Waybill 1-T Template Code"; Code[10])
        {
            Caption = 'Waybill 1-T Template Code';
            TableRelation = "Excel Template";
        }
        field(12452; "Item Document Template Code"; Code[10])
        {
            Caption = 'Item Document Template Code';
            TableRelation = "Excel Template";
        }
        field(12454; "Shpt.Request M-11 Templ. Code"; Code[10])
        {
            Caption = 'Shpt.Request M-11 Templ. Code';
            TableRelation = "Excel Template";
        }
        field(12455; "TORG-16 Template Code"; Code[10])
        {
            Caption = 'TORG-16 Template Code';
            TableRelation = "Excel Template";
        }
        field(12456; "INV-17 Template Code"; Code[10])
        {
            Caption = 'INV-17 Template Code';
            TableRelation = "Excel Template";
        }
        field(12457; "INV-17 Appendix Template Code"; Code[10])
        {
            Caption = 'INV-17 Appendix Template Code';
            TableRelation = "Excel Template";
        }
        field(12458; "Item Card M-17 Template Code"; Code[10])
        {
            Caption = 'Item Card M-17 Template Code';
            TableRelation = "Excel Template";
        }
        field(12459; "Phys.Inv. INV-3 Template Code"; Code[10])
        {
            Caption = 'Phys.Inv. INV-3 Template Code';
            TableRelation = "Excel Template";
        }
        field(12460; "Phys.Inv. INV-19 Template Code"; Code[10])
        {
            Caption = 'Phys.Inv. INV-19 Template Code';
            TableRelation = "Excel Template";
        }
        field(12461; "TORG-29 Template Code"; Code[10])
        {
            Caption = 'TORG-29 Template Code';
            TableRelation = "Excel Template";
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        ItemLedgEntry: Record "Item Ledger Entry";
        Text000: Label 'Some unadjusted value entries will not be covered with the new setting. You must run the Adjust Cost - Item Entries batch job once to adjust these.';
        Item: Record Item;
        InvtAdjmtEntryOrder: Record "Inventory Adjmt. Entry (Order)";
        Text004: Label 'The program has cancelled the change that would have caused an adjustment of all items.';
        Text005: Label '%1 has been changed to %2. You should now run %3.';
        ObjTransl: Record "Object Translation";
        Text006: Label 'The field %1 should not be set to %2 if field %3 in %4 table is set to %5 because of possibility of deadlocks.';
        ItemEntriesAdjustQst: Label 'If you change the %1, the program must adjust all item entries.The adjustment of all entries can take several hours.\Do you really want to change the %1?', Comment = '%1 - field caption';
        Text12400: Label 'Do you want to enable red storno?';
        Text12401: Label 'Do you want to disable red storno?';

    local procedure UpdateInvtAdjmtEntryOrder()
    var
        InvtAdjmtEntryOrder: Record "Inventory Adjmt. Entry (Order)";
    begin
        InvtAdjmtEntryOrder.SetCurrentKey("Cost is Adjusted", "Allow Online Adjustment");
        InvtAdjmtEntryOrder.SetRange("Cost is Adjusted", false);
        InvtAdjmtEntryOrder.SetRange("Allow Online Adjustment", false);
        InvtAdjmtEntryOrder.SetRange("Is Finished", false);
        InvtAdjmtEntryOrder.SetRange("Order Type", InvtAdjmtEntryOrder."Order Type"::Production);
        InvtAdjmtEntryOrder.ModifyAll("Allow Online Adjustment", true);
    end;

    local procedure UpdateAvgCostItemSettings(FieldCaption: Text[80]; FieldValue: Text[80])
    var
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        if not ConfirmManagement.GetResponseOrDefault(
             StrSubstNo(ItemEntriesAdjustQst, FieldCaption), false)
        then
            Error(Text004);

        CODEUNIT.Run(CODEUNIT::"Change Average Cost Setting", Rec);

        Message(
          Text005, FieldCaption, FieldValue,
          ObjTransl.TranslateObject(ObjTransl."Object Type"::Report, REPORT::"Adjust Cost - Item Entries"));
    end;
}
