## 1. Install sbctl
```sh
sudo pacman -S sbctl
```

## 2. Pre-setup
for GRUB Boot Manager
```sh
sudo grub-install --target=x86_64-efi --efi-driectory=/boot/efi --bootloader-id=cachyos --modules="tpm" --disable-shim-lock
```

## 3. Setup Mode in UEFI
```sh
systemctl reboot --firmware-setup
```

On BIOS, Reset to setup mode or restore factory keys and reboot back to the system. On the other motherboards, you can disable `Provision Factory Default keys` and `Delete all Secure Boot variables`.

## 4. Setting Up sbctl
```sh
sudo sbctl status
sudo sbctl create-keys
sudo sbctl enroll-keys --microsoft
sudo sbctl status
```

## 5. Signing the Kernel Image and Boot Manager
```sh
sudo sbctl verify
sudo sbctl-batch-sign
sudo sbctl verify
```

## 6. Verify Secure Boot is Enabled
```sh
sudo sbctl status
```