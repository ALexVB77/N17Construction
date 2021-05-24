$srcFile = "..\..\AL\BaseApp\Translations\Base Application.ru-RU.xlf"
$dstFile = "..\..\AL\GeneralExt\Translations\GeneralExt.ru-RU.xlf"

[xml]$src =  Get-Content -Path $srcFile -Encoding UTF8
[xml]$dst =  Get-Content -Path $dstFile -Encoding UTF8

$dstUnits = $dst.xliff.file.body.group.'trans-unit' | Where-Object {$_.target -eq '[NAB: NOT TRANSLATED]'}
foreach($dstNode in $dstUnits){
  $srcUnits = $src.xliff.file.body.group.'trans-unit' | Where-Object {(($_.source -eq $dstNode.source)-and($_.target.state -eq 'translated'))} | Select-Object -First 1
  if ($srcUnits) {
    $dstNode.target = '[GG]' + $srcUnits.target.innerText
    Write-Output $dstNode.source $dstNode.target    
  }
}
$dst.Save($dstFile)








