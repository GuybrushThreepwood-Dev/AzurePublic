$aaRBAssoc = @()

$AA = "AA-EUW-PRD"
$RG = "RG-EUW-PRD-OMS"
$sub = "Mazars UK - CSP"
$newAA = "aa-ops-prd-mgmt-ukso-01"
$newRG = "rg-ops-prd-mgmt-ukso-01"
$newSub = "muk-management-001"




function copyAAScheduleRb{
    param (
      $newAA,
      $newRG,
      $newSub
    )
    #Select the subscription of the Automation Account, Vairables are being copied to
    #Select-AzSubscription -subscriptionname "$NewSub"
    foreach ($aaRbAssoc in $aaRbAssocs){
      #Extract the Schedule Details from the list
      $rbName = $aaRBAssoc.RunbookName
      $rbSched = $aaRBAssoc.ScheduleName
      #Create new variables in the new Automation Account
      Register-AzAutomationScheduledRunbook -ResourceGroupName $newRG -AutomationAccountName $newAA -ScheduleName $rbSched -RunbookName $rbName
    }
}



$aaRBAssocs = Get-AzAutomationScheduledRunbook -ResourceGroupName $RG -AutomationAccountName $AA


copyAAScheduleRb