if not defined DevEnvDir (
	@call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars32.bat"
)	

:: Not building those since visual studio builds arent deterministic (they contain timestamps). 
REM msbuild ..\ThirdParty\NotSoFatso\NotSoFatso.vcxproj /t:Rebuild /p:Configuration=Release /p:Platform="Win32" /p:SolutionDir="%~dp0../" /verbosity:quiet
REM msbuild ..\ThirdParty\NesSndEmu\SndEmu.vcxproj /t:Rebuild /p:Configuration=Release /p:Platform="Win32" /p:SolutionDir="%~dp0../" /verbosity:quiet
REM msbuild ..\ThirdParty\ShineMp3\ShineMp3.vcxproj /t:Rebuild /p:Configuration=Release /p:Platform="Win32" /p:SolutionDir="%~dp0../" /verbosity:quiet

:: Build main app.
msbuild ..\FamiStudio\FamiStudio.csproj /t:Rebuild /p:Configuration=Release /p:Platform="AnyCPU" /p:SolutionDir="%~dp0../" /verbosity:quiet

:: This is needed to build setup project, well know visual studio issue.
cd "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\CommonExtensions\Microsoft\VSI\DisableOutOfProcBuild"
@call DisableOutOfProcBuild.exe

:: Build setup.
cd "%~dp0"
devenv ..\FamiStudio.sln /Project Setup /rebuild Release

:: Until we switch to 64-bit, make the process large addressaware to use up to 3-4GB.
"C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Tools\MSVC\14.29.30133\bin\Hostx64\x86\editbin.exe" /largeaddressaware ..\FamiStudio\bin\Release\FamiStudio.exe

cd "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\CommonExtensions\Microsoft\VSI\DisableOutOfProcBuild"
@call DisableOutOfProcBuild.exe undo

:: Zip and create 3 versions (zipped installer, installer, portable exe)
cd "%~dp0"

set /p Version=<Version.txt

cd Release
tar -a -c -f ..\FamiStudio%Version%-WinInstaller.zip Setup.msi Setup.exe
cd ..

del ..\FamiStudio\bin\Release\FamiStudio.Android.dll
tar -a -c -f FamiStudio%Version%-WinPortableExe.zip "Demo Songs\*.*" portable.txt -C ..\FamiStudio\bin\Release\ *.exe *.dll *.config FamiStudio.pdb
