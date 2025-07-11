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
  name                 = "AuditRBACroles"
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
  name                 = "SubnetsSecurityGroup"
  display_name         = "Subnets should be associated with a Network Security Group"
  policy_definition_id = "/providers/microsoft.authorization/policydefinitions/e71308d3-144b-4262-b144-efdc3cc90517"
  management_group_id  = azurerm_management_group.PMG.id
  description = "Protect your subnet from potential threats by restricting access to it with a Network Security Group (NSG). NSGs contain a list of Access Control List (ACL) rules that allow or deny network traffic to your subnet."

  parameters = jsonencode({
    effect = {
      value = "AuditIfNotExists"
    }
  })
}

resource "azurerm_management_group_policy_assignment" "Web_Application_Firewall_should_be_enabled_for_Application_Gateway" {
  name                 = "Application_Gateway_WAF"
  display_name         = "Web_Application_Firewall_(WAF)_should_be_enabled_for_Application_Gateway"
  policy_definition_id = "/providers/microsoft.authorization/policydefinitions/564feb30-bf6a-4854-b4bb-0d2d2d1e6c66"
  management_group_id  = azurerm_management_group.PMG.id
  description = "Deploy Azure Web Application Firewall (WAF) in front of public facing web applications for additional inspection of incoming traffic. Web Application Firewall (WAF) provides centralized protection of your web applications from common exploits and vulnerabilities such as SQL injections, Cross-Site Scripting, local and remote file executions. You can also restrict access to your web applications by countries, IP address ranges, and other http(s) parameters via custom rules."

  parameters = jsonencode({
    effect = {
      value = "Deny"
    }
  })
}


resource "azurerm_management_group_policy_assignment" "Azure_Key_Vault_should_disable-public_network_access" {
  name                 = "KeyVdisablepublicaccess"
  display_name         = "Azure_Key_Vault_should_disable-public_network_access"
  policy_definition_id = "/providers/microsoft.authorization/policydefinitions/405c5871-3e91-4644-8a63-58e19d68ff5b"
  management_group_id  = azurerm_management_group.PMG.id
  description = "Disable public network access for your key vault so that it's not accessible over the public internet. This can reduce data leakage risks. Learn more at: https://aka.ms/akvprivatelink."

  parameters = jsonencode({
    effect = {
      value = "Deny"
    }
  })
}


resource "azurerm_management_group_policy_assignment" "Azure_Backup_should_be_enabled_for_Virtual_Machines" {
  name                 = "BackupforVirtualMachines"
  display_name         = "Azure Backup should be enabled for Virtual Machines"
  policy_definition_id = "/providers/microsoft.authorization/policydefinitions/013e242c-8828-4970-87b3-ab247555486d"
  management_group_id  = azurerm_management_group.PMG.id
  description = "Ensure protection of your Azure Virtual Machines by enabling Azure Backup. Azure Backup is a secure and cost effective data protection solution for Azure."

  parameters = jsonencode({
    effect = {
      value = "AuditIfNotExists"
    }
  })
}

resource "azurerm_management_group_policy_assignment" "Windows_virtual_machines_should_enable_Azure_Disk_Encryption_or_EncryptionAtHost" {
  name                 = "VMDiskEncryption"
  display_name         = "Windows virtual machines should enable Azure Disk Encryption or EncryptionAtHost"
  policy_definition_id = "/providers/microsoft.authorization/policydefinitions/3dc5edcd-002d-444c-b216-e123bbfa37c0"
  management_group_id  = azurerm_management_group.PMG.id
  description = "Although a virtual machine's OS and data disks are encrypted-at-rest by default using platform managed keys; resource disks (temp disks), data caches, and data flowing between Compute and Storage resources are not encrypted. Use Azure Disk Encryption or EncryptionAtHost to remediate. Visit https://aka.ms/diskencryptioncomparison to compare encryption offerings. This policy requires two prerequisites to be deployed to the policy assignment scope. For details, visit https://aka.ms/gcpol."

  parameters = jsonencode({
    effect = {
      value = "AuditIfNotExists"
    }
  })
}

resource "azurerm_management_group_policy_assignment" "Vulnerability_assessment_should_be_enabled_on_your_SQL_servers" {
  name                 = "VulnerabilitySQLservers"
  display_name         = "Vulnerability assessment should be enabled on your SQL servers"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ef2a8f2a-b3d9-49cd-a8a8-9a3aaaf647d9"
  management_group_id  = azurerm_management_group.PMG.id
  description = "Audit Azure SQL servers which do not have vulnerability assessment properly configured. Vulnerability assessment can discover, track, and help you remediate potential database vulnerabilities."

  parameters = jsonencode({
    effect = {
      value = "AuditIfNotExists"
    }
  })
}


resource "azurerm_management_group_policy_assignment" "Private_endpoint-should_be_enabled_for_MySQL_servers" {
  name                 = "PrivateendpointforMySQL"
  display_name         = "Private endpoint should be enabled for MySQL servers"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/7595c971-233d-4bcf-bd18-596129188c49"
  management_group_id  = azurerm_management_group.PMG.id
  description = "Private endpoint connections enforce secure communication by enabling private connectivity to Azure Database for MySQL. Configure a private endpoint connection to enable access to traffic coming only from known networks and prevent access from all other IP addresses, including within Azure."

  parameters = jsonencode({
    effect = {
      value = "AuditIfNotExists"
    }
  })
}


resource "azurerm_management_group_policy_assignment" "Only-secure_connections_to_your_Azure_Cache_for_Redis_should_be_enabled" {
  name                 = "AzureCacheenabled"
  display_name         = "Only secure connections to your Azure Cache for Redis should be enabled"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/22bee202-a82f-4305-9a2a-6d7f44d4dedb"
  management_group_id  = azurerm_management_group.PMG.id
  description = "Audit enabling of only connections via SSL to Azure Cache for Redis. Use of secure connections ensures authentication between the server and the service and protects data in transit from network layer attacks such as man-in-the-middle, eavesdropping, and session-hijacking"

  parameters = jsonencode({
    effect = {
      value = "Deny"
    }
  })
}

resource "azurerm_management_group_policy_assignment" "MySQL_server_should_use_a_virtual_network_service_endpoint" {
  name                 = "MySQLserviceendpoint"
  display_name         = "MySQL server should use a virtual network service endpoint"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/3375856c-3824-4e0e-ae6a-79e011dd4c47"
  management_group_id  = azurerm_management_group.PMG.id
  description = "Virtual network based firewall rules are used to enable traffic from a specific subnet to Azure Database for MySQL while ensuring the traffic stays within the Azure boundary. This policy provides a way to audit if the Azure Database for MySQL has virtual network service endpoint being used."

  parameters = jsonencode({
    effect = {
      value = "AuditIfNotExists"
    }
  })
}


resource "azurerm_management_group_policy_assignment" "Allowed_virtual_machine_size_SKUs" {
  name                 = "Allowed_VM_SKUs"
  display_name         = "Allowed_virtual_machine_size_SKUs"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3"
  management_group_id  = azurerm_management_group.PMG.id
  description          = "This policy enables you to specify a set of virtual machine size SKUs that your organization can deploy."

  parameters = jsonencode({
    listOfAllowedSKUs = {
      value = [
        "Standard_D2s_v3",
        "Standard_B2ms",
      ]
    }
  })
}

resource "azurerm_management_group_policy_assignment" "Microsoft_Defender_CSPM_should_be_enabled" {
  name                 = "CSPMshouldbeenabled"
  display_name         = "Microsoft Defender CSPM should be enabled"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/1f90fc71-a595-4066-8974-d4d0802e8ef0"
  management_group_id  = azurerm_management_group.PMG.id
  description          = "Defender Cloud Security Posture Management (CSPM) provides enhanced posture capabilities and a new intelligent cloud security graph to help identify, prioritize, and reduce risk. Defender CSPM is available in addition to the free foundational security posture capabilities turned on by default in Defender for Cloud."

  parameters = jsonencode({
    effect = {
      value = "AuditIfNotExists"
    }
  })
}

resource "azurerm_management_group_policy_assignment" "WAF_Mode_Requirement" {
  name                 = "WAFModeRequirement"
  display_name         = "Web Application Firewall (WAF) should use the specified mode for Azure Front Door Service"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/425bea59-a659-4cbb-8d31-34499bd030b8"
  management_group_id  = azurerm_management_group.LZMG.id
  description          = "Mandates the use of 'Detection' or 'Prevention' mode to be active on all Web Application Firewall policies for Azure Front Door Service."

  parameters = jsonencode({
    effect = {
      value = "Deny" 
    }
    modeRequirement = {
      value = "Prevention"
    }
  })
}





# Custom Policy Definition: Enforce HTTPS for Storage Accounts
#-------------------------------
resource "azurerm_policy_definition" "Enforce_HTTPS_for_rStorage_Account" {
  name                = "EnforceHTTPSStorage"
  policy_type         = "Custom"
  mode                = "All"
  display_name        = "Enforce HTTPS for Storage Accounts"
  description         = "This policy ensures HTTPS is enforced on all Storage Accounts"
  management_group_id = azurerm_management_group.PMG.id

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type"
          equals = "Microsoft.Storage/storageAccounts"
        },
        {
          field  = "Microsoft.Storage/storageAccounts/supportsHttpsTrafficOnly"
          equals = false
        }
      ]
    }
    then = {
      effect = "[parameters('effect')]"
    }
  })

  parameters = jsonencode({
    effect = {
      type         = "String"
      defaultValue = "Deny"
      allowedValues = ["Deny", "Audit"]
      metadata = {
        description = "Effect of the policy - Deny or Audit."
      }
    }
  })
}

# ----------------------------------------
# Policy Assignment to Management Group
# ----------------------------------------

resource "azurerm_management_group_policy_assignment" "Enforce_HTTPS_for_rStorage_Account" {
  name                 = "EnforceHTTPSStorage"
  display_name         = "Enforce HTTPS for Storage Accounts"
  policy_definition_id = azurerm_policy_definition.Enforce_HTTPS_for_rStorage_Account.id
  management_group_id  = azurerm_management_group.PMG.id

  parameters = jsonencode({
    effect = {
      value = "Deny"
    }
  })
}



# Custom Policy Definition: Enforce_Resource_Locks_on_Critical_Resources

resource "azurerm_policy_definition" "Enforce_Resource_Locks_on_Critical_Resources" {
  name                = "LocksonCriticalResources"
  policy_type         = "Custom"
  mode                = "All"
  display_name        = "Enforce Resource Locks on Critical Resources"
  description         = "This policy audits if Virtual Networks and Azure Firewalls are not protected by delete locks."
  management_group_id = azurerm_management_group.PMG.id

  policy_rule = jsonencode({
    if = {
      anyOf = [
        {
          field  = "type"
          equals = "Microsoft.Network/virtualNetworks"
        },
        {
          field  = "type"
          equals = "Microsoft.Network/azureFirewalls"
        }
      ]
    }
    then = {
      effect = "[parameters('effect')]"
      details = {
        type = "Microsoft.Authorization/locks"
        name = "[concat(field('name'), '-lock')]"
        existenceCondition = {
          field  = "Microsoft.Authorization/locks/level"
          equals = "CanNotDelete"
        }
      }
    }
  })

  parameters = jsonencode({
    effect = {
      type         = "String"
      metadata = {
        displayName = "Effect"
        description = "The effect determines whether to audit or deny the request."
      }
      allowedValues = ["AuditIfNotExists", "Deny"]
      defaultValue  = "AuditIfNotExists"
    }
  })
}




# ----------------------------------------
# Policy Assignment to Management Group
# ----------------------------------------

resource "azurerm_management_group_policy_assignment" "Audit_Locks_on_Critical_Resources" {
  name                 = "LocksOnCriticalResources"
  display_name         = "Audit Resource Locks on Critical Resources"
  policy_definition_id = azurerm_policy_definition.Enforce_Resource_Locks_on_Critical_Resources.id
  management_group_id  = azurerm_management_group.PMG.id

  parameters = jsonencode({
    effect = {
      value = "AuditIfNotExists"
    }
  })
}


















