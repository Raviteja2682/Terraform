provider "azurerm" {
    features {}
    subscription_id= "356b9a2d-84c1-46f4-9ee3-cef6efc992fc"
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

resource "azurerm_management_group_policy_assignment" "RequireTag" {
  name                 = "require-environment-tag"
  display_name         = "Require Environment Tag"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/1e30110a-5ceb-460c-a204-c1c3969c6d62"
  management_group_id  = azurerm_management_group.PMG.id
  description          = "Ensure that the 'Environment' tag is present on all resources."
  parameters = jsonencode({
    tagName = {
      value = "environment"
    }
    tagValue = {
      value = "production" 
    }
  })
}


resource "azurerm_management_group_policy_assignment" "deny_unapproved_resources" {
  name                 = "deny-unapproved-rsrcs"
  display_name         = "Deny Unapproved Resource Types"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749"
  management_group_id  = azurerm_management_group.PMG.id
  description = "Denies creation of resources that are not in the approved list."

  parameters = jsonencode({
    listOfResourceTypesNotAllowed = {
      value = [
        "Microsoft.Network/publicIPAddresses",
      ]
    }
  })
}

resource "azurerm_management_group_policy_assignment" "Storage_accounts_should_disable_public_network_access" {
  name                 = "storagepublicdeny"
  display_name         = "Storage_accounts_should_disable_public_network_access"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b2982f36-99f2-4db5-8eff-283140c09693"
  management_group_id  = azurerm_management_group.PMG.id
  description = "Denies creation of resources that are not in the approved list."

  parameters = jsonencode({
    effect = {
      value = "Deny"
    }
  })
}

resource "azurerm_management_group_policy_assignment" "Audit_usage_of_custom_RBAC_roles" {
  name                 = "Audit usage of custom RBAC roles"
  display_name         = "Audit_usage_of_custom_RBAC_roles"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a451c1ef-c6ca-483d-87ed-f49761e3ffb5"
  management_group_id  = azurerm_management_group.PMG.id
  description = "Audit built-in roles such as 'Owner, Contributer, Reader' instead of custom RBAC roles, which are error prone. Using custom roles is treated as an exception and requires a rigorous review and threat modeling"

  parameters = jsonencode({
    effect = {
      value = "Audit"
    }
  })
}



resource "azurerm_management_group_policy_assignment" "Storage_accounts_should_have_infrastructure_encryption" {
  name                 = "Storage encryption"
  display_name         = "Storage accounts should have infrastructure encryption"
  policy_definition_id = "/providers/microsoft.authorization/policydefinitions/4733ea7b-a883-42fe-8cac-97454c2a9e4a"
  management_group_id  = azurerm_management_group.PMG.id
  description = "Enable infrastructure encryption for higher level of assurance that the data is secure. When infrastructure encryption is enabled, data in a storage account is encrypted twice."

  parameters = jsonencode({
    effect = {
      value = "Audit"
    }
  })
}


resource "azurerm_management_group_policy_assignment" "Subnets_should_be_associated_with_a_Network_Security_Group" {
  name                 = "Subnets Security Group"
  display_name         = "SSubnets should be associated with a Network Security Group"
  policy_definition_id = "/providers/microsoft.authorization/policydefinitions/e71308d3-144b-4262-b144-efdc3cc90517"
  management_group_id  = azurerm_management_group.PMG.id
  description = "Protect your subnet from potential threats by restricting access to it with a Network Security Group (NSG). NSGs contain a list of Access Control List (ACL) rules that allow or deny network traffic to your subnet."

  parameters = jsonencode({
    effect = {
      value = "AuditIfNotExists"
    }
  })
}















