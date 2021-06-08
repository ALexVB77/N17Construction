
$MYTEXT = "<object>__BASE64_ENCODED_OBJECT_XML_3__</object>"

$ENCODED = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($MYTEXT))
Write-Output $ENCODED
