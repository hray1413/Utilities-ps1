function Show-Menu {
    param (
        [string]$Title,
        [string[]]$Options
    )
    Write-Host "`n🔸 $Title"
    for ($i = 0; $i -lt $Options.Length; $i++) {
        Write-Host "[$($i+1)] $($Options[$i])"
    }
    $choice = Read-Host "請輸入選項編號（可多選，用逗號分隔）"
    return $choice -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^\d+$' }
}

# 🌐 Browser 選單
$browserOptions = @("Brave", "Firefox", "Chrome")
$browserChoices = Show-Menu -Title "選擇要安裝的瀏覽器：" -Options $browserOptions

# 📄 Office 選單
$officeOptions = @("LibreOffice", "OnlyOffice")
$officeChoices = Show-Menu -Title "選擇要安裝的 Office 工具：" -Options $officeOptions

# 🛠️ 工具選單
$toolOptions = @("7-Zip", "Java", "curl")
$toolChoices = Show-Menu -Title "選擇要安裝的實用工具：" -Options $toolOptions

# 🔧 驅動更新選單
$driverOptions = @("Snappy Driver Installer")
$driverChoices = Show-Menu -Title "是否安裝驅動更新工具？" -Options $driverOptions

# 🌐 安裝瀏覽器
foreach ($i in $browserChoices) {
    switch ($browserOptions[$i - 1]) {
        "Brave" {
            Invoke-WebRequest -Uri "https://laptop-updates.brave.com/latest/winx64" -OutFile "$env:TEMP\brave.exe"
            Start-Process "$env:TEMP\brave.exe" -ArgumentList "/silent" -Wait
            Write-Host "🌐 Brave 安裝完成"
        }
        "Firefox" {
            Invoke-WebRequest -Uri "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=zh-TW" -OutFile "$env:TEMP\firefox.exe"
            Start-Process "$env:TEMP\firefox.exe" -ArgumentList "/S" -Wait
            Write-Host "🌐 Firefox 安裝完成"
        }
        "Chrome" {
            Invoke-WebRequest -Uri "https://dl.google.com/chrome/install/latest/chrome_installer.exe" -OutFile "$env:TEMP\chrome.exe"
            Start-Process "$env:TEMP\chrome.exe" -ArgumentList "/silent /install" -Wait
            Write-Host "🌐 Chrome 安裝完成"
        }
    }
}

# 📄 安裝 Office 工具
foreach ($i in $officeChoices) {
    switch ($officeOptions[$i - 1]) {
        "LibreOffice" {
            Invoke-WebRequest -Uri "https://download.documentfoundation.org/libreoffice/stable/7.6.2/win/x86_64/LibreOffice_7.6.2_Win_x64.msi" -OutFile "$env:TEMP\libre.msi"
            Start-Process "msiexec.exe" -ArgumentList "/i `"$env:TEMP\libre.msi`" /quiet" -Wait
            Write-Host "📄 LibreOffice 安裝完成"
        }
        "OnlyOffice" {
            Invoke-WebRequest -Uri "https://download.onlyoffice.com/install/desktop/windows/distrib/onlyoffice-desktopeditors.exe" -OutFile "$env:TEMP\onlyoffice.exe"
            Start-Process "$env:TEMP\onlyoffice.exe" -ArgumentList "/silent" -Wait
            Write-Host "📄 OnlyOffice 安裝完成"
        }
    }
}

# 🛠️ 安裝工具
foreach ($i in $toolChoices) {
    switch ($toolOptions[$i - 1]) {
        "7-Zip" {
            Invoke-WebRequest -Uri "https://www.7-zip.org/a/7z2301-x64.exe" -OutFile "$env:TEMP\7z.exe"
            Start-Process "$env:TEMP\7z.exe" -ArgumentList "/S" -Wait
            Write-Host "🛠️ 7-Zip 安裝完成"
        }
        "Java" {
            Invoke-WebRequest -Uri "https://download.oracle.com/java/17/latest/jdk-17_windows-x64_bin.exe" -OutFile "$env:TEMP\java.exe"
            Start-Process "$env:TEMP\java.exe" -ArgumentList "/s" -Wait
            Write-Host "☕ Java 安裝完成"
        }
        "curl" {
            Write-Host "🛠️ curl 通常已內建於 Windows 10+，如需更新請至 GitHub Releases"
        }
    }
}

# 🔧 安裝驅動更新工具
foreach ($i in $driverChoices) {
    switch ($driverOptions[$i - 1]) {
        "Snappy Driver Installer" {
            $sdiZip = "$env:TEMP\sdi.zip"
            Invoke-WebRequest -Uri "https://sdi-tool.org/download/SDI_R2304.zip" -OutFile $sdiZip
            Expand-Archive -Path $sdiZip -DestinationPath "$env:TEMP\sdi" -Force
            Start-Process "$env:TEMP\sdi\SDI_R2304\SDI_x64.exe" -ArgumentList "/autoinstall" -Wait
            Write-Host "🔧 驅動更新完成"
        }
    }
}

Write-Host "`n✨ Goblin 儀式完成，所有選定工具已安裝！"
