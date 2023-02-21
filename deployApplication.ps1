<#
    Deployment script
#>

#Clear Variables
$vmNames = @{}
$vms = @{}

#Vairables
$subscription = Read-Host "Enter the Subscription Name of where the VMs deploying to are"
$csvPath = Read-Host "Enter the CSV file path and name"
$outfilepath = Read-Host "Enter the output file path and name"
$runCommandScript = "runCommand.ps1"
$runCommandPath = ".\" #It's expected the 2 scripts are kept together
$runCommand = $runCommandPath + $runCommandScript

function ConnectToAzure {
    Connect-AZAccount
    Set-AZContext -Subscription $subscription
}

function RunCommand {
            #Clear Output
            $output = @{}
            #Set context to the sub the application is being deployed to
            Set-AZContext -subscription $subscription
            $azVMs = Get-AzVM -status | Where {$_.StorageProfile.OsDisk.OsType -eq "Windows"-and $_.PowerState -eq "VM Running"}
            foreach ($azVM in $azVMs) {
            try {
            $azVMName = $azVM.Name#."VM Name"
            $azVMRG = $azVM.ResourceGroupName#$_."ResourceGroup"
            #Execute Run Command
            $command = Invoke-AzVMRunCommand `
                -ResourceGroupName $azVMRG `
                -Name $azVMName `
                -CommandId  'RunPowerShellScript' `
                -ScriptPath $runCommand
            #Setup an output for script feedback
            $output = $command.Value[0].Message
            #Output to console
            $output
            #Output to file
            $output | Out-File -filepath $outfilepath -Append
            }
        catch {
            <#Do this if a terminating exception happens#>
            Write-Host "$azVMName can't be found. Please check the name used in the .csv, or if the VM exists"
            Write-Output "$azVMName can't be found. Please check the name used in the .csv, or if the VM exists" | Out-File -filepath $outfilepath -Append
        }
    }
}


# Main Function handler - Select PS console type and run required functions
Write-Host "Locally"
Write-Host "Azure Cloud Shell"
$PSConsoleEnv = Read-Host "How are you running this PowerShell script?"

    switch ($PSConsoleEnv) {
        'Locally' {
            Write-Host "User selected local PS console"
            ConnectToAzure
            RunCommand
            Continue
        }
        'Azure Cloud Shell' {
            Write-Host "User selected Azure Cloud Shell"
            RunCommand
            Continue
        }
    }
