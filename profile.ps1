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
        [Switch]$gifut,
        [Switch]$k18gifut,
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

    if ($gifut) {
        $SiteRoot       = "/var/www/gifut"
        $PageLang       = "fi"
        $PageTitle      = "gifut"
        $PageUrl        = "https://gifut.fi/"
        $PageImage      = "$($PageUrl)ogp.jpg"
        $PageVideo      = "$($PageUrl)ogp.mp4"
        $AdultContent   = $false
    } elseif ($k18gifut) {
        $SiteRoot       = "/var/www/k18gifut"
        $PageLang       = "fi"
        $PageTitle      = "K18 gifut"
        $PageUrl        = "https://k18gifut.fi/"
        $PageImage      = "$($PageUrl)ogp.jpg"
        $PageVideo      = "$($PageUrl)ogp.mp4"
        $AdultContent   = $true
    } else {
        $SiteRoot       = "/var/www/$($ShortName)gifs"
        $PageLang       = "en"
        $PageTitle      = "$($FullName) gifs"
        $PageUrl        = "https://$($ShortName)gifs.com/"
        $PageImage      = "$($PageUrl)ogp.jpg"
        $PageVideo      = "$($PageUrl)ogp.mp4"
        $AdultContent   = $false
    }
    
    $IndexFile  = "$SiteRoot/index.html"
    $GifDir     = "$SiteRoot/gif/"
    $JpgDir     = "$SiteRoot/jpg/"
    $WebmDir    = "$SiteRoot/webm/"
    $Mp4Dir     = "$SiteRoot/mp4/"
    $JsonDir     = "$SiteRoot/json/"
    $gifs       = Get-ChildItem -Path $GifDir -File -Filter "*.gif"

    if ($gifut) {
        $PageHeaderText = "$($gifs.count) gifua"
        $PageDesc       = $PageHeaderText
        $PageVideoPath  = "$($Mp4Dir)/abofal_bonk_2.mp4"
    } elseif ($k18gifut) {
        $PageHeaderText = "$($gifs.count) gifua"
        $PageDesc       = "$($gifs.count) gifua"
        $PageVideoPath  = "$($Mp4Dir)/lola_hot_diggity_01.mp4"
    } else {
        $PageHeaderText = "$($gifs.count) gifs"
        $PageDesc       = $PageHeaderText
        
        switch ($ShortName) {
            "alex"      { $PageVideoPath = "/var/www/gifut/mp4/abofal_bonk_2.mp4" }
            "alice"     { $PageVideoPath = "$($Mp4Dir)/2015_james_and_alice_comedy_neighbours_love_actually_01.mp4" }
            "alison"    { $PageVideoPath = "$($Mp4Dir)/2015_get_hard_golf_zoom_03.mp4" }
            "alizee"    { $PageVideoPath = "/var/www/gifut/mp4/abofal_bonk_2.mp4" }
            "amy"       { $PageVideoPath = "$($Mp4Dir)/1999_drop_dead_gorgeous_silly.mp4" }
            "behm"      { $PageVideoPath = "$($Mp4Dir)/2020_ylex_5_sekunnin_haaste_2_zoom.mp4" }
            "blake"     { $PageVideoPath = "$($Mp4Dir)/2016_the_shallows_prep_08.mp4" }
            "christina" { $PageVideoPath = "$($Mp4Dir)/2007_mad_men_s01e08_dancing_01.mp4" }
            "elisabeth" { $PageVideoPath = "$($Mp4Dir)/2020_cobra_kai_s03e09_scene_02_shot_10_zoom.mp4" }
            "elizabeth" { $PageVideoPath = "$($Mp4Dir)/2002_serving_sara_change_08.mp4" }
            "january"   { $PageVideoPath = "$($Mp4Dir)/2015_the_last_man_on_earth_s01e04_scene_04_shot_01.mp4" }
            "jessica"   { $PageVideoPath = "$($Mp4Dir)/2017_mollys_game_scene_01_shot_06.mp4" }
            "julie"     { $PageVideoPath = "$($Mp4Dir)/2001_joe_somebody_basketball_10.mp4" }
            "katheryn"  { $PageVideoPath = "$($Mp4Dir)/2004_satans_little_helper_scene_08_shot_05.mp4" }
            "kiernan"   { $PageVideoPath = "$($Mp4Dir)/2020_chilling_adventures_of_sabrina_s04e01_scene_01_shot_05.mp4" }
            default     { $PageVideoPath = "/var/www/gifut/mp4/abofal_bonk_2.mp4" }
        }
    }

    $JpgDir, $WebmDir, $Mp4Dir, $JsonDir | ForEach-Object {
        New-Item -ItemType Directory -Force -Path $_ -ea 0 | Out-Null
        if ($Force) {
            Remove-Item -Force -Recurse -Path $_/* -ea 0 | Out-Null
        }
    }

    Remove-Item -Force -Path "$SiteRoot/ogp.*" -ea 0 | Out-Null
    New-Item -ItemType SymbolicLink -Path "$SiteRoot/ogp.mp4" -Target $PageVideoPath -ea 0 | Out-Null
    New-Item -ItemType SymbolicLink -Path "$SiteRoot/ogp.jpg" -Target $PageVideoPath.Replace("mp4", "jpg") -ea 0 | Out-Null
    $PageVideoWidth, $PageVideoHeight = (ffprobe -v quiet -select_streams v -show_entries stream=width,height -of csv=p=0:s=x "$SiteRoot/ogp.mp4").split("x")
    $PageImageWidth, $PageImageHeight = $PageVideoWidth, $PageVideoHeight

    $res = @"
<!DOCTYPE html>
<html lang="$PageLang">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="rating" content="$(if ($AdultContent) { "adult"} else { "general" })">
    <title>$PageTitle</title>
    <meta property="og:title" content="$PageTitle">
    <meta property="og:description" content="$PageDesc">
    <meta property="og:type" content="video">
    <meta property="og:url" content="$PageUrl">
    <meta property="og:image" content="$PageImage">
    <meta property="og:image:secure_url" content="$PageImage">
    <meta property="og:image:type" content="image/jpeg">
    <meta property="og:image:width" content="$PageImageWidth">
    <meta property="og:image:height" content="$PageImageHeight">
    <meta property="og:image:alt" content="$PageTitle">
    <meta property="og:video" content="$PageVideo">
    <meta property="og:video:secure_url" content="$PageVideo">
    <meta property="og:video:type" content="video/mp4">
    <meta property="og:video:width" content="$PageVideoWidth">
    <meta property="og:video:height" content="$PageVideoHeight">
    <link rel="stylesheet" href="gallery.css">
    <script src="lazyload.min.js"></script>
</head>
<body onload="initFilter()">
<header>
    <nav role="navigation">
        <div id="menuToggle">
            <input type="checkbox">
            <span></span>
            <span></span>
            <span></span>
            <ul id="menu">
                <a href="/gif/"><li>gif</li></a>
                <a href="/webm/"><li>webm</li></a>
                <a href="/mp4/"><li>mp4</li></a>
                <a href="/humans.txt"><li>?</li></a>
                $(if (-not $gifut -or -not $k18gifut) { 
                    "<a href=""https://alexgifs.com/""><li>Alexandra Daddario gifs</li></a>`n"
                    "                <a href=""https://alicegifs.com/""><li>Alice Levine gifs</li></a>`n"
                    "                <a href=""https://alisongifs.com/""><li>Alison Brie gifs</li></a>`n"
                    "                <a href=""https://alizeegifs.com/""><li>Alizée gifs</li></a>`n"
                    "                <a href=""https://amygifs.com/""><li>Amy Adams gifs</li></a>`n"
                    "                <a href=""https://behmgifs.com/""><li>BEHM gifs</li></a>`n"
                    "                <a href=""https://blakegifs.com/""><li>Blake Lively gifs</li></a>`n"
                    "                <a href=""https://christinagifs.com/""><li>Christina Hendricks gifs</li></a>`n"
                    "                <a href=""https://elisabethgifs.com/""><li>Elisabeth Shue gifs</li></a>`n"
                    "                <a href=""https://elizabethgifs.com/""><li>Elizabeth Hurley gifs</li></a>`n"
                    "                <a href=""https://januarygifs.com/""><li>January Jones gifs</li></a>`n"
                    "                <a href=""https://jessicagifs.com/""><li>Jessica Chastain gifs</li></a>`n"
                    "                <a href=""https://juliegifs.com/""><li>Julie Bowen gifs</li></a>`n"
                    "                <a href=""https://katheryngifs.com/""><li>Katheryn Winnick gifs</li></a>`n"
                    "                <a href=""https://kiernangifs.com/""><li>Kiernan Shipka gifs</li></a>"
                 })
            </ul>
        </div>
    </nav>
    <input style="display:none" type="text" placeholder="$PageHeaderText" id="filter" onkeyup='filter()'>
</header>
<main>
"@

    $cnt = 1
    $res += $gifs | ForEach-Object {
        Write-Progress -Activity "Giffing" -Status $_.FullName -PercentComplete ($cnt/$gifs.count*100)
        $cnt++

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

        if ($gifut -or $k18gifut) {
            $alt = $n.Replace("_"," ").Replace(".gif","")
        } else {
            $groups = $n | `
                Select-String -Pattern "^(\d{4})_(.+)?(\.gif)$" -AllMatches | `
                Select-Object -ExpandProperty Matches | `
                Select-Object -ExpandProperty Groups
            $alt = "($($groups[1].Value)) $($groups[2].Value.Replace("_"," "))"
        }

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
"@

    $res += @"

<script>
    var filterEl = document.getElementById('filter');
    filterEl.style.display = '';
    //filterEl.focus({ preventScroll: true });

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
