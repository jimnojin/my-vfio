#!/bin/bash
set -x

# return cpus
systemctl set-property --runtime -- user.slice AllowedCPUs=0-11
systemctl set-property --runtime -- system.slice AllowedCPUs=0-11
systemctl set-property --runtime -- init.scope AllowedCPUs=0-11

virsh nodedev-reattach pci_0000_09_00_1
virsh nodedev-reattach pci_0000_09_00_0

modprobe -r vfio-pci

#bind efi
#echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

# Reload nvidia modules
modprobe nvidia
modprobe nvidia_modeset
modprobe nvidia_uvm
modprobe nvidia_drm

# Rebind VT consoles
echo 1 > /sys/class/vtconsole/vtcon0/bind

systemctl restart display-manager
