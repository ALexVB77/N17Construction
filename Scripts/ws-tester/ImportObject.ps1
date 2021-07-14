$CrmWSUrlTest = "https://vm-tst-app035.oneplatform.info:7147/BonavaTest/WS/Bonava/Codeunit/CrmAPI"

$WS = New-WebServiceProxy $CrmWSUrlTest -UseDefaultCredential
$WS.Timeout = [System.Int32]::MaxValue

$CrmObjectsFolder = 'C:\Temp\CRM\xml'

$SoapEnv = @"
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <soap:Body>
      <crm_objects>
         _1_
      </crm_objects>
   </soap:Body>
</soap:Envelope>
"@

$XmlObject = "<object>_1_</object>"
$XmlAllObjects = ""

$Files = Get-ChildItem -Path "$CrmObjectsFolder\*" -Include "*.xml"
if (!$Files){
   Write-Host "There are no xml files!"
} else {
   $Files | ForEach-Object {
      $Filename = Join-Path -Path $CrmObjectsFolder -ChildPath $_.Name
      $XmlContent = Get-Content -Path $Filename -Encoding utf8
      $Base64XmlContent = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($XmlContent))
      $XmlAllObjects += $XmlObject.Replace("_1_", $Base64XmlContent)
   }
}

$SoapEnv = $SoapEnv.Replace("_1_", $XmlAllObjects)

$ResponseText = $WS.ImportObject($SoapEnv)
Write-Host $ResponseText
Read-Host "Press Enter to exit"
