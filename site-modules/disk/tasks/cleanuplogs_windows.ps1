[CmdletBinding()]
Param(
  [String] $days = 7
)

Write-Host "Cleaning up logfiles older than $days days..."
Write-Host "Done!"