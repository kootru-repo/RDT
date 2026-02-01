# ============================================================
#  PowerShell FTP Upload Script for Relational Drainage Theory
#  Target: relationaldrainage.org
# ============================================================
#
#  INSTRUCTIONS:
#  1. Copy ftp-credentials.template.txt to ftp-credentials.txt
#  2. Edit ftp-credentials.txt and set your FTP password
#  3. Run: powershell -ExecutionPolicy Bypass -File ftp-upload.ps1
#
# ============================================================

# --- Get script directory ---
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$CredsFile = Join-Path $ScriptDir "ftp-credentials.txt"
$TemplateFile = Join-Path $ScriptDir "ftp-credentials.template.txt"

# --- Check if credentials file exists ---
if (-not (Test-Path $CredsFile)) {
    Write-Host ""
    Write-Host "ERROR: Credentials file not found: $CredsFile" -ForegroundColor Red
    Write-Host "Please copy $TemplateFile to $CredsFile and fill in your password."
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

# --- Load credentials from file ---
$Config = @{}
Get-Content $CredsFile | ForEach-Object {
    if ($_ -match "^\s*([^#][^=]+)=(.*)$") {
        $Config[$matches[1].Trim()] = $matches[2].Trim()
    }
}

$FtpHost = "ftp://$($Config['host'])"
$FtpUser = $Config['username']
$FtpPass = $Config['password']
$RemoteDir = $Config['remote_folder']
$LocalDir = Join-Path $ScriptDir ".."

# --- Check if password is set ---
if ($FtpPass -eq "YOUR_FTP_PASSWORD_HERE") {
    Write-Host ""
    Write-Host "ERROR: Please edit ftp-credentials.txt and set your FTP password." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

# --- Files to upload ---
$FilesToUpload = @(
    @{ Local = "$LocalDir\index.html"; Remote = "$RemoteDir/index.html" },
    @{ Local = "$LocalDir\rdt-playground.html"; Remote = "$RemoteDir/rdt-playground.html" },
    @{ Local = "$LocalDir\css\styles.css"; Remote = "$RemoteDir/css/styles.css" },
    @{ Local = "$LocalDir\css\print.css"; Remote = "$RemoteDir/css/print.css" },
    @{ Local = "$LocalDir\js\main.js"; Remote = "$RemoteDir/js/main.js" }
)

# --- Create credentials ---
$FtpCredentials = New-Object System.Net.NetworkCredential($FtpUser, $FtpPass)

# --- Function to create FTP directory ---
function New-FtpDirectory {
    param([string]$Uri)
    try {
        $FtpRequest = [System.Net.FtpWebRequest]::Create($Uri)
        $FtpRequest.Method = [System.Net.WebRequestMethods+Ftp]::MakeDirectory
        $FtpRequest.Credentials = $FtpCredentials
        $FtpRequest.GetResponse() | Out-Null
        Write-Host "  Created directory: $Uri" -ForegroundColor Green
    }
    catch {
        # Directory might already exist, which is fine
    }
}

# --- Function to upload file ---
function Send-FtpFile {
    param(
        [string]$LocalPath,
        [string]$RemotePath
    )

    $Uri = "$FtpHost/$RemotePath"

    try {
        $FileContent = [System.IO.File]::ReadAllBytes($LocalPath)

        $FtpRequest = [System.Net.FtpWebRequest]::Create($Uri)
        $FtpRequest.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
        $FtpRequest.Credentials = $FtpCredentials
        $FtpRequest.UseBinary = $true
        $FtpRequest.ContentLength = $FileContent.Length

        $RequestStream = $FtpRequest.GetRequestStream()
        $RequestStream.Write($FileContent, 0, $FileContent.Length)
        $RequestStream.Close()

        $Response = $FtpRequest.GetResponse()
        Write-Host "  Uploaded: $LocalPath -> $RemotePath" -ForegroundColor Green
        $Response.Close()
    }
    catch {
        Write-Host "  FAILED: $LocalPath - $($_.Exception.Message)" -ForegroundColor Red
    }
}

# --- Main upload process ---
Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  Uploading RDT website to relationaldrainage.org" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# Create remote directories
Write-Host "Creating directories..." -ForegroundColor Yellow
New-FtpDirectory "$FtpHost/$RemoteDir/css"
New-FtpDirectory "$FtpHost/$RemoteDir/js"
New-FtpDirectory "$FtpHost/$RemoteDir/assets"
Write-Host ""

# Upload files
Write-Host "Uploading files..." -ForegroundColor Yellow
foreach ($File in $FilesToUpload) {
    if (Test-Path $File.Local) {
        Send-FtpFile -LocalPath $File.Local -RemotePath $File.Remote
    }
    else {
        Write-Host "  SKIPPED (not found): $($File.Local)" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  Upload complete!" -ForegroundColor Green
Write-Host "  Visit: https://relationaldrainage.org" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

Read-Host "Press Enter to exit"
