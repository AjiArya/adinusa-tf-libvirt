provider "libvirt" {
    uri = "qemu:///system"
}

terraform {
 required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.2"
    }
  }
}
    
resource "libvirt_cloudinit_disk" "ubuntu20-cloudinit" {
    name = "ubuntu20-cloudinit.iso"
    pool = "vms"
    user_data = data.template_file.user1_data.rendered
    network_config = data.template_file.network1_config.rendered
}
    
data "template_file" "user1_data" {
    template = file("${path.module}/cloudinit1.cfg")
}
    
data "template_file" "network1_config" {
    template = file("${path.module}/network1_config.cfg")
}

resource "libvirt_volume" "ubuntu20-vda" {
    name = "ubuntu20-vda.qcow2"
    pool = "vms"
    base_volume_name = "template-ubuntu20.qcow2"
    base_volume_pool = "isos"
    size = "32212254720"
    format = "qcow2"
}

resource "libvirt_domain" "ubuntu20" {
    name = "ubuntu20"
    memory = "2048"
    vcpu = "2"
    machine = "pc-i440fx-rhel7.6.0"

    cpu = {
           mode = "host-passthrough"
    }

    cloudinit = libvirt_cloudinit_disk.ubuntu20-cloudinit.id

    console {
        type        = "pty"
        target_port = "0"
        target_type = "serial"
    }

    console {
        type        = "pty"
        target_port = "1"
        target_type = "virtio"
    }

    network_interface {
        network_name = "net-10.10.10"
        addresses = ["10.10.10.2"]
    }

    disk {
        volume_id = libvirt_volume.ubuntu20-vda.id
    }

    graphics {
        type = "vnc"
        listen_type = "address"
        autoport = true
    }
}
