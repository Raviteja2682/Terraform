# Set the target subscription
$subscriptionId = "6c03a441-b7a1-4699-917a-f99c751d42e8"
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
