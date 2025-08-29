variable "infra-config" {
  sensitive = true
  default = {
    resource_group_name           = "rashi"
    resource_group_location       = "westUS"
    storage_account               = "rashistrg"
    account_tier                  = "Standard"
    account_replication_type      = "LRS"
    vnet_name                     = "vnet1"
    address_space                 = ["10.0.0.0/16"]
    subnet_name                   = "subnet1"
    address_prefixes              = ["10.0.0.0/24"]
    nic_name                      = "vm1"
    ip_name                       = "vm1-ip"
    private_ip_address_allocation = "Dynamic"
    nsg_name                      = "rashinsg"
    public_ip_name                = "mypip"
    allocation_method             = "Static"
    vm_name                       = "vm1"
    vm_size                       = "Standard_F2"
    admin_username                = "Mritunjay"
    admin_password                = "Admin@12345678"
  }
}