#!/usr/bin/pwsh
# ~/.config/powershell/profile.ps1
function gif {
    [CmdletBinding()]
    param (
        [Alias("Alexandra","Daddario")]
        [Switch]$Alex,
        [Alias("Levine")]
        [Switch]$Alice,
        [Alias("Brie")]
        [Switch]$Alison,
        [Alias("Alizée")]
        [Switch]$Alizee,
        [Alias("Adams")]
        [Switch]$Amy,
        [Alias("Rita")]
        [Switch]$BEHM,
        [Alias("Lively")]
        [Switch]$Blake,
        [Alias("Hendricks")]
        [Switch]$Christina,
        [Alias("Shue")]
        [Switch]$Elisabeth,
        [Alias("Hurley")]
        [Switch]$Elizabeth,
        [Alias("Jones")]
        [Switch]$January,
        [Alias("Chastain")]
        [Switch]$Jessica,
        [Alias("Bowen")]
        [Switch]$Julie,
        [Alias("Winnick")]
        [Switch]$Katheryn,
        [Alias("Shipka")]
        [Switch]$Kiernan,
        [Switch]$Force
    )
    
    $ShortName, $FullName = switch ($PSBoundParameters.GetEnumerator().Where({$_.Value -eq $true}).Key) {
        "Alex"      { "alex",       "Alexandra Daddario" }
        "Alice"     { "alice",      "Alice Levine" }
        "Alison"    { "alison",     "Alison Brie" }
        "Alizee"    { "alizee",     "Alizée" }
        "Amy"       { "amy",        "Amy Adams" }
        "BEHM"      { "behm",       "BEHM" }
        "Blake"     { "blake",      "Blake Lively" }
        "Christina" { "christina",  "Christina Hendricks" }
        "Elisabeth" { "elisabeth",  "Elisabeth Shue" }
        "Elizabeth" { "elizabeth",  "Elizabeth Hurley" }
        "January"   { "january",    "January Jones" }
        "Jessica"   { "jessica",    "Jessica Chastain" }
        "Julie"     { "julie",      "Julie Bowen" }
        "Katheryn"  { "katheryn",   "Katheryn Winnick" }
        "Kiernan"   { "kiernan",    "Kiernan Shipka" }
    }

    $IndexFile = "/var/www/$($ShortName)gifs/index.html"
    $EmptyZipFile = "/var/www/empty.zip"
    $ZipFile = "/var/www/$($ShortName)gifs/$($ShortName)gifs.zip"
    $GifDir = "/var/www/$($ShortName)gifs/gif/"
    $JpgDir ="/var/www/$($ShortName)gifs/jpg/"
    $WebmDir = "/var/www/$($ShortName)gifs/webm/"
    $Mp4Dir = "/var/www/$($ShortName)gifs/mp4/"
    $gifs = Get-ChildItem -Path $GifDir -File -Filter "*.gif"

    if ($Force) {
        $JpgDir, $WebmDir, $Mp4Dir | ForEach-Object {
            New-Item -ItemType Directory -Force -Path $_ -ea 0 | Out-Null
            Remove-Item -Force -Recurse -Path $_/* -ea 0 | Out-Null
        }

        if (-not (Test-Path $EmptyZipFile)) {
            Write-Output UEsFBgAAAAAAAAAAAAAAAAAAAAAAAA== | base64 -d > $EmptyZipFile
        }

        Copy-Item $EmptyZipFile $ZipFile -ea 0
    }

    zip -ujqr $ZipFile $GifDir

    $ZipSizeInMB = [math]::Round((Get-Item $ZipFile).Size/1MB,0)

    $res = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>$FullName gifs</title>
    <style>
        * {
            margin: 0;
            padding: 0;
        }

        body {
            color: #444;
            background-color: #f0f0f0;
        }

        ul {
            list-style-type: none;
        }

        li {
            display: inline-block;
            padding: 0.5em;
        }

        a {
            text-decoration: none;
        }

        main {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            justify-items: center;
            align-items: center;
        }

        video, img {
            max-width: 29vw;
            max-height: 70vh;
            object-fit: contain;
        }
    </style>
</head>
<body>
<header>
<nav>
    <ul>
        <li>$($gifs.count) gifs, $ZipSizeInMB MB <a href="/$($ShortName)gifs.zip" title="All $FullName gifs zipped">$($ShortName)gifs.zip</a></li>
        <li><a href="/gif/">gif</a></li>
        <li><a href="/webm/">webm</a></li>
        <li><a href="/mp4/">mp4</a></li>
    </ul>
</nav>
</header>
<main>
"@

    $res += $gifs | ForEach-Object {
        $gif = $_.FullName
        $jpg = $gif.replace("/gif/","/jpg/").replace(".gif",".jpg")
        $webm = $gif.replace("/gif/","/webm/").replace(".gif",".webm")
        $mp4 = $gif.replace("/gif/","/mp4/").replace(".gif",".mp4")
        $width, $height = (ffprobe -v quiet -select_streams v -show_entries stream=width,height -of csv=p=0:s=x $gif).split("x")

        if ($Force -or -not (Test-Path $jpg)) {
            ffmpeg -hide_banner -loglevel quiet -y -i $gif -frames:v 1 -q:v 30 -f image2 $jpg
        }

        if ($Force -or -not (Test-Path $webm)) {
            ffmpeg -hide_banner -loglevel quiet -y -i $gif -c vp9 -b:v 0 -crf 20 $webm
        }

        if ($Force -or -not (Test-Path $mp4)) {
            ffmpeg -hide_banner -loglevel quiet -y -i $gif -movflags +faststart -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" $mp4
        }
        
        #
        # 1999_tässä_on_title_tässä_jotain_lisää_01.gif
        # ->
        # (1999) tässä on title tässä jotain lisää 01
        #
        $n = $_.Name
        $groups = $n | `
            Select-String -Pattern "^(\d{4})_(.+)?(\.gif)$" -AllMatches | `
            Select-Object -ExpandProperty Matches | `
            Select-Object -ExpandProperty Groups
        $alt = "($($groups[1].Value)) $($groups[2].Value.Replace("_"," "))"

        @"

<article>
<a href="/gif/$n">
<video autoplay loop muted playsinline poster="/jpg/$($n.Replace(".gif",".jpg"))" width="$width">
    <source src="/webm/$($n.Replace(".gif",".webm"))" type="video/webm">
    <source src="/mp4/$($n.Replace(".gif",".mp4"))" type="video/mp4">
    <img src="/jpg/$($n.Replace(".gif",".jpg"))" alt="$alt" width="$width">
</video>
</a>
</article>
"@
    }

    $res += @"

</main>
<footer>
<nav>
    <ul>
        <li><a href="https://alexgifs.com/">Alexandra Daddario gifs</a></li>
        <li><a href="https://alicegifs.com/">Alice Levine gifs</a></li>
        <li><a href="https://alisongifs.com/">Alison Brie gifs</a></li>
        <li><a href="https://alizeegifs.com/">Alizée gifs</a></li>
        <li><a href="https://amygifs.com/">Amy Adams gifs</a></li>
        <li><a href="https://behmgifs.com/">BEHM gifs</a></li>
        <li><a href="https://blakegifs.com/">Blake Lively gifs</a></li>
        <li><a href="https://christinagifs.com/">Christina Hendricks gifs</a></li>
        <li><a href="https://elisabethgifs.com/">Elisabeth Shue gifs</a></li>
        <li><a href="https://elizabethgifs.com/">Elizabeth Hurley gifs</a></li>
        <li><a href="https://januarygifs.com/">January Jones gifs</a></li>
        <li><a href="https://jessicagifs.com/">Jessica Chastain gifs</a></li>
        <li><a href="https://juliegifs.com/">Julie Bowen gifs</a></li>
        <li><a href="https://katheryngifs.com/">Katheryn Winnick gifs</a></li>
        <li><a href="https://kiernangifs.com/">Kiernan Shipka gifs</a></li>
    </ul>
</nav>
</footer>
</body>
</html>
"@

    $res | Set-Content -Path $IndexFile
}