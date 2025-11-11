<#
.SYNOPSIS  
	Takes a specified certificate pfx file and imports it to certificate store "Trusted Root Certification Authorities" and "Trusted Publishers" using a pfx password.
	https://learn.microsoft.com/en-us/powershell/module/pki/import-pfxcertificate?view=windowsserver2025-ps
.NOTES  
	Author: someone@cpgmbh.de
#>

$RootDirectory = ".\" | Resolve-Path
$PfxPath = "$RootDirectory\Signing\cp_selfsigned_pfx.pfx"
$PfxPassword = "123"
$TargetCertStoreLocations = @("Cert:\LocalMachine\Root","Cert:\LocalMachine\TrustedPublisher")

# Some basic validation
if($PfxPassword -eq "") {
	Write-Error "No password was provided for importing the certificate!"
	Exit 1
}

if($PfxPath -eq "") {
	Write-Error "No value for a pfx file was specified!"
	Exit 1
}

if(!($PfxPath.EndsWith(".pfx"))) {
	Write-Error "Specified pfx file [$PfxPath] does not have an expected pfx file ending."
	Exit 1	
}

if(!(Test-Path $PfxPath)) {
	Write-Error "Specified pfx file [$PfxPath] does not exist, please verify and try again."
	Exit 1	
}

# Install the certificate
$SecurePwd = ConvertTo-SecureString -String $PfxPassword -Force -AsPlainText

$i = 1
$Count = $TargetCertStoreLocations.Count

Write-Output "Installing certificate from path [$PfxPath].."
foreach($CertStore in $TargetCertStoreLocations) {
	Write-Output "$i/$Count Importing to cert store at [$CertStore]."
	Import-PfxCertificate -FilePath $PfxPath -CertStoreLocation $CertStore -Password $SecurePwd | Out-Null
	$i = $i + 1
}

# Validate after the installation of the certificate
$i = 1
Write-Output "Verifying certificates after installation.."
foreach($CertStore in $TargetCertStoreLocations) {
	$Response = @( Get-ChildItem -path $CertStore | Where-Object {$_.Subject -match $PfxSubjectName} )
	$ResponseCount = $Response.Count
	if($ResponseCount -eq 1)
	{
		Write-Output "$i/$Count Success, certificate with subject common name [$PfxSubjectName] could be found in cert store [$CertStore]."
	}
	elseif($ResponseCount -gt 1)
	{
		Write-Warning "$i/$Count There are multiple certificates with subject common name [$PfxSubjectName]. Please investigate as it should only be one."
	}
	elseif($ResponseCount -lt 1)
	{
		Write-Warning "$i/$Count There was an error installing the certificate to cert store [$CertStore], please investigate."
	}
	$i = $i + 1
}