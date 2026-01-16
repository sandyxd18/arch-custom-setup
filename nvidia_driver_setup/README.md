## 1. Enable multilib repository
```sh
sudo nano /etc/pacman.conf
```
```conf
[multilib]
Include = /etc/pacman.d/mirrorlist
```
```sh
yay -Syu
```

## 2. Installing the driver packages
### Find your NVIDIA card
You can find your [NVIDIA card from this list here](https://nouveau.freedesktop.org/CodeNames.html)

### Check driver packages you need to install
| Driver name                                             | Kernel                      | Base driver            | OpenGL             | OpenGL (multilib)        |
| ------------------------------------------------------- | --------------------------- | ---------------------- | ------------------ | ------------------------ |
| Turing (NV160/TUXXX) and newer                          | linux                       | nvidia-open            | nvidia-utils       | lib32-nvidia-utils       |
| Turing (NV160/TUXXX) and newer                          | any other kernel            | nvidia-open-dkms       | nvidia-utils       | lib32-nvidia-utils       |
| Maxwell (NV110) series up to Ada Lovelace (NV190/ADXXX) | linux                       | nvidia                 | nvidia-utils       | lib32-nvidia-utils       |
| Maxwell (NV110) series up to Ada Lovelace (NV190/ADXXX) | linux-lts                   | nvidia                 | nvidia-utils       | lib32-nvidia-utils       |
| Maxwell (NV110) series up to Ada Lovelace (NV190/ADXXX) | any other kernel            | nvidia-dkms            | nvidia-utils       | lib32-nvidia-utils       |
| Kepler (NVE0) series                                    | any                         | nvidia-470xx-dkms      | nvidia-470xx-utils | lib32-nvidia-470xx-utils |
| GeForce 400/500/600 series cards [NVCx and NVDx]        | any                         | nvidia-390xx-dkms      | nvidia-390xx-utils | lib32-nvidia-390xx-utils |
| Tesla (NV50/G80-90-GT2XX)                               | any                         | nvidia-340xx-dkms      | nvidia-340xx-utils | lib32-nvidia-340xx-utils |

### Install the correct Base driver, OpenGL, and OpenGL (multilib)
Example: `yay -S nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings egl-wayland`

## 3. Enabling DRM kernel mode setting
### Setting the kernel parameter
```sh
sudo nano /etc/default/grub
```
Find the link with GRUB_CMDLINE_LINUX_DEFAULT. For Linux kernel 1.10 or older: `GRUB_CMDLINE_LINUX_DEFAULT="quiet splash nvidia-drm.modeset=1"`, and for Linux kernel 6.11 or newer: `GRUB_CMDLINE_LINUX_DEFAULT="quiet splash nvidia-drm.modeset=1 nvidia-drm.fbdev=1"`.

### Update GRUB config
```sh
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Add early loading of Nvidia Modules
Edit the mkinitcpio config file
```sh
sudo nano /etc/mkinitcpio.conf
```
Find the line that says `MODULES=()`, Update the line to: `MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)`, Find the line that says `HOOKS=()`, On the `HOOKS=()` line, find the word kms inside the parenthesis and remove it.

### Adding the Pacman Hook
Create the directory for hook file.
```sh
sudo mkdir -p /etc/pacman.d/hooks/
```
Create new hook file.
```sh
sudo nano /etc/pacman.d/hooks/nvidia.hook
```
```hook
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia
Target=linux
# Adjust line(6) above to match your driver, e.g. Target=nvidia-470xx-dkms
# Change line(7) above, if you are not using the regular kernel For example, Target=linux-lts

[Action]
Description=Update Nvidia module in initcpio
Depends=mkinitcpio
When=PostTransaction
NeedsTargets
Exec=/bin/sh -c 'while read -r trg; do case $trg in linux) exit 0; esac; done; /usr/bin/mkinitcpio -P'
```
Replace the word nvidia with the base driver you installed, e.g., nvidia-470xx-dkms, The edited line should look something like this: Target=nvidia-470xx-dkms.

## 4. Reboot the system
```sh
sudo reboot
```