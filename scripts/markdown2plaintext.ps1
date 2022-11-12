
$markdownFile=$args[0]
$outputFile=$args[1]
$repositoryBase=$args[2] # base of GitHub repository
$repositoryPath=$args[3] # relative path to the files

pandoc $markdownFile -t plain -o $outputFile --reference-links

# Fix links to this repository
$plain = [string]::Join("`n", (gc $outputFile -encoding utf8))  # Notet that all line separators are \n
$imageBase = "$repositoryBase/blob/main$repositoryPath"
$plain = $plain -replace ']: \./',"]: $imageBase/"
$plain = $plain -replace '(.*)]: #(.*)\n',"" # remove anchor links
$plain | Out-File -encoding utf8 $outputFile