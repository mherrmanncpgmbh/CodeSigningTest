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
# SIG # Begin signature block
# MIIJagYJKoZIhvcNAQcCoIIJWzCCCVcCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUDAw9+hB0E4kWT8OValt41u36
# gpWgggWwMIIFrDCCA5SgAwIBAgIQHmEdrQY2JrBLRRbmucsi5zANBgkqhkiG9w0B
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
# AYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUuWdIu8enOtPN
# FfZyewm3qz/j8YowDQYJKoZIhvcNAQEBBQAEggIAju2/oqDOaVzbh0MXoGwNjQnV
# Xwpzb5CpNpqjKT2nwGhdyc4xFaXr/5e8kvr4TodYfdctwACeM0N4ij5MtbF8pSRs
# pTiPoznsMpEN30XEOrXoZG230qH4pH77CnSsn1cvU+AA4CajoJ56puAm4jSVp18L
# OhgegpguR0vfQhfX5GuHBpFpl4Mvsj7WYFZtMyr5wZYcVLHGVw/NRsfXJi2K5dIw
# giirfCBXzxcJn5F53FOC5L+482v57zSZwFlCEhLraIbqPUVljGuMoDj16d4qRqs1
# 1LNSmretaXPhPhr3+jdeiRZ5p/X4mnqk4glq0+n972DrptFirKSNvWsMPReIM3tV
# DDtvyYf+kP2uZ5DdSI2ga7Eqg4OxM2uE6gAWgy07GQ7zOkBATA/RPoMDIbi5VYOH
# 8z7PPb1mE22/HKXKZN8HdNDTX75xJ0l8n2oYqhKdqmFBzm93W9Z5KYz0On9/Sgde
# ugJf3CIPzBjehNJ1Lemqmfe4AOKZ3QHJkzDwrS7+8G5sC4sW/ii5T3xWa8Xnetuh
# qbpGGco/CpJoPrkQEh140YM9FuQt/e9uXqiP1nb3RvfD4s53BM/xbuZLPP71C2f+
# RMQ7k4Nx0SX4/rZBMzmY1I8t99CYNKmXouTrqzTBws6OYFOXMYtRYwk7kXoS7MDz
# 1KBYc0O9mryrDkNONYY=
# SIG # End signature block
