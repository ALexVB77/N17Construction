// TODO: доработать отчет @eapomazkov
// report 70009 "Item Shipment M-19"
// {
//     // NC22512
//     // NC 52624 EP
//     //  перенес объект

//     // TODO: уточнить навигацию @eapomazkov
//     ApplicationArea = All;
//     UsageCategory = ReportsAndAnalysis;

//     Caption = 'Item Shipment M-19';
//     ProcessingOnly = true;

//     dataset
//     {
//         dataitem(ItemDocHeader; "Item Document Header")
//         {
//             DataItemTableView = sorting("Document Type", "No.") order(ascending) where("Document Type" = const(Shipment));

//             dataitem(ItemDocLine; "Item Document Line")
//             {
//                 DataItemTableView = sorting("Document Type", "Document No.", "Line No.") order(ascending);
//                 DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");

//                 trigger OnAfterGetRecord()
//                 begin
//                     //NC 22512 > DP
//                     FillBodyID(ItemDocLine);
//                     //NC 22512 < DP
//                 end;

//                 trigger OnPostDataItem()
//                 begin
//                     //NC 22512 > DP
//                     FillFooter();
//                     //NC 22512 < DP
//                 end;
//             }

//             trigger OnPreDataItem()
//             begin
//                 //NC 22512 > DP
//                 if ItemDocHeader.GetFilters() = '' then CurrReport.Break();
//                 //NC 22512 < DP
//             end;

//             trigger OnAfterGetRecord()
//             begin
//                 //NC 22512 > DP
//                 Location.Get(ItemDocHeader."Location Code");
//                 PurchaserCode := ItemDocHeader."Salesperson/Purchaser Code";
//                 FillHeader();

//                 ILE.SetFilter("Posting Date", '<1%', ItemDocHeader."Posting Date");
//                 VE.SetFilter("Posting Date", '<1%', ItemDocHeader."Posting Date");
//                 ILE.SetRange("Location Code", ItemDocHeader."Location Code");
//                 VE.SetRange("Location Code", ItemDocHeader."Location Code");
//                 //NC 22512 < DP
//             end;
//         }
//         dataitem("Item Shipment Header"; "Item Shipment Header")
//         {
//             DataitemTableView = sorting("No.");

//             dataitem("Item Shipment Line"; "Item Shipment Line")
//             {
//                 DataItemTableView = sorting("Document No.", "Line No.");
//                 DataItemLink = "Document No." = field("No.");

//                 trigger OnAfterGetRecord()
//                 var
//                     IDL: Record "Item Document Line";
//                 begin
//                     //NC 22512 > DP
//                     IDL.TransferFields("Item Shipment Line");
//                     FillBodyID(IDL);
//                     //NC 22512 < DP
//                 end;

//                 trigger OnPostDataItem()
//                 begin
//                     //NC 22512 > DP
//                     FillFooter();
//                     //NC 22512 < DP
//                 end;
//             }

//             trigger OnPreDataItem()
//             begin
//                 //NC 22512 > DP
//                 if "Item Shipment Header".GetFilters() = '' then CurrReport.Break();
//                 //NC 22512 < DP
//             end;

//             trigger OnAfterGetRecord()
//             begin
//                 //NC 22512 > DP
//                 Location.Get("Item Shipment Header"."Location Code");
//                 PurchaserCode := "Item Shipment Header"."Salesperson Code";
//                 FillHeader();

//                 ILE.SetFilter("Posting Date", '<%1', "Item Shipment Header"."Posting Date");
//                 VE.SetFilter("Posting Date", '<%1', "Item Shipment Header"."Posting Date");
//                 ILE.SetRange("Location Code", "Item Shipment Header"."Location Code");
//                 VE.SetRange("Location Code", "Item Shipment Header"."Location Code");
//                 //NC 22512 < DP
//             end;
//         }
//     }


//     requestpage
//     {
//         Caption = 'Item Shipment M-15 Posted';
//         SaveValues = true;

//         layout
//         {
//             area(Content)
//             {
//                 group(Options)
//                 {
//                     field(Employee2; Employee2)
//                     {
//                         Caption = 'Project Manager';
//                         TableRelation = Employee;
//                     }
//                     field(Employee3; Employee3)
//                     {
//                         Caption = 'Report verified by';
//                         TableRelation = Employee;
//                     }
//                     field(ReportDate; ReportDate)
//                     {
//                         Caption = 'Report Date';
//                         // NC 52624 > EP
//                         // Ну это мем какой-то, отключил
//                         // TableRelation = Employee;
//                         // NC 52624 < EP
//                     }
//                 }
//             }
//         }

//         trigger OnOpenPage()
//         begin
//             ReportDate := WorkDate();
//         end;
//     }

//     trigger OnPreReport()
//     begin
//         FileName := ExcelTemplate.OpenTemplate(Format(Report::"Item Shipment M-19"));
//         ExcelBuf.OpenBook(FileName, 'Sheet1');
//         RowNo := 24;

//         ILE.SetCurrentKey("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date");
//         // TODO: перенести этот ключ в "Value Entry" либо использовать другой @eapomazkov
//         // VE.SetCurrentKey("Item No.","Location Code","Expected Cost",Inventoriable,"Posting Date");
//         if ReportDate = 0D then ReportDate := WorkDate();
//     end;

//     trigger OnPostReport()
//     begin
//         // NC 52624 > EP
//         // ExcelBuf.SaveCellsToExcel();
//         // ExcelBuf.GiveUserControl();
//         ExcelBuf.WriteSheet('', '', '');
//         ExcelBuf.CloseBook();
//         ExcelBuf.OpenExcel();
//         // NC 52624 < EP
//     end;

//     var
//         Location: Record Location;
//         ILE: Record "Item Ledger Entry";
//         VE: Record "Value Entry";
//         ExcelTemplate: Record "Excel Template";
//         ExcelBuf: Record "Excel Buffer Mod" temporary;
//         LocRepMgt: Codeunit "Local Report Management";
//         LocalManagement: Codeunit "Localisation Management";
//         Employee2: Code[20];
//         Employee3: Code[20];
//         PurchaserCode: Code[20];
//         ReportDate: Date;
//         TotalItemAmount: Decimal;
//         TotalLineAmount: Decimal;
//         TotalEndAmount: Decimal;
//         RowNo: Integer;
//         FileName: Text[250];
//         Text0001: Label 'по учету материально-производственные запасов  на строительной площадке %1', Comment = '%1 = Location Name';
//         Text0002: Label 'Отчет составил';
//         Text0003: Label '*получаетель материалов';


//     procedure FillHeader()
//     begin
//         // NC 52624 > EP
//         // Вызываем стандартную EnterCell() вместо AddCell().
//         // В AddCell() был параметр, определяющий значение "Font Size", однако
//         // сейчас значение из этого поля вообще не используется.
//         /* //NC 22512 > DP
//             ExcelBuf.AddCell(7, 7, LocRepMgt.GetEmpName(Employee2), FALSE, FALSE, FALSE, 9);
//             ExcelBuf.AddCell(7, 26, LocRepMgt.GetEmpName(Employee3), FALSE, FALSE, FALSE, 9);

//             ExcelBuf.AddCell(16, 8, STRSUBSTNO(Text0001, Location.Name + Location."Name 2"), FALSE, FALSE, FALSE, 9);

//             ExcelBuf.AddCell(20, 12, FORMAT(DATE2DMY(ReportDate, 1)), FALSE, FALSE, FALSE, 9);
//             ExcelBuf.AddCell(20, 14, LocalManagement.Month2Text(ReportDate), FALSE, FALSE, FALSE, 9);
//             ExcelBuf.AddCell(20, 19, FORMAT(DATE2DMY(ReportDate, 3)), FALSE, FALSE, FALSE, 9);
//             //NC 22512 < DP
//         */

//         ExcelBuf.EnterCell(ExcelBuf, 7, 7, LocRepMgt.GetEmpName(Employee2), false, false, false);
//         ExcelBuf.EnterCell(ExcelBuf, 7, 26, LocRepMgt.GetEmpName(Employee3), false, false, false);

//         ExcelBuf.EnterCell(ExcelBuf, 16, 8, StrSubstNo(Text0001, Location.Name + Location."Name 2"), false, false, false);

//         ExcelBuf.EnterCell(ExcelBuf, 20, 12, Format(Date2DMY(ReportDate, 1)), false, false, false);
//         ExcelBuf.EnterCell(ExcelBuf, 20, 14, LocalManagement.Month2Text(ReportDate), false, false, false);
//         ExcelBuf.EnterCell(ExcelBuf, 20, 19, Format(Date2DMY(ReportDate, 3)), false, false, false);

//         // NC 52624 < EP
//     end;

//     procedure FillFooter()
//     begin
//         // NC 52624 > EP
//         // Вызываем стандартную EnterCell() вместо AddCell().

//         /* //NC 22512 > DP

//             ExcelBuf.DeleteString(RowNo - 1);

//             //RowNo += 1;

//             ExcelBuf.AddCell(RowNo, 18, ReportFormat(TotalItemAmount), FALSE, FALSE, FALSE, 7);
//             ExcelBuf.AddCell(RowNo, 23, ReportFormat(TotalLineAmount), FALSE, FALSE, FALSE, 7);
//             ExcelBuf.AddCell(RowNo, 28, ReportFormat(TotalEndAmount), FALSE, FALSE, FALSE, 7);

//             RowNo += 6;
//             ExcelBuf.AddCell(RowNo, 8, Text0002, FALSE, FALSE, FALSE, 9);
//             ExcelBuf.AddCell(RowNo, 13, PurchaserCode, FALSE, FALSE, FALSE, 9);
//             ExcelBuf.AddCell(RowNo, 22, Text0003, FALSE, FALSE, FALSE, 9);

//             //NC 22512 < DP
//         */

//         // TODO: добавить вызов функции DeleteString() или аналогичной (должна удалять строку), когда она появится. @eapomazkov
//         // ExcelBuf.DeleteString(RowNo - 1);

//         ExcelBuf.EnterCell(ExcelBuf, RowNo, 18, ReportFormat(TotalItemAmount), false, false, false);
//         ExcelBuf.EnterCell(ExcelBuf, RowNo, 23, ReportFormat(TotalLineAmount), false, false, false);
//         ExcelBuf.EnterCell(ExcelBuf, RowNo, 28, ReportFormat(TotalEndAmount), false, false, false);

//         RowNo += 6;
//         ExcelBuf.EnterCell(ExcelBuf, RowNo, 8, Text0002, false, false, false);
//         ExcelBuf.EnterCell(ExcelBuf, RowNo, 13, PurchaserCode, false, false, false);
//         ExcelBuf.EnterCell(ExcelBuf, RowNo, 22, Text0003, false, false, false);

//         // NC 52624 < EP
//     end;

//     procedure FillBodyID(IDL: Record "Item Document Line")
//     var
//         Item: Record Item;
//         ItemAmount: Decimal;
//         LineAmount: Decimal;
//         EndAmount: Decimal;
//     begin
//         // NC 52624 > EP
//         // Обновил вызываемые функции, избавился от конструкции "with..."

//         /* //NC 22512 > DP
//             WITH IDL DO BEGIN
//                 Item.GET("Item No.");
//                 ILE.SETRANGE("Item No.", "Item No.");
//                 VE.SETRANGE("Item No.", "Item No.");
//                 ILE.CALCSUMS(Quantity);
//                 VE.CALCSUMS("Cost Amount (Actual)");

//                 ItemAmount := VE."Cost Amount (Actual)";
//                 Amount := ItemAmount;

//                 TotalItemAmount += ItemAmount;
//                 TotalLineAmount += Amount;
//                 TotalEndAmount += EndAmount;

//                 ExcelBuf.InsertString(RowNo);
//                 ExcelBuf.AddCell(RowNo, 1, "Item No.", FALSE, FALSE, FALSE, 7);
//                 ExcelBuf.AddCell(RowNo, 3, Description, FALSE, FALSE, FALSE, 7);

//                 ExcelBuf.AddCell(RowNo, 12, ReportFormat(Item."Unit Cost"), FALSE, FALSE, FALSE, 7);
//                 ExcelBuf.AddCell(RowNo, 14, "Unit of Measure Code", FALSE, FALSE, FALSE, 6);

//                 ExcelBuf.AddCell(RowNo, 16, ReportFormat(Quantity), FALSE, FALSE, FALSE, 7);
//                 ExcelBuf.AddCell(RowNo, 18, ReportFormat(Amount), FALSE, FALSE, FALSE, 7);
//                 ExcelBuf.AddCell(RowNo, 21, ReportFormat(Quantity), FALSE, FALSE, FALSE, 7);
//                 ExcelBuf.AddCell(RowNo, 23, ReportFormat(Amount), FALSE, FALSE, FALSE, 7);

//                 ExcelBuf.AddCell(RowNo, 26, ReportFormat(0), FALSE, FALSE, FALSE, 7);
//                 ExcelBuf.AddCell(RowNo, 28, ReportFormat(EndAmount), FALSE, FALSE, FALSE, 7);
//                 RowNo += 1;
//             END;
//             //NC 22512 < DP
//         */

//         Item.Get(IDL."Item No.");
//         ILE.SetRange("Item No.", IDL."Item No.");
//         VE.SetRange("Item No.", IDL."Item No.");
//         ILE.CalcSums(Quantity);
//         VE.CalcSums("Cost Amount (Actual)");

//         ItemAmount := VE."Cost Amount (Actual)";
//         IDL.Amount := ItemAmount;

//         TotalItemAmount += ItemAmount;
//         TotalLineAmount += IDL.Amount;
//         TotalEndAmount += EndAmount;

//         // TODO: добавить вызов функции InsertString() или аналогичной (должна копировать строку со смещением), когда она появится. @eapomazkov
//         // ExcelBuf.InsertString(RowNo);

//         ExcelBuf.EnterCell(ExcelBuf, RowNo, 1, IDL."Item No.", false, false, false);
//         ExcelBuf.EnterCell(ExcelBuf, RowNo, 3, IDL.Description, false, false, false);

//         ExcelBuf.EnterCell(ExcelBuf, RowNo, 12, ReportFormat(Item."Unit Cost"), false, false, false);
//         ExcelBuf.EnterCell(ExcelBuf, RowNo, 14, IDL."Unit of Measure Code", false, false, false);

//         ExcelBuf.EnterCell(ExcelBuf, RowNo, 16, ReportFormat(IDL.Quantity), false, false, false);
//         ExcelBuf.EnterCell(ExcelBuf, RowNo, 18, ReportFormat(IDL.Amount), false, false, false);
//         ExcelBuf.EnterCell(ExcelBuf, RowNo, 21, ReportFormat(IDL.Quantity), false, false, false);
//         ExcelBuf.EnterCell(ExcelBuf, RowNo, 23, ReportFormat(IDL.Amount), false, false, false);

//         ExcelBuf.EnterCell(ExcelBuf, RowNo, 26, ReportFormat(0), false, false, false);
//         ExcelBuf.EnterCell(ExcelBuf, RowNo, 28, ReportFormat(EndAmount), false, false, false);
//         RowNo += 1;

//         // NC 52624 < EP
//     end;

//     procedure ReportFormat(dec: Decimal): Text[250]
//     begin
//         exit(Format(dec, 0, '<Precision,2:2><Standard Format,0>'));
//     end;
// }