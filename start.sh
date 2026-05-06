#!/bin/bash
set -x

#DIRS=("/media/Storage" "/media/stuff")
#for dir in "${DIRS[@]}"
#do
#  if ! mountpoint -q "$dir"; then
#    echo "ERROR: $dir does not exist!" >&2
#    exit 1
#  fi
#done
log() {
    ts=$(date +"%Y-%m-%d %T")
    echo "$ts: $1" >> /var/log/libvirt/custom.log
}

trunc --size 0 /var/log/libvirt/custom.log
trunc --size 0 /var/log/libvirt/libvirt.log
log "logs cleaned"

# Stop display manager
systemctl stop display-manager
log "display manager stopped"

echo 0 > /sys/class/vtconsole/vtcon0/bind
log "console unbound"

# Unbind EFI-Framebuffer
if [ -d /sys/bus/platform/drivers/efi-framebuffer ]; then
  echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/unbind
  log "efi unbound"
else
  log "no efi to unbind"
fi

sleep 1
modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia
log "unloaded nvidia mods"

# isolate cpu cores 3,4,5
sleep 1
systemctl set-property --runtime -- user.slice AllowedCPUs=3,9,4,10,5,11
systemctl set-property --runtime -- system.slice AllowedCPUs=3,9,4,10,5,11
systemctl set-property --runtime -- init.scope AllowedCPUs=3,9,4,10,5,11
log "limited CPUs"

# Unbind the GPU from display driver (replace the pci addresses with yours)
sleep 2
virsh nodedev-detach pci_0000_09_00_0
virsh nodedev-detach pci_0000_09_00_1
log "detached gpu iommu"

# Load VFIO Kernel Module 
modprobe vfio_pci
log "vfio_pci loaded"
log "done"
