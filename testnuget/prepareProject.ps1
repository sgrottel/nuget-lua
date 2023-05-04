cd $PSScriptRoot
$pkg = gci ../lua.*.nupkg
if (-not (Test-Path $pkg))
{
	Write-Error "No Nuget Package found"
	exit
}
if (-not ($pkg.Name -match "^lua\.([\d\.]+)\.nupkg"))
{
	Write-Error "Nuget Package file name format mismatch"
	exit
}
$version = $matches[1]
Write-Host "Lua nuget package version: $version"

$filename = [System.IO.Path]::Combine($PSScriptRoot, "packages.config")
$xml = [xml](Get-Content $filename)
[System.Xml.XmlNamespaceManager]$ns = $xml.NameTable
$ns.AddNamespace("Any", $proj.DocumentElement.NamespaceURI)
$xml.SelectNodes("/packages/package[@id='lua']", $ns) | foreach { $_.Attributes.Get_ItemOf('version').Value = $version }
$xml.save($filename)

$filename = [System.IO.Path]::Combine($PSScriptRoot, "TestNuget.vcxproj")
$file = [string](Get-Content $filename -raw)
$file = $file -replace "\\lua\.[\d\.]+\\","\lua.$version\"
[System.IO.File]::WriteAllText($filename, $file, (New-Object System.Text.UTF8Encoding $true))
Write-Host "Project files patched"