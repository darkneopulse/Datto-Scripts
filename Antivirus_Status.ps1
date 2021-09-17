# This script finds the first instance of the running and up to date antivirus and overwrites the Datto RMM Antivirus File
# This script is provided as is, and I assume no responsibility for any damages caused by it.
# Created by Darkneopulse

$Antivirus = Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntivirusProduct
$RunningAV = $Antivirus | where-object {$_.productstate -eq "397568"}
if ($RunningAV -ne $Null) {
    $FirstAV = $RunningAV | select-object -First 1
    $AVName = $FirstAV.displayName
    $UpdateStatus = "true"
    $RealTimeProtectionStatus = "true"
}
elseif ($RunningAV -eq $Null) {
    $FirstAV = $Antivirus | select-object -First 1
    $AVName = $FirstAV.displayname
    switch ($FirstAV.productState) { 
        "262144" {$UpdateStatus = "true" ;$RealTimeProtectionStatus = "false"} 
        "262160" {$UpdateStatus = "false" ;$RealTimeProtectionStatus = "false"} 
        "266240" {$UpdateStatus = "true" ;$RealTimeProtectionStatus = "true"} 
        "266256" {$UpdateStatus = "false" ;$RealTimeProtectionStatus = "true"} 
        "393216" {$UpdateStatus = "true" ;$RealTimeProtectionStatus = "false"} 
        "393232" {$UpdateStatus = "false" ;$RealTimeProtectionStatus = "false"} 
        "393488" {$UpdateStatus = "false" ;$RealTimeProtectionStatus = "false"} 
        "397312" {$UpdateStatus = "true" ;$RealTimeProtectionStatus = "true"} 
        "397328" {$UpdateStatus = "false" ;$RealTimeProtectionStatus = "true"} 
        "397584" {$UpdateStatus = "false" ;$RealTimeProtectionStatus = "true"} 
        "397568" {$UpdateStatus = "true"; $RealTimeProtectionStatus = "true"}
        "393472" {$UpdateStatus = "true" ;$RealTimeProtectionStatus = "false"}
    default {$UpdateStatus = "Unknown" ;$RealTimeProtectionStatus = "Unknown"} 
    }
}
    else {
    $AVName = "Unknown"
    $UpdateStatus = "Unknown"
    $RealTimeProtectionStatus = "Unknown"
}
$Product = "{""product"":""$AVName"""
$running = """running"":$RealTimeProtectionStatus"
$Status = """upToDate"":$UpdateStatus}"
$AVOutput = $Product, $running, $status -join ","
$AVOutput | out-file C:\ProgramData\CentraStage\AEMAgent\antivirus.json
