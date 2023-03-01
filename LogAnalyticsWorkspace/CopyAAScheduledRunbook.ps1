$aaRBAssoc = @()

$AA = ""
$RG = ""
$sub = ""
$newAA = ""
$newRG = ""
$newSub = ""




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
