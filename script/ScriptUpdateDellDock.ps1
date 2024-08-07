###########################################################

#      Script de detection et MAJ des bases Dell
#                 V2 - DijixH

###########################################################

$ComputerName = $env:computername
$Fabricant = (Get-WmiObject Win32_BIOS).Manufacturer
$Base = @('Dell Docking Station - WD15 Firmware','WD19','WD19S','WD19DCS')
$CibleWD15 = "0001.0000.0009.0000"
$CibleWD19 = '01.00.36.01'

function UpdateWD19 {
    param (

    )
    if ($StationDell.Version -lt $CibleWD19) {
        Write-Host "Version actuelle : "$StationDell.Version
        Write-Host "Version cible : "$CibleWD19
        Write-Host "$((Get-Date).ToString()) - Debut de la mise a jour...."
        Start-Process msiexec.exe -Wait -ArgumentList '/I C:\Temp\DellDockUpdate\UpdateDock\DockWrapper_v1.0.0.msi /quiet DFUPATH="C:\Temp\DellDockUpdate\UpdateDock\DellDockFirmwarePackage_WD19_WD22_Series_HD22_01.00.20.exe" DFUARGS="/s"'
        Write-Host "$((Get-Date).ToString()) - Update termine, desinstallation du Dell Wrapper..."
        $DellApp = Get-WmiObject -Class Win32_Product | Where-Object {$_.name -eq "Dell Dock Firmware Update Package"}
        $DellApp.Uninstall()
        Write-Host "$((Get-Date).ToString()) - Desinstallation fini"
    }
    else {
        Write-Host "Version actuelle : "$StationDell.Version
        Write-Host "$((Get-Date).ToString()) - Station a jour"
    }
}

function UpdateWD15 {
    param (
        
    )
    if ($StationWD15.versionstring -lt $CibleWD15) {
        Write-Host "Version actuelle : "$StationWD15.versionstring
        Write-Host "$((Get-Date).ToString()) - Debut de la mise a jour...."
        Start-Process C:\Temp\DellDockUpdate\UpdateDock\DellDockingStationFwUp_1.0.9_WD15_20210716.exe -Wait -ArgumentList '/s'
        Write-Host "$((Get-Date).ToString()) - Update termine"

    }
    else {
        Write-Host "Version actuelle : "$StationWD15.versionstring
        Write-Host "$((Get-Date).ToString()) - Station a jour"
    }
}
function DellComputer {
    param (
        
    )
    ###########################################################

    #     Verification/Installation Dell Command Monitor

    ###########################################################

    Write-Host "Verification de la presence de Dell Command | Monitor..."

    $DellCMPath = Get-Package 'Dell Command | Monitor' | ForEach-Object { $_.Name }

    if ($DellCMPath -eq 'Dell Command | Monitor') {
        Write-Host "Dell Command Monitor deja present"
    }

    else {
        Write-Host "$((Get-Date).ToString()) - Installation Dell Command Monitor..."
        Start-Process msiexec.exe -Wait -ArgumentList '/I C:\Temp\DellDockUpdate\DellCommandMonitor\Command_Monitor_x64.msi /qn'
        Write-Host "$((Get-Date).ToString()) - Installation de Dell Command Monitor termine"
    }


    ###########################################################

    #     Verification/Installation Dell DSIA

    ###########################################################

    Write-Host "Verification de la presence de Dell DSIA..."

    $DellDSIAPath = Get-Package "Dell Client System Inventory Agent (for Dell Business Client Systems)" | ForEach-Object {$_.Name}

    if ($DellDSIAPath -eq 'Dell Client System Inventory Agent (for Dell Business Client Systems)') {
        Write-Host "Dell DSIA deja present"
    }

    else {
        Write-Host "$((Get-Date).ToString()) - Installation Dell DSIA..."
        Start-Process msiexec.exe -Wait -ArgumentList '/I C:\Temp\DellDockUpdate\DSIA\DSIAPC_5.2.1.2.msi /qn'
        Start-Sleep -Seconds 120
        Write-Host "$((Get-Date).ToString()) - Installation de Dell DSIA termine"
        Write-Host "$((Get-Date).ToString()) - Nouvelle execution du script..."
        Start-Sleep -Seconds 5
        & "C:\Temp\DellDockUpdate\script\ScriptUpdateDellDock_Remote.ps1"
        exit    
    }

    ###########################################################

    #            Script de MAJ des bases Dell

    ###########################################################

    Write-Host "Script de reconaissance et maj des bases Dell"

    $StationDell = Get-CimInstance -Namespace root\dcim\sysman -ClassName DCIM_Chassis | Where-Object -Property CreationClassName -EQ DCIM_DockingStation | Select-Object ElementName, Name, Model, Manufacturer, SerialNumber, Version, Tag
    $StationWD15 = Get-WmiObject -n root\dell\sysinv dell_softwareidentity | Select-Object versionstring, elementname |Sort-Object elementname | Where-Object elementname -like "*WD15*"
    $BaseTest = @($StationDell.Name,$StationWD15.elementname)
    $BaseTest = $BaseTest | Where-Object { $_}

    while ($Base -notcontains $BaseTest){
        Write-Host "$((Get-Date).ToString()) - Attente de connexion d'une base..."
        Start-Sleep -Seconds 300
        $StationDell = Get-CimInstance -Namespace root\dcim\sysman -ClassName DCIM_Chassis | Where-Object -Property CreationClassName -EQ DCIM_DockingStation | Select-Object ElementName, Name, Model, Manufacturer, SerialNumber, Version, Tag
        $StationWD15 = Get-WmiObject -n root\dell\sysinv dell_softwareidentity | Select-Object versionstring, elementname |Sort-Object elementname | Where-Object elementname -like "*WD15*"
        $BaseTest = @($StationDell.Name,$StationWD15.elementname)
        $BaseTest = $BaseTest | Where-Object { $_}

    }

    if ($StationDell.Name -eq 'WD19S') {
        Write-Host "WD19S reconnu"
        Write-Host "Service Tag : " $StationDell.Tag
        UpdateWD19
    }
    elseif ($StationDell.Name -eq 'WD19') {
        Write-Host "WD19 reconnu"
        Write-Host "Service Tag : " $StationDell.Tag
        UpdateWD19
    } 
    elseif ($StationDell.Name -eq 'WD19DCS') {
        Write-Host "WD19DCS reconnu"
        Write-Host "Service Tag : " $StationDell.Tag
        UpdateWD19
    }
    elseif ($StationWD15.elementname -eq 'Dell Docking Station - WD15 Firmware') {
        Write-Host "WD15 reconnu"
        UpdateWD15
    }
    else {
        Write-Host "Aucune base Dell reconnu"
    }

}

function OtherComputer {
    param (
        
    )
    
    Write-Host "Ordinateur $Fabricant"
    Write-Host "Tentative de detection d'une base Dell WD19..."
    Start-Process C:\Temp\DellDockUpdate\UpdateDock\DellDockFirmwarePackage_WD19_WD22_Series_HD22_01.00.20.exe -Wait -ArgumentList "/componentsvers /s /l=C:\Temp\DellDockUpdate\detectWD19.txt"
    $FindDock = Select-String -Path C:\Temp\DellDockUpdate\detectWD19.txt -Pattern "No dock attached"

    if ($null -ne $FindDock)
    {
        Write-Host "Aucune base WD19/WD22 series connecte"
    }
    else
    {
        Write-Host "Base WD19/WD22 series detecte"
        Write-Host "Detection de la version en cours..."
        $FindVersion = Select-String -Path C:\Temp\DellDockUpdate\componentsvers.txt -Pattern $CibleWD19
        $FindBaseModel = Select-String -Path C:\Temp\DellDockUpdate\componentsvers.txt -Pattern "Dock Type"
        $FindServiceTag = Select-String -Path C:\Temp\DellDockUpdate\componentsvers.txt -Pattern "Service Tag"
        $FindFirmware = Select-String -Path C:\Temp\DellDockUpdate\componentsvers.txt -Pattern "Package Version"
        Write-Host "Modele detecte : `n "$FindBaseModel.line" `n "$FindServiceTag.line" `n Version en cours : `n "$FindFirmware.line
        if ($null -ne $FindVersion) {
            Write-Host "Base a jour"
        }
        else {
            Write-Host "Debut de la mise a jour...."
            Start-Process C:\Temp\DellDockUpdate\UpdateDock\DellDockFirmwarePackage_WD19_WD22_Series_HD22_01.00.20.exe -Wait -ArgumentList "/s /l=C:\Temp\DellDockUpdate\logs\DellDockUpdateLogs\logBase_$ComputerName.txt"
            Write-Host "Mise a jour termine"
        }
    }
    Remove-Item C:\Temp\DellDockUpdate\detectWD19.txt
    Remove-Item C:\Temp\DellDockUpdate\componentsvers.txt
}
###########################################################

#     Check admin execution of the script

###########################################################

#Requires -RunAsAdministrator

Start-Transcript -Path C:\Temp\DellDockUpdate\logs\log_$ComputerName-$((Get-Date).ToString('ddMMyyyy-HHmmss')).log -Verbose

Set-Location -Path C:\Temp\DellDockUpdate

if ("Dell Inc." -eq $Fabricant) {
    Write-Host "Ordinateur $Fabricant"
    DellComputer
}
else {
    OtherComputer
}

Stop-Transcript

Start-Sleep -Seconds 5
