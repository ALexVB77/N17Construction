param($ObjectID)
if (!$ObjectID){
	Throw "Object ID must be specified!"
}

$Cred = New-Object System.Management.Automation.PSCredential -ArgumentList "wsuser", (ConvertTo-SecureString "tk7xhPjZ"  -AsPlainText -Force)
$WS = New-WebServiceProxy "http://nav.rharitonov.ru:7047/BC170/WS/CRONUS%20%D0%A0%D0%BE%D1%81%D1%81%D0%B8%D1%8F%20%D0%97%D0%90%D0%9E/Codeunit/NavnavAPI"  -Credential $cred 
$WS.Timeout = [System.Int32]::MaxValue


$Param = @"
{
	"RemoteHost": "$env:COMPUTERNAME",
	"User": "$env:USERNAME",
    "GetOriganalObject": true,
	"GetXliffData": false
}
"@

$ToConvertObjectID = $ObjectID
$ConvertedObject = ""
$OriginalObject = ""
$XliffData = ""
$ResponseText = $WS.GimmeAL($Param, $ToConvertObjectID, [ref]$ConvertedObject, [ref]$OriginalObject, [ref]$XliffData)
Write-Host $ResponseText


$OutputFolder = ".\"

if ($OriginalObject){
	$Filename = "navnav-$ToConvertObjectID.txt"
	$OutputFilename = Join-Path -Path $OutputFolder -ChildPath $Filename
	Set-Content -Path $OutputFilename -Value $OriginalObject
}

if ($ConvertedObject){
	$Filename = "navnav-$ToConvertObjectID.al"
	$OutputFilename = Join-Path -Path $OutputFolder -ChildPath $Filename
	Set-Content -Path $OutputFilename -Value $ConvertedObject
}

if ($XliffData){
	$Filename = "navnav-$ToConvertObjectID.xlf"
	$OutputFilename = Join-Path -Path $OutputFolder -ChildPath $Filename
	Set-Content -Path $OutputFilename -Value $XliffData
}
