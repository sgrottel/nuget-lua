param(
	[Parameter(Mandatory=$true)][string]$buildVersion
	)
$ErrorActionPreference = "Stop"

Push-Location
try
{
Add-Type -AssemblyName System.Drawing

# Just to be sure where the package is written
cd $PSScriptRoot

# parse version information
$header = gc "$PSScriptRoot/lua/src/lua.h" | Out-String
if (($header -match '(?m)^#define\s+LUA_VERSION_MAJOR\s+"(\d+)"\s*$') -ne $true) { throw "Failed to parse LUA_VERSION_MAJOR" }
$verMajor = $Matches[1]
if (($header -match '(?m)^#define\s+LUA_VERSION_MINOR\s+"(\d+)"\s*$') -ne $true) { throw "Failed to parse LUA_VERSION_MINOR" }
$verMinor = $Matches[1]
if (($header -match '(?m)^#define\s+LUA_VERSION_RELEASE\s+"(\d+)"\s*$') -ne $true) { throw "Failed to parse LUA_VERSION_RELEASE" }
$verPatch = $Matches[1]
$verBuild = $buildVersion

$version = "$verMajor.$verMinor.$verPatch"
if ($verBuild) { $version += ".$verBuild" }

$year = (get-date).Year

# identify latest runtime
$latestRuntime = $false
$runtimes = gci "$PSScriptRoot/bin/x64/v*" | Select-Object -ExpandProperty 'Name' | Sort-Object -Descending -Unique
$latestRuntime = $runtimes[0]

# file convert the logo image
$image = [System.Drawing.Image]::FromFile("$PSScriptRoot/lua/doc/logo.gif")
$image.Save("$PSScriptRoot/bin/logo.png", [System.Drawing.Imaging.ImageFormat]::Png)
$image.Dispose()

# inject runtimes into build scripts
[xml]$propsUi = gc "$PSScriptRoot/Lua-propertiesui.xml"
[System.Xml.XmlNamespaceManager]$ns = $propsUi.NameTable
$ns.AddNamespace("Any", $propsUi.DocumentElement.NamespaceURI)
$runtimesEnum = $propsUi.SelectSingleNode('//Any:EnumProperty[@Name="LuaRuntimePlatform"]', $ns)
$runtimes | foreach {
	$rTag = $runtimesEnum.AppendChild($propsUi.CreateElement('EnumValue', 'clr-namespace:Microsoft.Build.Framework.XamlTypes;assembly=Microsoft.Build.Framework'))
	$rTag.SetAttribute('Name', $_)
	$rTag.SetAttribute('DisplayName', $_)
}
$propsUi.Save("$PSScriptRoot/bin/Lua-propertiesui.xml")

[xml]$targets = gc "$PSScriptRoot/Lua.targets"
[System.Xml.XmlNamespaceManager]$ns = $targets.NameTable
$ns.AddNamespace("Any", $targets.DocumentElement.NamespaceURI)
$dns = "http://schemas.microsoft.com/developer/msbuild/2003"
$rpc = $targets.SelectSingleNode('//Any:Choose[not(*)]', $ns)
$runtimes | foreach {
	$tagCase = $rpc.AppendChild($targets.CreateElement('When', $dns))
	$tagCase.SetAttribute('Condition', '''$(PlatformToolset)'' == ' + "'$_'")
	$tagPG = $tagCase.AppendChild($targets.CreateElement('PropertyGroup', $dns))
	$tagPG.SetAttribute('Condition', '''$(LuaRuntimePlatform)'' == ''''')
	$tagLRP = $tagPG.AppendChild($targets.CreateElement('LuaRuntimePlatform', $dns))
	$tagLRP.InnerText = $_
}
$tagCase = $rpc.AppendChild($targets.CreateElement('Otherwise', $dns))
$tagPG = $tagCase.AppendChild($targets.CreateElement('PropertyGroup', $dns))
$tagPG.SetAttribute('Condition', '''$(LuaRuntimePlatform)'' == ''''')
$tagLRP = $tagPG.AppendChild($targets.CreateElement('LuaRuntimePlatform', $dns))
$tagLRP.InnerText = 'ERROR'

$targets.Save("$PSScriptRoot/bin/Lua.targets")

# create the nuget
$nuspecPath = [System.IO.Path]::Combine($PSScriptRoot, "Lua.nuspec")
& nuget pack $nuspecPath -properties "version=$version;year=$year;latestRuntime=$latestRuntime"
if ($LASTEXITCODE -ne 0) { throw "Failed to create package" }

# done!

}
finally
{
Pop-Location
}
