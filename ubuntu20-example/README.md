# Requirement

You need to create following resource:
* libvirt network: `net-10.10.10`
* libvirt pool: `isos` & `vms`
* ubuntu focal image in pool `isos` and named `template-ubuntu20.qcow2`

Create net-10.10.10.xml
```xml
<network>
  <name>net-10.10.10</name>
  <forward mode='route'/>
  <bridge name='virbr10' stp='on' delay='0'/>
  <ip address='10.10.10.1' netmask='255.255.255.0'>
  </ip>
</network>
```
```bash
virsh net-define net-10.10.10.xml
virsh net-autostart net-10.10.10
virsh net-start net-10.10.10
```

create pool
```bash
virsh pool-define-as isos dir - - - - "/data/isos"
virsh pool-define-as vms dir - - - - "/data/vms"
```

download image
```
wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img -O /data/isos/template-ubuntu20.qcow2
virsh pool-refresh isos
```

Create resources
```
cd ubuntu20-example
terraform init
terraform plan
terraform apply -auto-approve
```