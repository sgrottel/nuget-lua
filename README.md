# Lua Nuget #

This repository contains all files and information to create a NuGet package from the source code of Lua.

For problems with the NuGet package contact SGrottel: 

* https://bitbucket.org/sgrottel_nuget/lua/overview
* http://www.sgrottel.de
* http://go.sgrottel.de/nuget/lua

For problems with the library itself contact the authors:

* https://www.lua.org/

## Lua ##

[Lua](https://www.lua.org/) is a powerful, fast, lightweight, embeddable scripting language.

Lua combines simple procedural syntax with powerful data description constructs based on associative arrays and extensible semantics.
Lua is dynamically typed, runs by interpreting bytecode for a register-based virtual machine, and has automatic memory management with incremental garbage collection, making it ideal for configuration, scripting, and rapid prototyping.

Lua is free open-source software, distributed under a [very liberal license](https://www.lua.org/license.html) (the well-known MIT license).

Project Website: https://www.lua.org/


# Update Lua #

[![Build status](https://ci.appveyor.com/api/projects/status/9qn16byb2a15kd5u/branch/master?svg=true)](https://ci.appveyor.com/project/s_grottel/lua/branch/master)

## Update the source ##

* Download the newest Lua code and replace the content in the `lua` subdirectory.
* Update the source file list in the Visual Studio Project based on the updated lua documentation.

## Deprecated ###

* Update `lua.autopkg` commands for packing `include` and `doc`umentation files based on the updated lua documentation.
* Also update meta data like version number

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

## Deprecated ##

* Use the Visual Studio Solution to build the Dlls for all desired (and installed) platform toolsets
* Edit `lua.autopkg` to reflect your built binaries

Install CoApp Tools: http://coapp.org/

* http://coapp.org/tutorials/installation.html
* http://coapp.org/tutorials/building-a-package.html

Navigate your Powershell to the repository.

Run: `Write-NuGetPackage .\lua.autopkg`
