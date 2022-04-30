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
    }

    $res = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>$FullName gifs</title>
    <link rel="stylesheet" href="gallery.css">
    <script src="lazyload.min.js"></script>
</head>
<body onload="initFilter()">
<header>
<nav>
    <ul>
        <li>$($gifs.count) gifs</li>
        <li><a href="/gif/">gif</a></li>
        <li><a href="/webm/">webm</a></li>
        <li><a href="/mp4/">mp4</a></li>
        <li><a href="/humans.txt">?</a></li>
        <li><input style="display:none" type="text" placeholder="filter" id="filter" onkeyup='filter()'></li>
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
<video class="lazy" autoplay loop muted playsinline poster="/jpg/$($n.Replace(".gif",".jpg"))" width="$width">
    <source data-src="/webm/$($n.Replace(".gif",".webm"))" type="video/webm">
    <source data-src="/mp4/$($n.Replace(".gif",".mp4"))" type="video/mp4">
    <img src="/jpg/$($n.Replace(".gif",".jpg"))" alt="$alt" width="$width">
</video>
<p>$alt</p>
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
<script>
    var filterEl = document.getElementById('filter');
    filterEl.style.display = '';
    filterEl.focus({ preventScroll: true });

    function initFilter() {
        if (!filterEl.value) {
            var filterParam = new URL(window.location.href).searchParams.get('filter');
            if (filterParam) {
                filterEl.value = filterParam;
            }
        }
        filter();
    }

    function filter() {
        var q = filterEl.value.trim().toLowerCase();
        var elems = document.querySelectorAll('article');
        elems.forEach(function(el) {
            if (!q) {
                el.style.display = '';
                return;
            }
            var nameEl = el.querySelector('p');
            var nameVal = nameEl.textContent.trim().toLowerCase();
            if (nameVal.indexOf(q) !== -1) {
                el.style.display = '';
            } else {
                el.style.display = 'none';
            }
        });
    }

    var lazyLoadInstance = new LazyLoad({
        // Your custom settings go here
    });
</script>
</body>
</html>
"@

    $res | Set-Content -Path $IndexFile
}

function gifut {
    [CmdletBinding()]
    param (
        [Switch]$k18,
        [Switch]$Force
    )

    if ($k18) {
        $IndexFile = "/var/www/k18gifut/index.html"
        $GifDir = "/var/www/k18gifut/gif/"
        $JpgDir ="/var/www/k18gifut/jpg/"
        $WebmDir = "/var/www/k18gifut/webm/"
        $Mp4Dir = "/var/www/k18gifut/mp4/"
        $gifs = Get-ChildItem -Path $GifDir -File -Filter "*.gif"
    } else {
        $IndexFile = "/var/www/gifut/index.html"
        $GifDir = "/var/www/gifut/gif/"
        $JpgDir ="/var/www/gifut/jpg/"
        $WebmDir = "/var/www/gifut/webm/"
        $Mp4Dir = "/var/www/gifut/mp4/"
        $gifs = Get-ChildItem -Path $GifDir -File -Filter "*.gif"
    }

    if ($Force) {
        $JpgDir, $WebmDir, $Mp4Dir | ForEach-Object {
            New-Item -ItemType Directory -Force -Path $_ -ea 0 | Out-Null
            Remove-Item -Force -Recurse -Path $_/* -ea 0 | Out-Null
        }
    }

    $res = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    $(if ($k18) {
        "<meta name=""rating"" content=""adult"">"
    })
    <title>$(if ($k18) { "k18" })gifut</title>
    <link rel="stylesheet" href="gallery.css">
    <script src="lazyload.min.js"></script>
</head>
<body onload="initFilter()">
<header>
<nav>
    <ul>
        <li>$(if ($k18) { "(<a href=""https://gifut.fi/"">muut gifut</a>) " }) $($gifs.count) gifua</li>
        <li><a href="/gif/">gif</a></li>
        <li><a href="/webm/">webm</a></li>
        <li><a href="/mp4/">mp4</a></li>
        <li><a href="/humans.txt">?</a></li>
        <li><input style="display:none" type="text" placeholder="filter" id="filter" onkeyup='filter()'></li>
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
        
        $n = $_.Name
        $alt = $n.Replace("_"," ").Replace(".gif","")

        @"

<article>
<a href="/gif/$n">
<video class="lazy" autoplay loop muted playsinline poster="/jpg/$($n.Replace(".gif",".jpg"))" width="$width">
    <source data-src="/webm/$($n.Replace(".gif",".webm"))" type="video/webm">
    <source data-src="/mp4/$($n.Replace(".gif",".mp4"))" type="video/mp4">
    <img src="/jpg/$($n.Replace(".gif",".jpg"))" alt="$alt" width="$width">
</video>
<p>$alt</p>
</a>
</article>
"@
    }

    $res += @"

</main>
<script>
    var filterEl = document.getElementById('filter');
    filterEl.style.display = '';
    filterEl.focus({ preventScroll: true });

    function initFilter() {
        if (!filterEl.value) {
            var filterParam = new URL(window.location.href).searchParams.get('filter');
            if (filterParam) {
                filterEl.value = filterParam;
            }
        }
        filter();
    }

    function filter() {
        var q = filterEl.value.trim().toLowerCase();
        var elems = document.querySelectorAll('article');
        elems.forEach(function(el) {
            if (!q) {
                el.style.display = '';
                return;
            }
            var nameEl = el.querySelector('p');
            var nameVal = nameEl.textContent.trim().toLowerCase();
            if (nameVal.indexOf(q) !== -1) {
                el.style.display = '';
            } else {
                el.style.display = 'none';
            }
        });
    }

    var lazyLoadInstance = new LazyLoad({
        // Your custom settings go here
    });
</script>
</body>
</html>
"@

    $res | Set-Content -Path $IndexFile
}