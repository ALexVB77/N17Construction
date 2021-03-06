report 14905 "Letter of Attorney M-2A"
{
    Caption = 'Letter of Attorney M-2A';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Letter of Attorney Header"; "Letter of Attorney Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            dataitem("Letter of Attorney Line"; "Letter of Attorney Line")
            {
                DataItemLink = "Letter of Attorney No." = FIELD("No.");
                DataItemTableView = SORTING("Letter of Attorney No.", "Line No.");

                trigger OnAfterGetRecord()
                begin
                    Counter += 1;

                    QuantityText := '';

                    if Quantity <> 0 then
                        QuantityText := LocManagement.Integer2Text(Quantity, 0, "Unit of Measure", "Unit of Measure", "Unit of Measure");

                    if not ExcelReportBuilderManager.TryAddSectionWithPlaceForFooter('BODY', 'REPORTFOOTER') then begin
                        ExcelReportBuilderManager.AddPagebreak;
                        ExcelReportBuilderManager.AddSection('PAGEHEADER');
                        ExcelReportBuilderManager.AddSection('BODY');
                    end;

                    FillBody(Format(Counter), Description, "Unit of Measure", QuantityText);
                end;

                trigger OnPostDataItem()
                begin
                    if (Counter = 0) and PrintItemList then begin
                        ExcelReportBuilderManager.AddSection('BODY');
                        FillBody('----', '----------------', '-----', '-----------------');
                    end;

                    ExcelReportBuilderManager.AddSection('REPORTFOOTER');
                    ExcelReportBuilderManager.AddDataToSection('ManagerName', CompanyInformation."Director Name");
                    ExcelReportBuilderManager.AddDataToSection('AccountantName', CompanyInformation."Accountant Name");
                end;

                trigger OnPreDataItem()
                begin
                    if not PrintItemList then
                        CurrReport.Break();
                end;
            }

            trigger OnAfterGetRecord()
            var
                LocalReportManagement: Codeunit "Local Report Management";
            begin
                TestField("Employee No.");
                TestField("Buy-from Vendor Name");
                Employee.Get("Employee No.");
                Employee.TestField("Person No.");
                Person.Get(Employee."Person No.");
                Person.GetIdentityDoc("Validity Date", PersonalDoc);

                if not Preview then begin
                    if "Letter of Attorney No." = '' then
                        "Letter of Attorney No." := NoSeriesManagement.GetNextNo(PurchSetup."Released Letter of Attor. Nos.", WorkDate, true);
                    Release;
                end;

                ExcelReportBuilderManager.AddSection('REPORTHEADER');
                ExcelReportBuilderManager.AddDataToSection('CompanyName', LocalReportManagement.GetCompanyName);
                ExcelReportBuilderManager.AddDataToSection('OKPO', CompanyInformation."OKPO Code");
                ExcelReportBuilderManager.AddDataToSection('DocNo', "Letter of Attorney No.");
                ExcelReportBuilderManager.AddDataToSection('DocDay', Format(Date2DMY("Document Date", 1)));
                ExcelReportBuilderManager.AddDataToSection('DocMonth', LocManagement.Month2Text("Document Date"));
                ExcelReportBuilderManager.AddDataToSection('DocYear', Format(Date2DMY("Document Date", 3)));
                ExcelReportBuilderManager.AddDataToSection('ValidDay', Format(Date2DMY("Validity Date", 1)));
                ExcelReportBuilderManager.AddDataToSection('ValidMonth', LocManagement.Month2Text("Validity Date"));
                ExcelReportBuilderManager.AddDataToSection('ValidYear', Format(Date2DMY("Validity Date", 3)));
                ExcelReportBuilderManager.AddDataToSection('ReceiverName',
                  LocalReportManagement.GetCompanyName + '  ' +
                  CompanyInformation.Address + '  ' + CompanyInformation."Address 2");
                ExcelReportBuilderManager.AddDataToSection('PayerName',
                  LocalReportManagement.GetCompanyName + '  ' +
                  CompanyInformation.Address + '  ' + CompanyInformation."Address 2");
                ExcelReportBuilderManager.AddDataToSection('BancAccNo', CompanyInformation."Bank Account No.");
                ExcelReportBuilderManager.AddDataToSection('BankName',
                  CompanyInformation."Bank Name" + BICTxt + CompanyInformation."Bank BIC");
                ExcelReportBuilderManager.AddDataToSection('JobTitle', Employee.GetJobTitleName);
                ExcelReportBuilderManager.AddDataToSection('EmployeeName', "Employee Full Name");
                ExcelReportBuilderManager.AddDataToSection('EmployeeDocSeries', PersonalDoc."Document Series");
                ExcelReportBuilderManager.AddDataToSection('EmployeeDocNo', PersonalDoc."Document No.");
                ExcelReportBuilderManager.AddDataToSection('IssueAuthority', PersonalDoc."Issue Authority");
                ExcelReportBuilderManager.AddDataToSection('DocIssueDay', Format(Date2DMY(PersonalDoc."Issue Date", 1)));
                ExcelReportBuilderManager.AddDataToSection('DocIssueMonth', LocManagement.Month2Text(PersonalDoc."Issue Date"));
                ExcelReportBuilderManager.AddDataToSection('DocIssueYear', Format(Date2DMY(PersonalDoc."Issue Date", 3)));
                ExcelReportBuilderManager.AddDataToSection('VendorName', "Buy-from Vendor Name");
                ExcelReportBuilderManager.AddDataToSection('Desription', "Document Description");

                ExcelReportBuilderManager.AddSection('PAGEHEADER');
                if not PrintItemList then begin
                    ExcelReportBuilderManager.AddSection('BODY');
                    FillBody('----', '----------------', '-----', '-----------------');
                end;
            end;

            trigger OnPostDataItem()
            begin
                if FileName <> '' then
                    ExcelReportBuilderManager.ExportDataToClientFile(FileName)
                else
                    ExcelReportBuilderManager.ExportData;
            end;

            trigger OnPreDataItem()
            var
                FASetup: Record "FA Setup";
            begin
                CompanyInformation.Get();
                PurchSetup.Get();
                PurchSetup.TestField("Released Letter of Attor. Nos.");

                FASetup.Get();
                FASetup.TestField("M-2a Template Code");
                ExcelReportBuilderManager.InitTemplate(FASetup."M-2a Template Code");
                ExcelReportBuilderManager.SetSheet('Sheet1');
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintItemList; PrintItemList)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Item List';
                        ToolTip = 'Specifies if you want to print the detailed list of items that are covered by this Letter of Attorney M-2A.';
                    }
                    field(Preview; Preview)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CompanyInformation: Record "Company Information";
        PurchSetup: Record "Purchases & Payables Setup";
        Employee: Record Employee;
        Person: Record Person;
        PersonalDoc: Record "Person Document";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        LocManagement: Codeunit "Localisation Management";
        ExcelReportBuilderManager: Codeunit "Excel Report Builder Manager";
        QuantityText: Text[250];
        Counter: Integer;
        PrintItemList: Boolean;
        BICTxt: Label ' BIC ';
        Preview: Boolean;
        FileName: Text;

    [Scope('OnPrem')]
    procedure FillBody(LineNo: Text; Description: Text; UoM: Text; Quantity: Text)
    begin
        ExcelReportBuilderManager.AddDataToSection('LineNo', LineNo);
        ExcelReportBuilderManager.AddDataToSection('Description', Description);
        ExcelReportBuilderManager.AddDataToSection('UoM', UoM);
        ExcelReportBuilderManager.AddDataToSection('Quantity', Quantity);
    end;

    [Scope('OnPrem')]
    procedure InitializeRequest(NewFileName: Text; NewPreview: Boolean)
    begin
        FileName := NewFileName;
        Preview := NewPreview;
    end;
}

