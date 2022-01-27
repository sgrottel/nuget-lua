# Lua Nuget #

This repository contains all files and information to create a NuGet package from the source code of Lua.

For problems with the library itself contact the authors:

* https://www.lua.org/

For problems with the NuGet package contact SGrottel:

* https://go.grottel.net/nuget-project/lua  (takes you here)
* https://go.grottel.net/nuget/lua
* https://www.sgrottel.de


## Lua ##

[Lua](https://www.lua.org/) is a powerful, fast, lightweight, embeddable scripting language.

Lua combines simple procedural syntax with powerful data description constructs based on associative arrays and extensible semantics.
Lua is dynamically typed, runs by interpreting bytecode for a register-based virtual machine, and has automatic memory management with incremental garbage collection, making it ideal for configuration, scripting, and rapid prototyping.

Lua is free open-source software, distributed under a [very liberal license](https://www.lua.org/license.html) (the well-known MIT license).

Project Website: https://www.lua.org/


# Update Lua #

Build status master:
[![Build status](https://ci.appveyor.com/api/projects/status/9qn16byb2a15kd5u/branch/master?svg=true)](https://ci.appveyor.com/project/s_grottel/lua/branch/master)

Build status latest:
[![Build status](https://ci.appveyor.com/api/projects/status/9qn16byb2a15kd5u?svg=true)](https://ci.appveyor.com/project/s_grottel/lua)

## Update the source ##

* Download the newest Lua code and replace the content in the `lua` subdirectory.
* Update the source file list in the Visual Studio Project based on the updated lua documentation.
* If files were added or removed, especially public header files, you might need to adjust `lua.nuspec` and `lua.targets`.

## Solution ##

Before you commit an update, do successfully build all projects in all configurations locally in a modern Visual Studio.


# Building the NuGet Package #

## Building binaries ##

All binary variants for the nuget package will be built in the cloud using AppVeyor:

https://ci.appveyor.com/project/s_grottel/lua

The build is controlled by the the checked in file: `appveyor.yml`

Make sure all binaries have been successfully built by AppVeyor before proceeding.

## Collecting Artifacts ##

Run `./collectArtifacts.ps1`

This will download the binary artifacts for exactly this commit from AppVeyor, if available.
Those will overwrite the content of your local ```bin``` directory.

The `git` command line client must be available for the script, in order to identify the code commit hash.

## Build nuget ##

Run `./makeNuget.ps1 <build-number>`

You need to specify the `<build-number>`. This will be used as fourth number in the version number.

