resource "azurerm_kubernetes_cluster" "k8s" {
  location            = data.azurerm_resource_group.this.location
  name                = "${data.azurerm_resource_group.this.name}-${var.cluster_prefix}"
  resource_group_name = data.azurerm_resource_group.this.name
  dns_prefix          = "${data.azurerm_resource_group.this.name}-dns"

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = var.node_pool_name
    vm_size    = var.vm_size
    node_count = var.node_count
  }

  linux_profile {
    admin_username = var.username
    ssh_key {
      key_data = data.azurerm_ssh_public_key.this.public_key
    }
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}
