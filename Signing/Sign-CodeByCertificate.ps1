<#
.SYNOPSIS  
	Signs a specified powershell script by a specified PFX file.
    https://learn.microsoft.com/en-us/powershell/module/pki/export-pfxcertificate?view=windowsserver2025-ps
.NOTES  
	Author: someone@cpgmbh.de
#>

$RootDirectory = ".\" | Resolve-Path
$PfxPath = "$RootDirectory\Signing\cp_selfsigned_pfx.pfx"
$PfxPassword = ${env:PFXPASSWORD} # This is specified via a pipeline variable in Azure DevOps

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

if($SignCounter -gt 0) {
	Write-Output "A total of [$SignCounter] files have been signed."
}
else {
	Write-Output "No files have been signed. This typically means that all files are already in a signed and valid state."
}

# SIG # Begin signature block
# MIIJagYJKoZIhvcNAQcCoIIJWzCCCVcCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUWQeavKXs95GJiUV/tJI5SQp+
# G16gggWwMIIFrDCCA5SgAwIBAgIQHmEdrQY2JrBLRRbmucsi5zANBgkqhkiG9w0B
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
# AYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUWjVIKE9q8PuP
# K/RWim4utL52XE8wDQYJKoZIhvcNAQEBBQAEggIAT0YvrAetwSxsPLNRk8P+V2OI
# d0dbA6lenwRj3EebeQ+62DZPxIh4BCJrOnoh5kpxetmfHB/cyGpvW8ykR4G2b6HO
# AhAKhaxS4pn9nkEx0S8Pr1QN+uwYP2E0uU4AzvwRTIGEIEOCI87ExUl4qcS9XR/c
# ZAvarnFZAvKwWWjyGH7PXTx/KT38Y6CPdYqUioSStBS8NGT86Ho8RVK9dLNDkqGl
# NZreNszrAFNNif21ICoy5513UhT2u6Zv/r6OHVTdlFV1hYKAlUCzyhikgr8qLlSG
# CC0Eiqn9RZYjJ0iYm83GLzSCxrjxXDuVcnCFl3wc+dbiG7iSSzYDae7+T9knXmwu
# B/OVn50pSEnDnUv7wZJ6pvZAgPyPbD3gj1Vxga9P+LIZJ9AT44Pk0uqIyUGWA2/N
# HHVJcr5f3neiljvJ8eqw66AyiDV7LLmBGzinZDql6991nhxhxA8xgfo548L7/PhK
# skzW/8zn9xEq8SLGbR8fWRteM40x9oifNwj8NAWbBS4utWTtiiA9oGc4ENcQKbyB
# K96+pycssaUMXk9VofUrD6rnDWIEoR06W6HA3dQ4SLXVl8scVZDH7RRpSpQ7IRzL
# 2pNs1NjHVmTCyPdvin2VK6CanytEs3qWNA4ikLLv65Ddkyg7P6sqm4A8DHckhbi1
# RB/UQM+vNhRtv0T6NYo=
# SIG # End signature block
