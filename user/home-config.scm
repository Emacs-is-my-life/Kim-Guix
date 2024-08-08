(use-modules (gnu home)
             (gnu home services)
             (gnu home services shells)
             (gnu home services ssh)
             (gnu home services gnupg)
             (gnu home services desktop)
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
             (gnu packages glib)
             (gnu packages fonts)
             (gnu packages emacs)
             (gnu packages emacs-xyz)
             (gnu packages gnupg)
             (gnu packages web-browsers)
             (gnu packages chromium)
             (gnu packages browser-extensions)
             (gnu packages messaging)
             (gnu packages pdf)
             (gnu packages libreoffice)
             (gnu packages education)
             (gnu packages textutils)
             (gnu packages gawk)
             (gnu packages finance)
             (gnu packages image-viewers)
             (gnu packages video)
             (gnu packages audio)
             (gnu packages music)
             (gnu packages gstreamer)
             (gnu packages gimp)
             (gnu packages imagemagick)
             (gnu packages inkscape)
             (gnu packages kde)
             (gnu packages graphics)
             (gnu packages ssh)
             (gnu packages linux)
             (gnu packages vnc)
             (gnu packages syncthing)
             (gnu packages magic-wormhole)
             (gnu packages base)
             (gnu packages cmake)
	           (gnu packages autotools)
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
             (gnu packages haskell-xyz)
             (gnu packages haskell-apps)
             (gnu packages ocaml)
             (gnu packages forth)
             (gnu packages scheme)
             (gnu packages guile)
             (gnu packages chicken)
             (gnu packages racket)
             (gnu packages lisp)
             (gnu packages coq)
             (gnu packages lean)
             (gnu packages idris)
             (gnu packages prolog)
             (gnu packages python)
             (gnu packages python-build)
	           (gnu packages python-xyz)
             (gnu packages jupyter)
             (gnu packages parallel)
             (gnu packages package-management)
             (gnu packages julia)
             (gnu packages statistics)
             (gnu packages maths)
             (gnu packages gawk)
             (gnu packages golang)
             (gnu packages java)
             (gnu packages node)
             (gnu packages python-web)
             (gnu packages web)
             (gnu packages tex)
             (gnu packages password-utils)
             (gnu packages games)
             (guix channels)
             (guix packages)
             (guix gexp)
	           (nongnu packages game-client))

(home-environment
 (packages
  (list
   ;; Emacs
   emacs emacs-vterm libtool ncurses pinentry dunst scrot brightnessctl playerctl
   
   ;; Fonts
   font-google-noto font-google-noto-sans-cjk font-google-noto-serif-cjk font-google-noto-emoji font-google-roboto font-google-material-design-icons font-awesome font-juliamono 
   
   ;; Desktop Theme
   glib materia-theme flat-remix-icon-theme

   ;; File Browser
   nautilus gvfs trash-cli

   ;; Web Browser
   qutebrowser ungoogled-chromium

   ;; Messenger
   dino

   ;; Document
   zathura-pdf-mupdf libreoffice pandoc pandoc-include

   ;; Finance
   hledger monero

   ;; Media Viewer
   viewnior mpv ffmpeg gstreamer

   ;; Media Creation
   xournalpp gimp imagemagick inkscape audacity shotcut blender

   ;; Remote Tools
   openssh sshfs remmina syncthing syncthing-gtk magic-wormhole moonlight-qt

   ;; Dev-Build
   gnu-make cmake git bison flex graphviz

   ;; Dev-Debug
   gdb lldb rr valgrind strace uftrace bpftrace bpftool bcc

   ;; Dev-Profiling
   perf perf-tools flamegraph

   ;; Dev-HPC
   openblas-ilp64 lapack openmpi

   ;; Dev-ASM
   nasm yasm lightning

   ;; Dev-C/C++
   gcc-toolchain clang-toolchain

   ;; Dev-Fortran
   gfortran-toolchain

   ;; Dev-Rust
   rust rust-cargo rust-analyzer

   ;; Dev-Haskell
   ghc ghc-rio cabal-install

   ;; Dev-Ocaml
   ocaml ocaml-base opam

   ;; Dev-Forth
   gforth

   ;; Dev-Scheme
   chicken racket gerbil

   ;; Dev-CommonLisp
   sbcl

   ;; Dev-Coq
   coq coq-ide

   ;; Dev-Lean
   lean

   ;; Dev-Idris
   idris

   ;; Dev-Prolog
   swi-prolog

   ;; Dev-Python
   python python-pip python-lsp-server python-debugpy
   python-jupyterlab-server python-jupyterlab-widgets python-jupyterlab-pygments
   python-nbconvert python-slurm-magic
   
   ;; Dev-Julia
   julia

   ;; Dev-R
   r r-languageserver

   ;; Dev-Octave (MATLAB alternative)
   octave

   ;; Dev-TextProcessing
   gawk sed

   ;; Dev-Golang
   go gopls

   ;; Dev-Java
   openjdk

   ;; Dev-Web
   node httpie jq

   ;; Gnuplot
   gnuplot

   ;; TeX
   texlive-scheme-basic texlive-listing texlive-hyperref texlive-beamer texlive-pgf texlive-pgfplots texlive-wrapfig texlive-cm-super texlive-amsfonts texlive-gnuplottex
   
   ;; Security
   keepassxc keepassxc-browser/icecat

   ;; ETC
   steam))
 
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
export USER_BOOK_DIR=$HOME/Books/

JULIA_VERSION=$(ls $HOME/.julia/environments/ | tail -n 1)
export USER_JULIA_DIR=$HOME/.julia/environments/${JULIA_VERSION}/

mkdir -p $USER_PROJECT_DIR
mkdir -p $USER_ORG_DIR
mkdir -p $USER_HTML_DIR
mkdir -p $USER_SECRET_DIR
mkdir -p $USER_LEDGER_DIR
mkdir -p $USER_BOOK_DIR

mkdir -p $HOME/Desktop
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

export OPAMROOT=$XDG_DATA_HOME/opam
source $XDG_DATA_HOME/opam/opam-init/variables.sh
export RUSTUP_HOME=$XDG_DATA_HOME/rustup
export PLTUSERHOME=$XDG_DATA_HOME/racket
export GOPATH=$XDG_DATA_HOME/go
export GOMODCACHE=$XDG_CACHE_HOME/go/mod
export PATH=$PATH:$GOPATH/bin
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot=\"$XDG_CONFIG_HOME/java\"
export IPYTHONDIR=$XDG_CONFIG_HOME/ipython
export JULIA_DEPOT_PATH=$XDG_DATA_HOME/julia:$JULIA_DEPOT_PATH
export JULIAUP_DEPOT_PATH=$XDG_DATA_HOME/julia
export R_ENVIRON=$XDG_CONFIG_HOME/R/Renviron
export R_WORK_DIR=$USER_PROJECT_DIR

export LEDGER_FILE=$USER_LEDGER_DIR/hledger.journal
export TEXMFHOME=$XDG_DATA_HOME/texmf
export TEXMFVAR=$XDG_CACHE_HOME/texlive/texmf-var
export TEXMFCONFIG=$XDG_CONFIG_HOME/texlive/texmf-config

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
                        ("python" . "python3")))))

   (simple-service 'home-files
                   home-files-service-type
                   `((".gnuplot" ,(local-file "./files/gnuplotrc"))))
   
   (simple-service 'xdg-config-home-files
                   home-xdg-configuration-files-service-type
                   `(("X11/xresources" ,(local-file "./files/xresources"))
                     ("X11/xinitrc" ,(local-file "./files/xinitrc"))
                     ("X11/xmodmap" ,(local-file "./files/xmodmap"))
                     ("picom/picom.conf" ,(local-file "./files/picom.conf"))
                     ("xsettingsd/xsettingsd.conf" ,(local-file "./files/xsettingsd.conf"))
                     ("emacs/init.el" ,(local-file "./files/init.el"))
                     ("emacs/exwm/start-exwm.sh" ,(local-file "./files/start-exwm.sh" #:recursive? #t))
                     ("emacs/exwm/monitors-exwm.sh" ,(local-file "./files/monitors-exwm.sh" #:recursive? #t))
                     ("dunst/dunstrc" ,(local-file "./files/dunstrc"))
                     ("qutebrowser/config.py" ,(local-file "./files/config.py"))
                     ("R/Renviron" ,(local-file "./files/Renviron"))
                     ("R/Rprofile" ,(local-file "./files/Rprofile"))
                     ("ipython/profile_default/startup/10-nopager.py" ,(local-file "./files/10-nopager.py"))))

   (service home-shepherd-service-type)
   
   (service home-batsignal-service-type)

   (service home-unclutter-service-type
            (home-unclutter-configuration
             (idle-timeout 2)))

   (service home-ssh-agent-service-type
            (home-ssh-agent-configuration
             (extra-options '("-t" "10m"))))
   
   (service home-gpg-agent-service-type
            (home-gpg-agent-configuration
             (pinentry-program
              (file-append pinentry-emacs "/bin/pinentry-emacs"))
             (ssh-support? #f)))

   (service home-syncthing-service-type)
   
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
