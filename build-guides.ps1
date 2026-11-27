$ErrorActionPreference = 'Stop'
$guidesPath = Join-Path $PSScriptRoot 'guias'
$guideLinks = @(
    @{ File = 'prism-launcher'; Label = 'Tutorial do Prism Launcher' },
    @{ File = 'primeiros-passos'; Label = 'Primeiros passos' },
    @{ File = 'serie-arca'; Label = 'Série Arca e ginásios' },
    @{ File = 'level-cap'; Label = 'Level cap e evoluções' },
    @{ File = 'dimensoes'; Label = 'Dimensões' },
    @{ File = 'mods-exclusivos'; Label = 'Mods exclusivos do pack' },
    @{ File = 'skinrestorer'; Label = 'SkinRestorer' }
)

function Convert-InlineMarkdown([string] $Text) {
    $Text = [regex]::Replace($Text, '\[([^\]]+)\]\(([^)]+)\)', '<a href="$2">$1</a>')
    $Text = [regex]::Replace($Text, '\*\*(.+?)\*\*', '<strong>$1</strong>')
    $Text = [regex]::Replace($Text, '\*([^*]+)\*', '<em>$1</em>')
    return [regex]::Replace($Text, '`([^`]+)`', '<code>$1</code>')
}

foreach ($guide in $guideLinks) {
    $markdownPath = Join-Path $guidesPath ($guide.File + '.md')
    $htmlPath = Join-Path $guidesPath ($guide.File + '.html')
    $lines = Get-Content -LiteralPath $markdownPath -Encoding utf8
    $title = ($lines | Where-Object { $_ -match '^# ' } | Select-Object -First 1) -replace '^# ', ''
    $body = [System.Collections.Generic.List[string]]::new()
    $inList = $false

    foreach ($line in $lines) {
        if ($line -match '^# ') { continue }
        if ($line -match '^## (.+)$') {
            if ($inList) { $body.Add('</ul>'); $inList = $false }
            $body.Add('<h2>' + $Matches[1] + '</h2>')
            continue
        }
        if ($line -match '^> (.+)$') {
            if ($inList) { $body.Add('</ul>'); $inList = $false }
            $body.Add('<blockquote><p>' + (Convert-InlineMarkdown $Matches[1]) + '</p></blockquote>')
            continue
        }
        if ($line -match '^!\[([^\]]+)\]\(([^)]+)\)$') {
            if ($inList) { $body.Add('</ul>'); $inList = $false }
            $alt = [System.Net.WebUtility]::HtmlEncode($Matches[1])
            $src = [System.Net.WebUtility]::HtmlEncode($Matches[2])
            $body.Add('<figure class="guide-image"><a href="' + $src + '"><img src="' + $src + '" alt="' + $alt + '" loading="lazy"></a></figure>')
            continue
        }
        if ($line -match '^[-*] (.+)$') {
            if (-not $inList) { $body.Add('<ul>'); $inList = $true }
            $body.Add('<li>' + (Convert-InlineMarkdown $Matches[1]) + '</li>')
            continue
        }
        if ([string]::IsNullOrWhiteSpace($line)) {
            if ($inList) { $body.Add('</ul>'); $inList = $false }
            continue
        }
        if ($inList) { $body.Add('</ul>'); $inList = $false }
        $body.Add('<p>' + (Convert-InlineMarkdown $line) + '</p>')
    }
    if ($inList) { $body.Add('</ul>') }

    $navigation = [System.Collections.Generic.List[string]]::new()
    $navigation.Add('<a class="nav-link" href="../index.html">Início</a><p class="nav-heading">JORNADA</p>')
    foreach ($entry in $guideLinks) {
        if ($entry.File -eq $guide.File) {
            $navigation.Add('<a class="nav-link current" aria-current="page" href="' + $entry.File + '.html">' + $entry.Label + '</a>')
        } else {
            $navigation.Add('<a class="nav-link" href="' + $entry.File + '.html">' + $entry.Label + '</a>')
        }
        if ($entry.File -eq 'level-cap') { $navigation.Add('<p class="nav-heading">MUNDO</p>') }
    }

    $page = @'
<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="__TITLE__ — guia para jogadores do servidor Arca.">
  <title>__TITLE__ · Wiki Arca</title>
  <link rel="stylesheet" href="../assets/style.css">
</head>
<body>
  <header class="topbar"><a class="brand" href="../index.html"><span class="brand-mark">A</span><span>ARCA Wiki <small>GUIA DO SERVIDOR</small></span></a><nav class="toplinks"><a href="../index.html">Início</a><a href="dimensoes.html">Regras do servidor</a></nav></header>
  <div class="layout">
    <aside class="sidebar">__NAV__<div class="sidebar-bottom"><span>ARCA</span><p>Cobblemon 1.8.4<br>Baseado em Cobbleverse</p></div></aside>
    <main class="article"><div class="breadcrumb"><a href="../index.html">Wiki Arca</a><span>/</span>__TITLE__</div><h1>__TITLE__</h1>
__BODY__
    </main>
    <aside class="toc"><strong>Nesta seção</strong>__TOC__<hr><span>Conteúdo para jogadores do servidor</span></aside>
  </div>
  <footer class="footer"><span>ARCA WIKI</span><span>Conteúdo para jogadores do servidor</span></footer>
</body>
</html>
'@
    $toc = [System.Collections.Generic.List[string]]::new()
    foreach ($line in $lines) {
        if ($line -match '^## (.+)$') {
            $heading = $Matches[1]
            $slug = [regex]::Replace($heading.ToLowerInvariant(), '[^a-z0-9]+', '-') -replace '(^-|-$)', ''
            $toc.Add('<a href="#' + $slug + '">' + $heading + '</a>')
        }
    }
    $bodyHtml = [regex]::Replace(($body -join "`n"), '<h2>(.*?)</h2>', {
        param($match)
        $heading = $match.Groups[1].Value
        $slug = [regex]::Replace($heading.ToLowerInvariant(), '[^a-z0-9]+', '-') -replace '(^-|-$)', ''
        '<h2 id="' + $slug + '">' + $heading + '</h2>'
    })
    $page = $page.Replace('__TITLE__', $title).Replace('__NAV__', ($navigation -join "`n")).Replace('__TOC__', ($toc -join "`n")).Replace('__BODY__', $bodyHtml)
    $page = $page -replace '\r?\n', [Environment]::NewLine
    [System.IO.File]::WriteAllText($htmlPath, $page + [Environment]::NewLine)
}

Write-Output "Páginas HTML geradas em $guidesPath"
