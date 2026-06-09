Add-Type -AssemblyName System.IO.Compression.FileSystem

$DIR = "D:\claude\1107"
$zipPath = "$env:TEMP\1107-site.zip"

Write-Host "1/3 Packing site..." -ForegroundColor Yellow
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
[System.IO.Compression.ZipFile]::CreateFromDirectory($DIR, $zipPath)
Write-Host "  Done: $((Get-Item $zipPath).Length) bytes" -ForegroundColor Green

Write-Host "2/3 Creating Netlify site..." -ForegroundColor Yellow
$site = Invoke-RestMethod -Uri "https://api.netlify.com/api/v1/sites" -Method Post -Body "{}" -ContentType "application/json"
Write-Host "  Site ID: $($site.id)" -ForegroundColor Green

Write-Host "3/3 Deploying..." -ForegroundColor Yellow
$deploy = Invoke-RestMethod -Uri "https://api.netlify.com/api/v1/sites/$($site.id)/deploys" -Method Post -InFile $zipPath -ContentType "application/zip"
Write-Host "  Status: $($deploy.state)" -ForegroundColor Green

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  Site live at: $($deploy.ssl_url)" -ForegroundColor Yellow
Write-Host "======================================" -ForegroundColor Cyan
