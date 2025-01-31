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
$ git clone https://github.com/Emacs-is-my-life/Kim-Guix.git Guix
```

#### Fill variables in `config.env` and install
```bash
$ cd Guix/system  # Move to system directory
$ vim config.env      # Fill variables appropriately
$ ./system-install.sh # Install guix system to target drive
```

After the installtion, remove the usb drive and reboot to the installed system.

#### Change password
Login as root user
```bash
$ passwd             # Set root password 
$ passwd <username>  # Set password of user you created
```

## User environment setup
### Network connection
Login as created user <username>  
Then configure network connection
```bash
$ sudo nmtui
```

### Guix home installation
```bash
$ git clone https://github.com/Emacs-is-my-life/Kim-Guix.git Guix
$ cd Guix/user
$ ./user-install.sh
```

### Monitor setup
Logout first, then login again to start EXWM  
Then use following programs to config display setup
```bash
$ arandr                           # GUI program for display configuration
$ autorandr --save <profile-name>  # Saves your current display configuration as a profile
```

### (Optional) Mail and LLM service account information
Create `authinfo` textfile, which has email account info and llm service accounts
```
machine imap.gmail.com login my.email.addr@gmail.com port 993 password blahblah123
machine smtp.gmail.com login my.email.addr@gmail.com port 587 password blahblah123
machine api.openai.com login apikey password TOKEN
machine generativelanguage.googleapis.com login apikey password TOKEN
machine api.anthropic.com login apikey password TOKEN
machine api.deepseek.com login apikey password TOKEN
```

Then encrypt `authinfo` textfile with gpg, place it at `~/Documents/Secrets/`
```bash
$ gpg --output authinfo.gpg --encrypt authinfo
$ mv authinfo.gpg ~/Documents/Secrets/
$ rm authinfo
```

# Notes
