$Cred = New-Object System.Management.Automation.PSCredential -ArgumentList "wsuser", (ConvertTo-SecureString "tk7xhPjZ"  -AsPlainText -Force)
$WS = New-WebServiceProxy "http://nav-bonava.ncdev.ru:17057/BonavaDev/WS/CRONUS%20%D0%A0%D0%BE%D1%81%D1%81%D0%B8%D1%8F%20%D0%97%D0%90%D0%9E/Codeunit/CRMIntegrationAPI" -UseDefaultCredential
$WS.Timeout = [System.Int32]::MaxValue

$SoapEnv = @"
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <soap:Body>
      <crm_objects>
         <object>__BASE64_ENCODED_OBJECT_XML_1__</object>
         <object>__BASE64_ENCODED_OBJECT_XML_2__</object>
         <object>__BASE64_ENCODED_OBJECT_XML_3__</object>
      </crm_objects>
   </soap:Body>
</soap:Envelope>
"@

$XmlContent = Get-Content -Path .\t1\Unit.xml -Encoding utf8
$Base64XmlContent = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($XmlContent))
$SoapEnv = $SoapEnv.Replace("__BASE64_ENCODED_OBJECT_XML_1__", $Base64XmlContent)

$XmlContent = Get-Content -Path .\t1\Contact.xml -Encoding utf8
$Base64XmlContent = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($XmlContent))
$SoapEnv = $SoapEnv.Replace("__BASE64_ENCODED_OBJECT_XML_2__", $Base64XmlContent)

$XmlContent = Get-Content -Path .\t1\Contract.xml -Encoding utf8
$Base64XmlContent = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($XmlContent))
$SoapEnv = $SoapEnv.Replace("__BASE64_ENCODED_OBJECT_XML_3__", $Base64XmlContent)

$null = Set-Content -path "C:\Temp\out.xml" -Value $SoapEnv

$ResponseText = $WS.ImportObject($SoapEnv)
Write-Host $ResponseText
