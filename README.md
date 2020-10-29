# PS_Install_Software
Powershell script to install software on a windows 10 machine utilizing chocolatey.
As i hated to always search for the tools i needed and to circumvent the creation of an image but always get the latest version. 
And it should make any windows 10 devices usefull for me i created this script to make my life a bit easier.

Its not intended to solve every issue but just to help me to be quicker up and running. Hopfully you can use this as a startingpoint for creating your own (better) solution
Change the following arrays and fill them with the software you need (or want to remove)

- $Packages
- $WebPIPackages
- $PowershellModules
- $WindowsFeaturePackages
- $Bloatware

For the bloatware list i used https://github.com/Sycnex/Windows10Debloater as a source so credits for Sycnex
