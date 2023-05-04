Have one Nuget placed in the parent directory.

Run `prepareProject.ps1`

Open solution and build all projects.

Test run after build:
gci -recurse TestNuget.exe | foreach { & $_ }
