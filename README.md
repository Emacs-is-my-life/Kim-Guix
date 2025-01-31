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

## Guix system installation
### Booting
- Boot your computer with prepared USB drive, in UEFI boot mode
- When Guix installaion TUI pops up, press `Ctrl + Alt + F3` to enter shell.

### Network connection
<details>
  <summary>Wired connection</summary>
  </br>
  ```bash
  $ dhclient -v <wired-interface-name>
  ```
</details>

<details>
  <summary>Wireless connection</summary>
  </br>

  #### Create `wifi.conf` text file
  ```
  network={
    ssid="ssid-name"
    key_mgmt=WPA-PSK
    psk="<wifi-password>"
  }
  ```

  #### Connect to Wifi network
  ```bash
  $ rfkill unblock all
  $ ifconfig -a
  $ wpa_supplicant -c wifi.conf -i <wireless-interface-name> -B
  ```

  #### Get network info using DHCP
  ```bash
  $ dhclient -v <wireless-interface-name>
  ```
</details>

### System installation
#### Copy this repository to booted guix system
```bash
$ git clone https://github.com/Emacs-is-my-life/Kim-Guix.git
```

#### Fill variables in `config.env` and install
```bash
$ cd Kim-Guix/system  # Move to system directory
$ vim config.env      # Fill variables appropriately
$ ./system-install.sh # Install guix system to target drive
```

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
