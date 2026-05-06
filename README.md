# What is this?
The single GPU passthrough setup that works for my hardware

- CPU pinning for my ryzen 3600 - 6 cores for host and 6 cores for VM
- patched ROM from TechPowerUp
- start qemu hook - lives under /etc/libvirt/hooks/qemu.d/win10/prepare/begin/start.sh
- release qemu hook - lives under /etc/libvirt/hooks/qemu.d/win10/release/end/stop.sh

