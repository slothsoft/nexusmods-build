# ------------------------------------------------------
# Replace the Translation table with a list (because
# NexusMods cannot display tables).
# ------------------------------------------------------

function ReplaceTranslationTable {
    Param ([string]$inputFile, [string]$outputFile, [string]$sectionName)

    $bbcode = [string]::Join("`n", (gc $inputFile -encoding utf8))

    # Fetch the entire table that should be replaced
    $bbcode = $bbcode -replace "(?ms)((.*)`]$sectionName(.*?))table",'$1replaced-table' -replace "(?ms)`/table`](.*)",'/replaced-table]$1'
    $originalTable = $bbcode -replace "(?ms)(.*)`\`[replaced-table`]`n",'' -replace "(?ms)`\`[`/replaced-table(.*)",''
    # Write-Host $originalTable

    $replacedTable = $originalTable
    
    # Before: [tr] [td]CODE[/td] [td]LANGUAGE[/td] [td]TRANSLATED[/td] [/tr]
    # After: [list] [*] LANGUAGE (CODE): TRANSLATED[/list] 
    $replacedTable = $replacedTable  -replace 
            "(?ms)`\`[th`](.*)`\`[`/th`]",'' -replace
            "(?ms)`\`[tr`]`n`\`[td`](.*?)`\`[`/td`]`n`\`[td`](.*?)`\`[`/td`]`n`\`[td`](.*?)`\`[`/td`]`n`\`[`/tr`]",'[*] $2 ($1): $3'
    
    $bbcode =  $bbcode -replace "(?ms)`\`[replaced-table(.*)replaced-table`]", "[list]$replacedTable[/list]"
    
    if (!$outputFile) { $outputFile = $inputFile }
    $bbcode| Out-File -encoding utf8 $outputFile
}

# ------------------------------------------------------
# Replace the Versions table with a list (because
# NexusMods cannot display tables).
# ------------------------------------------------------

function ReplaceVersionsTable {
    Param ([string]$inputFile, [string]$outputFile, [string]$sectionName)

    $bbcode = [string]::Join("`n", (gc $inputFile -encoding utf8))

    # Fetch the entire table that should be replaced
    $bbcode = $bbcode -replace "(?ms)((.*)`]$sectionName(.*?))table",'$1replaced-table' -replace "(?ms)`/table`](.*)",'/replaced-table]$1'
    $originalTable = $bbcode -replace "(?ms)(.*)`\`[replaced-table`]`n",'' -replace "(?ms)`\`[`/replaced-table(.*)",''
    # Write-Host $originalTable

    $replacedTable = $originalTable

    # Before: [tr] [td]VERSION[/td] [td]ISSUES_LINK[/td] [td]CHANGES[/td] [/tr]
    # After: [list] [*] [B]VERSION[/B] (ISSUES_LINK): CHANGES[/list] 
    $replacedTable = $replacedTable  -replace
            "(?ms)`\`[th`](.*)`\`[`/th`]",'' -replace
            "(?ms)`\`[tr`]`n`\`[td`](.*?)`\`[`/td`]`n`\`[td`](.*?)`\`[`/td`]`n`\`[td`](.*?)`\`[`/td`]`n`\`[`/tr`]",'[*] [B]$1[/B] ($2): $3'
    $replacedTable = $replacedTable  -replace " `\`(-`\`)", ''

    $bbcode =  $bbcode -replace "(?ms)`\`[replaced-table(.*)replaced-table`]", "[list]$replacedTable[/list]"

    if (!$outputFile) { $outputFile = $inputFile }
    $bbcode| Out-File -encoding utf8 $outputFile
}