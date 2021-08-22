#Packer main template
variable "vm_name" {}
variable "guest_os_type" {}
variable "iso_url" {}
variable "iso_checksum" {}

variable "disk_size_server" {}
variable "disk_size_desktop" {}
variable "cpus_server" {}
variable "cpus_desktop" {}
variable "memory_server" {}
variable "memory_desktop" {}
variable "ks_file_server" {}
variable "ks_file_desktop" {}

variable "hostname" {}
variable "ip_addr" {}

source "virtualbox-iso" "centos-server" {
    vm_name = "${var.vm_name} ${var.hostname}"
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
    shutdown_command = "echo 'root' | sudo -S shutdown -P now"
    vboxmanage = [
        ["modifyvm", "{{.Name}}", "--nic1", "nat", "--cableconnected1", "on"],
        ["modifyvm", "{{.Name}}", "--nic2", "hostonly", "--cableconnected2", "on", 
        "--hostonlyadapter2", "VirtualBox Host-Only Ethernet Adapter"]
    ]
}

source "virtualbox-iso" "centos-desktop" {
    vm_name = "${var.vm_name} ${var.hostname}"
    guest_os_type = var.guest_os_type
    http_directory = "http"
    iso_url = var.iso_url
    iso_checksum = var.iso_checksum
    disk_size = var.disk_size_desktop
    cpus = var.cpus_desktop
    memory = var.memory_desktop
    headless = "false"
    keep_registered = "true"
    skip_export = "true"
    output_directory = "${var.vm_name} ${var.hostname}"
    boot_wait = "10s"
    boot_command =  [
        "<tab>",
        " text ks=http://{{.HTTPIP}}:{{.HTTPPort}}/${var.ks_file_desktop}",
        "<enter>",
        "<wait>"
    ]
    ssh_username = "root"
    ssh_password = "future5"
    ssh_wait_timeout = "60m"
    shutdown_command = "echo 'root' | sudo -S shutdown -P now"
    vboxmanage = [
        ["modifyvm", "{{.Name}}", "--nic1", "nat", "--cableconnected1", "on"],
        ["modifyvm", "{{.Name}}", "--nic2", "hostonly", "--cableconnected2", "on", 
        "--hostonlyadapter2", "VirtualBox Host-Only Ethernet Adapter"], 
        ["modifyvm", "{{.Name}}", "--clipboard", "bidirectional"],
        ["modifyvm", "{{.Name}}", "--draganddrop", "bidirectional"]
    ]
}

build {
    # Build name for the log output in CLI
    name = "centos7-server" 
    sources = [
        "sources.virtualbox-iso.centos-server"
    ]
    provisioner "shell" {
        inline = [
            "hostnamectl set-hostname ${var.hostname}",
            "nmcli con mod 'System enp0s8' ipv4.addresses ${var.ip_addr}/24"
        ]
    }
}

build {
    # Build name for the log output in CLI
    name = "centos7-desktop" 
    sources = [
        "sources.virtualbox-iso.centos-desktop"
    ]
    provisioner "shell" {
        inline = [
            "hostnamectl set-hostname ${var.hostname}",
            "nmcli con mod 'System enp0s8' ipv4.addresses ${var.ip_addr}/24"
        ]
    }
}