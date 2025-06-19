# Set the target subscription
$subscriptionId = "f84313aa-da60-4b45-be6d-4591b3c91113"
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
