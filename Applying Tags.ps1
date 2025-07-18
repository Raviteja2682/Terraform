# Set the target subscription
$subscriptionId = "70c26b10-cb3a-45ae-934b-b9bae43abee8"
Set-AzContext -SubscriptionId $subscriptionId

# Define the tags to apply
$tags = @{
    "BU" = "Naukari"
    "SBU"  = ""
}

# Get all resource groups in the subscription
$resourceGroups = Get-AzResourceGroup

foreach ($rg in $resourceGroups) {
    Write-Host "Tagging Resource Group: $($rg.ResourceGroupName)" -ForegroundColor Yellow
    
    # Merge existing and new tags
    $existingTags = $rg.Tags
    if (-not $existingTags) { $existingTags = @{} }

    foreach ($key in $tags.Keys) {
        $existingTags[$key] = $tags[$key]
    }

    # Apply tags to resource group
    Set-AzResourceGroup -Name $rg.ResourceGroupName -Tag $existingTags

    # Get all resources in the resource group
    $resources = Get-AzResource -ResourceGroupName $rg.ResourceGroupName

    foreach ($resource in $resources) {
        Write-Host "Tagging resource: $($resource.Name)" -ForegroundColor Cyan

        $existingResTags = $resource.Tags
        if (-not $existingResTags) { $existingResTags = @{} }

        foreach ($key in $tags.Keys) {
            $existingResTags[$key] = $tags[$key]
        }

        # Apply tags to resource
        Set-AzResource -ResourceId $resource.ResourceId -Tag $existingResTags -Force
    }
}
