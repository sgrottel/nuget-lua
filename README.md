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

## Update Lua ##

* Download the newest Lua code and replace the content in the `lua` subdirectory.
* Update the source file list in the Visual Studio Project based on the updated lua documentation.
* Update `lua.autopkg` commands for packing `include` and `doc`umentation files based on the updated lua documentation.
* Also update meta data like version number

Most likely this is all there is.

## Building the NuGet Package ##

* Use the Visual Studio Solution to build the Dlls for all desired (and installed) platform toolsets
* Edit `lua.autopkg` to reflect your built binaries

Install CoApp Tools: http://coapp.org/

* http://coapp.org/tutorials/installation.html
* http://coapp.org/tutorials/building-a-package.html

Navigate your Powershell to the repository.

Run: `Write-NuGetPackage .\lua.autopkg`
