provider "libvirt" {
   uri = "qemu:///system" # For Local Provisioning
}

resource "libvirt_network" "network-demo" {
   name      = "network-demo"
   mode      = "nat"
   addresses = ["192.168.1.0/24"]
   dhcp {
       enabled = false
   }
}

resource "libvirt_volume" "centos7-kvm" {
   name   = "centos7-kvm.qcow2"
   source = "http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2"
#  source = "path/to/image"
   pool   = "default"
   format = "qcow2"
}

resource "libvirt_volume" "kvm-demo-volume" {
   name                = "kvm-demo-volume.qcow2"
   pool                = "default"
   base_volume_name    = "centos7-kvm.qcow2"
   base_volume_pool    = "default"
   size                = 10737418240 # in Bytes, Actually 10GB
   format              = "qcow2"
}

resource "libvirt_cloudinit_disk" "kvm-demo-cloudinit" {
   name           = "kvm-demo-cloudinit.iso"
   pool           = "default"
   user_data      = data.template_file.user_data.rendered
   network_config = data.template_file.network_config.rendered
}

data "template_file" "user_data" {
   template = file("${path.module}/user-data.cfg")
}

data "template_file" "network_config" {
   template = file("${path.module}/network-config.cfg")
}

resource "libvirt_domain" "kvm-demo" {
   name       = "kvm-demo"
   memory     = "2048"
   vcpu       = "2"
   machine    = "pc-i440fx-rhel7.6.0"
   cloudinit  = libvirt_cloudinit_disk.kvm-demo-cloudinit.id
  
   cpu        = {
       mode = "host-passthrough"
   }

   network_interface {
       network_name = "network-demo"
       addresses    = ["192.168.1.10"]
   }

   console {
       type        = "pty"
       target_port = "0"
       target_type = "virtio"
   }

   disk {
       volume_id = libvirt_volume.kvm-demo-volume.id
   }

   graphics {
       type = "vnc"
       listen_type = "address"
       listen_address = "138.201.205.172"
       autoport = true
   }
}

terraform {
 required_version = ">= 0.13"
   required_providers {
     libvirt = {
       source = "dmacvicar/libvirt"
       version = "0.6.2"
     }
   }    
}
