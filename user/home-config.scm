(use-modules (gnu home)
             (gnu home services)
             (gnu home services shells)
             (gnu home services ssh)
             (gnu home services gnupg)
             (gnu home services desktop)
             (gnu home services fontutils)
             (gnu home services sound)
             (gnu home services guix)
             (gnu home services shepherd)
             (gnu home services syncthing)
             (gnu home services pm)
             (gnu services)
             (gnu packages terminals)
             (gnu packages shellutils)
             (gnu packages ncurses)
             (gnu packages xdisorg)
             (gnu packages wm)
             (gnu packages gnome)
             (gnu packages gnome-xyz)
             (gnu packages admin)
             (gnu packages disk)
             (gnu packages glib)
             (gnu packages kde)
             (gnu packages kde-utils)
             (gnu packages fonts)
             (gnu packages emacs)
             (gnu packages emacs-xyz)
             (gnu packages emacs-build)
             (gnu packages gnupg)
             (gnu packages web-browsers)
             (gnu packages librewolf)
             (gnu packages browser-extensions)
             (gnu packages mail)
             (gnu packages pdf)
             (gnu packages ebook)
             (gnu packages education)
             (gnu packages libreoffice)
             (gnu packages uml)
	         (gnu packages ghostscript)
             (gnu packages education)
             (gnu packages textutils)
             (gnu packages gawk)
             (gnu packages finance)
             (gnu packages image-viewers)
             (gnu packages photo)
             (gnu packages video)
             (gnu packages audio)
             (gnu packages music)
             (gnu packages gstreamer)
             (gnu packages gimp)
             (gnu packages imagemagick)
             (gnu packages inkscape)
	         (gnu packages image-processing)
             (gnu packages kde)
             (gnu packages graphics)
             (gnu packages ssh)
             (gnu packages linux)
	         (gnu packages compression)
             (gnu packages vnc)
             (gnu packages syncthing)
             (gnu packages magic-wormhole)
             (gnu packages base)
             (gnu packages code)
             (gnu packages cmake)
	         (gnu packages autotools)
             (gnu packages build-tools)
             (gnu packages ninja)
             (gnu packages elf)
             (gnu packages engineering)
             (gnu packages version-control)
             (gnu packages bison)
             (gnu packages flex)
             (gnu packages graphviz)
             (gnu packages gdb)
             (gnu packages llvm)
             (gnu packages debug)
             (gnu packages valgrind)
             (gnu packages instrumentation)
             (gnu packages maths)
             (gnu packages mpi)
             (gnu packages assembly)
             (gnu packages commencement)
             (gnu packages gcc)
             (gnu packages rust)
             (gnu packages rust-apps)
             (gnu packages haskell)
             (gnu packages pkg-config)
             (gnu packages haskell-xyz)
             (gnu packages haskell-apps)
             (gnu packages ocaml)
             (gnu packages forth)
             (gnu packages scheme)
             (gnu packages guile)
             (gnu packages guile-xyz)
             (gnu packages chicken)
             (gnu packages racket)
             (gnu packages lisp)
             (gnu packages coq)
             (gnu packages lean)
             (gnu packages python)
             (gnu packages python-build)
             (gnu packages python-check)
             (gnu packages python-xyz)
             (gnu packages python-web)
             (gnu packages python-crypto)
             (gnu packages python-science)
	         (gnu packages jupyter)
             (gnu packages image-processing)
             (gnu packages check)
             (gnu packages rpc)
             (gnu packages xml)
             (gnu packages databases)
             (gnu packages time)
             (gnu packages graph)
	         (gnu packages machine-learning)
	         (gnu packages qt)
             (gnu packages parallel)
             (gnu packages package-management)
             (gnu packages julia)
             (gnu packages statistics)
             (gnu packages cran)
             (gnu packages maths)
             (gnu packages gawk)
             (gnu packages golang)
             (gnu packages golang-xyz)
             (gnu packages golang-apps)
             (gnu packages java)
             (gnu packages dotnet)
             (gnu packages node)
             (gnu packages web)
             (gnu packages tex)
             (gnu packages virtualization)
             (gnu packages engineering)
             (gnu packages password-utils)
             (gnu packages game-development)
             (gnu packages games)
             (nongnu packages game-client)
             (guix channels)
             (guix packages)
             (guix gexp))

(home-environment
 (packages
  (list
   ;; Emacs & EXWM
   emacs-next emacs-vterm pinentry-emacs emacs-guix libtool ncurses dunst scrot brightnessctl playerctl redshift

   ;; Emacs dependencies
   emacs-dash emacs-zmq emacs-magit-popup emacs-emacsql emacs-pg emacs-edit-indirect emacs-bui
   emacs-finalize emacs-peg
   emacs-geiser emacs-geiser-guile emacs-geiser-racket

   ;; Security
   gnupg paperkey argon2 keepassxc
   
   ;; Email
   isync mu
   
   ;; Fonts
   font-google-noto font-google-noto-sans-cjk font-google-noto-serif-cjk font-google-noto-emoji font-google-roboto font-google-material-design-icons font-awesome font-juliamono
   
   ;; Desktop Themes
   glib materia-theme flat-remix-icon-theme

   ;; File Browser
   nautilus gvfs trash-cli

   ;; Compression Utility
   gzip unzip

   ;; Test Processing Utility
   gawk sed the-silver-searcher

   ;; Web Browser
   qutebrowser librewolf

   ;; Finance
   hledger electrum

   ;; Document Viewer
   zathura-pdf-mupdf evince fbreader

   ;; Document Edit
   libreoffice ghostscript pandoc

   ;; Media Viewer
   viewnior strawberry mpv

   ;; Media Edit
   gimp imagemagick inkscape graphviz blender

   ;; Remote Tools
   openssh sshfs syncthing syncthing-gtk remmina moonlight-qt magic-wormhole

   ;; Study
   anki openboard exercism cf-tool

   ;; Build Tools
   gnu-make cmake meson ninja git shellcheck

   ;; Debugging Tools
   gdb ddd lldb valgrind strace uftrace ltrace ;; rr

   ;; Working with binary
   radare2 cutter patchelf

   ;; Assembly
   nasm yasm

   ;; C/C++
   gcc-toolchain clang-toolchain

   ;; Rust
   rust rust-analyzer

   ;; Haskell
   ghc ghc-rio cabal-install pkg-config

   ;; Ocaml
   ocaml ocaml-utop ocaml-lsp-server ocamlformat ocamlformat-rpc-lib
   opam dune

   ;; Forth
   gforth

   ;; Guile scheme
   guildhall guile-lib

   ;; Chicken scheme
   chicken

   ;; Racket
   racket

   ;; Common Lisp
   sbcl

   ;; Coq
   coq coq-ide

   ;; Lean
   lean4

   ;; Python
   python python-pip python-virtualenv python-lsp-server python-debugpy
   python-mypy python-mypy-extensions python-types-dataclasses python-pydantic
   
   ;; Julia
   julia

   ;; R
   r r-languageserver r-irkernel

   ;; Octave
   octave

   ;; Golang
   go gopls

   ;; Java
   openjdk

   ;; C#
   ;; mono

   ;; JS
   node

   ;; Scientific Visualization
   gnuplot labplot

   ;; TeX
   texlive-digestif
   texlive-scheme-basic texlive-collection-plaingeneric
   texlive-xetex texlive-xetex-bin texlive-collection-xetex
   texlive-dvipng texlive-dvipng-bin

   ;; Virtualization
   spike bochs

   ;; Serial
   minicom))
 
 (services
  (list
   (service home-bash-service-type
            (home-bash-configuration
             (guix-defaults? #t)
             (bash-profile
              (list
               (plain-file "bash_profile"
                           "
export USER_PROJECT_DIR=$HOME/Workspace/
export USER_ORG_DIR=$HOME/Documents/Org/
export USER_ORG_SHORTCUT_DIR=$HOME/Org/
export USER_HTML_DIR=$XDG_CACHE_HOME/public_html/
export USER_SECRET_DIR=$HOME/Documents/Secrets/
export USER_LEDGER_DIR=$HOME/Documents/Ledger/
export USER_MAIL_DIR=$HOME/Documents/Mail/
export USER_BOOK_DIR=$HOME/Books/
export USER_BIBTEX_DIR=$HOME/Documents/BibTeX/
export USER_MUSIC_DIR=$HOME/Music/

mkdir -p $USER_PROJECT_DIR
mkdir -p $USER_ORG_DIR
mkdir -p $USER_HTML_DIR
mkdir -p $USER_SECRET_DIR
chmod 700 $USER_SECRET_DIR
mkdir -p $USER_LEDGER_DIR
mkdir -p $USER_MAIL_DIR
mkdir -p $USER_BOOK_DIR
mkdir -p $USER_BIBTEX_DIR
mkdir -p $USER_MUSIC_DIR

mkdir -p $HOME/Downloads
mkdir -p $HOME/Mount
mkdir -p $HOME/.local/share/Trash

ln -sfn $USER_ORG_DIR $HOME/Org

export HISTFILE=$XDG_CACHE_HOME/.bash_history
export PATH=$HOME/.config/guix/current/bin:$HOME/.local/bin:$PATH
export INFOPATH=$HOME/.config/guix/current/share/info:$INFOPATH

export XAUTHORITY=$XDG_RUNTIME_DIR/Xauthority
export XINITRC=$XDG_CONFIG_HOME/X11/xinitrc
export XSERVERRC=$XDG_CONFIG_HOME/X11/xserverrc
export XCOMPOSEFILE=$XDG_CONFIG_HOME/X11/xcompose
export XCOMPOSECACHE=$XDG_CACHE_HOME/X11/xcompose
export USERXSESSION=$XDG_CACHE_HOME/X11/xsession
export USERXSESSIONRC=$XDG_CACHE_HOME/X11/xsessionrc
export ALTUSERXSESSION=$XDG_CACHE_HOME/X11/Xsession
export ERRFILE=$XDG_CACHE_HOME/X11/xsession-errors

export GUIX_EXTRA_PROFILES=$HOME/.guix-extra-profiles
mkdir -p $GUIX_EXTRA_PROFILES

export GTK_RC_FILES=$XDG_CONFIG_HOME/gtk-1.0/gtkrc
export GTK2_RC_FILES=$XDG_CONFIG_HOME/gtk-2.0/gtkrc:$XDG_CONFIG_HOME/gtk-2.0/gtkrc.mine

export RUSTUP_HOME=$XDG_DATA_HOME/rustup

export GHC_PACKAGE_PATH=$(guix build ghc | sed -n '2p')/lib/ghc-$(ghc --numeric-version)/package.conf.d
export CABAL_DIR=$XDG_DATA_HOME/cabal
export PATH=$CABAL_DIR/bin:$PATH

export PLTUSERHOME=$XDG_DATA_HOME/racket

export GOPATH=$XDG_DATA_HOME/go
export GOMODCACHE=$XDG_CACHE_HOME/go/mod
export PATH=$PATH:$GOPATH/bin

export _JAVA_OPTIONS=-Djava.util.prefs.userRoot=\"$XDG_CONFIG_HOME/java\"

alias python='python3'
export IPYTHONDIR=$XDG_CONFIG_HOME/ipython

JULIA_VERSION=$(ls $HOME/.julia/environments/ | tail -n 1)
export USER_JULIA_DIR=$HOME/.julia/environments/${JULIA_VERSION}/
export JULIA_DEPOT_PATH=$XDG_DATA_HOME/julia:$JULIA_DEPOT_PATH
export JULIAUP_DEPOT_PATH=$XDG_DATA_HOME/julia

export R_ENVIRON=$XDG_CONFIG_HOME/R/Renviron
export R_WORK_DIR=$USER_PROJECT_DIR

export GNUPGHOME=\"$USER_SECRET_DIR\"GnuPG
mkdir -p $GNUPGHOME
chmod 700 $GNUPGHOME
export GPG_TTY=$(tty)

export GNUPG_KEYID_SIGN=$(gpg -K | grep -E -i '\\[S\\]' | awk -F'/0x' '{print $2}' | cut -d ' ' -f 1)
export GNUPG_KEYID_ENCRYPT=$(gpg -K | grep -E -i '\\[E\\]' | awk -F'/0x' '{print $2}' | cut -d ' ' -f 1)
source \"$USER_SECRET_DIR\"userinfo.env

export LEDGER_FILE=$USER_LEDGER_DIR/hledger.journal
export TEXMFHOME=$XDG_DATA_HOME/texmf
export TEXMFVAR=$XDG_CACHE_HOME/texlive/texmf-var
export TEXMFCONFIG=$XDG_CONFIG_HOME/texlive/texmf-config

# Enable all guix profiles
for i in $GUIX_EXTRA_PROFILES/*; do
  profile=$i/$(basename \"$i\")
  if [ -f \"$profile\"/etc/profile ]; then
    GUIX_PROFILE=\"$profile\"
    . \"$GUIX_PROFILE\"/etc/profile
  fi
  unset profile
done

# emacs-vterm
if [[ \"$INSIDE_EMACS\" = 'vterm' ]]; then
    VTERM_DIR=$(ls $HOME/.guix-home/profile/share/emacs/site-lisp/ | grep vterm)
    source $HOME/.guix-home/profile/share/emacs/site-lisp/$VTERM_DIR/etc/emacs-vterm-bash.sh
fi

# EXWM
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
   exec $XDG_CONFIG_HOME/emacs/exwm/start-exwm.sh
fi
")))
             
             (aliases `(("shutdown" . "loginctl poweroff")
                        ("ls" . "ls --color=auto")
                        ("grep" . "grep --color=auto")
                        ("python" . "python3")
                        ("pp" . "loginctl poweroff")))))

   (simple-service 'home-files
                   home-files-service-type
                   `((".gnuplot" ,(local-file "./files/gnuplotrc"))))
   
   (simple-service 'xdg-config-home-files
                   home-xdg-configuration-files-service-type
                   `(("X11/xresources" ,(local-file "./files/xresources"))
                     ("X11/xinitrc" ,(local-file "./files/xinitrc"))
                     ("picom/picom.conf" ,(local-file "./files/picom.conf"))
                     ("xsettingsd/xsettingsd.conf" ,(local-file "./files/xsettingsd.conf"))
                     ("emacs/init.el" ,(local-file "./files/init.el"))
                     ("emacs/exwm/start-exwm.sh" ,(local-file "./files/start-exwm.sh" #:recursive? #t))
                     ("emacs/exwm/monitors-exwm.sh" ,(local-file "./files/monitors-exwm.sh" #:recursive? #t))
                     ("dunst/dunstrc" ,(local-file "./files/dunstrc"))
                     ("qutebrowser/config.py" ,(local-file "./files/config.py"))
                     ("R/Renviron" ,(local-file "./files/Renviron"))
                     ("R/Rprofile" ,(local-file "./files/Rprofile"))
                     ("ipython/profile_default/startup/10-nopager.py" ,(local-file "./files/10-nopager.py"))
                     ("isyncrc" ,(local-file "./.temp/isyncrc"))))

   (service home-shepherd-service-type)

   (service home-batsignal-service-type
            (home-batsignal-configuration
             (warning-level 20)
             (critical-level 15)
             (danger-level 10)
             (danger-command "loginctl hibernate")
             (full-level 90)
             (poll-delay 60)))

   (service home-ssh-agent-service-type
            (home-ssh-agent-configuration
             (extra-options '("-t" "32m"))))
   
   (service home-gpg-agent-service-type
            (home-gpg-agent-configuration
             (pinentry-program
              (file-append pinentry-emacs "~/.guix-home/profile/bin/pinentry-emacs"))
             (ssh-support? #f)
	         (extra-content "allow-emacs-pinentry
			    allow-loopback-pinentry
			    pinentry-program ~/.guix-home/profile/bin/pinentry-emacs")))

   (service home-syncthing-service-type)

   (service home-redshift-service-type
            (home-redshift-configuration
             (location-provider 'geoclue2)))

   (service home-unclutter-service-type
            (home-unclutter-configuration
             (idle-timeout 2)))

   (service home-xmodmap-service-type
            (home-xmodmap-configuration
             (key-map '(("remove Lock" . "Caps_Lock")
                        ("remove Control" . "Control_L")
                        ("keysym Control_L" . "Caps_Lock")
                        ("keysym Caps_Lock" . "Control_L")
                        ("add Lock" . "Caps_Lock")
                        ("add Control" . "Control_L")))))

   (simple-service 'additional-font-config
                   home-fontconfig-service-type
                   (list "~/.fontconfig/fonts.conf"
                         '(alias
                           (family "Roboto Mono Nerd")
                           (prefer
                            (family "Fira Code")))))
   
   (simple-service 'guix-channels
                   home-channels-service-type
                   (append (list
                            (channel
                             (name 'nonguix)
                             (url "https://gitlab.com/nonguix/nonguix")
                             ;; Enable signature verification:
                             (introduction
                              (make-channel-introduction
                               "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
                               (openpgp-fingerprint
                                "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5")))))
                           %default-channels)))))
