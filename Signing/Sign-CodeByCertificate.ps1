<#
.SYNOPSIS  
	Signs a specified powershell script by a specified PFX file.
    https://learn.microsoft.com/en-us/powershell/module/pki/export-pfxcertificate?view=windowsserver2025-ps
.NOTES  
	Author: someone@cpgmbh.de
#>

$RootDirectory = ".\" | Resolve-Path
$PfxPath = "$RootDirectory\Signing\cp_selfsigned_pfx.pfx"
$PfxPassword = "123"

# Abort if path to pfx does not actually exist
if(!(Test-Path $PfxPath)) {
    Write-Error "PFX file [$PfxPath] does not exist."
    Exit 1
}

$AllPs1s = Get-ChildItem -Path $RootDirectory -Recurse -Filter *.ps1
$AllPs1sCount = $AllPs1s.Count
Write-Output "Found a total of [$AllPs1sCount] powershell files in directory [$RootDirectory] and its subdirectories."

$PfxPassword = ConvertTo-SecureString $PfxPassword -AsPlainText -Force
$Cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
$Cert.Import($PfxPath, $PfxPassword, "Exportable,PersistKeySet")
$SignCounter = 0

Write-Output "Looping over all powershell files ..."
foreach($Ps1 in $AllPs1s) {
	$Signature = Get-AuthenticodeSignature -FilePath $Ps1.FullName
	if($Signature.Status -ne "Valid") {
		# Sign the script with our certificate
		Write-Output "File [$($Signature.Path)] with current signing status [$($Signature.Status)] needs a new signing. Signing it now with certificate [$PfxPath]."
		Set-AuthenticodeSignature -FilePath $Ps1.FullName -Certificate $Cert | Out-Null
		$SignCounter = $SignCounter + 1
	}
}

Write-Output "A total of [$SignCounter] files have been signed."
