$toolset = 'v142'
$winTarget = '10.0'
$img = $env:APPVEYOR_BUILD_WORKER_IMAGE
if ($img -Match 'visual studio') {
	if ($img -Match '2013') {
		$toolset = 'v120'
		$winTarget = '10.0'
	}
	if ($img -Match '2015') {
		$toolset = 'v140'
		$winTarget = ''
	}
	if ($img -Match '2017') {
		$toolset = 'v141'
		$winTarget = ''
	}
	if ($img -Match '2019') {
		$toolset = 'v142'
		$winTarget = '10.0'
	}
	if ($img -Match '2022') {
		$toolset = 'v143'
		$winTarget = '10.0'
	}
}
#$toolset

gci -r '*.vcxproj' | foreach {
	$proj = [xml](Get-Content $_)
	[System.Xml.XmlNamespaceManager]$ns = $proj.NameTable
	$ns.AddNamespace("Any", $proj.DocumentElement.NamespaceURI)
	$proj.SelectNodes("//Any:PlatformToolset", $ns) | foreach { $_.InnerText = $toolset }
	$proj.SelectNodes("//Any:WindowsTargetPlatformVersion", $ns) | foreach { $_.InnerText = $winTarget }
	$proj.save($_)
}
