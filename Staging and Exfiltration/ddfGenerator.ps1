# This script was vibe coded with Claude Opus 5.5.
<#
.SYNOPSIS
  Compress a directory (recursively) into a .cab file using makecab.

.EXAMPLE
  .\New-Cab.ps1 -CabFile archive.cab -SourcePath C:\path\to\folder
  .\New-Cab.ps1 D:\backups\docs.cab .\docs
#>
param(
  [Parameter(Mandatory = $true, Position = 0)]
  [string]$CabFile,

  [Parameter(Mandatory = $true, Position = 1)]
  [string]$SourcePath
)

$ErrorActionPreference = 'Stop'

# Resolve the source to a full path with no trailing backslash
$src = (Resolve-Path -LiteralPath $SourcePath).ProviderPath.TrimEnd('\')
if (-not (Test-Path -LiteralPath $src -PathType Container)) {
  throw "Source path '$SourcePath' is not a directory."
}

# Split the cab path into folder + file name (makecab wants them separately)
$cabFull = [System.IO.Path]::GetFullPath(
  [System.IO.Path]::Combine((Get-Location).ProviderPath, $CabFile))
$cabDir  = Split-Path $cabFull -Parent
$cabName = Split-Path $cabFull -Leaf
if (-not (Test-Path -LiteralPath $cabDir)) {
  New-Item -ItemType Directory -Path $cabDir | Out-Null
}

$ddf = @(
  '.OPTION EXPLICIT'
  ".Set CabinetNameTemplate=$cabName"
  ".Set DiskDirectoryTemplate=`"$cabDir`""
  '.Set CompressionType=LZX'
  '.Set MaxDiskSize=0'
  '.Set Cabinet=on'
  '.Set Compress=on'
  '.Set InfFileName=nul'
  '.Set RptFileName=nul'
)

$files = Get-ChildItem -LiteralPath $src -Recurse -File
if (-not $files) { throw "No files found in '$src'." }

foreach ($f in $files) {
  $rel = $f.DirectoryName.Substring($src.Length).TrimStart('\')
  $ddf += ".Set DestinationDir=$rel"
  $ddf += "`"$($f.FullName)`""
}

# Write the directive file to a temp location and clean it up afterwards
$ddfPath = [System.IO.Path]::GetTempFileName()
try {
  $ddf | Set-Content -LiteralPath $ddfPath -Encoding ASCII
  makecab /F $ddfPath
  if ($LASTEXITCODE -ne 0) { throw "makecab failed with exit code $LASTEXITCODE." }
  Write-Host "Created $cabFull ($($files.Count) files)"
}
finally {
  Remove-Item -LiteralPath $ddfPath -ErrorAction SilentlyContinue
}
