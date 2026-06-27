$ErrorActionPreference = "Stop"

function Require-Env {
    param(
        [string]$Name,
        [string]$Message
    )

    $Value = [Environment]::GetEnvironmentVariable($Name)
    if ([string]::IsNullOrWhiteSpace($Value)) {
        Write-Error "CRITICAL: $Name is empty. $Message"
        exit 1
    }

    return $Value
}

function Get-BoolEnv {
    param(
        [string]$Name,
        [bool]$Default
    )

    $Value = [Environment]::GetEnvironmentVariable($Name)
    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $Default
    }

    switch ($Value.Trim().ToLowerInvariant()) {
        "1" { return $true }
        "true" { return $true }
        "yes" { return $true }
        "on" { return $true }
        "0" { return $false }
        "false" { return $false }
        "no" { return $false }
        "off" { return $false }
        default { return $Default }
    }
}

$InstallDir = if ($env:INSTALL_DIR) { $env:INSTALL_DIR } else { "C:\serverfiles" }
$Branch = if ($env:BRANCH) { $env:BRANCH } else { "production" }
$Database = if ($env:DATABASE) { $env:DATABASE } else { "Remote" }
$GamePort = if ($env:GAME_PORT) { $env:GAME_PORT } else { "7777" }
$QueryPort = if ($env:QUERY_PORT) { $env:QUERY_PORT } else { "27015" }
$RconPort = if ($env:RCON_PORT) { $env:RCON_PORT } else { "37015" }
$RconPassword = if ($env:RCON_PASSWORD) { $env:RCON_PASSWORD } else { "" }
$ServerName = if ($env:SERVER_NAME) { $env:SERVER_NAME } else { "Path of Titans Server" }
$GameLogPath = if ($env:GAME_LOG_PATH) { $env:GAME_LOG_PATH } else { Join-Path $InstallDir "PathOfTitans\Saved\Logs\PathOfTitansServer-GSA.log" }
$ExtraArgs = if ($env:EXTRA_ARGS) { $env:EXTRA_ARGS } else { "" }
$UpdateOnStart = Get-BoolEnv -Name "POT_UPDATE_ON_START" -Default $true

$ServerGuid = Require-Env -Name "SERVER_GUID" -Message "Set this from {helper.uuid} or a fixed server GUID."

New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $GameLogPath) | Out-Null

$AlderonCmd = Join-Path $InstallDir "AlderonGamesCmd-Win64.exe"
$ServerExe = Join-Path $InstallDir "PathOfTitans\Binaries\Win64\PathOfTitansServer-Win64-Shipping.exe"

if ($UpdateOnStart -or -not (Test-Path -LiteralPath $ServerExe)) {
    $AuthToken = Require-Env -Name "AG_AUTH_TOKEN" -Message "Set this from your GSA auth_token parameter."

    if (-not (Test-Path -LiteralPath $AlderonCmd)) {
    Write-Host "*** Downloading AlderonGamesCmd-Win64.exe"
    Invoke-WebRequest `
        -Uri "https://launcher-cdn.alderongames.com/AlderonGamesCmd-Win64.exe" `
        -OutFile $AlderonCmd `
        -UseBasicParsing
    }

    Write-Host "*** Updating Path of Titans server files"
    & $AlderonCmd `
        --game path-of-titans `
        --server true `
        --beta-branch $Branch `
        --auth-token $AuthToken `
        --install-dir $InstallDir

    if ($LASTEXITCODE -ne 0) {
        Write-Error "AlderonGamesCmd failed with exit code $LASTEXITCODE"
        exit $LASTEXITCODE
    }
}
else {
    Write-Host "*** Skipping Path of Titans update because POT_UPDATE_ON_START is disabled and server files already exist"
}

if (-not (Test-Path -LiteralPath $ServerExe)) {
    Write-Error "Path of Titans server executable was not found at $ServerExe"
    exit 1
}

$ServerArgs = @(
    "-Port=$GamePort",
    "-BranchKey=$Branch",
    "-log",
    "-ServerGUID=$ServerGuid",
    "-Database=$Database",
    "-ServerName=$ServerName",
    "-QueryPort=$QueryPort",
    "-QueryIP=0.0.0.0",
    "-RconPort=$RconPort",
    "-RconIP=0.0.0.0",
    "-MULTIHOME=0.0.0.0"
)

if (-not [string]::IsNullOrWhiteSpace($RconPassword)) {
    $ServerArgs += "-RconPassword=$RconPassword"
}

if (-not [string]::IsNullOrWhiteSpace($ExtraArgs)) {
    $ServerArgs += ($ExtraArgs -split " ")
}

Write-Host "*** Starting Path of Titans server"
Write-Host ("*** Args: " + ($ServerArgs -join " "))
Write-Host "*** Game log: $GameLogPath"

@(
    ""
    "============================================================"
    "Path of Titans server start: $(Get-Date -Format o)"
    "Executable: $ServerExe"
    "Args: $($ServerArgs -join ' ')"
    "============================================================"
) | Add-Content -LiteralPath $GameLogPath -Encoding UTF8

& $ServerExe @ServerArgs 2>&1 | Tee-Object -FilePath $GameLogPath -Append

$ExitCode = $LASTEXITCODE
Write-Host "*** Path of Titans server exited with code $ExitCode"
"Path of Titans server exit: $(Get-Date -Format o) code=$ExitCode" | Add-Content -LiteralPath $GameLogPath -Encoding UTF8
exit $ExitCode
