page 247 "VAT Registration Log Details"
{
    PageType = List;
    SourceTable = "VAT Registration Log Details";
    Caption = 'Validation Details';
    DataCaptionFields = "Account Type", "Account No.";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Details)
            {
                field("Field Name"; Rec."Field Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the field that has been validated by the VAT registration no. validation service.';
                }
                field(Requested; Rec.Requested)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the requested value.';
                }
                field("Current Value"; Rec."Current Value")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the current value.';
                }
                field(Response; Rec.Response)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value that was returned by the service.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the status of the field validation.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Accept)
            {
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedOnly = true;
                PromotedIsBig = true;
                Image = Approve;
                PromotedCategory = Process;
                Enabled = AcceptEnabled;
                Caption = 'Accept';
                ToolTip = 'Apply the value that the service returned to the account.';

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Accepted;
                    Rec.Modify();

                    UpdateControls();
                end;
            }
            action(AcceptAll)
            {
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedOnly = true;
                PromotedIsBig = true;
                Image = Approve;
                PromotedCategory = Process;
                Enabled = AcceptAllEnabled;
                Caption = 'Accept All';
                ToolTip = 'Accept all returned values and update the account.';

                trigger OnAction()
                begin
                    UpdateAllDetailsStatus(Rec.Status::"Not Valid", Rec.Status::Accepted);
                end;

            }
            action(Reset)
            {
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedOnly = true;
                PromotedIsBig = true;
                Image = ResetStatus;
                PromotedCategory = Process;
                Enabled = ResetEnabled;
                Caption = 'Reset';
                ToolTip = 'Reset the value that was applied to the account.';

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::"Not Valid";
                    Rec.Modify();

                    UpdateControls();
                end;
            }
            action(ResetAll)
            {
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedOnly = true;
                PromotedIsBig = true;
                Image = ResetStatus;
                PromotedCategory = Process;
                Enabled = ResetAllEnabled;
                Caption = 'Reset All';
                ToolTip = 'Reset the values that were applied to the account.';

                trigger OnAction()
                begin
                    UpdateAllDetailsStatus(Rec.Status::Accepted, Rec.Status::"Not Valid");
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        UpdateControls();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        AcceptEnabled := (Rec.Status = Rec.Status::"Not Valid") and (Rec.Response <> '');
        ResetEnabled := Rec.Status = Rec.Status::Accepted;
    end;

    var
        AcceptEnabled: Boolean;
        AcceptAllEnabled: Boolean;
        ResetEnabled: Boolean;
        ResetAllEnabled: Boolean;

    local procedure UpdateAllDetailsStatus(Before: Enum "VAT Reg. Log Details Field Status"; After: Enum "VAT Reg. Log Details Field Status")
    var
        VATRegistrationLogDetails: Record "VAT Registration Log Details";
    begin
        VATRegistrationLogDetails.Copy(Rec);
        VATRegistrationLogDetails.SetFilter(Response, '<>%1', '');
        VATRegistrationLogDetails.SetRange(Status, Before);
        VATRegistrationLogDetails.ModifyAll(Status, After);

        UpdateControls();
    end;

    local procedure UpdateControls()
    var
        VATRegistrationLogDetails: Record "VAT Registration Log Details";
    begin
        VATRegistrationLogDetails.CopyFilters(Rec);
        VATRegistrationLogDetails.SetFilter(Response, '<>%1', '');

        VATRegistrationLogDetails.SetRange(Status, VATRegistrationLogDetails.Status::"Not Valid");
        AcceptAllEnabled := not VATRegistrationLogDetails.IsEmpty();

        VATRegistrationLogDetails.SetRange(Status, VATRegistrationLogDetails.Status::Accepted);
        ResetAllEnabled := not VATRegistrationLogDetails.IsEmpty();
    end;
}