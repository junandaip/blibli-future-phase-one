$hostname=@("haproxy","web1","web2","db1","db2","control-node")
$ip_addr=@("192.168.56.190","192.168.56.191","192.168.56.192","192.168.56.193","192.168.56.194","192.168.56.199")

# Build VirtualBox machine images
For ($i=0; $i -lt $($hostname.Length-1); $i++) {
    $host_name = $hostname[$i]
    $ip = $ip_addr[$i]
    Write-Output "Building VM for ${host_name}"
    packer build -only="Blibli_Future_CentOS_7_Server.*" `
    -var-file="centos7-var.pkrvars.hcl" `
    -var="hostname=$host_name" `
    -var="ip_addr=$ip" `
    -on-error=ask `
    centos7.pkr.hcl
}

$host_name = $hostname[5] 
$ip = $ip_addr[5]
Write-Output "Building VM for ${host_name}"
packer build -only="Blibli_Future_CentOS_7_Ansible.*" `
-var-file="centos7-var.pkrvars.hcl" `
-var="hostname=$host_name" `
-var="ip_addr=$ip" `
-on-error=ask `
centos7.pkr.hcl

# Start the VirtualBox machine images
For ($i=0; $i -lt $hostname.Length; $i++) {
    $vmName = "Blibli_Future_CentOS_7_" + $hostname[$i]
    VBoxManage.exe startvm $vmName --type headless
}

Read-Host -Prompt "Press Enter to exit"