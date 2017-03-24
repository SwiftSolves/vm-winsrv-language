<# Custom Script for Windows to install DSIM language #>

param (


    [string]$winservertype,

    [string]$lang


)



New-Item -ItemType Directory c:\temp

#Download needed files from storage blob

Invoke-WebRequest https://ctxlabs.blob.core.windows.net/installs/adksetup.exe -OutFile "c:\temp\adksetup.exe"

$url = "https://ctxlabs.blob.core.windows.net/lps/$winservertype/$lang/lp.cab"

Invoke-WebRequest $url -OutFile "c:\temp\lp.cab"

#Install adk onto VM, this can take some time

Start-Process c:\temp\adksetup.exe -ArgumentList '/installpath "C:\temp\MyTools\mykit" /features + /q' -Wait

#Inject language file into VM

Add-WindowsPackage –Online –PackagePath C:\temp\lp.cab

#Restart VM for language file to be avaliable

Restart-Computer -ComputerName "localhost"