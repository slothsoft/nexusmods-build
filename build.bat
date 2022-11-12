@echo off

Rem -------------------------------------------------
Rem Simple Example
Rem -------------------------------------------------

set inputFolder=%cd%\examples\simple
set outputFolder=%inputFolder%\result
CALL :ClearFolder %outputFolder%

powershell -ExecutionPolicy Bypass -File %cd%/scripts/markdown2plaintext.ps1 %inputFolder%\README.md %outputFolder%\readme.txt https://github.com/slothsoft/nexusmods-build /examples/simple
echo Created file %outputFolder%\readme.txt

powershell -ExecutionPolicy Bypass -File %cd%/scripts/markdown2html.ps1 %inputFolder%\README.md %outputFolder%\readme.html
powershell -ExecutionPolicy Bypass -File %cd%/scripts/html2bbcode.ps1 %outputFolder%\readme.html %outputFolder%\readme-bbcode.txt https://github.com/slothsoft/nexusmods-build /examples/simple
echo Created file %outputFolder%\readme-bbcode.txt

EXIT /B %ERRORLEVEL%

Rem -------------------------------------------------
Rem Delete and re-create folder to clear all old data
Rem -------------------------------------------------
:ClearFolder
set folder=%~1
if exist "%folder%" rmdir /s /q "%folder%"
if not exist "%folder%" mkdir "%folder%"
EXIT /B 0