# Set the target subscription
$subscriptionId = "c28040d2-c232-4150-8299-a9fe33fa6aa1"
Set-AzContext -SubscriptionId $subscriptionId

# Define the tag keys to remove
$tagsToRemove = @("BU", "SBU")

# Get all resource groups in the subscription
$resourceGroups = Get-AzResourceGroup

foreach ($rg in $resourceGroups) {
    Write-Host "Processing Resource Group: $($rg.ResourceGroupName)" -ForegroundColor Yellow

    $existingTags = $rg.Tags
    if ($existingTags) {
        foreach ($tagKey in $tagsToRemove) {
            if ($existingTags.ContainsKey($tagKey)) {
                $existingTags.Remove($tagKey)
            }
        }
        Set-AzResourceGroup -Name $rg.ResourceGroupName -Tag $existingTags
        Write-Host "Updated RG: $($rg.ResourceGroupName)" -ForegroundColor Green
    }

    # Get all resources in the resource group
    $resources = Get-AzResource -ResourceGroupName $rg.ResourceGroupName

    foreach ($resource in $resources) {
        Write-Host "Processing Resource: $($resource.Name)" -ForegroundColor Cyan

        $resTags = $resource.Tags
        if ($resTags) {
            foreach ($tagKey in $tagsToRemove) {
                if ($resTags.ContainsKey($tagKey)) {
                    $resTags.Remove($tagKey)
                }
            }
            Set-AzResource -ResourceId $resource.ResourceId -Tag $resTags -Force
            Write-Host "Updated resource: $($resource.Name)" -ForegroundColor Green
        }
    }
}
