# Lua Nuget

This repository contains all files and information to create a [NuGet package](https://www.nuget.org/packages/lua/) from the source code of [Lua](https://www.lua.org/).

[![MSBuild](https://github.com/sgrottel/nuget-lua/actions/workflows/build.yml/badge.svg)](https://github.com/sgrottel/nuget-lua/actions/workflows/build.yml)
![MIT LICENSE](https://img.shields.io/github/license/sgrottel/nuget-lua)
![Nuget](https://img.shields.io/nuget/v/lua)

For problems with the library itself contact the authors:

* https://www.lua.org/

For problems with the NuGet package contact SGrottel:

* https://www.nuget.org/packages/lua/
* https://go.grottel.net/nuget-project/lua  (takes you here)
* https://go.grottel.net/nuget/lua
* https://www.sgrottel.de


## Lua

[Lua](https://www.lua.org/) is a powerful, fast, lightweight, embeddable scripting language.

Lua combines simple procedural syntax with powerful data description constructs based on associative arrays and extensible semantics.
Lua is dynamically typed, runs by interpreting bytecode for a register-based virtual machine, and has automatic memory management with incremental garbage collection, making it ideal for configuration, scripting, and rapid prototyping.

Lua is free open-source software, distributed under a [very liberal license](https://www.lua.org/license.html) (the well-known MIT license).

Project Website: https://www.lua.org/

## How To: Update Lua

* Download the newest Lua code and replace the content in the `lua` subdirectory.
* Update the source file list in the Visual Studio Project based on the updated lua documentation.
* If files were added or removed, especially public header files, you might need to adjust `lua.nuspec` and `lua.targets`.

## How To: Build

* Everything is built from `lua.sln` with Visual Studio
* Adjust the project to the different `Toolset` versions. You might also need to adjust the target platform versions to select the correct Windows SDK.
* Build all projects. Those will populate different subdirectories in `bin` directory.
* As soon as you got all flavors built, run `makeNuget.ps1`. Specify `0` as build number, to show that the package is not created by CI.

## How To: Test

TODO

## License
Lua is freely available under the terms of the [MIT open source license](https://www.lua.org/license.html).

The additional code to produce the Lua NuGet package is freely available under the terms of the [MIT open source license](./LICENSE).
