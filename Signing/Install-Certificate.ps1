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
# SIG # Begin signature block
# MIIJagYJKoZIhvcNAQcCoIIJWzCCCVcCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU/TPdJ3dlaAlrK84ttpfv8z5C
# pKqgggWwMIIFrDCCA5SgAwIBAgIQHmEdrQY2JrBLRRbmucsi5zANBgkqhkiG9w0B
# AQsFADBuMSAwHgYJKoZIhvcNAQkBFhFub3JlcGx5QGNwZ21iaC5kZTELMAkGA1UE
# BhMCREUxDjAMBgNVBAsMBUF0bGFzMREwDwYDVQQKDAhDJlAgR21iSDEaMBgGA1UE
# AwwRY3BnbWJoLnNlbGZzaWduZWQwHhcNMjUxMTA1MDcxOTU3WhcNMzAxMTA1MDcy
# OTU3WjBuMSAwHgYJKoZIhvcNAQkBFhFub3JlcGx5QGNwZ21iaC5kZTELMAkGA1UE
# BhMCREUxDjAMBgNVBAsMBUF0bGFzMREwDwYDVQQKDAhDJlAgR21iSDEaMBgGA1UE
# AwwRY3BnbWJoLnNlbGZzaWduZWQwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIK
# AoICAQCyooiTtvohJ8Fe9ZejM7yUkg8/3tvOpxqfspZZEpq713g7M1ZOfidw+QZM
# N2WZe8iO4FfbRurv8Iun4pAhvmkFYKr+dbGV06oEPa1UmhTJBI6WKqpoiJThYlqo
# 8eDAupq97q9sDId5VqF0UQB6nhxH9TMUSpX9AJ6NyeNeDc7prdKOmMXCx1DEuWFu
# c/F0ztPkH/uegf+sMSMnMQTFma5h5bg02jjUUH0c7DmeLHJLq5RHTQXyUyCZyZz8
# pBy2pI7xYxZ+5Dz+kIW9cveHXJuKzrm/HKhsU7ZCQ17+NIrR5NtDIbXiDFckgbtb
# 6t7pio/OjOeTcZT/2AF3X3iXGWdxAVVpbR0Ec+B1DK0ZmdtUi+rmZfFSIn1s9UpN
# V+/ztbrOhiQc71BYliMi2EZTqt9FsS5u8+/xDnL7I6tHW4cgY08xTBox5L1r2k5N
# 7kKM7K0QEQmVPQJUVdxnV67sREA1vJZVr8ys3dMTb5rICHIXWtmB903zH1+fl3q5
# GP0CUDe7GOSXJrRAulS3xaNMYnaTHg8SxnkisSgDKsv1rs90YBRoXtXkljCsubpZ
# 4p/iTJFN2gSIdJsUNjbPq3YJ1AQSBNHSTMOGLUMY7CdVEnV0GWGsqTcytagAuilt
# U89JD4OsQWuhiYAfYPMhsvB2G4UMueuuvGCvCOl7izUP51yYYQIDAQABo0YwRDAO
# BgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwHQYDVR0OBBYEFMtZ
# wfekKQjTD2HBxfPjiT/vtGJRMA0GCSqGSIb3DQEBCwUAA4ICAQAbp0/hwWzvp11H
# 0jsjDdBwq68pTT+mHWV22GXqdDY7fKqVnSgxQ8t1ombxQt0PRnlHzhXDg7e7/+Rm
# 14vzCVXaFtSfxuVxaZQuN15yltaAq1S27RvVhXCfpDYxB0RZJHu9XEkNJ3y4ZwJo
# hWPevsXh4X3mobkIXbYNkHEU3J7fKKSosyUAKMsaaMF8/BlkQnmOBoC7NnWLZzGp
# 6dCROlboeFkgrL3eLO0p3QjmWLtXBXCfoDZ41YG8gS2ISCIylYjdyDZnq+dMg6XX
# fmf9jJr+tdnIftXWT0ajPS25b3ZYkVdaF+NFUY413+4jVqW3g4NQHBqq4BQU01mv
# Npk0ji8MB7RkVZ1h+f4khFn32QWIPfY+l3jV5bnDVXe7IyzoOjqq25kRa9m0SSHB
# U8TGh/fhZL85kWzUfNkPygqLxfmzIhLWPSf9OoCVI0+jRqBjD5A8aGhYIIZPv5EL
# psP4qlkcEBFF9vtz98cqBvW6J4uDrIEe3wOL7FINLNyWCKMphmZhbsrs+NaHifvx
# 9l0DWxq4BxIPl/FZROLnjE7Fb7Pg4loD+A8VxRsIUSakUTO+PbMZ2bquHKvVFUP6
# v7iy1qbIRF1d1DwSRqgoxNUPK0gbAzTg8UMTwSX8eynLuqLaVoqIY7/SRb4q5mbl
# X5pLvSXaE9KhF30CCH2L/J00i6r4KTGCAyQwggMgAgEBMIGCMG4xIDAeBgkqhkiG
# 9w0BCQEWEW5vcmVwbHlAY3BnbWJoLmRlMQswCQYDVQQGEwJERTEOMAwGA1UECwwF
# QXRsYXMxETAPBgNVBAoMCEMmUCBHbWJIMRowGAYDVQQDDBFjcGdtYmguc2VsZnNp
# Z25lZAIQHmEdrQY2JrBLRRbmucsi5zAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIB
# DDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEE
# AYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUUYwLjtPk0SjX
# CqMqcXGdc54BHK4wDQYJKoZIhvcNAQEBBQAEggIAktBADhI8lYNE/vpp/UqY2ez7
# R6Q5Sno85mN0Iv+/YQnk4blylnn9rcXunWmxdWzQ8XRgGwZa843u3pAP95gxeK00
# Yf/4nkE6Us9XYvHd0M3h7uQlfwSXoknSqXvtmFuoN3aROh5KY0z+chQsim1+xf3q
# ZXvYs8DzRGhX5bQGRctRGPYLc9486SneFxanrS/L+k2I3kiJg/fuKNKqI8UnvU+p
# WUbHTe7J7As5bSx2DPLI4+RV47Kf/aFsXEElVUj3jea0wBVS9gsdNCFdkEA+uScF
# WpLnV6qhb6cIy27/MAA+zxBYvpNLXctUYh45X6ghlFxyqhRUV3AGF7tlZSxU13aw
# B2pW27O6BoBl/FAzen9RPrXqpDQgVljUnaY1aBzEn5f1l0aIkEP8YIHCP4XjuNz6
# mA5Qq2GutybiOsjauVymKYizxn0YY1ASUNLO9lbUsAHqAdL5VxFMcbmR2BU3Sfm5
# pcdZNNrixTGqaYNW8hQxawI0rINgRAsjZZmNMlo/nww1QGIbHmUBpcny0M5TRsLI
# RNi1nVO3YuxJwe0XmBqqGkLQl1BroSI2h5QQYw+TsKjxmHEx1t6kYLT3T0h/R4UX
# +OyH9AzCk5XHcCqwfvJWFmHax9j39qEIwUqYu3Y+73roM6ay7o0e4JhvgHwCk2Xr
# o4TbicSmqCtdcqxjIbI=
# SIG # End signature block
