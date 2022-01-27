param(
	[String]$appVeyorApiToken = "yjy40es2t83sr4mcxpa7",
	[String]$commitID)
$ErrorActionPreference = "Stop"

# Ensure commitId is known
if (-not $commitID) { $commitID = git rev-parse HEAD }
#$commitID

# clean bin
$binPath = "$PSScriptRoot\bin"
if (!(test-path $binPath)) { New-Item -ItemType Directory -Force -Path $binPath | Out-Null }
if (test-path $binPath) { remove-item "$binPath\*" -Recurse -Force }

# Fetch available builds
# Setup
$appVeyorApi = 'https://ci.appveyor.com/api'
$headers = @{}
$headers['Authorization'] = "Bearer $appVeyorApiToken"
$headers['Content-type'] = 'application/json'
# Collect last 100 builds
$history = Invoke-RestMethod -Uri "$appVeyorApi/projects/s_grottel/nuget-lua/history?recordsNumber=100" -Headers $headers -Method Get
# Find build for this commit
$builds = $history.builds | Where-Object -Property 'status' -eq -value 'success' | Where-Object -Property 'commitId' -eq -Value $commitID
$buildversion = $builds[0].version
# request build details
$build = Invoke-RestMethod -Uri "$appVeyorApi/projects/s_grottel/nuget-lua/build/$buildversion" -Headers $headers -Method Get
$jobs = $build.build.jobs | Where-Object -Property 'status' -eq -value 'success'
$artCnt = 0
$jobs | foreach {
	Write-Host "Downloading: $($_.name)"
	Write-Host "[$($_.jobId)]"
	$jobId = $_.jobId
	$artifacts = Invoke-RestMethod -Method Get -Uri "$appVeyorApi/buildjobs/$jobId/artifacts" -Headers $headers
	$artifacts | Select-Object -ExpandProperty 'fileName' | foreach {
		Write-Host "`t$_"
		$localPath = "$PSScriptRoot\$_"
		$localDir = [System.IO.Path]::GetDirectoryName($localPath)
		if (!(test-path $localDir)) { New-Item -ItemType Directory -Force -Path $localDir | Out-Null }
		Invoke-RestMethod -Method Get -Uri "$appVeyorApi/buildjobs/$jobId/artifacts/$_" `
			-OutFile $localPath -Headers @{ "Authorization" = "Bearer $appVeyorApiToken" }
		$artCnt++
	}
}

# Done
Write-Host "Downloaded $artCnt artifacts"
