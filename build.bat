@echo off
setlocal

rem if run as administrator the working directory is "C:\WINDOWS\system32"
rem using popd to switch to the bat file's directory
pushd "%~dp0"

rem the build script to run
set "bdb_BuildScript=build.xml"

rem name of temporary log file
set "bdb_BuildLog=Build.Log.txt"

rem the log file will be renamed
rem depending on if the build succeeds or fails
set "bdb_SuccessLog=Success.Log.txt"
set "bdb_ErrorLog=Error.Log.txt"

rem delete old log files
call:TryDelete "%bdb_BuildLog%"
call:TryDelete "%bdb_SuccessLog%"
call:TryDelete "%bdb_ErrorLog%"

rem search for a valid path to MSBuild
call:FindMSBuild bdb_MSBuild

rem echo the command so it shows up in the console
echo "%bdb_MSBuild%" "%bdb_BuildScript%" /fl /flp:"LogFile=%bdb_BuildLog%"

rem run the build command
"%bdb_MSBuild%" "%bdb_BuildScript%" /fl /flp:"LogFile=%bdb_BuildLog%"

rem rename the log file based on the build's success or failure
rem makes it easy to see if a build worked
rem without watching the output in the command window
if %ErrorLevel% neq 0 (
    rename "%bdb_BuildLog%" "%bdb_ErrorLog%"
    echo --- Error: build log saved as "%bdb_ErrorLog%" ---
) else (
    rename "%bdb_BuildLog%" "%bdb_SuccessLog%"
    echo --- Success: build log saved as "%bdb_SuccessLog%" ---
)

rem restore the original working directory 
popd

endlocal
goto:eof

:TryDelete
    setlocal
    if exist "%~1" (del "%~1")
    endlocal
goto:eof

:FindMSBuild
    setlocal
    rem - a list of all the currently known msbuild locations
    rem - this list will need to be extended as new versions of msbuild are released
    rem - rules for picking the msbuild version:
    rem -   1. prefer newer version to older version
    rem -   2. prefer "ProgramFiles(x86)" to "ProgramFiles" (msbuild on x86 windows?)
    rem -   3. prefer x86 to x64 version of msbuild
    rem -   4. prefer BuildTools version to Visual Studio Version
    rem -   5. prefer "Bigger" Visual Studio version (Enterprise, Professional, Community?)
    rem - known paths are listed from least preferred to most preferred
    rem - and bdb_MSBuildPath will be set to the last valid path

    REM If on an x64 system, MSBuild is installed in ProgramFiles(x86)
    REM If on an x86 system, MSBuild is installed in ProgramFiles
    set "bdb_pFiles=%ProgramFiles(x86)%"
    if "%bdb_pFiles%" equ "" (
        set "bdb_pFiles=%ProgramFiles%"
    )

    call:SetMsBuild bdb_MsBuildPath "%WinDir%\Microsoft.NET\Framework64\v2.0.50727"
    call:SetMsBuild bdb_MsBuildPath "%WinDir%\Microsoft.NET\Framework\v2.0.50727"
    call:SetMsBuild bdb_MsBuildPath "%WinDir%\Microsoft.NET\Framework64\v3.5"
    call:SetMsBuild bdb_MsBuildPath "%WinDir%\Microsoft.NET\Framework\v3.5"
    call:SetMsBuild bdb_MsBuildPath "%WinDir%\Microsoft.NET\Framework64\v4.0.30319"
    call:SetMsBuild bdb_MsBuildPath "%WinDir%\Microsoft.NET\Framework\v4.0.30319"
    call:SetMsBuild bdb_MsBuildPath "%bdb_pFiles%\MSBuild\12.0\Bin\amd64"
    call:SetMsBuild bdb_MsBuildPath "%bdb_pFiles%\MSBuild\12.0\Bin"
    call:SetMsBuild bdb_MsBuildPath "%bdb_pFiles%\MSBuild\14.0\Bin\amd64"
    call:SetMsBuild bdb_MsBuildPath "%bdb_pFiles%\MSBuild\14.0\Bin"
    call:SetMsBuild bdb_MsBuildPath "%bdb_pFiles%\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\Bin\amd64"
    call:SetMsBuild bdb_MsBuildPath "%bdb_pFiles%\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\Bin"
    call:SetMsBuild bdb_MsBuildPath "%bdb_pFiles%\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin\amd64"
    call:SetMsBuild bdb_MsBuildPath "%bdb_pFiles%\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin"
    call:SetMsBuild bdb_MsBuildPath "%bdb_pFiles%\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin\amd64"
    call:SetMsBuild bdb_MsBuildPath "%bdb_pFiles%\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin"
    call:SetMsBuild bdb_MsBuildPath "%bdb_pFiles%\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\amd64"
    call:SetMsBuild bdb_MsBuildPath "%bdb_pFiles%\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin"
    call:SetMsBuild bdb_MsBuildPath "%bdb_pFiles%\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\amd64"
    call:SetMsBuild bdb_MsBuildPath "%bdb_pFiles%\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin"
    call:SetMsBuild bdb_MsBuildPath "%bdb_pFiles%\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\amd64"
    call:SetMsBuild bdb_MsBuildPath "%bdb_pFiles%\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin"
    call:SetMsBuild bdb_MsBuildPath "%bdb_pFiles%\Microsoft Visual Studio\2019\BuildTools\MSBuild\Current\Bin\amd64"
    call:SetMsBuild bdb_MsBuildPath "%bdb_pFiles%\Microsoft Visual Studio\2019\BuildTools\MSBuild\Current\Bin"

    (
        endlocal
        set "%~1=%bdb_MsBuildPath%"
    )
goto:eof

:SetMsBuild
    setlocal
    if not exist "%~2\MSBuild.exe" (goto:eof)

    (
        endlocal
        if "%~1" neq "" set "%~1=%~2\MSBuild.exe"
    )
goto:eof
