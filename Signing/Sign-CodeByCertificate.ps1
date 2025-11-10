<#
.SYNOPSIS  
	Signs a specified powershell script by the first found "CodeSigningCert" from the certificate store.
    https://learn.microsoft.com/en-us/powershell/module/pki/export-pfxcertificate?view=windowsserver2025-ps
.NOTES  
	Author: someone@cpgmbh.de
.EXAMPLE  
    .\Sign-CodeByCertificate.ps1
.PARAMETER CertStoreLocation
	Specifies the certificate stores where the code signing certificate is going to get picked from for signing the powershell.
.PARAMETER PowershellToSign
	Specifies the location of the powershell which needs signing.
#>

$PfxPath = ".\cp_selfsigned_pfx.pfx"
$PfxPassword = "123"
$PowershellToSign = "..\TestScript.ps1"


# Abort if powershell has not the expected file format
if(!($PowershellToSign.EndsWith(".ps1"))) {
    Write-Error "[$PowershellToSign] appears to be not a valid powershell file. Expected '.ps1' as file extension."
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