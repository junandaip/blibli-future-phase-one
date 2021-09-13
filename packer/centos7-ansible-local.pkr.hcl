#Packer main template
variable "guest_os_type" {}
variable "iso_url" {}
variable "iso_checksum" {}
variable "disk_size_server" {}
variable "cpus_server" {}
variable "memory_server" {}
variable "ks_file_server" {}

source "virtualbox-iso" "centos-server" {
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
    # Build name for the log output in CLI and for the VM Name
    name = "CentOS 7 - Haproxy" 
    sources = [
        "sources.virtualbox-iso.centos-server"
    ]
    provisioner "shell" {
        inline = [
            "hostnamectl set-hostname haproxy",
            "nmcli con mod 'System enp0s8' ipv4.addresses 192.168.56.190/24",
            "nmcli con down 'System enp0s8'",
            "nmcli con up 'System enp0s8'"
        ]
    }
    provisioner "shell" {
        scripts =  [
            "scripts/edit_hostfile.sh",
            "scripts/ansible.sh"
        ]
    }
    provisioner "ansible-local" {
        playbook_file = "./ansible/haproxy/playbook.yml"
        role_paths = [
            "./ansible/roles/docker",
            "./ansible/roles/haproxy"
        ]
        extra_arguments = ["-vvv"]
    }
}