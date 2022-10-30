﻿# ----------------------------------------
# Converts HTML to BBCode
# see https://www.bbcode.org/reference.php
# ----------------------------------------

$htmlFile=$args[0]
$outputFile=$args[1]
$repositoryBase=$args[2]

$html = [string]::Join("`n", (gc $htmlFile -encoding utf8))  # Notet that all line separators are \n

# $html = $html -replace '<img(.*?)src="readme/(.*?)"(.*?)width="(.*?)"(.*?)>(\n)+','' # removes images entirely
# $html = $html -replace '<a href="LICENSE">(.*?)</a>','[url=https://github.com/slothsoft/stardew-informant/blob/main/LICENSE]$1[/url]' # links license

# Fix links to this repository
$html = $html -replace 'src="./',"src=""$repositoryBase/"
$html = $html -replace 'href="./',"href=""$repositoryBase/"

# Remove unsupported features
$html = $html -replace '<a href="#(.*?)">(.*?)</a>','$2' # removes anchor links

# Replace simple formatting tags (tags that are the same in HTML and BBCode)
$html = $html -replace '<([/]*(table|tr|th|td|code))(.*?)>','[$1]'

# Replace the list tags
$html = $html -replace '<([/])*(ul)(.*?)>','[$1list]'
$html = $html -replace '<ol(.*?)>','[list=1]'
$html = $html -replace '</ol>','[/list]'
$html = $html -replace '<li>','[*]'
$html = $html -replace '</li>',''

#Replace other tags...
$html = $html -replace '<([/])*(strong)(.*?)>','[$1b]'
$html = $html -replace '<([/])*(del)(.*?)>','[$1s]'
$html = $html -replace '<([/])*(em|figcaption)(.*?)>','[$1i]'
$html = $html -replace '<a href="([^"]*?)"(.*?)>(.*?)</a>','[url=$1]$3[/url]'
$html = $html -replace '<img(.*?)src="(.*?)"(.*?)>','[img]$2[/img]'

# Replace the headers (default font size is 12)
$html = $html -replace '<h1(.*?)>(.*?)</h1>',"[color=#00ff00][size=6]`$2[/size][/color]"
$html = $html -replace '<h2(.*?)>(.*?)</h2>',"`n[size=6]`$2[/size]"
$html = $html -replace '<h3(.*?)>(.*?)</h3>',"`n[size=5]`$2[/size]"
$html = $html -replace '<h4(.*?)>(.*?)</h4>',"`n[size=4]`$2[/size]"
$html = $html -replace '<h5(.*?)>(.*?)</h5>',"`n[b]`$2[/b]"

# Replace all the tags that mark a new paragraph in HTML
$html = $html -replace '<p>',"`n"

# Remove all the tags that don't exist in BBCode
$html = $html -replace '(</p>)',''
$html = $html -replace '<([/])*tbody>(\n)+',''
$html = $html -replace '<([/])*(colgroup)>(\n)+',''
$html = $html -replace '<([/])*(figure)>(\n)+',"`n"
$html = $html -replace '<col(.*?)/>(\n)+',''

# Make newlines better
$html = $html -replace '\[\/list\](\n)*',"`[/list`]`n"

# Replace the newlines
$html = $html -replace "`n","`r`n"

$html| Out-File -encoding utf8 $outputFile