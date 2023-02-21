<#
    Powershell installer
    This script is invoked by a separate script "deployApplication.ps1 that identifies devices to run on
    This script will access a file from a storage container and run/install it using a pre-generated SAS URL
#>

#Variables
$VmOsName = $env:COMPUTERNAME
$sasURL = "" #Enter a generated SAS URL here
$serviceName = "" #Enter the name of the applications service, if applicable
$log = "C:\Windows\Logs\Agent_install.log" #Recommended to edit and add the application name
#Compile the Nessus arguments 
$execArgList = ""; #Application install argmaents can be added here


#Check the existence of the service
$service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
if ($service.Status -eq "Running" -or $service.Status -eq "Stopped")
{
    Write-Host "Agent is already installed on $VmOsName. Exiting the installer"
}
else {
    #Run the installer
    Write-Host "Agent will be installed on $VmOsName"
    Start-Process msiexec.exe "/i $sasURL $execArgList /qn /l*v $log" -wait
    #Check the service for install status
    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    if ($service.Status -eq "Running") {
        Write-Host "Agent installed on $VmOsName"  
    }
    elseif ($service.status -eq "Stopped") {
        Write-Host "Agent installed on $VmOsName but the service is stopped" 
    }
    else {
        Write-Host "Agent install failed on $VmOsName" 
    }
}
