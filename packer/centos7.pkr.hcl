variable "vm_name" {}
variable "guest_os_type" {}
variable "iso_url" {}
variable "iso_checksum" {}
variable "disk_size_server" {}
variable "cpus_server" {}
variable "memory_server" {}
variable "ks_file_server" {}
variable "hostname" {}
variable "ip_addr" {}

source "virtualbox-iso" "centos-server" {
    vm_name = "${var.vm_name}${var.hostname}"
    guest_os_type = var.guest_os_type
    http_directory = "http"
    iso_url = var.iso_url
    iso_checksum = var.iso_checksum
    disk_size = var.disk_size_server
    cpus = var.cpus_server
    memory = var.memory_server
    headless = "false"
    keep_registered = "true"
    skip_export = "true"
    output_directory = "${var.vm_name} ${var.hostname}"
    boot_wait = "10s"
    boot_command =  [
        "<tab>",
        " text ks=http://{{.HTTPIP}}:{{.HTTPPort}}/${var.ks_file_server}",
        "<enter>",
        "<wait>"
    ]
    ssh_username = "root"
    ssh_password = "future5"
    ssh_wait_timeout = "60m"
    shutdown_command = "echo 'future5' | sudo -S shutdown -P now"
    vboxmanage = [
        ["modifyvm", "{{.Name}}", "--nic1", "nat", "--cableconnected1", "on"],
        ["modifyvm", "{{.Name}}", "--nic2", "hostonly", "--cableconnected2", "on", 
        "--hostonlyadapter2", "VirtualBox Host-Only Ethernet Adapter"]
    ]
}

build {
    # Build name for the log output in the CLI
    name = "CentOS_7_Server" 
    sources = [
        "sources.virtualbox-iso.centos-server"
    ]
    provisioner "shell" {
        inline = [
            "hostnamectl set-hostname ${var.hostname}",
            "nmcli con mod 'System enp0s8' ipv4.addresses ${var.ip_addr}/24"
        ]
    }
    provisioner "shell" {
        scripts =  [
            "scripts/edit_hostfile.sh"
        ]
    }
}

build {
    # Build name for the log output in the CLI
    name = "CentOS_7_Ansible" 
    sources = [
        "sources.virtualbox-iso.centos-server"
    ]
    provisioner "file" {
        source = "./ansible"
        destination = "/home/server/"
    }
    provisioner "shell" {
        inline = [
            "hostnamectl set-hostname ${var.hostname}",
            "nmcli con mod 'System enp0s8' ipv4.addresses ${var.ip_addr}/24",
            "chown -R server:server /home/server/ansible",
            "chmod 755 /home/server/ansible/start-ansible.sh" 
        ]
    }
    provisioner "shell" {
        scripts =  [
            "scripts/edit_hostfile.sh",
            "scripts/ansible.sh",
            "scripts/run-ansible-on-boot.sh"
        ]
    }
}