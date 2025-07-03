provider "azurerm" {
    features {}
    subscription_id= "c28040d2-c232-4150-8299-a9fe33fa6aa1"
    resource_provider_registrations = "none"
}


resource "azurerm_management_group" "PMG" {
    display_name = "PlatformMG"
    
  
}

resource "azurerm_management_group" "HUBMG" {
    display_name = "HUBMG"
    parent_management_group_id = azurerm_management_group.PMG.id

}

resource "azurerm_management_group" "LZMG" {
    display_name = "LANDINGZONEMG"
    parent_management_group_id = azurerm_management_group.PMG.id
}


    resource "azurerm_management_group" "MGMTMG" {
    display_name = "MANAGEMENTMG"
    parent_management_group_id = azurerm_management_group.PMG.id
}

resource "azurerm_management_group_policy_assignment" "Locationpolicy" {
    name = "Allowed_Locations"
    display_name = "Allowed Locations for PMG"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
    management_group_id = azurerm_management_group.PMG.id
    parameters = jsonencode({
        listofAllowedLocations = {
            value = ["centralindia"]
        }
    }) 
}