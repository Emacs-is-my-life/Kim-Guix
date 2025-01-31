# What is this?

This repo has configuration files and installation scripts for my Guix linux system.  

# How to install
## Prepare installaion medium
### Download nonguix iso image
https://gitlab.com/nonguix/nonguix/-/releases
Download the installation image iso file.

### Create bootable USB drive

```bash
$ sudo dd if=nonguix-system-install-VERSION.x86_64-linux.iso of=/dev/your-usb-drive bs=4M && sync
```
or use Ventoy

** Install Guix system on your computer
- Boot your computer into Guix installation USB in UEFI boot mode
- When Guix install TUI pops up after boot process, press Ctrl + Alt + F3 to login to shell
- Connect your booted guix installation system to the internet
- Move to "Kim-Guix" directory, which you have copied into the installation USB
- Move to "system" directory
- Fill "config.env" text file according to your preferences
- Run "system-install.sh" script to install Guix on your computer
- Reboot

## Guix system installation
### Booting
- Boot your computer with prepared USB drive, in UEFI boot mode
- When Guix installaion TUI pops up, press `Ctrl + Alt + F3` to enter shell.

### Network connection
<details>
  <summary>Wired connection</summary>
  </br>
  
  #### Using DHCP
  ```bash
  $ dhclient -v *interface-name*
  ```
  
  #### Using manual connection
  ```bash
  $ ip addr 
  ```
</details>

### System installation

** Guix home configuration (X11, Emacs, ...)
- Login as root to your newly installed Guix system
- Set password for root user
- Set password for user you have created during installation
- Configure network for internet connectivity
  $ nmtui
  
- Logout then login as a user which you have created through installation process
- Copy this "Kim-Guix" directory into logged in user's home
- Move to "user" directory in "Kim-Guix" directory
- Run "user-install.sh" script to configure user environment
- Reboot
- Login again as the user account
- Plug all your monitors and do monitor config setup
  $ arandr                 # This is a gui app for monitor setup configuration
  $ autorandr --save home  # Save your current monitor setup (you just did with arandr) as "home" profile.

* Notes
