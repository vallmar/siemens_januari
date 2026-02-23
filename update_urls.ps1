$ErrorActionPreference = "Stop"
$sourceDir = "c:\Users\marku\source\DNAB\Siemens_Januari\ads"

$urls = @{
    "sv" = "https://www.siemens-home.bsh-group.com/se/bli-inspirerad/innovation/produktnyheter/studioline-ugnar-iq700"
    "no" = "https://www.siemens-home.bsh-group.com/no/inspirasjon/innovasjon/produktnyheter/studioline-ovner-iq700"
    "dk" = "https://www.siemens-home.bsh-group.com/dk/inspiration/innovation/produktnyheder/studioline-ovne-iq700"
    "fi" = "https://www.siemens-home.bsh-group.com/fi/etsi-inspiraatiota/innovaatio/tuoteuutuudet/studioline-uunit-iq700"
}

$htmlFiles = Get-ChildItem -Path $sourceDir -Filter "*.html" -Recurse

foreach ($file in $htmlFiles) {
    # Extract language code from directory name
    $langCode = ""
    if ($file.DirectoryName -match "-sv-") { $langCode = "sv" }
    elseif ($file.DirectoryName -match "-no-") { $langCode = "no" }
    elseif ($file.DirectoryName -match "-dk-") { $langCode = "dk" }
    elseif ($file.DirectoryName -match "-fi-") { $langCode = "fi" }

    if ($langCode -ne "") {
        $content = Get-Content $file.FullName -Raw
        $newUrl = $urls[$langCode]
        
        # We know the old tag looks like: var clickTag = "https://www.siemens-home.bsh-group.com/dk/";
        # or similar depending on the file. Let's use regex to replace it entirely.
        $content = $content -replace 'var clickTag = ".*?";', "var clickTag = `"$newUrl`";"
        
        Set-Content -Path $file.FullName -Value $content -NoNewline -Encoding UTF8
        Write-Host "Updated $($file.FullName) to $langCode"
    }
}
Write-Host "Done updating click URLs."
