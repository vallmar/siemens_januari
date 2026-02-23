$ErrorActionPreference = "Stop"
$sourceDir = "c:\Users\marku\source\DNAB\Siemens_Januari\ads"
$formats = @("160x600", "300x250", "300x600", "728x90", "970x250")
$campaigns = @("consideration-m1", "consideration-m2")

$languages = @(
    @{ Code = "sv"; Uppercase = "SV"; },
    @{ Code = "dk"; Uppercase = "DK"; },
    @{ Code = "fi"; Uppercase = "FI"; }
)

foreach ($c in $campaigns) {
    foreach ($f in $formats) {
        $sourceName = "$c-no-$f"
        $sourcePath = Join-Path $sourceDir $sourceName
        
        if (!(Test-Path $sourcePath)) {
            Write-Host "Skipping $sourcePath"
            continue
        }

        foreach ($lang in $languages) {
            $langCode = $lang.Code
            $langUpper = $lang.Uppercase
            $targetName = "$c-$langCode-$f"
            $targetPath = Join-Path $sourceDir $targetName

            Write-Host "Creating $targetName"

            if (Test-Path $targetPath) {
                Remove-Item -Recurse -Force $targetPath
            }
            Copy-Item -Path $sourcePath -Destination $targetPath -Recurse
            
            $htmlFiles = Get-ChildItem -Path $targetPath -Filter "*.html"
            foreach ($htmlFile in $htmlFiles) {
                $content = Get-Content $htmlFile.FullName -Raw
                
                # Update title and directory mentions
                $content = $content -replace "-no-", "-$langCode-"
                $content = $content -replace "NO  ", "$langUpper  "
                $content = $content -replace 'lang="no"', "lang=`"$langCode`""
                $content = $content -replace 'lang="dk"', "lang=`"$langCode`"" # Just in case
                
                if ($langCode -eq "sv") {
                    $content = $content -replace 'Oppdag', 'Upptäck'
                    $content = $content -replace 'stekeovn iQ700', 'iQ700-ugn'
                    $content = $content -replace 'Intelligens som begeistrer', 'Intelligens som hänför'
                    $content = $content -replace 'Stekeovnen<br>iQ700', 'Ugnen<br>iQ700'
                    $content = $content -replace 'Stekeovnen iQ700', 'Ugnen iQ700'
                    $content = $content -replace 'gjenkjenner og finjusterer<br>opptil 100 ulike matretter\.', 'identifierar och finjusterar<br>upp till 100 olika maträtter.'
                    $content = $content -replace 'gjenkjenner og<br>finjusterer opptil<br>100 ulike matretter\.', 'identifierar och<br>finjusterar upp till<br>100 olika maträtter.'
                    $content = $content -replace 'gjenkjenner og finjusterer opptil 100 ulike matretter\.', 'identifierar och finjusterar upp till 100 olika maträtter.'
                    $content = $content -replace 'Les mer', 'Läs mer'
                }
                elseif ($langCode -eq "dk") {
                    $content = $content -replace 'Oppdag', 'Oplev'
                    $content = $content -replace 'stekeovn iQ700', 'iQ700 ovn'
                    $content = $content -replace 'Intelligens som begeistrer', 'Intelligens som begejstrer'
                    $content = $content -replace 'Stekeovnen<br>iQ700', 'iQ700<br>ovnen'
                    $content = $content -replace 'Stekeovnen iQ700', 'iQ700 ovnen'
                    $content = $content -replace 'gjenkjenner og finjusterer<br>opptil 100 ulike matretter\.', 'identificerer og finjusterer<br>op til 100 retter.'
                    $content = $content -replace 'gjenkjenner og<br>finjusterer opptil<br>100 ulike matretter\.', 'identificerer og<br>finjusterer op til<br>100 retter.'
                    $content = $content -replace 'gjenkjenner og finjusterer opptil 100 ulike matretter\.', 'identificerer og finjusterer op til 100 retter.'
                    $content = $content -replace 'Les mer', 'Læs mere'
                }
                elseif ($langCode -eq "fi") {
                    $content = $content -replace 'Oppdag', 'Tutustu'
                    $content = $content -replace 'stekeovn iQ700', 'iQ700-uuniin'
                    $content = $content -replace 'Intelligens som begeistrer', 'Älykkyyttä joka ilahduttaa'
                    $content = $content -replace 'Stekeovnen<br>iQ700', 'iQ700-<br>uuni'
                    $content = $content -replace 'Stekeovnen iQ700', 'iQ700-uuni'
                    $content = $content -replace 'gjenkjenner og finjusterer<br>opptil 100 ulike matretter\.', 'tunnistaa jopa 100 eri<br>ruokaa ja kypsentää<br>ne täydellisiksi.'
                    $content = $content -replace 'gjenkjenner og<br>finjusterer opptil<br>100 ulike matretter\.', 'tunnistaa jopa 100 eri<br>ruokaa ja kypsentää<br>ne täydellisiksi.'
                    $content = $content -replace 'gjenkjenner og finjusterer opptil 100 ulike matretter\.', 'tunnistaa jopa 100 eri ruokaa ja kypsentää ne täydellisiksi.'
                    $content = $content -replace 'Les mer', 'Lue lisää'
                }
                
                Set-Content -Path $htmlFile.FullName -Value $content -NoNewline -Encoding UTF8
            }
        }
    }
}
Write-Host "Done copying and translating to SV, DK, FI."
