#ServerInstance
$serverInstance = "BC170"
#Path
$rootDirPath = "C:\Users\alpopov\AL\N17Construction"

$quietExecution = $null

$homeDir = "$rootDirPath\AL\BaseApp"
cd $homeDir

$quietExecution = git pull

$response = read-host "Are you sure the code is in sync and you want to continue? Press 'yes' to continue"
if ($response -ne "yes") {
    Exit
}

$userName = $env:username
cd "C:\Users\$userName\.vscode\extensions\"
$extensionName = Get-ChildItem -Name -Filter "ms-dynamics-smb.al*"

cd "C:\Users\$userName\.vscode\extensions\$extensionName\bin\"

$quietExecution = ./alc.exe /project:$homeDir /packagecachepath:$homeDir\.alpackages

cd "$rootDirPath\Scripts"

$quietExecution = ./Modules/NavAdminTool.ps1

$quietExecution = Import-Module ".\Modules\AppAdminTool.psm1"

cd $homeDir

try {
    RepublishBaseApp -ServerInstanceName $serverInstance -ApplicationName "Base Application" -ApplicationPath ".\Microsoft_Base Application_17.4.21491.21531.app"
    Write-Output "Base Application has been republished successfully."
} catch {
    Exit
}

cd $homeDir
$quietExecution = git add .

$commitMessage = Read-Host "`nEnter commit message '<Task ID> <Documentation message>'"
if ($commitMessage -notmatch '^[0-9]{5}') {
    Write-Host "The commit message does not contain a task ID."
    Exit
}

$quietExecution = git commit -m $commitMessage
$quietExecution = git push