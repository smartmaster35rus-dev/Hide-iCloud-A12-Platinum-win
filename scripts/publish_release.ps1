param(
    [Parameter(Mandatory = $true)]
    [string]$Version,
    [string]$NotesFile = ""
)

$ErrorActionPreference = "Stop"
$repo = "smartmaster35rus-dev/Hide-iCloud-A12-Platinum-win"
$tag = if ($Version -match '^v') { $Version } else { "v$Version" }
$ver = $tag -replace '^v', ''

if (-not $NotesFile) {
    $candidate = "RELEASE_$ver.md"
    if (Test-Path -LiteralPath $candidate) {
        $NotesFile = $candidate
    }
}

$dist = Join-Path (Get-Location) "dist"
$portable = Join-Path $dist "hide_icloud_open_menu_a12_platinum_$ver.exe"
$setup = Join-Path $dist "hide_icloud_open_menu_a12_platinum_setup.exe"

$assets = @()
if (Test-Path -LiteralPath $portable) { $assets += $portable }
if (Test-Path -LiteralPath $setup) { $assets += $setup }
if (-not $assets) {
    throw "No build artifacts in dist\ for version $ver. Run nutika_build.bat first."
}

$title = "Hide iCloud Open menu A12+ Platinum $tag"
$args = @("release", "create", $tag, "--repo", $repo, "--title", $title)
if ($NotesFile -and (Test-Path -LiteralPath $NotesFile)) {
    $args += @("--notes-file", $NotesFile)
} else {
    $args += @("--generate-notes")
}
$args += $assets

Write-Host ("Publishing: gh " + ($args -join ' '))
& gh @args
Write-Host "Done: https://github.com/$repo/releases/tag/$tag"
