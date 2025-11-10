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

<#
# Search in certificate store for all certificates with attribute "CodeSigningCert"
Write-Output "Searching certificate store for code signing certificates.."
$Cert = Get-ChildItem -Path $CertStoreLocation -CodeSigningCert

if($null -eq $Cert) {
    Write-Error "No code signing certificate could be found in certificate store [$CertStoreLocation], please validate whether one exists."
    Exit 1
}
else {
    $Cert = $Cert[0]
    Write-Output "Found a code signing certificate with subject [$($Cert.Subject)], issuer [$($Cert.Issuer)] and thumbprint [$($Cert.Thumbprint)]."
}

# Perform the signing
Write-Output "Signing powershell file [$PowershellToSign] by certificate [$($Cert.Thumbprint)]."
Set-AuthenticodeSignature -FilePath "$PowershellToSign" -Certificate $Cert | Out-Null
# MHE: The timestamp-server-parameter works only for public certificates, trusted by CA. If C&P decides to use a public certificate, we could also add timestamping here:
# Set-AuthenticodeSignature -FilePath "$PowershellToSign" -Certificate $Cert -TimestampServer "http://timestamp.acs.microsoft.com" | Out-Null
#>

# Verify that the file was signed and what is its status
$VerificationResult = Get-AuthenticodeSignature -FilePath "$PowershellToSign"
Write-Output "Powershell [$($VerificationResult.Path)] signing status: $($VerificationResult.Status)"