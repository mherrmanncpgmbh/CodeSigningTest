<#
.SYNOPSIS  
	Signs a specified powershell script by a specified PFX file.
    https://learn.microsoft.com/en-us/powershell/module/pki/export-pfxcertificate?view=windowsserver2025-ps
.NOTES  
	Author: someone@cpgmbh.de
#>

$PfxPath = ".\Signing\cp_selfsigned_pfx.pfx" | Resolve-Path
$PfxPassword = "123"
$PowershellToSign = ".\TestScript.ps1" | Resolve-Path

# Abort if path to pfx does not actually exist
if(!(Test-Path $PfxPath)) {
    Write-Error "PFX file [$PfxPath] does not exist."
    Exit 1
}

# Abort if path to powershell does not actually exist
if(!(Test-Path $PowershellToSign)) {
    Write-Error "Powershell file [$PowershellToSign] does not exist."
    Exit 1
}

$PfxPassword = ConvertTo-SecureString $PfxPassword -AsPlainText -Force
$Cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
$Cert.Import($PfxPath, $PfxPassword, "Exportable,PersistKeySet")

# Sign the script
Set-AuthenticodeSignature -FilePath $PowershellToSign -Certificate $Cert

# Verify that the file was signed and what is its status
$VerificationResult = Get-AuthenticodeSignature -FilePath "$PowershellToSign"
Write-Output "Powershell [$($VerificationResult.Path)] signing status: $($VerificationResult.Status)"