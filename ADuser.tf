terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azuread" {}

# Define users
locals {
  users = {
    testuser1 = {
      user_principal_name = "testuser1@tejakodamanchili47gmail.onmicrosoft.com"
      display_name        = "Test User 1"
      password            = "Passw0rd!123"
    },
    testuser2 = {
      user_principal_name = "testuser2@tejakodamanchili47gmail.onmicrosoft.com"
      display_name        = "Test User 2"
      password            = "Passw0rd!123"
    },
    testuser3 = {
      user_principal_name = "testuser3@tejakodamanchili47gmail.onmicrosoft.com"
      display_name        = "Test User 3"
      password            = "Passw0rd!123"
    },
    testuser4 = {
      user_principal_name = "testuser4@tejakodamanchili47gmail.onmicrosoft.com"
      display_name        = "Test User 4"
      password            = "Passw0rd!123"
    },
    testuser5 = {
      user_principal_name = "testuser5@tejakodamanchili47gmail.onmicrosoft.com"
      display_name        = "Test User 5"
      password            = "Passw0rd!123"
    }
  }
}

# Create AD users
resource "azuread_user" "users" {
  for_each = local.users

  user_principal_name    = each.value.user_principal_name
  display_name           = each.value.display_name
  mail_nickname          = each.key
  password               = each.value.password
  force_password_change  = false
  account_enabled        = true
}
