# Import the ImageBuilder module (ensure it's already imported in Azure Automation Modules)
Import-Module Az.ImageBuilder -ErrorAction Stop

# Use system-assigned managed identity to login
Connect-AzAccount -Identity

# Set context to the desired subscription
$subscriptionId = "c28040d2-c232-4150-8299-a9fe33fa6aa1"
Set-AzContext -SubscriptionId $subscriptionId

# Define parameters
$resourceGroupName = "Ravi"
$templateName = "SandyImagetemp"

# Start the image builder template
Start-AzImageBuilderTemplate -ResourceGroupName $resourceGroupName -Name $templateName

Write-Output "✅ Image build initiated successfully for template: $templateName"
