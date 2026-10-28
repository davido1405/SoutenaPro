# ============================================================================
# SoutenaPro — compilation, packaging et déploiement WildFly
# Usage :
#   .\build.ps1                 -> compile et crée dist\SoutenaPro.war
#   .\build.ps1 -Deploy         -> compile et copie le WAR dans WildFly
# ============================================================================
param(
    [switch]$Deploy,
    [string]$WildFly = "C:\Users\Grace David\wildfly-37.0.1.Final"
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path

# --- Localisation du JDK 17 --------------------------------------------------
$jdk = $null
foreach ($candidat in @("C:\Program Files\Java\jdk-17", $env:JAVA_HOME)) {
    if ($candidat -and (Test-Path "$candidat\bin\javac.exe")) { $jdk = $candidat; break }
}
if (-not $jdk) {
    $javac = (Get-Command javac -ErrorAction SilentlyContinue)
    if ($javac) { $jdk = Split-Path -Parent (Split-Path -Parent $javac.Source) }
}
if (-not $jdk) { throw "JDK introuvable. Installez un JDK 17 ou définissez JAVA_HOME." }

$javac = "$jdk\bin\javac.exe"
$jar = "$jdk\bin\jar.exe"
Write-Host "JDK      : $jdk"

# --- API Servlet fournie par WildFly ----------------------------------------
$servletJar = Get-ChildItem "$WildFly\modules\system\layers\base\jakarta\servlet\api\main\*.jar" -ErrorAction SilentlyContinue |
              Select-Object -First 1
if (-not $servletJar) {
    throw "jakarta.servlet-api introuvable dans $WildFly. Vérifiez le chemin -WildFly."
}
Write-Host "Servlet  : $($servletJar.Name)"

# --- Répertoires -------------------------------------------------------------
$build = Join-Path $root "build"
$classes = Join-Path $build "classes"
$webapp = Join-Path $build "webapp"
$dist = Join-Path $root "dist"

if (Test-Path $build) { Remove-Item $build -Recurse -Force }
if (Test-Path $dist) { Remove-Item $dist -Recurse -Force }
New-Item -ItemType Directory -Force $classes, $webapp, $dist | Out-Null

# --- Compilation -------------------------------------------------------------
$sources = Get-ChildItem (Join-Path $root "src\main\java") -Recurse -Filter *.java |
           ForEach-Object { $_.FullName }
Write-Host "Compilation de $($sources.Count) fichier(s) Java..."
& $javac --release 17 -encoding UTF-8 -Xlint:-options `
    -cp $servletJar.FullName -d $classes $sources
if ($LASTEXITCODE -ne 0) { throw "La compilation a échoué." }

# --- Assemblage du WAR -------------------------------------------------------
Write-Host "Assemblage du WAR..."
Copy-Item (Join-Path $root "src\main\webapp\*") $webapp -Recurse -Force
$classesDest = Join-Path $webapp "WEB-INF\classes"
New-Item -ItemType Directory -Force $classesDest | Out-Null
Copy-Item "$classes\*" $classesDest -Recurse -Force

$war = Join-Path $dist "SoutenaPro.war"
& $jar --create --file $war -C $webapp .
if ($LASTEXITCODE -ne 0) { throw "La création du WAR a échoué." }
Write-Host "WAR créé : $war ($([math]::Round((Get-Item $war).Length / 1MB, 2)) Mo)"

# --- Déploiement -------------------------------------------------------------
if ($Deploy) {
    $deployments = Join-Path $WildFly "standalone\deployments"
    if (-not (Test-Path $deployments)) { throw "Répertoire de déploiement introuvable : $deployments" }
    $warName = "SoutenaPro.war"
    $warTarget = Join-Path $deployments $warName
    Copy-Item $war $warTarget -Force
    Write-Host "WAR copié dans $deployments."

    # Le déploiement reste piloté par le scanner WildFly : le marqueur .dodeploy
    # déclenche un redéploiement propre sans ajouter d'entrée persistante dans
    # standalone.xml (une entrée CLI + le WAR dans deployments provoquent un
    # doublon au prochain démarrage).
    foreach ($suffix in @(".failed", ".deployed", ".undeployed")) {
        Remove-Item "$warTarget$suffix" -Force -ErrorAction SilentlyContinue
    }
    Set-Content -Path "$warTarget.dodeploy" -Value "" -Encoding ASCII

    # Si le serveur tourne, on force un passage immédiat du scanner.
    $management = Get-NetTCPConnection -LocalPort 9990 -State Listen -ErrorAction SilentlyContinue
    $cli = Join-Path $WildFly "bin\jboss-cli.bat"
    if ($management -and (Test-Path $cli)) {
        $cliFile = Join-Path $env:TEMP "soutenapro-deploy.cli"
        Set-Content -Path $cliFile -Value "connect`n/subsystem=deployment-scanner/scanner=default:run-scan" -Encoding ASCII
        & $cli "--file=$cliFile" | Out-Host
        Remove-Item $cliFile -Force -ErrorAction SilentlyContinue
        Write-Host "Scanner de déploiement relancé via jboss-cli."
    }
    Write-Host "Ouvrez http://localhost:8080/SoutenaPro/ : l'application est à jour."
}
