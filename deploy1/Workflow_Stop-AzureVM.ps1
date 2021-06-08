workflow Shutdown-ARM-VMs-Parallel
{

	$SubscriptionId         = Get-AutomationVariable -Name  "aeb44919-96b9-42cf-a108-0cec7dc86b31"
	$TenantID               = Get-AutomationVariable -Name  "42a1205d-ebeb-47bb-bfd5-bcfad63e2353"
	$CredentialAssetName    = Get-AutomationVariable -Name  "Mycredo313"
   
	"CredentialAssetName: $CredentialAssetName"
	#Get the credential with the above name from the Automation Asset store
	$Cred = Get-AutomationPSCredential -Name $CredentialAssetName
	if(!$Cred) {
        Throw "Could not find an Automation Credential Asset named '${CredentialAssetName}'. Make sure you have created one in this Automation Account."
    }

    #Connect to your Azure Account
	$Account = Login-AzureRmAccount -Credential $Cred -TenantId $TenantID -ServicePrincipal 
    
	$subscription = Get-AzureRmSubscription | Where-Object {$_.Id -eq $SubscriptionId} | Set-AzureRmContext

	$vms = Get-AzureRmVM
		
	Foreach -Parallel ($vm in $vms){
	    Write-Output "Stopping $($vm.Name)"
	    Stop-AzureRmVm -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -Force
	}
}
