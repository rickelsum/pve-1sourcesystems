# Configure the Proxmox provider
provider "proxmox" {
  url      = var.proxmox_host
  username = var.proxmox_username
  password = var.proxmox_password
}

# Create development network on Proxmox
resource "proxmox_network" "dev_net" {
  name   = var.dev_net_name
  gateway = var.dev_net_gateway
  cidr    = var.dev_net_cidr
}

# Define VLANs for each service (modify based on service_vlans in dev.tfvars)
resource "proxmox_vlan" "service_vlan" {
  for_each = var.service_vlans
  vid       = each.value.vid
  name      = format("vlan-%s", each.key)
  pvid      = false

  # Associate VLAN with development network
  network = proxmox_network.dev_net.id
}

# Define VM resources based on your pod configurations (example for web service)
resource "proxmox_vm" "web_vm" {
  name         = "web-dev"
  memory       = 1024
  cores        = 1
  storage      = 20
  hostname     = "web-dev"
  # Define network interface with VLAN tag
  network_interface {
    name = "eth0"
    bridge = proxmox_network.dev_net.name
    tag = var.service_vlans.web.vid
  }
}

# Define additional VMs for other services (modify and replicate based on your needs)
# ...

# Define firewall rules to allow communication between service VMs (example)
resource "proxmox_lxc_firewall_rule" "allow_web_db" {
  name        = "allow-web-db"
  vm_id       = proxmox_vm.web_vm.id
  # Allow traffic from web VLAN to db VLAN on port 3306 (adjust as needed)
  rule {
    name     = "allow-db"
    src      = { cidr = var.service_vlans.db.cidr }
    dst      = { cidr = var.service_vlans.web.cidr }
    protocol = "tcp"
    port     = "3306"
    action   = "accept"
  }
}

# Define additional firewall rules for other communication needs (modify and replicate)
# ...