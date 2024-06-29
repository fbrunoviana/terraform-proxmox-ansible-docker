terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.9.0"
    }
    
  }
}

provider "proxmox" {
  pm_api_url    = "https://${var.proxmox_ip}:8006/api2/json"
  pm_user       = "root@pam"
  # pm_password   = "" # Change-me or execute export export PM_PASS="password"
  pm_tls_insecure = true
}