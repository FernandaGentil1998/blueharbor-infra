
param(
    [Parameter(Mandatory = $true)]
    [string]$VMName,

    [int]$CPU = 1,

    [int]$RAM = 1024,

    [Parameter(Mandatory = $true)]
    [string]$ISOPath
)

if (VBoxManage list vms | Select-String "`"$VMName`"") {
    Write-Error "A VM '$VMName' already exists."
    exit 1
}

if (-not (Test-Path $ISOPath)) {
    Write-Error "ISO file not found: $ISOPath"
    exit 1
}

$VMPath = "C:\Users\ferge\VirtualBox VMs\$VMName"

VBoxManage createvm --name $VMName --ostype Ubuntu_64 --register
if ($LASTEXITCODE -ne 0) { exit 1 }

VBoxManage modifyvm $VMName --cpus $CPU --memory $RAM

VBoxManage createmedium disk --filename "$VMPath\$VMName.vdi" --size 20000

VBoxManage storagectl $VMName --name "SATA Controller" --add sata --controller IntelAhci

VBoxManage storageattach $VMName --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$VMPath\$VMName.vdi"

VBoxManage storageattach $VMName --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium $ISOPath

VBoxManage modifyvm $VMName --boot1 dvd --boot2 disk

Write-Host "VM $VMName created successfully."
