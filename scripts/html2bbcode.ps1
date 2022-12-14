# ----------------------------------------
# Converts HTML to BBCode
# see https://www.bbcode.org/reference.php
# ----------------------------------------

$htmlFile=$args[0]
$outputFile=$args[1]
$repositoryBase=$args[2] # base of GitHub repository
$repositoryPath=$args[3] # relative path to the files

$html = [string]::Join("`n", (gc $htmlFile -encoding utf8))  # Notet that all line separators are \n

# Fix links to this repository
$imageBase = "$repositoryBase/raw/main$repositoryPath"
$html = $html -replace 'src="\./',"src=""$imageBase/"
$linkBase = "$repositoryBase/blob/main$repositoryPath"
$html = $html -replace 'href="\./',"href=""$linkBase/"

# Fix ASCII emojis (see https://www.w3schools.com/charsets/ref_emoji.asp )
$html = $html -replace '✅','&#9989;'
$html = $html -replace '🔜','&#128284;'
$html = $html -replace '❎','&#10062;'
$html = $html -replace '❌','&#10060;'

# Remove unsupported features
$html = $html -replace '<a href="#(.*?)">(.*?)</a>','$2' # removes anchor links

# Replace inline-code tags because in BBCode it's a block
$html = $html -replace '<code(.*?)>(.*?)</code>', '[font=Courier New][color=#00ffff]$2[/color][/font]'
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