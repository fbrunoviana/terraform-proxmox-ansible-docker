resource "random_password" "password" {
  length  = 16
  special = true
}

resource "proxmox_lxc" "ct_create" {
  target_node = "pve" 
  ostemplate  = "local:${var.os_template}"
  vmid        = var.vmid
  hostname    = var.hostname
  cores       = var.cores
  memory      = var.memory
  password    = random_password.password.result
  unprivileged = true
  rootfs {
    storage = "local-lvm"
    size    = var.disk_size
  }
  features {
    nesting = true
  }
  network {
    name    = "eth0"
    bridge  = "vmbr0"
    ip      = "${var.ip}/24" 
    gw      = var.gateway
  }
  nameserver    = var.nameserver
  searchdomain  = "local"
  onboot        = true
  start         = true
}

resource "null_resource" "provision_ct" {
  depends_on = [proxmox_lxc.ct_create]

  provisioner "local-exec" {
    command = <<EOT
      ssh root@${var.proxmox_ip} "pct exec ${var.vmid} -- bash -c 'apt-get update && apt-get install -y openssh-server && mkdir -p /run/sshd && mkdir -p /root/.ssh && echo \"$(cat ~/.ssh/id_rsa.pub)\" > /root/.ssh/authorized_keys && chown root:root /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys && sed -i \"s/#PermitRootLogin prohibit-password/PermitRootLogin yes/\" /etc/ssh/sshd_config && sed -i \"s/#PasswordAuthentication yes/PasswordAuthentication no/\" /etc/ssh/sshd_config && systemctl enable ssh && systemctl start ssh'"
    EOT
  }
}

resource "null_resource" "wait_for_ssh" {
  depends_on = [proxmox_lxc.ct_create]

  provisioner "local-exec" {
    command = <<EOT
      for i in {1..30}; do
        sshpass -p '${random_password.password.result}' ssh -o StrictHostKeyChecking=no root@${var.ip} 'echo SSH is up' && break
        echo "Waiting for SSH to be available..."
        sleep 10
      done
    EOT
  }
}

resource "null_resource" "provision_ansible" {
  depends_on = [null_resource.wait_for_ssh]

  provisioner "local-exec" {
    command = <<EOT
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${var.ip}, --user root --extra-vars "ansible_ssh_pass=${random_password.password.result}" ansible/playbook.yml
    EOT
    working_dir = path.module
  }
}
