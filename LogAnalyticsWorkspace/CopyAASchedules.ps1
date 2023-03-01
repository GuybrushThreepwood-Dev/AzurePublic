$aaSchedules = @()

$AA = ""
$RG = ""
$sub = ""
$newAA = ""
$newRG = ""
$newSub = ""

#Function to copy the captured schedules
function copyAASchedules{
    param (
      #$newAA,
      #$newRG,
      #$newSub
    )
    #Select the subscription of the Automation Account, Vairables are being copied to
    Select-AzSubscription -subscriptionname $NewSub
    foreach ($aaSchedule in $aaSchedules){
      #Extract the Schedule Details from the list
      $schedName = $aaSchedule.Name
      $schedInterval = $aaSchedule.Interval
      $schedFreq = $aaSchedule.Frequency
      $schedEnabled = $aaSchedule.IsEnabled
      $schedStart = Get-Date "18:00:00"
      $schedTimeZone = $aaSchedule.TimeZone
      $schedEnd = $aaSchedule.ExpiryTime
      $schedMonthlyOptions = $aaSchedule.WeeklyScheduleOptions.DaysOfMonth
      $schedWeeklyOptions = $aaSchedule.WeeklyScheduleOptions.DaysOfWeek
      $schedDescription = $aaSchedule.Description
      #Create new variables in the new Automation Account depending on the Frequency value
      if ($schedFreq -eq "Week"){
      New-AzAutomationSchedule -ResourceGroupName $newRG -AutomationAccountName $newAA -Name $schedName -WeekInterval $schedInterval -DaysOfWeek $schedWeeklyOptions `
      -StartTime $schedStart -ExpiryTime $schedEnd -Description $schedDescription
      }
      elseif ($schedFreq -eq "Month"){
      New-AzAutomationSchedule -ResourceGroupName $newRG -AutomationAccountName $newAA -Name $schedName -MonthInterval $schedInterval -DaysOfMonth $schedMonthlyOptions `
      -StartTime $schedStart -ExpiryTime $schedEnd -Description $schedDescription
      }
      elseif ($schedFreq -eq "Onetime"){
      New-AzAutomationSchedule -ResourceGroupName $newRG -AutomationAccountName $newAA -Name $schedName -OneTime -Timezone $schedTimeZone `
      -StartTime "18:00" -Description $schedDescription
      }
    }
}

#Select the subscription of the Automation Account, Variables are being copied from
Select-AzSubscription -subscriptionname "$sub"

#Get the variables from the automation account being copied from
$aaSchedules = Get-AzAutomationSchedule -ResourceGroupName $RG -AutomationAccountName $AA

#Run the function
copyAASchedules




