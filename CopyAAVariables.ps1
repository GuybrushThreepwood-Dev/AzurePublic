$aaVars = @()

$AA = "AA-EUW-PRD"
$RG = "RG-EUW-PRD-OMS"
$newAA = "aa-ops-prd-mgmt-ukso-01"
$newRG = "rg-ops-prd-mgmt-ukso-01"
$sub = "Mazars UK - CSP"
$newSub = "muk-management-001"

function copyAAVariables{
    param (
      #$newAA,
      #$newRG,
      #$newSub
    )
    #Select the subscription of the Automation Account, Vairables are being copied to
    Select-AzSubscription -subscriptionname "$NewSub"
    foreach ($aaVar in $aaVars){
      #Extract the Vairable Name and value from the list
      $varName = $aaVar.Name
      $varValue = $aaVar.Value
      #Create new variables in the new Automation Account
      New-AzAutomationVariable -ResourceGroupName $newRG -AutomationAccountName $newAA -Name $varName -Encrypted $false -Value $varValue
      Write-Host "New Variable to be added $varName"
    }
}


#Select the subscription of the Automation Account, Variables are being copied from
Select-AzSubscription -subscriptionname "$sub"

#Get the variables from the automation account being copied from
$aaVars = Get-AzAutomationVariable -ResourceGroupName $RG -AutomationAccountName $AA

#Run the function with the data captured above
copyAAVariables