# Reuni Virtual NOLSATU dan Peresmian ADINUSA

Slides: https://docs.google.com/presentation/d/17Mi3NFS5hEQjuwk4hRp7skK-efOqhRNiaqPrlR5RtsY/edit?usp=sharing

# References

Libvirt Provider: https://github.com/dmacvicar  
Terraform Docs: https://www.terraform.io/docs/index.html

# Demo

You can try the demo on your environment

* Password for user `admin` and `user` is `rahasia`  
* Change `ssh_authorized_keys` with your pubkey
* Change `graphics` `listen_address` to your machine IP Address

[Demo](demo)

```bash
cd demo
terraform init
terraform apply
```