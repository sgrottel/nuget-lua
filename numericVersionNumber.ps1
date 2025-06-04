Write-Host "Generating 'versioninfo.h'"

Write-Host "Reading Header..."
$header = get-content "$PSScriptRoot/lua/src/lua.h" | Out-String

if (($header -match '(?m)^#define\s+LUA_VERSION_MAJOR\s+"(\d+)"\s*$') -ne $true) { throw "Failed to parse LUA_VERSION_MAJOR" }
$verMajor = $Matches[1]
if (($header -match '(?m)^#define\s+LUA_VERSION_MINOR\s+"(\d+)"\s*$') -ne $true) { throw "Failed to parse LUA_VERSION_MINOR" }
$verMinor = $Matches[1]
if (($header -match '(?m)^#define\s+LUA_VERSION_RELEASE\s+"(\d+)"\s*$') -ne $true) { throw "Failed to parse LUA_VERSION_RELEASE" }
$verPatch = $Matches[1]

Write-Host "Parsed version: $verMajor.$verMinor.$verPatch"

$cnt = ([regex]::Matches($header, "^\s*#define\s+LUA[^\n]+", [System.Text.RegularExpressions.RegexOptions]::Multiline) | Select-Object -ExpandProperty Value | Out-String) + @"

#define VER_VERSION $verMajor, $verMinor, $verPatch
#define VER_VERSION_STR "$verMajor.$verMinor.$verPatch"
"@

Write-Host "Writing: '$PSScriptRoot/versioninfo.h'"
set-content -Path "$PSScriptRoot/versioninfo.h" -Value $cnt

Write-Host "Done."
