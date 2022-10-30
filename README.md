# NexusMods Build

- **Author:** [Stef Schulz](mailto:s.schulz@slothsoft.de)
- **Repository:** <https://github.com/slothsoft/nexusmods-build>
- **Open Issues:** <https://github.com/slothsoft/nexusmods-build/issues>

Scripts for making the work with [NexusMods](https://www.nexusmods.com) easier.

**Content:**

- **[Using the Scripts](#using-the-scripts)**
  - [Plaintext](#plaintext)
  - [BBCode](#bbcode)



## Using the Scripts

These scripts are based on **Pandoc** to make the MarkDown file to something else, so to install it do:

```
choco install pandoc
```

### Plaintext

```
powershell -ExecutionPolicy Bypass -File %cd%/scripts/markdown2plaintext.ps1 %inputFolder%\README.md %outputFolder%\readme.txt
```


### BBCode

[BBCode Online Editor](https://bbcode.ilma.dev)

```
powershell -ExecutionPolicy Bypass -File %cd%/scripts/markdown2html.ps1 %inputFolder%\README.md %outputFolder%\readme.html
powershell -ExecutionPolicy Bypass -File %cd%/scripts/html2bbcode.ps1 %outputFolder%\readme.html %outputFolder%\readme-bbcode.txt
```


