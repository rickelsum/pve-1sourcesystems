# Proxmox server details
proxmox_host = "your_proxmox_hostname_or_ip"
proxmox_username = "your_proxmox_username"
proxmox_password = "your_proxmox_password"

# Development environment network details
dev_net_name = "dev-net"
dev_net_gateway = "10.1.0.1"
dev_net_cidr = "10.1.0.0/16"

# Define VLAN details for each service or pod (adjust based on your needs)
service_vlans = {
  "web" = {
    vid = 10,
    gateway = "10.1.10.1",
    cidr = "10.1.10.0/24",
  }
  "db" = {
    vid = 20,
    gateway = "10.1.20.1",
    cidr = "10.1.20.0/24",
  }
}