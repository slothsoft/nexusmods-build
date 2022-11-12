# ------------------------------------------------------
# Build a Stardew Valley Mod from its Project Folder
#
# You need to do this before starting this script:
# - dotnet publish -c Release
# ------------------------------------------------------

$projectFolder=$args[0]
$htmlRefinerScript=$args[1]
$clearTargetFolder=$args[2]
if ($args[2] -eq $null) {
    $clearTargetFolder = 0
}

# Read manifest.json file into a dictionary so we can access various information
$manifestFile="$projectFolder\manifest.json"
$manifestFileContent = [string]::Join("`n", (gc $manifestFile -encoding utf8))
$manifest = @{}
(ConvertFrom-Json $manifestFileContent).psobject.properties | Foreach { $manifest[$_.Name] = $_.Value }

# Clear the target folder
$targetFolder= "$projectFolder\..\bin"
if (!($clearTargetFolder -eq 0)) { 
    if (Test-Path -Path $targetFolder) {
        Remove-Item $targetFolder -Recurse
    }
    if (-Not (Test-Path -Path $targetFolder)) {
        New-Item -Path $targetFolder -ItemType Directory | Out-Null
    }
}

# Create a folder that contains everything that should be in the ZIP
$zipFolder="$targetFolder\ReleaseZip"
New-Item -Path $zipFolder -ItemType Directory | Out-Null
$outputFolder= "$zipFolder\" + $manifest["Name"]
New-Item -Path $outputFolder -ItemType Directory | Out-Null
$outputFolder= resolve-path $outputFolder

# Now copy everything in the ZIP  folder
$publishFolder = "$projectFolder\bin\Release\net5.0\publish"
$dll = $publishFolder + "\" + $manifest["EntryDll"]
$pdb = $publishFolder + "\" + ($manifest["EntryDll"] -replace '.dll','.pdb')

Copy-Item $dll -Destination $outputFolder
Copy-Item $pdb -Destination $outputFolder
Copy-Item $manifestFile -Destination $outputFolder
if (Test-Path -Path "$projectFolder\assets\") {
    Copy-Item "$projectFolder\assets\" -Destination "$outputFolder\assets\" -Recurse
}
if (Test-Path -Path "$projectFolder\i18n\") {
    Copy-Item "$projectFolder\i18n\" -Destination "$outputFolder\i18n\" -Recurse
}
Copy-Item "$projectFolder\..\LICENSE" -Destination "$outputFolder\LICENSE"

# Make a HTML file out of the README
$readmeFile = resolve-path $projectFolder\..\README.md
$outputReadmeFile = "$outputFolder\Readme.html"
$title = $manifest["Author"] + " " + $manifest["Name"]
pandoc $readmeFile -f markdown -t html -s -o $outputReadmeFile --metadata title=$title

# Replace the image and other URLs of the HTML
$html = [string]::Join("`n", (gc $outputReadmeFile -encoding utf8))
$repositoryBase=$manifest["UpdateKeys"][1] -replace "Github:","https://github.com/"
$imageBase = "$repositoryBase/raw/main"
$html = $html -replace 'src="\./',"src=""$imageBase/"
$linkBase = "$repositoryBase/blob/main"
$html = $html -replace 'href="\./',"href=""$linkBase/"
$html| Out-File -encoding utf8 $outputReadmeFile

# Now ZIP the entire folder
$zipFile = $targetFolder + "\" + $manifest["Name"] + "-" + $manifest["Version"] + ".zip"
& "C:\Program Files\7-Zip\7z.exe" a $zipFile $zipFolder\*
Remove-Item $zipFolder -Recurse
Write-Host "Create ZIP file: $zipFile"

# Create Readme Files for Nexus
& "$PSScriptRoot\markdown2plaintext.ps1" $readmeFile "$targetFolder\Readme.txt" $repositoryBase
$readmeFolder = "$projectFolder\..\readme"
$htmlFile = "$readmeFolder\readme.html"
& "$PSScriptRoot\markdown2html.ps1" $readmeFile $htmlFile
if ($htmlRefinerScript) {
    # if this argument exist, use it to modify the HTML
    & "$htmlRefinerScript" $htmlFile $readmeFolder\readme-refined.html
    $htmlFile = "$readmeFolder\readme-refined.html"
}
& "$PSScriptRoot\html2bbcode.ps1" $htmlFile $readmeFolder\bbcode.txt $repositoryBase

# Replace the Versions Table with a Nice List
. "$PSScriptRoot\bbcode-readme-functions.ps1" 
ReplaceVersionsTable -inputFile $readmeFolder\bbcode.txt -sectionName 'Translator Guide'

# Clean up
Remove-Item "$readmeFolder\readme.html"
if (Test-Path -Path $htmlFile) {
    Remove-Item $htmlFile
}
Copy-Item $readmeFolder\bbcode.txt -Destination "$targetFolder\BBCode.txt"



