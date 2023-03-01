$lawTables = @()

$Sub = Read-Host "Enter Subscription Name"
$RG = Read-Host "Enter ResourceGroup Name"
$LAW = Read-Host "Enter Log Analytics Workspace Name"
$retDays = 1
$retDaysTotal = 2556 #7 years. This value set, allows for archiving for Table data over $retDays until the Total days


function applyRetention{
    param (
      #$RG,
      #$LAW,
      #$lawTables
      #$retDays,
      #$retDaysTotal
    )
    foreach ($lawTable in $lawTables){
      #Extract the Schedule Details from the list
      $TableName = $lawTable.Name
      #Update Log Analytics Workspace Table retention rule
      Update-AzOperationalInsightsTable -ResourceGroupName $RG -WorkspaceName $LAW -TableName $TableName -RetentionInDays $retDays #-TotalRetentionInDays $retDaysTotal
    }
}

#Select the subscription of the Log Analytics Workspace
Select-AzSubscription -subscriptionname "$Sub"

#Get the list of Tables within the Log Analytics Workspace
$lawTables = Get-AzOperationalInsightsTable -ResourceGroupName $RG -WorkspaceName $LAW

applyRetention