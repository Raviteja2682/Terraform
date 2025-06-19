# Set the target subscription
$subscriptionId = "70c26b10-cb3a-45ae-934b-b9bae43abee8"
Set-AzContext -SubscriptionId $subscriptionId

# Get all resource groups in the subscription
$resourceGroups = Get-AzResourceGroup

foreach ($rg in $resourceGroups) {
    Write-Host "Removing tags from Resource Group: $($rg.ResourceGroupName)" -ForegroundColor Yellow

    # Remove tags from the resource group
    Set-AzResourceGroup -Name $rg.ResourceGroupName -Tag @{}

    # Get all resources in the resource group
    $resources = Get-AzResource -ResourceGroupName $rg.ResourceGroupName

    foreach ($resource in $resources) {
        Write-Host "Removing tags from Resource: $($resource.Name)" -ForegroundColor Cyan

        # Remove all tags from the resource
        Set-AzResource -ResourceId $resource.ResourceId -Tag @{} -Force
    }
}
