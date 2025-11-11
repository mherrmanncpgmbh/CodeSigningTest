$CurrentScript = $MyInvocation.MyCommand.Path

Write-Output "Hello! This is a message from a script created on device [W11-MHerrmann.cpgmbh.de]."
$Blocked = Get-Item $CurrentScript -Stream Zone.Identifier -ErrorAction SilentlyContinue
if ($Blocked) {
    Write-Host "The script is currently [blocked]."
} 
else {
	Write-Host "The script is currently [unblocked]."
}

$Signature = Get-AuthenticodeSignature -FilePath $CurrentScript

if ($Signature.Status -eq 'Valid') {
    Write-Host "The script is currently digitally [signed and valid]."
} 
elseif ($Signature.Status -eq 'NotSigned') {
    Write-Host "The script is currently [not signed]."
} 
else {
	Write-Host "The script is currently [signed but not valid]. Status: $($Signature.Status)"
}

Write-Output "Current execution policy is set to [$(Get-ExecutionPolicy)]"
Get-ExecutionPolicy -List

