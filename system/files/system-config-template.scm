(use-modules (gnu)
             (gnu system nss)
             (gnu packages hardware)
             (gnu packages firmware)
             (gnu packages bootloaders)
             (gnu packages linux)
             (gnu packages cryptsetup)
             (gnu packages base)
             (gnu packages bash)
             (gnu packages vim)
             (gnu packages version-control)
             (gnu packages compression)
             (gnu packages admin)
             (gnu packages networking)
             (gnu packages certs)
             (gnu packages vpn)
             (gnu packages gl)
             (gnu packages video)
             (gnu packages xorg)
             (gnu packages xdisorg)
             (gnu packages compton)
             (gnu packages wm)
             (gnu packages suckless)
             (gnu packages freedesktop)
             (gnu packages glib)
             (gnu packages gnome)
             (gnu packages audio)
             (gnu packages pulseaudio)
             (gnu packages music)
             (gnu packages gnupg)
             (gnu packages emacs)
             (gnu packages guile-xyz)
             (gnu packages cups)
             (gnu packages security-token)
             (gnu packages virtualization)
             (gnu packages spice)
             (gnu packages containers)
             (gnu services linux)
             (gnu services admin)
             (gnu services pm)
             (gnu services mcron)
             (gnu services sysctl)
             (gnu services auditd)
             (gnu services networking)
             (gnu services syncthing)
             (gnu services dbus)
             (gnu services avahi)
             (gnu services xorg)
             (gnu services desktop)
             (gnu services cups)
             (gnu services sound)
             (gnu services virtualization)
             (gnu services authentication)
             (gnu services security-token)
             (guix)
             (nongnu packages linux)
             (nongnu system linux-initrd)
	     (nongnu packages video))

(define %XORG-LIBINPUT-M575
  "Section \"InputClass\"
      Identifier \"ERGO M575 Mouse\"
      Driver \"libinput\"
      Option \"ScrollMethod\" \"button\"
      Option \"ScrollButton\" \"8\"
      Option \"ScrollButtonLock\" \"true\"
      Option \"ButtonMapping\" \"1 2 3 4 5 6 7 0 2\"
      Option \"ScrollPixelDistance\" \"20\"
      Option \"AccelerationScheme\" \"predictable\"
      Option \"AccelSpeed\" \"0.08\"
      Option \"AccelerationNumerator\" \"2\"
      Option \"AccelerationDenominator\" \"2\"
      Option \"AccelerationThreshold\" \"16\"
  EndSection")

(define %XORG-INTEL-GRAPHICS
  "Section \"Device\"
      Identifier \"Intel Graphics\"
      Driver \"modesetting\"
      Option \"TearFree\" \"true\"
      option \"TripleBuffer\" \"true\"
  EndSection")

;; Allow members of the "video" group to change the screen brightness.
(define %backlight-udev-rule
  (udev-rule
   "90-backlight.rules"
   (string-append "ACTION==\"add\", SUBSYSTEM==\"backlight\", "
                  "RUN+=\"/run/current-system/profile/bin/chgrp video /sys/class/backlight/%k/brightness\""
                  "\n"
                  "ACTION==\"add\", SUBSYSTEM==\"backlight\", "
                  "RUN+=\"/run/current-system/profile/bin/chmod g+w /sys/class/backlight/%k/brightness\"")))

;; This rule is for Yubikey, Yubikey 4/5 OTP+U2F+CCID product. If you are using different fido key, update idVendor and idProduct accordingly.
(define %yubikey-udev-rule
  (udev-rule
   "90-flooose-fido2.rules"
   (string-append "KERNEL==\"hidraw*\", SUBSYSTEM==\"hidraw\", ATTRS{idProduct}==\"0407\", GROUP=\"plugdev\", ATTRS{idVendor}==\"1050\" TAG+=\"uaccess\"" "\n")))

(define cron-job-guix-gc
  ;; Collect garbage 5 minutes after midnight every day
  #~(job "5 0 * * *"
         "guix gc -d 1w"))

(operating-system
 (kernel linux)
 (kernel-loadable-modules (list acpi-call-linux-module))
 (kernel-arguments (append '("resume=UUID={{ GUIX_OS_UUID_SWAP }}" "resume_offset={{ GUIX_OS_OFFSET_SWAP }}") %default-kernel-arguments))
 (initrd microcode-initrd)
 (firmware (list sof-firmware linux-firmware))
 (host-name "{{ GUIX_OS_HOSTNAME }}")
 (keyboard-layout (keyboard-layout "{{ GUIX_OS_KEYBOARD }}"))
 (locale "{{ GUIX_OS_LOCALE }}")
 (timezone "{{ GUIX_OS_TIMEZONE }}")

 (mapped-devices
  (list (mapped-device
         (source (uuid "{{ GUIX_OS_UUID_ENCRYPTED }}"))
         (target "cryptroot")
         (type luks-device-mapping))))

 (file-systems
  (append
   (list
    (file-system
     (device (uuid {{ GUIX_OS_UUID_ESP }} 'fat))
     (mount-point "/efi")
     (type "vfat"))
    (file-system
     (device "/dev/mapper/cryptroot")
     (mount-point "/")
     (type "ext4")
     (dependencies mapped-devices)))
   %base-file-systems))

 (swap-devices
  (list
   (swap-space
    (target "/swapfile")
    (discard? #t)
    (dependencies file-systems))))
 
 (bootloader (bootloader-configuration
						  (bootloader grub-efi-bootloader)
              (targets '("/efi"))
              (keyboard-layout keyboard-layout)))

 (packages (append (list
                    ;; utility
                    coreutils binutils findutils diffutils iputils sysfsutils efibootmgr tar zip unzip bash-completion vim git

                    ;; video
                    mesa mesa-utils libva libva-utils libvdpau-va-gl intel-media-driver/nonfree

                    ;; autio
                    alsa-lib alsa-utils alsa-plugins pulseaudio pavucontrol

                    ;; network
                    network-manager network-manager-applet libnma wpa-supplicant wireguard-tools bridge-utils

                    ;; bluetooth
                    bluez bluez-alsa blueman

                    ;; xorg
                    elogind xorg-server xinit xinitrc-xsession xhost xterm xf86-input-evdev xf86-input-libinput xf86-input-wacom xrdb xmodmap xsettingsd xrandr arandr autorandr slock xss-lock dbus xdg-dbus-proxy picom

                    ;; monitoring
                    htop lm-sensors tlp thermald acpi-call-linux-module fwupd rasdaemon earlyoom mcron procps util-linux sysstat numactl cpuid msr-tools 

                    ;; printer
                    cups cups-filters system-config-printer

                    ;; security
                    tpm2-tss tpm2-tools cryptsetup opendoas audit nmap nftables usbguard libfido2 libu2f-host yubikey-manager-qt yubico-piv-tool yubikey-personalization

                    ;; virtualization
                    qemu ovmf libvirt virt-manager virt-viewer spice spice-gtk podman distrobox
                    )
                   %base-packages))
 
 (services
  (append
   (list
    (service tlp-service-type
             (tlp-configuration
              (tlp-default-mode "BAT")
              (cpu-scaling-governor-on-ac (list "performance"))
              (cpu-scaling-governor-on-bat (list "powersave"))
              (cpu-boost-on-ac? #t)
              (cpu-boost-on-bat? #f)
              (sched-powersave-on-ac? #f)
              (sched-powersave-on-bat? #t)
              (energy-perf-policy-on-ac "performance")
              (energy-perf-policy-on-bat "powersave")
              (start-charge-thresh-bat0 40)
              (stop-charge-thresh-bat0 80)
              (start-charge-thresh-bat1 40)
              (stop-charge-thresh-bat1 80)))
    (service thermald-service-type
             (thermald-configuration
              (adaptive? #t)))

    (service earlyoom-service-type)
    (service rasdaemon-service-type)
    (service auditd-service-type)
    
    (simple-service 'my-cron-jobs
                    mcron-service-type
                    (list cron-job-guix-gc))
    (service unattended-upgrade-service-type
             (unattended-upgrade-configuration
              (channels #~(append (list
                                   (channel
                                    (name 'nonguix)
                                    (url "https://gitlab.com/nonguix/nonguix")
                                    ;; Enable signature verification:
                                    (introduction
                                     (make-channel-introduction
                                      "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
                                      (openpgp-fingerprint
                                       "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5")))))
                                  %default-channels))))

    (service nftables-service-type
             (nftables-configuration
              (ruleset (plain-file "nftables.conf"
                                   "flush ruleset

                                    table ip nat {
                                        set net_RFC1918 {
                                            type ipv4_addr
                                            flags interval
                                            elements = { 0.0.0.0/8, 127.0.0.0/8, 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 }
                                        }

                                        chain prerouting {
                                            type nat hook prerouting priority dstnat
                                        }

                                        chain postrouting {
                                            type nat hook postrouting priority srcnat

                                            oifname {{ GUIX_OS_NIC_NAME }} ip daddr != @net_RFC1918 masquerade
                                        }
                                    }
                                    
                                    table inet filter {
                                        set net_RFC1918 {
                                            type ipv4_addr
                                            flags interval
                                            elements = { 0.0.0.0/8, 127.0.0.0/8, 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 }
                                        }

                                        chain input {
                                            type filter hook input priority filter; policy drop;

                                            ct state established,related accept
                                            ct state invalid drop
                                            iifname lo accept
                                        }

                                        chain output {
                                            type filter hook output priority filter; policy accept;
                                        }

                                        chain forward {
                                            type filter hook forward priority filter; policy drop;

					                                  ct state established,related accept
					                                  ct state invalid drop

                                            iifname virbr0 oifname {{ GUIX_OS_NIC_NAME }} ip daddr != @net_RFC1918 accept
                                        }
                                    }"))))

    (service libvirt-service-type
             (libvirt-configuration
              (unix-sock-group "libvirt")
              (tls-port "16555")))

    (extra-special-file "/usr/share/OVMF/OVMF_CODE.fd"
                        (file-append ovmf "/share/firmware/ovmf_x64.bin"))
    (extra-special-file "/usr/share/OVMF/OVMF_VARS.fd"
                        (file-append ovmf "/share/firmware/ovmf_vars_x64.bin"))

    (service virtlog-service-type
             (virtlog-configuration
              (max-clients 128)))

    (service cups-service-type
             (cups-configuration
              (web-interface? #t)
              (extensions
               (list cups-filters))))

    (service bluetooth-service-type
             (bluetooth-configuration
              (auto-enable? #t)))
    (simple-service 'blueman dbus-root-service-type (list blueman))

    (service xorg-server-service-type
             (xorg-configuration
              (keyboard-layout keyboard-layout)
              (extra-config (list %XORG-INTEL-GRAPHICS %XORG-LIBINPUT-M575))))

    (service inputattach-service-type)
    (service fprintd-service-type)
    (service pcscd-service-type)
    (udev-rules-service 'u2f %yubikey-udev-rule #:groups '("plugdev"))
    (udev-rules-service 'fido2 libfido2 #:groups '("plugdev"))
    (udev-rules-service 'yubikey yubikey-personalization))

   (modify-services %desktop-services
                    (guix-service-type config => (guix-configuration
                                                  (inherit config)
                                                  (substitute-urls
                                                   (append (list "https://substitutes.nonguix.org") %default-substitute-urls))
                                                  (authorized-keys
                                                   (append (list (plain-file "non-guix.pub"
                                                                             "(public-key (ecc (curve Ed25519)
                                                                                                 (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))
                                                           %default-authorized-guix-keys))))
                    (sysctl-service-type config =>
                                         (sysctl-configuration
                                          (settings
                                           (append
                                            '(("net.ipv4.ip_forward" . "1")
                                              ("net.ipv4.tcp_syncookies" . "1")
                                              ("net.ipv4.tcp_rfc1337" . "1")
                                              ("net.ipv4.conf.default.rp_filter" . "1")
                                              ("net.ipv4.conf.all.rp_filter" . "1")
                                              ("net.ipv4.conf.all.accept_redirects" . "0")
                                              ("net.ipv4.conf.default.accept_redirects" . "0")
                                              ("net.ipv4.conf.all.secure_redirects" . "0")
                                              ("net.ipv4.conf.default.secure_redirects" . "0")
                                              ("net.ipv6.conf.all.accept_redirects" . "0")
                                              ("net.ipv6.default.accept_redirects" . "0")
                                              ("net.ipv4.icmp_echo_ignore_all" . "1")
                                              ("net.ipv6.icmp_echo_ignore_all" . "1"))
                                            %default-sysctl-settings))))
                    (udev-service-type config =>
                                       (udev-configuration (inherit config)
                                                           (rules (cons %backlight-udev-rule
                                                                        (udev-configuration-rules config)))))
                    (elogind-service-type config =>
                                          (elogind-configuration (inherit config)
                                                                 (handle-lid-switch-external-power 'suspend)))
                    (delete gdm-service-type))))

 (name-service-switch %mdns-host-lookup-nss)

 (users
  (cons*
   (user-account
    (name "{{ GUIX_OS_USER_USERNAME }}")
    (comment "{{ GUIX_OS_USER_COMMENT }}")
    (group "users")
    (home-directory (string-append "/home/" "{{ GUIX_OS_USER_USERNAME }}" ))
    (supplementary-groups '("tty" "wheel" "netdev" "input" "audio" "video" "plugdev" "lp" "libvirt" "kvm")))
   %base-user-accounts)))

