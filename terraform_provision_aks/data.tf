data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azurerm_ssh_public_key" "this" {
  name                = var.ssh_key_name
  resource_group_name = var.resource_group_name
}
