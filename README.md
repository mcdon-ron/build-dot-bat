# build-dot-bat
**build.bat** is a .bat file that allows developers to run a build script locally with just a double click.

**build.bat** is **not for use on a build server**. A build server will have it's own method of finding MSBuild, and launching a build script. Ideally developers could run the same build script on their local machine.

**build.bat** will check a list of known paths for MSBuild, and use the latest version on the machine. The list of know paths would need to be updated as new versions are released.

### Running the build
- Double click **build.bat** to launch the build.
- Right click **build.bat** and select "Run as Administrator".
  - for projects that must be built using "Run as Administrator"

### The build log
To make it easy to check the overall status of a build, **build.bat** will rename the log file depending on the result. Further details can be found in the build log.

- **Success.Log.txt**
  - The build passed
  - MSBuild return code 0
- **Error.Log.txt**
  - The build failed
  - MSBuild return code not 0

### Setup
- Create your own build script named build.xml
- Copy **build.bat** alongside your build script

### Rules for picking the msbuild version:
1. Prefer newer a version to older versions
2. Prefer %ProgramFiles(x86)% to %ProgramFiles%
   - on x64 Windows MSBuild is installed to %ProgramFiles(x86)%
   - on x86 Windows, MSBuild is installed to %ProgramFiles%
   - older versions are installed to %WinDir%\Microsoft.NET\Framework
3. Prefer x86 to x64 versions of msbuild
4. Prefer BuildTools versions to Visual Studio Versions
5. Prefer "Bigger" Visual Studio versions
   - Enterprise, Professional, Community

### Sample build.xml and Project
The included build script and sample project provide a working example for **build.bat**. The project was made using Visual Studio 2019, and the build probably requires a minimum of installing [Build Tools for Visual Studio 2019](https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2019).

### Resources on Creating Batch Files
- [DosTips.com](https://www.dostips.com/)
- [Rob van der Woude's Scripting Pages](https://www.robvanderwoude.com/batchstart.php)
