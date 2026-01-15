## 1. Run the script
```sh
chmod +x change.sh
./change.sh
```
Choose 1 for installing the kernel. And choose 2 for uninstalling the kernel.

## 2. Reboot the system
```sh
sudo reboot
```

## Option 1: Choose Kernel Via Kernel Manager
### Install cachyos kernel manager

```sh
yay -S cachyos kernel manager
```
or
```sh
chmod +x kernel_manager.sh
./kernel_manager.sh
```

### Open the manager
Choose the kernel, I prefer to choose `linux-cachyos-bore`

## Option 2: Choose Kernal Via Pacman
### Install the kernel
```sh
sudo pacman -Sy linux-cachyos-bore
```

### Change GRUB config
```sh
sudo nano /etc/default/grub
```
```conf
GRUB_DEFAULT=saved
GRUB_SAVEDEFAULT=true
```

### Regenerate GRUB config
```sh
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Reboot the system
```sh
sudo reboot
```