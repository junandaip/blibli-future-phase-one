$hostname=@("haproxy","web1","web2","db1","db2","controller-node")
$ip_addr=@("192.168.56.190","192.168.56.191","192.168.56.192","192.168.56.193","192.168.56.194","192.168.56.199")

# Build VirtualBox machine images
For ($i=0; $i -lt $($hostname.Length-1); $i++) {
    packer build -only="CentOS_7_Server.*" `
    -var-file="centos7-var.pkrvars.hcl" `
    -var="hostname=$hostname[i]" `
    -var="ip_addr=$ip_addr[i]" `
    -on-error=ask `
    centos7.pkr.hcl
}
packer build -only="CentOS_7_Ansible.*" `
-var-file="centos7-var.pkrvars.hcl" `
-var="hostname=$hostname[5]" `
-var="ip_addr=$ip_addr[5]" `
-on-error=ask `
centos7.pkr.hcl

# Start the VirtualBox machine images
For ($i=0; $i -lt $hostname.Length; $i++) {
    VBoxManage.exe startvm "CentOS_7_$hostname[i]" --type headless
}

Read-Host -Prompt "Press Enter to exit"