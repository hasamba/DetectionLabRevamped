# Purpose: Installs chocolatey package manager, then installs custom utilities from Choco.

If (-not (Test-Path "C:\ProgramData\chocolatey")) {
  $env:ChocolateyVersion='1.4.0'; iex ((New-Object Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

} else {
  Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Chocolatey is already installed."
}

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Installing utilities..."
If ($(hostname) -eq "win10") {
  # Because the Windows10 start menu sucks
  choco install -y --limit-output --no-progress classic-shell -installArgs ADDLOCAL=ClassicStartMenu
  & "C:\Program Files\Classic Shell\ClassicStartMenu.exe" "-xml" "c:\vagrant\resources\windows\MenuSettings.xml"
  regedit /s c:\vagrant\resources\windows\MenuStyle_Default_Win7.reg
}
choco install -y --limit-output --no-progress NotepadPlusPlus WinRar processhacker

# This repo often causes failures due to incorrect checksums, so we ignore them for Chrome
choco install -y --limit-output --no-progress --ignore-checksums GoogleChrome 

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Utilties installation complete!"
