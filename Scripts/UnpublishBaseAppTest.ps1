$ServerInstanceName = "BonavaTest"

$quietExecution = $null

$quietExecution = ./Modules/NavAdminTool.ps1
$quietExecution = Import-Module ".\Modules\AppAdminToolTest.psm1"

UninstallAndUnpublish -ServerInstance $ServerInstanceName -AppName "Base Application"

Write-Output "Base Application uninstalled and unpublished succuesfully."