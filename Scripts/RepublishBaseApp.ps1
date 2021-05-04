cd "C:\Distr\Scripts"

$BankStatementPath = "C:\Users\alpopov\AL\N17Construction\AL\BankStatement\Default publisher_Bank Statement_1.0.0.0.app"
$ExcelBufferModExtPath = "C:\Users\alpopov\AL\N17Construction\AL\ExcelBufferModExt\Default publisher_ExcelBufferModExt_1.0.0.0.app"
$GeneralExtPath = "C:\Users\alpopov\AL\N17Construction\AL\GeneralExt\Default publisher_GeneralExt_1.0.0.5.app"

$ServerInstance = BonavaDev
$ApplicationPath = "C:\Users\alpopov\AL\N17Construction\AL\BaseApp\Microsoft_Base Application_17.4.21491.21531.app"

$quietExecution = $null

$quietExecution = ./Modules/NavAdminTool.ps1
$quietExecution = Import-Module ".\Modules\AppAdminTool.psm1"

RepublishBaseApp -ServerInstanceName $ServerInstance -ApplicationName "Base Application" -ApplicationPath $ApplicationPath

PublishAndInstall -ServerInstance $ServerInstance -AppName "Bank Statement" -AppPath $BankStatementPath
PublishAndInstall -ServerInstance $ServerInstance -AppName "ExcelBufferModExt" -AppPath $ExcelBufferModExtPath 
PublishAndInstall -ServerInstance $ServerInstance -AppName "GeneralExt" -AppPath $GeneralExtPath 

Write-Output "Base Application has been republished successfully."