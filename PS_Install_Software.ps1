# Geephile's NewRig Installscript
#
# Install and deinstall software to be up and running asap
#

#Install Chocolatey for speed installation of all essential software
(New-Object System.Net.WebClient).Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials

$chocolateyBin = [Environment]::GetEnvironmentVariable("ChocolateyInstall", "Machine") + "\bin"
$Choco1stInstall = $false

if(-not (Test-Path $chocolateyBin)) {
    $Choco1stInstall = $true
    Write-Output "Environment variable 'ChocolateyInstall' was not found in the system variables. Attempting to find it in the user variables..."
    $chocolateyBin = [Environment]::GetEnvironmentVariable("ChocolateyInstall", "User") + "\bin"
}

$cinst = "$chocolateyBin\cinst.exe"
$choco = "$chocolateyBin\choco.exe"

if (-not (Test-Path $cinst) -or -not (Test-Path $choco)) {
    Write-Output "Chocolatey was not found at $chocolateyBin."
    Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}


Choco feature enable -n allowGlobalConfirmation

#Arrays filled with software to in or even uninstall

$Packages = @(  '7zip', 
                'displaylink', 
                'microsoft-edge', 
                'nextcloud-client', 
                'vscode', 
                'windbg',
                'citrix-workspace',
                'vcredist-all',
                'adobereader',
                'lavfilters',
                'lessmsi',
                'orca',
                'patchcleaner',
                'putty',
                'spotify',
                'Signal',
                'teamviewer',
                'webpicmd',
                #'wixedit',
                'winscp', 
                'Whatsapp',
                'yubikey-manager',
                'microsoft-teams',
                'Outlookcaldav',
                'visualstudio2019community'
            )

$WebPIPackages = @( 'NetFx3', 
            'NetFx4'            
        )

$PowershellModules = @( 'AzureAD',
                        'MSOLOnline',
                        'Intune.HV.Tools'            
                )

$WindowsFeaturePackages = @(    'Microsoft-Windows-Subsystem-Linux', 
                                'Windows-Defender-Default-Definitions', 
                                'Microsoft-Hyper-V-All', 
                                'WindowsMediaPlayer'
                            )
                            
$Bloatware = @( #Unnecessary Windows 10 AppX Apps
                "Microsoft.BingNews"
                "Microsoft.GetHelp"
                "Microsoft.Getstarted"
                #"Microsoft.Messaging"
                "Microsoft.Microsoft3DViewer"
                "Microsoft.MicrosoftOfficeHub"
                "Microsoft.MicrosoftSolitaireCollection"
                "Microsoft.NetworkSpeedTest"
                "Microsoft.News"
                "Microsoft.Office.Lens"
                "Microsoft.Office.OneNote"
                "Microsoft.Office.Sway"
                "Microsoft.OneConnect"
                "Microsoft.People"
                "Microsoft.Print3D"
                "Microsoft.RemoteDesktop"
                "Microsoft.SkypeApp"
                "Microsoft.StorePurchaseApp"
                "Microsoft.Office.Todo.List"
                #"Microsoft.Whiteboard"
                "Microsoft.WindowsAlarms"
                #"microsoft.windowscommunicationsapps" Contains Mail
                "Microsoft.WindowsMaps"
                "Microsoft.WindowsSoundRecorder"
                "Microsoft.Xbox.TCUI"
                "Microsoft.XboxApp"
                "Microsoft.XboxGameOverlay"
                "Microsoft.XboxIdentityProvider"
                "Microsoft.XboxSpeechToTextOverlay"
                "Microsoft.ZuneMusic"
                "Microsoft.ZuneVideo"
                        
                #Sponsored Windows 10 AppX Apps
                #Add sponsored/featured apps to remove in the "*AppName*" format
                "*EclipseManager*"
                "*ActiproSoftwareLLC*"
                "*AdobeSystemsIncorporated.AdobePhotoshopExpress*"
                "*Duolingo-LearnLanguagesforFree*"
                "*PandoraMediaInc*"
                "*CandyCrush*"
                "*Wunderlist*"
                "*Flipboard*"
                "*Twitter*"
                "*Facebook*"
                "*Spotify*"
                "*Minecraft*"
                "*Royal Revolt*"
                "*Sway*"
                "*Speed Test*"
                "*Dolby*"
                "*Microsoft.BingWeather*"
                )

 
# Only installing at first run
If ($Choco1stInstall -eq $true) {
    ForEach ($PackageName in $WebPIPackages){Choco Install $PackageName -source webpi}
    ForEach ($PackageName in $WindowsFeaturePackages){Choco Install $PackageName -source windowsfeatures}
    foreach ($Bloat in $Bloatware) {
        Get-AppxPackage -Name $Bloat| Remove-AppxPackage
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Bloat | Remove-AppxProvisionedPackage -Online
        Write-Output "Trying to remove $Bloat."
    }
    Choco upgrade Office365ProPlus 
}

#Install needed Powershell modules
ForEach ($Module in $PowershellModules){
    Set-PSRepository -Name PSgallery -InstallationPolicy Trusted
    Install-Module $Module
}

#Installing/Upgrading every run
ForEach ($PackageName in $Packages){Choco Upgrade $PackageName}




