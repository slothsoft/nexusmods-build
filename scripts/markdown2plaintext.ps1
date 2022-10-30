
$markdownFile=$args[0]
$outputFile=$args[1]

pandoc $markdownFile -t plain -o $outputFile --reference-links