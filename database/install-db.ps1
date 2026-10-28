param(
    [string]$User = "root",
    [string]$Password = "",
    [string]$Server = ""
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$project = Split-Path -Parent $root
$driver = "C:\mysql-connector-j-9.1.0\mysql-connector-j-9.1.0.jar"

if (-not (Test-Path $driver)) {
    Write-Host "Connecteur MySQL introuvable : $driver"
    Write-Host "Téléchargez mysql-connector-j et adaptez la variable \$driver."
    exit 1
}

$jdk = $null
foreach ($candidat in @("C:\Program Files\Java\jdk-17", $env:JAVA_HOME)) {
    if ($candidat -and (Test-Path "$candidat\bin\javac.exe")) { $jdk = $candidat; break }
}
if (-not $jdk) { throw "JDK 17 introuvable." }

$tools = Join-Path $project "build\tools"
New-Item -ItemType Directory -Force $tools | Out-Null

Write-Host "Compilation de l'installateur..."
& "$jdk\bin\javac.exe" -encoding UTF-8 -cp $driver -d $tools (Join-Path $root "InstallerBD.java")
if ($LASTEXITCODE -ne 0) { throw "Compilation de l'installateur impossible." }

if ($Server) { $env:SOUTENAPRO_DB_SERVER = $Server }

Write-Host "Installation de la base soutena_pro..."
& "$jdk\bin\java.exe" -cp "$tools;$driver" InstallerBD (Join-Path $root "install.sql") $User $Password
if ($LASTEXITCODE -ne 0) { throw "L'installation de la base a échoué (vérifiez l'utilisateur / mot de passe MySQL)." }
