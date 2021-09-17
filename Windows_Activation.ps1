# This script creates a folder, exports the results of slmgr to a text file, creates a User-Defined Field for the activation status and then deletes the folder.
# Created by Darkneopulse

mkdir "C:\licensefolder"
cscript C:\Windows\System32\slmgr.vbs /dli > "C:\licensefolder\License.txt"
$Lines = get-content "C:\licensefolder\license.txt"
    foreach ($line in $Lines) {
        if ($line -like "*license Status*"){
            $LicenseStatus = $line
            New-ItemProperty -Path HKLM:\SOFTWARE\CentraStage -Name "Custom1" -PropertyType String -Value "Windows $LicenseStatus" -Force
        }
    }
rmdir "C:\licensefolder" -Recurse
