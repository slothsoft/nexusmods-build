# ------------------------------------------------------
# Replace the Versions table with a list (because
# NexusMods cannot display tables).
# ------------------------------------------------------

function ReplaceVersionsTable {
    Param ([string]$inputFile, [string]$outputFile)

    $bbcode = [string]::Join("`n", (gc $inputFile -encoding utf8))

    if (!$outputFile) { $outputFile = $inputFile }
    $bbcode| Out-File -encoding utf8 $outputFile
}