
$markdownFile=$args[0]
$outputFile=$args[1]

pandoc $markdownFile -t html -o $outputFile --wrap=none