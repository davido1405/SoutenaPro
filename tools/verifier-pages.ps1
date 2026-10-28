# ============================================================================
# SoutenaPro - verification des pages et des liens
#
# Parcourt toutes les pages accessibles depuis les tableaux de bord des trois
# espaces, suit chaque lien interne et signale les codes HTTP anormaux.
# Le script est en lecture seule : aucune donnee n'est modifiee.
#
# Usage :
#   .\tools\verifier-pages.ps1
#   .\tools\verifier-pages.ps1 -BaseUrl "http://localhost:8080/SoutenaPro"
# ============================================================================
param(
    [string]$BaseUrl = "http://localhost:8080/SoutenaPro",
    [string]$AdminLogin = "admin1",
    [string]$AdminPassword = "admin123"
)

$ErrorActionPreference = "Stop"
$global:problems = New-Object System.Collections.Generic.List[string]
$global:count = 0

function New-Session([string]$login, [string]$password) {
    $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
    Invoke-WebRequest "$BaseUrl/login" -Method Post -Body @{login = $login; motDePasse = $password } `
        -WebSession $session -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue | Out-Null
    return $session
}

function Get-Page($session, [string]$url, [string]$role) {
    $global:count++
    try {
        $response = Invoke-WebRequest $url -WebSession $session -UseBasicParsing `
            -MaximumRedirection 0 -ErrorAction SilentlyContinue
        $body = [string]$response.Content
        if ([int]$response.StatusCode -ne 200) {
            $global:problems.Add("[$($response.StatusCode)] $role -> $url")
        } elseif ($body -match 'Erreur interne du serveur|ServletException|java\.lang\.[A-Za-z]+Exception') {
            $global:problems.Add("[EXCEPTION] $role -> $url")
        }
        return $response
    } catch {
        $status = if ($_.Exception.Response) { [int]$_.Exception.Response.StatusCode } else { "ERR" }
        $global:problems.Add("[$status] $role -> $url")
        return $null
    }
}

function Get-Links([string]$html, [string]$role) {
    $links = New-Object System.Collections.Generic.List[string]
    $contextPath = ([uri]$BaseUrl).AbsolutePath.TrimEnd("/")
    foreach ($match in [regex]::Matches($html, '(?:href|action)="([^"]+)"')) {
        $value = $match.Groups[1].Value.Trim()
        if ($value -eq "" -or $value.StartsWith("#") -or $value.StartsWith("mailto:")) { continue }
        if ($value.StartsWith("javascript:") -or $value.StartsWith("http")) { continue }
        if ($value -match '\$\{') { continue }
        if ($value -match '/logout') { continue }
        if ($value.StartsWith("/")) {
            if (-not $value.StartsWith($contextPath + "/")) {
                $global:problems.Add("[HORS CONTEXTE] $role -> $value")
                continue
            }
            $links.Add("http://localhost:8080" + $value)
        } else {
            $global:problems.Add("[LIEN RELATIF] $role -> $value")
        }
    }
    return $links
}

function Crawl([string]$role, $session, [string[]]$seeds) {
    $queue = New-Object System.Collections.Generic.Queue[string]
    $seen = New-Object 'System.Collections.Generic.HashSet[string]'
    foreach ($seed in $seeds) { $queue.Enqueue($seed) }

    while ($queue.Count -gt 0) {
        $url = $queue.Dequeue()
        if (-not $seen.Add($url)) { continue }
        $response = Get-Page $session $url $role
        if ($null -eq $response) { continue }
        $contentType = [string]$response.Headers["Content-Type"]
        if ($contentType -match "text/html") {
            foreach ($link in (Get-Links ([string]$response.Content) $role)) {
                if (-not $seen.Contains($link) -and $link.StartsWith($BaseUrl)) {
                    $queue.Enqueue($link)
                }
            }
        }
    }
    Write-Host ("{0,-22} {1,3} page(s)" -f $role, $seen.Count)
}

Write-Host "Verification de $BaseUrl"
Write-Host ""

# --- Administrateur ----------------------------------------------------------
$admin = New-Session $AdminLogin $AdminPassword
Crawl "ADMIN" $admin @(
    "$BaseUrl/admin",
    "$BaseUrl/admin/etudiants", "$BaseUrl/admin/etudiants/nouveau",
    "$BaseUrl/admin/enseignants", "$BaseUrl/admin/enseignants/nouveau",
    "$BaseUrl/admin/soutenances", "$BaseUrl/admin/soutenances/nouvelle",
    "$BaseUrl/admin/resultats"
)

# --- Enseignants -------------------------------------------------------------
for ($i = 1; $i -le 6; $i++) {
    $session = New-Session "ens$i" "ens123"
    Crawl "ENSEIGNANT ens$i" $session @(
        "$BaseUrl/enseignant",
        "$BaseUrl/enseignant/soutenances",
        "$BaseUrl/enseignant/evaluations"
    )
}

# --- Etudiants ---------------------------------------------------------------
for ($i = 1; $i -le 10; $i++) {
    $session = New-Session "etu$i" "etu123"
    Crawl "ETUDIANT etu$i" $session @(
        "$BaseUrl/etudiant",
        "$BaseUrl/etudiant/soutenance",
        "$BaseUrl/etudiant/resultat"
    )
}

# --- Pages publiques, exports et filtres -------------------------------------
$extras = @(
    "/admin/export?type=etudiants",
    "/admin/export?type=enseignants",
    "/admin/export?type=soutenances",
    "/admin/etudiants?q=a",
    "/admin/enseignants?q=a",
    "/admin/soutenances?q=a",
    "/admin/soutenances?statut=PLANIFIEE",
    "/admin/soutenances?statut=EVALUEE",
    "/admin/soutenances?statut=ANNULEE",
    "/admin/soutenances?date=2026-01-01",
    "/admin/resultats?q=a"
)
foreach ($path in $extras) {
    Get-Page $admin "$BaseUrl$path" "EXTRA" | Out-Null
}

# --- Controle d'acces (reponses attendues) -----------------------------------
$anonymous = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$teacher = New-Session "ens1" "ens123"
$student = New-Session "etu1" "etu123"
$access = @(
    @{ Session = $anonymous; Path = "/"; Expected = @(200, 302) },
    @{ Session = $anonymous; Path = "/index.jsp"; Expected = @(200, 302) },
    @{ Session = $anonymous; Path = "/login"; Expected = 200 },
    @{ Session = $anonymous; Path = "/admin"; Expected = 302 },
    @{ Session = $teacher;   Path = "/admin/etudiants"; Expected = 302 },
    @{ Session = $teacher;   Path = "/etudiant/soutenance"; Expected = 302 },
    @{ Session = $student;   Path = "/admin/soutenances"; Expected = 302 },
    @{ Session = $student;   Path = "/enseignant/evaluations"; Expected = 302 },
    @{ Session = $anonymous; Path = "/page-inexistante"; Expected = 404 }
)
foreach ($test in $access) {
    $global:count++
    try {
        $response = Invoke-WebRequest "$BaseUrl$($test.Path)" -WebSession $test.Session `
            -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue
        $code = [int]$response.StatusCode
    } catch {
        $code = if ($_.Exception.Response) { [int]$_.Exception.Response.StatusCode } else { 0 }
    }
    if ($test.Expected -notcontains $code) {
        $global:problems.Add("[$code au lieu de $($test.Expected -join '/')] controle d'acces -> $($test.Path)")
    }
}

Write-Host ""
Write-Host ("Requetes effectuees : {0}" -f $global:count)
if ($global:problems.Count -eq 0) {
    Write-Host "RESULTAT : aucune page manquante, aucun lien casse."
    exit 0
}
Write-Host ("RESULTAT : {0} probleme(s)" -f $global:problems.Count)
$global:problems | ForEach-Object { Write-Host " - $_" }
exit 1
