Add-Type -AssemblyName System.Windows.Forms

function Show-CheckboxDialog {
    param (
        [string]$Title,
        [string[]]$Options
    )

    $form = New-Object Windows.Forms.Form
    $form.Text = $Title
    $form.Size = New-Object Drawing.Size(300, 300)
    $form.StartPosition = "CenterScreen"

    $checkedItems = @()
    $y = 10
    $checkboxes = @()

    foreach ($opt in $Options) {
        $cb = New-Object Windows.Forms.CheckBox
        $cb.Text = $opt
        $cb.Location = New-Object Drawing.Point(10, $y)
        $cb.AutoSize = $true
        $form.Controls.Add($cb)
        $checkboxes += $cb
        $y += 25
    }

    $okButton = New-Object Windows.Forms.Button
    $okButton.Text = "確認"
$locationY = $y + 10
$okButton.Location = New-Object System.Drawing.Point(100, $locationY)
    $okButton.Add_Click({
        foreach ($cb in $checkboxes) {
            if ($cb.Checked) { $checkedItems += $cb.Text }
        }
        $form.Close()
    })
    $form.Controls.Add($okButton)
    $form.ShowDialog() | Out-Null
    return $checkedItems
}

$browserChoices = Show-CheckboxDialog -Title "選擇要安裝的瀏覽器" -Options @("Brave", "Firefox", "Chrome")
$officeChoices = Show-CheckboxDialog -Title "選擇要安裝的 Office 工具" -Options @("LibreOffice", "OnlyOffice")
$toolChoices = Show-CheckboxDialog -Title "選擇要安裝的實用工具" -Options @("7-Zip", "Java", "curl")
$driverChoices = Show-CheckboxDialog -Title "是否安裝驅動更新工具" -Options @("Snappy Driver Installer")

foreach ($browser in $browserChoices) {
    switch ($browser) {
        "Brave" {
            Invoke-WebRequest -Uri "https://laptop-updates.brave.com/latest/winx64" -OutFile "$env:TEMP\brave.exe"
            Start-Process "$env:TEMP\brave.exe" -ArgumentList "/silent" -Wait
            Write-Host "Brave 安裝完成"
        }
        "Firefox" {
            Invoke-WebRequest -Uri "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=zh-TW" -OutFile "$env:TEMP\firefox.exe"
            Start-Process "$env:TEMP\firefox.exe" -ArgumentList "/S" -Wait
            Write-Host "Firefox 安裝完成"
        }
        "Chrome" {
            Invoke-WebRequest -Uri "https://dl.google.com/chrome/install/latest/chrome_installer.exe" -OutFile "$env:TEMP\chrome.exe"
            Start-Process "$env:TEMP\chrome.exe" -ArgumentList "/silent /install" -Wait
            Write-Host "Chrome 安裝完成"
        }
    }
}

foreach ($office in $officeChoices) {
    switch ($office) {
        "LibreOffice" {
            Invoke-WebRequest -Uri "https://download.documentfoundation.org/libreoffice/stable/7.6.2/win/x86_64/LibreOffice_7.6.2_Win_x64.msi" -OutFile "$env:TEMP\libre.msi"
            Start-Process "msiexec.exe" -ArgumentList "/i `"$env:TEMP\libre.msi`" /quiet" -Wait
            Write-Host "LibreOffice 安裝完成"
        }
        "OnlyOffice" {
            Invoke-WebRequest -Uri "https://download.onlyoffice.com/install/desktop/windows/distrib/onlyoffice-desktopeditors.exe" -OutFile "$env:TEMP\onlyoffice.exe"
            Start-Process "$env:TEMP\onlyoffice.exe" -ArgumentList "/silent" -Wait
            Write-Host "OnlyOffice 安裝完成"
        }
    }
}

foreach ($tool in $toolChoices) {
    switch ($tool) {
        "7-Zip" {
            Invoke-WebRequest -Uri "https://www.7-zip.org/a/7z2301-x64.exe" -OutFile "$env:TEMP\7z.exe"
            Start-Process "$env:TEMP\7z.exe" -ArgumentList "/S" -Wait
            Write-Host "7-Zip 安裝完成"
        }
        "Java" {
            Invoke-WebRequest -Uri "https://download.oracle.com/java/17/latest/jdk-17_windows-x64_bin.exe" -OutFile "$env:TEMP\java.exe"
            Start-Process "$env:TEMP\java.exe" -ArgumentList "/s" -Wait
            Write-Host "Java 安裝完成"
        }
        "curl" {
            Write-Host "curl 通常已內建於 Windows 10 以上版本，如需更新請至 GitHub Releases"
        }
    }
}

foreach ($driver in $driverChoices) {
    switch ($driver) {
        "Snappy Driver Installer" {
            $sdiZip = "$env:TEMP\sdi.zip"
            Invoke-WebRequest -Uri "https://sdi-tool.org/download/SDI_R2304.zip" -OutFile $sdiZip
            Expand-Archive -Path $sdiZip -DestinationPath "$env:TEMP\sdi" -Force
            Start-Process "$env:TEMP\sdi\SDI_R2304\SDI_x64.exe" -ArgumentList "/autoinstall" -Wait
            Write-Host "驅動更新完成"
        }
    }
}

Write-Host ""
Write-Host "所有選定工具已安裝完畢。儀式結束。"
