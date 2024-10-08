;; # ==== [Initialization]




;; * ---- <Start up>


;; Garbage collection
(setq gc-cons-percentage 0.6)

;; Compiler warning
(setq native-comp-async-report-warnings-errors 'silent) ;; native-comp warning
(setq byte-compile-warnings '(not free-vars unresolved noruntime lexical make-local))


;; * ---- <Emacs file management>


;; Disable lock files
(setq create-lockfiles nil)

;; Save backup files in different location
(make-directory (expand-file-name "tmp/backups/" user-emacs-directory) t)
(make-directory (expand-file-name "tmp/autosave/" user-emacs-directory) t)
(setq backup-directory-alist `(("." . ,(expand-file-name "tmp/backups/" user-emacs-directory))))
(setq auto-save-file-name-transforms `((".*" ,(expand-file-name "tmp/autosave/" user-emacs-directory))))
(setq backup-by-copying t)

;; Save custom variables to different file
(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)


;; * ---- <Package management>


;; Set up package
(require 'package)
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("elpa" . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))
(package-initialize)

;; use-package
(eval-when-compile
  (require 'use-package))
;; (package-refresh-contents)
(setq package-enable-at-startup nil)
(setq use-package-verbose nil)

;; Quelpa
(unless (package-installed-p 'quelpa)
  (with-temp-buffer
    (url-insert-file-contents "https://raw.githubusercontent.com/quelpa/quelpa/master/quelpa.el")
    (eval-buffer)
    (quelpa-self-upgrade)))

(use-package quelpa
  :ensure)

(use-package quelpa-use-package
  :demand
  :config
  (quelpa-use-package-activate-advice))

(require 'quelpa-use-package)

;; Keep package files in separated directory
(use-package no-littering
  :ensure t)

;; Auto update
(use-package auto-package-update
  :ensure t
  :custom 
  (auto-package-update-interval 7) 
  (auto-package-update-prompt-before-update nil) 
  (auto-package-update-hide-results t)
  :config
  (setq auto-package-update-excluded-packages '(mu4e))
  (setq auto-package-update-delete-old-versions t)
  (auto-package-update-maybe))


;; Straight package manager
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))


;; * ---- <Garbage collector>


(use-package gcmh
  :ensure t
  :diminish gcmh-mode
  :config
  (setq gcmh-idle-delay 5
	      gcmh-high-cons-threshold (* 64 1024 1024)) ; 64 mb
  (gcmh-mode 1)
  (add-hook 'emacs-startup-hook
            #'(lambda ()
                (setq gc-cons-percentage 0.1))) ;;; Default value for 'gc-cons-percentage
  (add-hook 'emacs-startup-hook
            #'(lambda ()
                (message "Emacs ready in %s with %d garbade collections."
                         (format "%.2f seconds"
		                             (float-time
		                              (time-subtract after-init-time before-init-time)))
                         gcs-done))))








;; # ===== [Appearance]




;; * ---- <Emacs appearance settings>

;; Frame inhibit implied resize
(setq frame-inhibit-implied-resize t)

;; Don't show splash screen
(setq inhibit-startup-message t)

;; Prevent using UI dialogs for prompts
(setq use-dialog-box nil)

;; Minimal UI
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(setq visible-bell 0)
(setq make-pointer-invisible t)

;; Show matching parenthesis
(show-paren-mode 1)
(setq show-paren-delay 0)

;; Show selected region
(transient-mark-mode t)

;; Encoding & Characters
(use-package emacs
  :init
  (set-charset-priority 'unicode)
  (setq locale-coding-system 'utf-8
        coding-system-for-read 'utf-8
        coding-system-for-write 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-selection-coding-system 'utf-8)
  (prefer-coding-system 'utf-8)
  (setq default-process-coding-system '(utf-8-unix . utf-8-unix))
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 2))

;; Better scrolling
(setq scroll-step 1)
(setq scroll-margin 1)
(setq scroll-conservatively 101)
(setq scroll-up-aggressively 0.01)
(setq scroll-down-aggressively 0.01)
(setq auto-window-vscroll nil)
(setq fast-but-imprecise-scrolling nil)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
(setq pixel-scroll-precision-mode t)

;; Horizontal Scroll
(setq hscroll-step 1)
(setq hscroll-margin 1)

;; Follow focus
(setq focus-follows-mouse t)
(setq mouse-autoselect-window-window t)


;; * ---- <Themes>


;; Nano Theme
(use-package nano-theme
  :ensure t
  :after exwm
  :quelpa (nano-theme
           :fetcher github
           :repo "rougier/nano-theme")
  :config
  (setq nano-fonts-use nil)
  (load-theme 'nano-light t)
  (add-hook 'after-make-frame-functions
	          #'(lambda (frame)
	              (select-frame frame)
	              (when (display-graphic-p frame)
		              (setq nano-fonts-use nil)
		              (load-theme 'nano-light t)
		              (nano-mode)
		              (set-face-attribute 'default nil :font "JuliaMono 12")
		              (set-frame-font "JuliaMono 12" nil t))))
  (nano-mode))

;; Nano Modeline
(use-package nano-modeline
  :ensure t
  :after nano-theme
  :init
  ;; Only show the major mode
  (setq-default mode-line-format
		            `((:propertize " %@%Z  [%b]  L%l (%p)    ")
		              (:propertize (vc-mode vc-mode) face (:weight normal))
		              (:propertize ("  %M  " mode-name)
			                         help-echo "Major mode\n\
                                mouse-1: Display major mode menu\n\
                                mouse-2: Show help for major mode\n\
                                mouse-3: Toggle minor modes"
			                         mouse-face mode-line-highlight
			                         local-map ,mode-line-major-mode-keymap)))
  :config
  (add-hook 'prog-mode-hook            #'nano-modeline-prog-mode)
  (add-hook 'text-mode-hook            #'nano-modeline-text-mode)
  (add-hook 'org-mode-hook             #'nano-modeline-org-mode)
  (add-hook 'pdf-view-mode-hook        #'nano-modeline-pdf-mode)
  (add-hook 'mu4e-headers-mode-hook    #'nano-modeline-mu4e-headers-mode)
  (add-hook 'mu4e-view-mode-hook       #'nano-modeline-mu4e-message-mode)
  (add-hook 'elfeed-show-mode-hook     #'nano-modeline-elfeed-entry-mode)
  (add-hook 'elfeed-search-mode-hook   #'nano-modeline-elfeed-search-mode)
  (add-hook 'term-mode-hook            #'nano-modeline-term-mode)
  (add-hook 'xwidget-webkit-mode-hook  #'nano-modeline-xwidget-mode)
  (add-hook 'messages-buffer-mode-hook #'nano-modeline-message-mode)
  (add-hook 'org-capture-mode-hook     #'nano-modeline-org-capture-mode)
  (add-hook 'org-agenda-mode-hook      #'nano-modeline-org-agenda-mode))


;; Font
(add-to-list 'default-frame-alist '(font . "JuliaMono 12"))
(set-face-attribute 'default t :font "JuliaMono 12" :height 120 :weight 'regular)

;; Icon pack
(use-package all-the-icons
  :if (display-graphic-p)
  :ensure t)

;; Beacon
(use-package beacon
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'beacon-mode)
  (add-hook 'org-mode-hook 'beacon-mode)
  (add-hook 'vterm-mode-hook #'(lambda () (beacon-mode -1))))








;; # ==== [Editor]




;; * ---- <Input>


(setq default-input-method "korean-hangul")
(global-set-key (kbd "<Hangul>") 'toggle-input-method)


;; * ---- <Formatting>


(setq sentence-end-double-space nil)
(setq require-final-newline t)




;; * ---- <File update>


;; Automatically revert buffers for changed files
(global-auto-revert-mode 1)

;; Automatically update file list in Dired
(setq global-auto-revert-non-file-buffers t)


;; * ---- <File management>


;; Remember recently edited file
(recentf-mode 1)
(save-place-mode 1)

;; Remember minibuffer command history
(setq history-length 16)
(savehist-mode 1)

;; recentf
(use-package recentf
  :ensure nil
  :config
  (setq recentf-max-saved-items 128)
  (setq recentf-filename-handlers
	(append '(abbreviate-file-name) recentf-filename-handlers))
  (recentf-mode))

;; Better search with transient
(use-package transient
  :config
  (transient-define-prefix cc/isearch-menu ()
    "isearch Menu"
    [["Edit Search String"
      ("e"
       "Edit the search string (recursive)"
       isearch-edit-string
       :transient nil)
      ("w"
       "Pull next word or character word from buffer"
       isearch-yank-word-or-char
       :transient nil)
      ("s"
       "Pull next symbol or character from buffer"
       isearch-yank-symbol-or-char
       :transient nil)
      ("l"
       "Pull rest of line from buffer"
       isearch-yank-line
       :transient nil)
      ("y"
       "Pull string from kill ring"
       isearch-yank-kill
       :transient nil)
      ("t"
       "Pull thing from buffer"
       isearch-forward-thing-at-point
       :transient nil)]
     ["Replace"
      ("q"
       "Start ‘query-replace’"
       isearch-query-replace
       :if-nil buffer-read-only
       :transient nil)
      ("x"
       "Start ‘query-replace-regexp’"
       isearch-query-replace-regexp
       :if-nil buffer-read-only     
       :transient nil)]]
    [["Toggle"
      ("X"
       "Toggle regexp searching"
       isearch-toggle-regexp
       :transient nil)
      ("S"
       "Toggle symbol searching"
       isearch-toggle-symbol
       :transient nil)
      ("W"
       "Toggle word searching"
       isearch-toggle-word
       :transient nil)
      ("F"
       "Toggle case fold"
       isearch-toggle-case-fold
       :transient nil)
      ("L"
       "Toggle lax whitespace"
       isearch-toggle-lax-whitespace
       :transient nil)]
     ["Misc"
      ("o"
       "occur"
       isearch-occur
       :transient nil)]])
  (define-key isearch-mode-map (kbd "<f2>") 'cc/isearch-menu))

;; treemacs
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              5000
          treemacs-file-extension-regex          treemacs-last-period-regex-value
          treemacs-file-follow-delay             0.2
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                      'left
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             nil
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-asc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-width                         26)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode t)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
	("M-0"       . treemacs-select-window)
	("C-x t 1"   . treemacs-delete-other-windows)
	("C-x t t"   . treemacs)
	("C-x t B"   . treemacs-bookmark)
	("C-x t C-t" . treemacs-find-file)
	("C-x t M-t" . treemacs-find-tag)))

;; treemacs-projectile
(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

;; treemacs-magit
;; (use-package treemacs-magit
;;   :after (treemacs magit)
;;   :ensure t)

;; treemacs-all-the-icons
(use-package treemacs-all-the-icons
  :after (treemacs all-the-icons)
  :ensure t)


;; Openwith for external programs
(use-package openwith
  :init
  (openwith-mode 1)
  :config
  (setq openwith-associations
        (list
         (list (openwith-make-extension-regexp
                '("pdf" "ps" "ps.gz" "dvi"))
               "evince"
               '(file))
         (list (openwith-make-extension-regexp
                '("doc" "xls" "xlsx" "ppt" "pptx" "odt" "ods" "odg" "odp"))
               "libreoffice"
               '(file))
         (list (openwith-make-extension-regexp
                '("mp4" "mov" "flv" "avi" "wmv" "mkv"))
               "mpv"
               '(file)))))








;; * ---- <Project Management>


;; Projectile
(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :config
  (setq projectile-enable-caching t)
  (setq projectile-completion-system 'default)
  (make-directory (getenv "USER_PROJECT_DIR") t)
  (setq projectile-project-search-path `(,(getenv "USER_PROJECT_DIR")))
  :bind
  (:map projectile-mode-map
        ("C-c p" . projectile-command-map)))

(use-package helm-projectile
  :ensure t
  :after (helm projectile))

;; Magit
;; (use-package magit
;;   :ensure t)








;; * ---- <Convenience>


;; Show line number
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setq linum-format "%4d ")

;; Highlight cursor line
(add-hook 'prog-mode-hook 'hl-line-mode)
(add-hook 'org-mode-hook 'hl-line-mode)
(add-hook 'vterm-mode-hook #'(lambda () (hl-line-mode -1)))

;; Match and highlight parenthesis
(electric-pair-mode 1)
(setq electric-pair-pairs
  '((?\" . ?\")
    (?\{ . ?\})))

(setq electric-pair-inhibit-predicate 
  (lambda (c)
    (or (char-equal c ?\')
        (char-equal c ?\<))))

(use-package rainbow-delimiters
  :hook
  ((lisp-mode . rainbow-delimiters-mode)
   (lisp-interaction-mode . rainbow-delimiters-mode)
   (scheme-mode . rainbow-delimiters-mode)
   (common-lisp-mode . rainbow-delimiters-mode)
   (emacs-lisp-mode . rainbow-delimiters-mode)))

;; Undo tree
(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode)
  (setq undo-tree-visualizer-diff t)
  (setq undo-tree-visualizer-timestamps t)
  (setq undo-tree-auto-save-history nil))








;; # ==== [Key Binding]




;; * ---- <Help>


;; Show key binding suggestions
(use-package which-key
  :ensure t
  :config
  (setq which-key-idle-delay 0.3)
  (setq which-key-popup-type 'frame)
  (which-key-mode)
  (which-key-setup-side-window-bottom)
  (set-face-attribute 'which-key-local-map-description-face nil :weight 'bold))








;; # ==== [Completion & Suggestion]




;; * ---- <Completion>


;; helm
(use-package helm
  :ensure t
  :init
  (helm-mode 1)
  :bind
  ("C-x C-f" . 'helm-find-files)
  ("C-x C-b" . 'helm-buffers-list)
  ("M-x" . 'helm-M-x)
  :config
  (helm-autoresize-mode 1)
  (setq helm-ff-skip-boring-files t)
  (customize-set-variable 'helm-boring-file-regexp-list (cons "^\\..+" helm-boring-file-regexp-list)))

;; helm-xref
(use-package helm-xref
  :ensure t
  :after helm)

(with-eval-after-load 'helm-xref 
  (define-key global-map [remap find-file] #'helm-find-files)
  (define-key global-map [remap execute-extended-command] #'helm-M-x)
  (define-key global-map [remap switch-to-buffer] #'helm-mini))

;; helm-lsp
(use-package helm-lsp 
  :ensure t
  :after (helm lsp-mode)
  :commands helm-lsp-workspace-symbol
  :config
  (define-key lsp-mode-map [remap xref-find-apropos] #'helm-lsp-workspace-symbol))

;; helpful source code search
(use-package helpful
  :commands
  (helpful-callable
   helpful-variable
   helpful-key
   helpful-macro
   helpful-function
   helpful-command))


;; info lookup symbol suggestion
(use-package info-look
  :ensure t)








;; * ---- <Language Server>




;; lsp install
(setq package-selected-packages '(lsp-mode lsp-ui lsp-treemacs helm-lsp
					                                 projectile hydra flycheck company avy which-key helm-xref dap-mode))
(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))

;; lsp-mode
(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-l")
  :bind-keymap ("C-l" . lsp-command-map)
  :commands lsp
  :ensure t
  :after (treemacs which-key)
  :hook
  ((verilog-mode . lsp)
   (vhdl-mode . lsp)
   (asm-mode . lsp)
   (haskell-mode . lsp)
   (haskell-literate-mode . lsp)
   (c-mode . lsp)
   (c++-mode . lsp)
   (prolog-mode . lsp)
   (python-mode . lsp)
   (julia-mode . lsp)
   (awk-mode . lsp)
   (java-mode . lsp)
   (scala-mode . lsp)
   (cmake-mode . lsp)
   (sh-mode . lsp)
   (html-mode . lsp)
   (css-mode . lsp)
   (javascript-mode . lsp)
   (lsp-mode . lsp-lens-mode)
   (lsp-mode . lsp-enable-which-key-integration))
  :config
  (lsp-enable-which-key-integration t)
  (setq lsp-log-io nil)
  (setq lsp-print-io nil)
  (setq lsp-enable-snippet t)
  (setq lsp-enable-semantic-highlighting t)
  (setq lsp-prefer-flymake nil) 
  (setq lsp-keep-workspace-alive nil)
  (setq lsp-diagnostics-provider :flycheck)
  (setq lsp-completion-provider :company-mode)
  (setq lsp-completion-show-detail t)
  (setq lsp-completion-show-kind t)
  ;; lsp garbage collection setting
  (setq gc-cons-threshold (* 128 1024 1024)
	      read-process-output-max (* 16 1024 1024)
	      treemacs-space-between-root-nodes nil
	      company-idle-delay 0.05
	      company-minimum-prefix-length 1
	      lsp-idle-delay 0.05))

;; Attach lsp to which-key-mode
(with-eval-after-load 'lsp-mode
  (which-key-mode)
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-cpptools))

;; lsp-ui
(use-package lsp-ui
  :ensure t
  :after lsp-mode 
  :commands lsp-ui-mode
  :config
  (setq lsp-enable-symbol-highlighting t)
  (setq lsp-ui-doc-enable t)
  (setq lsp-ui-doc-header t)
  (setq lsp-ui-doc-position 'at-point)
  (setq lsp-ui-doc-include-signature t)
  (setq lsp-ui-doc-border "orange")
  (setq lsp-ui-doc-delay 2)
  (setq lsp-ui-doc-show-with-cursor t)
  (setq lsp-ui-sideline-enable nil)
  (setq lsp-ui-sideline-show-hover nil)
  (setq lsp-ui-sideline-show-code-actions nil)
  (setq lsp-ui-sideline-delay 0.05)
  (setq lsp-ui-lens-enable nil)
  (setq lsp-headerline-breadcrumb-enable t)
  (setq lsp-modeline-code-actions-enable t))

;; lsp-treemacs
(use-package lsp-treemacs
  :ensure t
  :after (lsp-mode treemacs)
  :commands lsp-treemacs-errors-list
  :config
  (lsp-treemacs-sync-mode 1))

;; dap-mode for debugging support
(use-package dap-mode
  :commands dap-debug
  :after lsp-mode 
  :config
  (dap-auto-configure-mode)
  (dap-mode 1)
  (dap-ui-mode 1)
  (dap-tooltip-mode 1)
  (tooltip-mode 1)
  (dap-ui-controls-mode 1)
  ;; python
  (require 'dap-python)
  (setq dap-python-debugger 'debugpy)
  ;; C/C++
  (require 'dap-gdb-lldb)
  ;; Prolog
  (require 'dap-swi-prolog)
  ;; Java
  (require 'dap-java)
  ;; Golang
  (require 'dap-dlv-go)
  ;; Javascript
  (require 'dap-chrome)
  ;; MANUAL INSTALL REQUIRED
  ;; (emacs) [M-x] dap-chrome-setup
  :hook 
  (lsp-mode . dap-mode)
  (lsp-mode . dap-ui-mode))
;; MANUAL INSTALL REQUIRED for dap-mode
;; python: $ pip install debugpy
;; C/C++: (emacs) dap-gdb-lldb-setup
;; Prolog: $ swipl -g "pack_install(debug_adapter)" -t halt

;; posframe is a pop-up tool for dap-mode
(use-package posframe)

;; MANUAL INSTALL REQUIRED: mono (pacman)
;; "vscode-cpptools" should be installed in Emacs: M-x dap-cpptools-setup

;; Enable nice rendering of diagnostics like compile errors.
(use-package flycheck
  :init
  (add-hook 'after-init-hook #'global-flycheck-mode)
  :config
  (setq flycheck-scheme-chicken-executable "chicken-csc"))

;; company
(use-package company
  :ensure t
  :after lsp-mode
  :hook 
  (prog-mode . company-mode)
  :bind
  (:map company-active-map
    ("<tab>" . company-complete-selection))
  (:map lsp-mode-map
    ("<tab>" . company-indent-or-complete-common))
  :config
  (setq company-idle-delay 0.05)
  (setq company-minimum-prefix-length 1)
  (setq lsp-completion-provider :capf))

(with-eval-after-load 'company
  (add-hook 'prog-mode-hook 'company-mode)
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous)
  (define-key company-active-map (kbd "<tab>") #'company-abort)
  (add-hook 'after-init-hook 'global-company-mode))

;; company-box
(use-package company-box
  :ensure t
  :after company
  :hook (company-mode . company-box-mode))








;; # ==== [Language Support]




;; * ---- Hardware


;; <Verilog/VHDL>
;; MANUAL INSTALL REQUIRED: pip3 install hdl-checker --user --upgrade




;; * ---- Hard Languages


;; <Assembly>
;; MANUAL INSTALL REQUIRED: cargo install asm-lsp
;; [M-x] lsp-install-server [RET] asm-lsp [RET]


;; <Haskell>
;; lsp-haskell (broken for now)
;; (use-package lsp-haskell
;;   :after lsp-mode
;;   :config
;;   (add-hook 'haskell-mode-hook #'lsp)
;;   (add-hook 'haskell-literate-mode-hook #'lsp))
;; MANUAL INSTALL REQUIRED: $ ghcup install hls


;; <Ocaml>
;; MANUAL INSTALL REQUIRED: $ opam install ocaml-lsp-server
(use-package tuareg
  :config
  (add-hook 'tuareg-mode-hook #'lsp))


;; <C/C++>
;; MANUAL INSTALL REQUIRED: clangd


;; <Rust>
;; MANUAL INSTALL REQUIRED: rust-analyzer
(use-package rust-mode
  :config
  (add-hook 'rust-mode-hook #'lsp))


;; <Forth>
(use-package forth-mode
  :mode ("\\.fs\\'" . forth-mode)
  :config
  (autoload 'forth-mode "gforth.el")
  (autoload 'forth-block-mode "gforth.el"))




;; * ---- Soft Languages


;; <LISP family>
(use-package aggressive-indent
  :config
  (add-hook 'lisp-mode-hook             #'aggressive-indent-mode)
  (add-hook 'lisp-interaction-mode-hook #'aggressive-indent-mode)
  (add-hook 'scheme-mode-hook           #'aggressive-indent-mode)
  (add-hook 'emacs-lisp-mode-hook       #'aggressive-indent-mode)
  (add-hook 'common-lisp-mode-hook      #'aggressive-indent-mode))

(use-package lisp-extra-font-lock
  :config
  (lisp-extra-font-lock-global-mode 1)
  (add-hook 'lisp-mode-hook             #'lisp-extra-font-lock-mode)
  (add-hook 'lisp-interaction-mode-hook #'lisp-extra-font-lock-mode)
  (add-hook 'scheme-mode-hook           #'lisp-extra-font-lock-mode)
  (add-hook 'emacs-lisp-mode-hook       #'lisp-extra-font-lock-mode)
  (add-hook 'common-lisp-mode-hook      #'lisp-extra-font-lock-mode))

;; paredit: structural editing
(use-package paredit
  :config
  (add-hook 'lisp-mode-hook             'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
  (add-hook 'scheme-mode-hook           'enable-paredit-mode)
  (add-hook 'emacs-lisp-mode-hook       'enable-paredit-mode)
  (add-hook 'common-lisp-mode-hook      'enable-paredit-mode))


;; <Scheme>
;; Geiser for Scheme family
(use-package geiser
  :mode ("\\.scm\\'" . scheme-mode)
  :commands (geiser run-geiser)
  :config
  (setq geiser-default-implementation 'guile)
  (setq geiser-active-implementations '(guile chicken racket))
  (setq geiser-repl-query-on-exit-p nil)
  (setq geiser-repl-autodoc-p t)
  (add-hook 'geiser-repl-mode #'smartparens-mode))

(use-package geiser-guile 
    :after geiser)

(use-package geiser-chicken
  :after geiser
  :config
  (setq geiser-chicken-binary "csi"))

(use-package geiser-racket
  :after geiser)


;; <Common Lisp>
;; Sly for Common Lisp
(use-package sly
  :mode ("\\.lisp\\'" . common-lisp-mode)
  :commands (sly)
  :config
  (setq inferior-lisp-program "sbcl")
  (add-hook 'sly-repl-mode #'smartparens-mode))




;; * ---- Dependent Type Programming


;; <Coq>
(use-package proof-general
  :mode ("\\.v\\'" . coq-mode))

(use-package company-coq
  :after (company proof-general)
  :config
  (add-hook 'coq-mode-hook #'company-coq-mode))


;; <Lean>
(use-package lean4-mode
  :mode ("\\.lean\\'" . lean4-mode)
  :straight (lean4-mode
	           :type git
	           :host github
	           :repo "leanprover/lean4-mode"
	           :files ("*.el" "data"))
  ;; to defer loading the package until required
  :commands (lean4-mode))


;; <Idris>
;; MANUAL INSTALL REQUIRED: $ pack install-app idris2-lsp
(use-package idris-mode
  :config
  (add-hook 'idris-mode #'lsp))



;; * ---- Logical Programming


;; <Prolog>
(with-eval-after-load 'lsp-mode
  (lsp-register-client
   (make-lsp-client
    :new-connection
    (lsp-stdio-connection (list "swipl"
                                "-g" "use_module(library(lsp_server))."
                                "-g" "lsp_server:main"
                                "-t" "halt"
                                "--" "stdio"))
    :major-modes '(prolog-mode)
    :priority 1
    :multi-root t
    :server-id 'prolog-ls))
  (add-to-list 'auto-mode-alist '("\\.pl$" . prolog-mode)))
;; MANUAL INSTALL REQUIRED: swipl -g 'pack_install(lsp_server)'




;; * ---- SQL


;; MANUAL INSTALL REQUIRED: go install github.com/lighttiger2505/sqls@latest
(add-hook 'sql-mode-hook 'lsp)
(setq lsp-sqls-workspace-config-path nil)




;; * ---- Numerical Analysis


;; <Python>
;; Will move to ruff later
(use-package lsp-pyright
  :ensure t
  :custom (lsp-pyright-langserver-command "pyright")
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp))))

(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt --InteractiveShell.display_page=True")


;; <Julia>
(use-package julia-mode)

(use-package lsp-julia
  :mode ("\\.jl\\'" . julia-mode)
  :after (lsp-mode julia-mode) 
  :config 
  (setq lsp-julia-default-environment (getenv "USER_JULIA_DIR"))
  (add-hook 'julia-mode-hook #'lsp-mode)
  (add-hook 'ess-julia-mode-hook #'lsp-mode))

(use-package julia-repl
  :after vterm 
  :init
  :hook (julia-mode . julia-repl-mode)
  :config
  (julia-repl-set-terminal-backend 'vterm))


;; <APL>
(defun em-gnu-apl-init ()
  (setq buffer-face-mode-face 'gnu-apl-default)
  (buffer-face-mode))

(use-package gnu-apl-mode
  :config
  (add-hook 'gnu-apl-interactive-mode-hook 'em-gnu-apl-init)
  (add-hook 'gnu-apl-mode-hook 'em-gnu-apl-init)
  (setq gnu-apl-keymap-template"
╔════╦════╦════╦════╦════╦════╦════╦════╦════╦════╦════╦════╦════╦═════════╗
║ ±∇ ║ !∇ ║ @∇ ║ #∇ ║ $∇ ║ %∇ ║ ^∇ ║ &∇ ║ *∇ ║ (∇ ║ )∇ ║ _∇ ║ +∇ ║         ║
║ §∇ ║ 1∇ ║ 2∇ ║ 3∇ ║ 4∇ ║ 5∇ ║ 6∇ ║ 7∇ ║ 8∇ ║ 9∇ ║ 0∇ ║ -∇ ║ =∇ ║ BACKSP  ║
╠════╩══╦═╩══╦═╩══╦═╩══╦═╩══╦═╩══╦═╩══╦═╩══╦═╩══╦═╩══╦═╩══╦═╩══╦═╩══╦══════╣
║       ║ \"∇ ║ <∇ ║ >∇ ║ P∇ ║ Y∇ ║ F∇ ║ G∇ ║ C∇ ║ R∇ ║ L∇ ║ ?∇ ║ +∇ ║ RET  ║
║  TAB  ║ '∇ ║ ,∇ ║ .∇ ║ p∇ ║ y∇ ║ f∇ ║ g∇ ║ c∇ ║ r∇ ║ l∇ ║ /∇ ║ =∇ ║      ║
╠═══════╩═╦══╩═╦══╩═╦══╩═╦══╩═╦══╩═╦══╩═╦══╩═╦══╩═╦══╩═╦══╩═╦══╩═╦══╩═╗    ║
║ (CAPS   ║ A∇ ║ O∇ ║ E∇ ║ U∇ ║ I∇ ║ D∇ ║ H∇ ║ T∇ ║ N∇ ║ S∇ ║ _∇ ║ |∇ ║    ║
║  LOCK)  ║ a∇ ║ o∇ ║ e∇ ║ u∇ ║ i∇ ║ d∇ ║ h∇ ║ t∇ ║ n∇ ║ s∇ ║ -∇ ║ \\∇ ║    ║
╠════════╦╩═══╦╩═══╦╩═══╦╩═══╦╩═══╦╩═══╦╩═══╦╩═══╦╩═══╦╩═══╦╩═══╦╩════╩════╣
║        ║ ~∇ ║ Z∇ ║ X∇ ║ C∇ ║ V∇ ║ B∇ ║ N∇ ║ M∇ ║ <∇ ║ >∇ ║ ?∇ ║          ║
║  SHIFT ║ `∇ ║ z∇ ║ x∇ ║ c∇ ║ v∇ ║ b∇ ║ n∇ ║ m∇ ║ ,∇ ║ .∇ ║ /∇ ║  SHIFT   ║
╚════════╩════╩════╩════╩════╩════╩════╩════╩════╩════╩════╩════╩══════════╝"))


;; <R>
;; MANUAL INSTALL REQUIRED: (R) install.packages("languageserver")
(use-package ess)




;; * ---- Text Processing


;; AWK
;; Nothing to do


;; sed
(use-package sed-mode)




;; * ---- Server Backend


;; Java
(use-package lsp-java
  :config
  (require 'dap-java)
  (add-hook 'java-mode-hook #'lsp))


;; Scala
(use-package lsp-metals
  :ensure t
  :custom
  ;; You might set metals server options via -J arguments. This might not always work, for instance when
  ;; metals is installed using nix. In this case you can use JAVA_TOOL_OPTIONS environment variable.
  (lsp-metals-server-args '(;; Metals claims to support range formatting by default but it supports range
                            ;; formatting of multiline strings only. You might want to disable it so that
                            ;; emacs can use indentation provided by scala-mode.
                            "-J-Dmetals.allow-multiline-string-formatting=off"
                            ;; Enable unicode icons. But be warned that emacs might not render unicode
                            ;; correctly in all cases.
                            "-J-Dmetals.icons=unicode"))
  ;; In case you want semantic highlighting. This also has to be enabled in lsp-mode using
  ;; `lsp-semantic-tokens-enable' variable. Also you might want to disable highlighting of modifiers
  ;; setting `lsp-semantic-tokens-apply-modifiers' to `nil' because metals sends `abstract' modifier
  ;; which is mapped to `keyword' face.
  (lsp-metals-enable-semantic-highlighting t)
  :hook (scala-mode . lsp))


;; Golang
;; MANUAL INSTALL REQUIRED
;; $ go install golang.org/x/tools/gopls@latest
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))

(use-package go-mode
  :config
  (add-hook 'go-mode-hook #'lsp-go-install-save-hooks)
  (add-hook 'go-mode-hook #'lsp-deferred))

(with-eval-after-load 'lsp-mode
  (lsp-register-custom-settings
   '(("golangci-lint.command"
      ["golangci-lint" "run" "--enable-all" "--disable" "lll" "--out-format" "json" "--issues-exit-code=1"])))

  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection
                                     '("golangci-lint-langserver"))
                    :activation-fn (lsp-activate-on "go")
                    :language-id "go"
                    :priority 0
                    :server-id 'golangci-lint
                    :add-on? t
                    :library-folders-fn #'lsp-go--library-default-directories
                    :initialization-options (lambda ()
                                              (gethash "golangci-lint"
                                                       (lsp-configuration-section "golangci-lint"))))))








;; * ---- Infrastructure


;; <CMake>
;; MANUAL INSTALL REQUIRED: cmake-language server (pip)


;; <Bash>
;; MANUAL INSTALL REQUIRED: [M-x] lsp-install-server [RET] bash-ls [RET]




;; * ---- Web


;; <HTML>
;; MANUAL INSTALL REQUIRED: [M-x] lsp-install-server [RET] html-ls [RET]


;; <CSS>
;; MANUAL INSTALL REQUIRED: [M-x] lsp-install-server [RET] css-ls [RET]


;; <Javascript>
;; MANUAL INSTALL REQUIRED: [M-x] lsp-install-server [RET] ts-ls [RET]

;; Verb
(use-package verb)








;; * ---- Documentation




;; <Hledger>
;; hledger-mode
(use-package hledger-mode
  :mode ("\\.journal\\'" "\\.hledger\\'")
  :commands hledger-enable-reporting
  :bind (("C-c j" . hledger-run-command)
         :map hledger-mode-map
         ("C-c e" . hledger-jentry)
         ("M-p" . hledger/prev-entry)
         ("M-n" . hledger/next-entry))
  :init
  (setq hledger-jfile (getenv "LEDGER_FILE"))
  (setq hledger-show-expanded-report nil)
  :config
  (add-hook 'hledger-view-mode-hook #'hl-line-mode)
  (add-hook 'hledger-view-mode-hook #'center-text-for-reading)
  (add-hook 'hledger-mode-hook
            #'(lambda ()
                (make-local-variable 'company-backends)
                (add-to-list 'company-backends 'hledger-company))))

;; flycheck-hledger
(use-package flycheck-hledger
  :after (flycheck hledger-mode)
  :demand t)


;; <LaTeX>
;; AUCTeX
(use-package tex
  :ensure auctex
  :defer t
  :config
  (setq-default TeX-auto-save t)
  (setq-default TeX-parse-self t)
  (TeX-PDF-mode)
  ;; Use XeLaTeX & stuff
  (setq-default TeX-engine 'xetex)
  (setq-default TeX-command-extra-options "-shell-escape")
  (setq-default TeX-source-correlate-method 'synctex)
  (TeX-source-correlate-mode)
  (setq-default TeX-source-correlate-start-server t)
  (setq-default LaTeX-math-menu-unicode t)
  (setq-default font-latex-fontify-sectioning 1.3)
  ;; Scale preview for my DPI
  (setq-default preview-scale-function 1.0)
  (when (boundp 'tex--prettify-symbols-alist)
    (assoc-delete-all "--" tex--prettify-symbols-alist)
    (assoc-delete-all "---" tex--prettify-symbols-alist))
  (add-hook 'LaTeX-mode-hook
	          #'(lambda ()
	            (TeX-fold-mode 1)
	            (outline-minor-mode)))
  (add-to-list 'TeX-view-program-selection
	             '(output-pdf "Zathura"))
  ;; Do not run lsp within templated TeX files
  (add-hook 'LaTeX-mode-hook
	          (lambda ()
	            (unless (string-match "\.hogan\.tex$" (buffer-name))
		            (lsp))
	            (setq-local lsp-diagnostic-package :none)
	            (setq-local flycheck-checker 'tex-chktex)))
  (add-hook 'LaTeX-mode-hook #'rainbow-delimiters-mode)
  (add-hook 'LaTeX-mode-hook #'smartparens-mode)
  (add-hook 'LaTeX-mode-hook #'prettify-symbols-mode)
  (add-hook 'LaTeX-mode-hook #'display-line-numbers-mode)
  (use-package smartparens))

;; auctex-latexmk
(use-package auctex-latexmk
  :after tex
  :config
  (auctex-latexmk-setup))

;; render LaTeX in org mode
(use-package ob-latex-as-png
  :after tex)

(with-eval-after-load 'org
  (setq org-latex-create-formula-image-program 'imagemagick)
  (setq org-latex-packages-alist
	'(("" "minted" t)
	  ("" "tikz" t)
	  ("" "tikz-cd" t)))
  (setq my-org-latex-preview-scale 1.0)
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))
  (eval-after-load "preview"
    '(add-to-list 'preview-default-preamble "\\PreviewEnvironment{tikzpicture}" t)))

;; <GNUPlot>
(use-package gnuplot
  :mode ("\\.gpi\\'" . gnuplot-mode)
  :config
  (autoload 'gnuplot-mode "gnuplot" "Gnuplot major mode" t)
  (autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot-mode" t))








;; # ==== [Org Mode]




;; * ---- Org mode




;; org
(use-package org
  :ensure t
  :bind (:map org-mode-map
	            ("C-<tab>" . org-cycle))
  :mode
  ("\\.org'" . org-mode)
  :config
  (setq org-startup-indented t
        ;; org-bullets-bullet-list '(" ")
        org-ellipsis "  " ;; folding symbol
        org-pretty-entities t
        org-hide-emphasis-markers t
        ;; show actually italicized text instead of /italicized text/
        org-agenda-block-separator ""
        org-fontify-whole-heading-line t
        org-fontify-done-headline t
        org-fontify-quote-and-verse-blocks t)

  (setq calender-week-start-day 1)
  (setq org-agenda-start-on-weekday 1)
  (setq org-clock-persist 'history)
  (org-clock-persistence-insinuate)
  
  (setq org-directory (getenv "USER_ORG_DIR"))
  (make-directory org-directory t)

  (make-directory (concat org-directory "notes") t)
  (make-directory (concat org-directory "agenda") t)
  (make-directory (concat org-directory "roam") t)
  (make-directory (concat org-directory "blog") t)
  (make-directory (concat org-directory ".archive") t)
  (setq org-archive-location (concat org-directory ".archive/"))
  (make-directory (concat org-directory ".files") t)
  (make-directory (concat org-directory ".files/images") t)
  (make-directory (concat org-directory ".files/static") t)

  (make-directory (concat (getenv "USER_HTML_DIR") "images") t)
  (make-directory (concat (getenv "USER_HTML_DIR") "static") t)

  (setq org-default-notes-file (concat (concat org-directory "notes/") "default.org")
	      org-agenda-files (cons org-default-notes-file (directory-files-recursively (concat org-directory "agenda/") "\\.org$"))
	      
	      org-capture-templates
	      '(("t" "Todo" entry (file+headline org-default-notes-file "TODO")
	         "* TODO %?\n%u\n%i\n%a" :clock-in t :clock-resume t)
	        ("s" "Schedule" entry (file+headline org-default-notes-file "Schedule")
	         "* Schedule with %? :SCHEDULE:\non %T" :time-prompt t)
	        ("i" "Idea" entry (file+headline org-default-notes-file "Idea")
	         "* IDEA %? :IDEA:\n%t" :clock-in t :clock-resume t)
	        ("j" "Journal" entry (file+headline org-default-notes-file "Journal")
	         "* Journal %?\n%U\n" :clock-in t :clock-resume t)))

  (defun refresh-org-agenda-files ()
    "Refresh 'org-agenda-files' variable if tue current buffer is an .org file."
    (when (and (buffer-file-name)
               (string-equal "org" (file-name-extension (buffer-file-name)))
               (or (string-equal (concat org-directory "agenda/") (file-name-directory (buffer-file-name)))
                   (string-equal (concat (getenv "USER_ORG_SHORTCUT_DIR") "agenda/") (file-name-directory (buffer-file-name)))))
      (progn
        (org-agenda-file-to-front)
        (let ((return-buffer-name (buffer-name)))
          (dashboard-refresh-buffer)
          (switch-to-buffer return-buffer-name)))))

  (add-hook 'after-save-hook 'refresh-org-agenda-files)
  (setq org-todo-keywords
        '((sequence "TODO(t)" "DOING(g)" "HOLD(h)" "DONE(d)")))

  ;; org-clock for alarm
  (setq org-clock-sound (concat (getenv "USER_MUSIC_DIR") "SFX/bell.wav"))

  ;; org-tempo for structured editing
  (require 'org-tempo)
  
  (setq org-columns-default-format "%50ITEM(Task) %10CLOCKSUM %16TIMESTAMP_IA")
  (setq org-refile-targets (quote ((nil :maxlevel . 9)
				                           (org-agenda-files :maxlevel . 9))))
  
  (global-set-key (kbd "C-c l") #'org-store-link)
  (global-set-key (kbd "C-c a") #'org-agenda)
  (global-set-key (kbd "C-c c") #'org-capture)

  (add-hook 'org-mode-hook
	          (lambda ()
	            "Beautify Org Checkbox Symbol"
	            (push '("[ ]" .  "☐") prettify-symbols-alist)
	            (push '("[X]" . "☑" ) prettify-symbols-alist)
	            (push '("[-]" . "❍" ) prettify-symbols-alist)
	            (push '("#+BEGIN_SRC" . "↦" ) prettify-symbols-alist)
	            (push '("#+END_SRC" . "⇤" ) prettify-symbols-alist)
	            (push '("#+BEGIN_EXAMPLE" . "↦" ) prettify-symbols-alist)
	            (push '("#+END_EXAMPLE" . "⇤" ) prettify-symbols-alist)
	            (push '("#+BEGIN_QUOTE" . "↦" ) prettify-symbols-alist)
	            (push '("#+END_QUOTE" . "⇤" ) prettify-symbols-alist)
	            (push '("#+begin_quote" . "↦" ) prettify-symbols-alist)
	            (push '("#+end_quote" . "⇤" ) prettify-symbols-alist)
	            (push '("#+begin_example" . "↦" ) prettify-symbols-alist)
	            (push '("#+end_example" . "⇤" ) prettify-symbols-alist)
	            (push '("#+begin_src" . "↦" ) prettify-symbols-alist)
	            (push '("#+end_src" . "⇤" ) prettify-symbols-alist)
	            (prettify-symbols-mode)))
  ;; org-babel language extension
  (use-package ob-go
    :ensure t
    :after org)
  (use-package ob-prolog
    :ensure t
    :after org)
  (use-package ob-rust
    :ensure t
    :after org)
  (use-package jupyter
    :ensure t
    :after org)
  (use-package ob-lean4
    :ensure t
    :after org
    :quelpa (ob-lean4 :fetcher github :repo "Maverobot/ob-lean4"
                      :files ("ob-lean4.el")))

  (define-key org-mode-map (kbd "C-c C-r") verb-command-map)
  
  ;; org-babel languages support
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((scheme . t)
     (lisp . t)
     (haskell . t)
     (ocaml . t)
     (C . t)
     (forth . t)
     (prolog . t)
     (lean4 . t)
     (go . t)
     (rust . t)
     (julia . t)
     (python . t)
     (jupyter . t)
     (R . t)
     (awk . t)
     (sed . t)
     (js . t)
     (java . t)
     (octave . t)
     (makefile . t)
     (org . t)
     (latex . t)
     (gnuplot . t)
     (sql . t)
     (css . t)))

  ;; org-babel python3
  (setq org-babel-python-command "python3")
  (setq org-babel-jupyter-override-src-block "python")
  
  ;; refresh org inline image every execution
  (setq org-image-actual-width '(1024 512 256))
  (add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)

  ;; Blog
  (require 'ox-publish)
  (require 'ox-html)

  (setq org-html-validation-link nil)
  (setq org-html-head-include-scripts nil)
  (setq org-html-head-include-default-style nil)
  (setq org-html-head
        ""        )   

  (setq org-publish-project-alist
        `(("articles"
           :base-directory ,(concat org-directory "blog/")
           :base-extension "org"
           :publishing-directory ,(getenv "USER_HTML_DIR")
           :publishing-function org-html-publish-to-html
           :recursive t

           :auto-sitemap t
           :sitemap-filename "sitemap.org"
           :sitemap-title "Sitemap"

           :with-author nil
           :with-creator nil
           :with-toc t
           :with-title t
           :with-date t
           :section-numbers nil
           :time-stamp-file nil
           :with-fixed-width t
           :with-latex t
           :with-tables t
           :auto-preamble t
           
           :html-doctype "html5"
           :html-html5-fancy t
           :html-head-include-default-style nil
           :html-head-include-scripts nil
           :html-preamble
           "<nav>
               <a href=\"/\">&lt; Home</a>
           </nav>"
           :html-postamble
           "<hr/>
           <footer>
               <div class=\"copyright-container\">
                   <div class=\"copyright\">
                       Copyright &copy; 1996-2077 Emacs is my life rights reserved<br/>
                       Content is available under
                       <a rel=\"license\" href=\"http://creativecommons.org/licenses/by-sa/4.0/\">
                           CC-BY-SA 4.0
                       </a> unless otherwise noted
                   </div>
                   <div class=\"cc-badge\">
                       <a rel=\"license\" href=\"http://creativecommons.org/licenses/by-sa/4.0/\">
                           <img alt=\"Creative Commons License\"
                                src=\"https://i.creativecommons.org/l/by-sa/4.0/88x31.png\"/>
                       </a>
                   </div>
               </div>
           </footer>"
           :htmlized-source t)
          
          ("static"
           :base-directory ,(concat org-directory ".files/static/")
           :base-extension "css\\|js\\|txt\\|png\\|jpg\\|jpeg\\|gif"
           :publishing-directory ,(concat (getenv "USER_HTML_DIR") "static/")
           :recursive t
           :publishing-function org-publish-attachment)
          
          ("images"
           :base-directory ,(concat org-directory ".files/images/")
           :base-extension "png\\|jpg\\|jpeg\\|gif\\|webp\\|webm"
           :publishing-directory ,(concat (getenv "USER_HTML_DIR") "images/")
           :recursive t
           :publishing-function org-publish-attachment)
          
          ("blog" :components ("articles" "static" "images")))))

;; org-bullets
(use-package org-bullets
  :after org
  :ensure t
  :init
  (setq org-bullets-bullet-list
	      '("■" "□" "◆" "◇" "▲" "△" "●" "○"))
  :hook (org-mode . org-bullets-mode))

;; Asynchronous src block execution for org-babel
(use-package ob-async
  :after org
  :config
  (setq ob-async-no-async-languages-alist '("python" "jupyter-python"))
  (add-hook 'ob-async-pre-execute-src-block-hook
            #'(lambda ()
	              (setq inferior-julia-program-name "julia"))))

(use-package org-auto-tangle
  :after org
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))

(use-package org-bullets
  :after org 
  :config
  (add-hook 'org-mode-hook #'(lambda () (org-bullets-mode))))

;; org-roam
(use-package org-roam
  :ensure t
  :after org 
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory (concat org-directory "roam/"))
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
   '(("d" "default" plain
      "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
      :unnarrowed t)))
  :bind
  (("C-c n l" . org-roam-buffer-toggle)
   ("C-c n f" . org-roam-node-find)
   ("C-c n i" . org-roam-node-insert)
   :map org-mode-map
   ("C-M-i" . completion-at-point))
  :config
  (org-roam-setup))

(use-package websocket
  :after org-roam)

(use-package org-roam-ui
  :after org-roam ;; or :after org
  ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
  ;;         a hookable mode anymore, you're advised to pick something yourself
  ;;         if you don't care about startup time, use
  ;;  :hook (after-init . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

(use-package org-ref
  :after org-roam)

(use-package org-roam-bibtex
  :after org-roam
  :config
  (require 'org-ref))

;; org-download
(use-package org-download
  :after org 
  :init
  (setq-default org-download-image-dir (concat org-directory ".files/images/"))
  :config
  (add-hook 'dired-mode-hook 'org-download-enable)
  (setq-default org-download-timestamp t))

;; org-ql for searching
(use-package org-ql
  :after org
  :quelpa (org-ql :fetcher github :repo "alphapapa/org-ql"
		  :files (:defaults (:exclude "helm-org-ql.el"))))

(use-package helm-org-ql
  :after (helm org-ql)
  :quelpa (helm-org-ql :fetcher github :repo "alphapapa/org-ql"
                       :files ("helm-org-ql.el")))

;; org-fc for spaced repetition
(use-package hydra)
(use-package org-fc
  :straight
  (org-fc :type git
          :host github
          :repo "l3kn/org-fc"
          :files (:defaults "awk" "demo.org"))
  :after org-roam
  :config
  (require 'org-fc-keymap-hint)
  (require 'org-fc-hydra)
  (global-set-key (kbd "C-c f") 'org-fc-hydra/body)
  (setq org-fc-directories `(,(concat org-directory "roam/")))
  (setq org-fc-review-history-file (concat org-directory "notes/org-fc-reviews.tsv")))

;; Nano Agenda
(use-package nano-agenda)








;; # ==== [Email]




;; mu4e
(use-package mu4e
  :ensure nil
  :pin manual
  :defer 20
  :config
  (setq mu4e-change-filenames-when-moving t)
  (setq mu4e-maildir (getenv "USER_MAIL_DIR"))
  (setq mu4e-attachment-dir "~/Downloads")

  (defun mu4e/run-mbsync (temp_arg)
    (with-environment-variables (("MBSYNC_TEMP_ARG" temp_arg))
      (start-process "mbsync" nil "mbsync" "-a")))
  
  (add-hook 'mu4e-update-pre-hook
            (lambda ()
              (let ((auth-info (car (auth-source-search :max 1
                                                        :host "imap.gmail.com"
                                                        :user (getenv "USER_MAIL_ADDRESS")
                                                        :require '(:secret)))))
                (if auth-info
                    (let ((secret (plist-get auth-info :secret)))
                      (cond
                       ((stringp secret) (mu4e/run-mbsync secret))
                       ((functionp secret) (mu4e/run-mbsync (funcall secret)))
                       (t (message "[MU4E]: Unexpected secret type: %s" (type-of secret)))))
                  (message "[MU4E]: No matching auth entry found")))))
  
  (setq mu4e-get-mail-command "true")
  
  (setq mu4e-drafts-folder "/[Gmail]/Drafts")
  (setq mu4e-sent-folder "/[Gmail]/Sent Mail")
  (setq mu4e-refile-folder "/[Gmail]/All Mail")
  (setq mu4e-trash-folder "/[Gmail]/Trash")
  
  (setq mu4e-maildir-shortcuts
        '((:maildir "/Inbox"    :key ?i)
          (:maildir "/[Gmail]/Sent Mail" :key ?s)
          (:maildir "/[Gmail]/Trash"     :key ?t)
          (:maildir "/[Gmail]/Drafts"    :key ?d)
          (:maildir "/[Gmail]/All Mail"  :key ?a)))

  (setq mu4e-headers-date-format "%Y-%m-%d %H:%M")
  (setq mu4e-search-include-related t)
  (setq mu4e-compose-format-flowed t)

  (require 'smtpmail)
  (require 'auth-source)
  (setq smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil)))
  (setq smtp-mail-stream-type 'starttls)
  (setq auth-sources `(,(concat (getenv "USER_SECRET_DIR") "authinfo.gpg")))
  (setq smtpmail-auth-credentials 'auth-source)
  (setq user-mail-address (getenv "USER_MAIL_ADDRESS"))
  (setq user-full-name (getenv "USER_FULL_NAME"))
  (setq smtpmail-smtp-server "smtp.gmail.com")
  (setq smtpmail-smtp-service 587)

  (defun sign-or-encrypt-message ()
    (let ((answer (read-from-minibuffer "Sign or encrypt?\nEmpty to do nothing.\n[s/e]: ")))
      (cond
       ((string-equal answer "s") (progn
                                    (message "Signing message.")
                                    (mml-secure-message-sign-pgpmime)))
       ((string-equal answer "e") (progn
                                    (message "Encrypt and signing message.")
                                    (mml-secure-message-encrypt-pgpmime)))
       (t (progn
            (message "Dont signing or encrypting message.")
            nil)))))
  (add-hook 'message-send-hook 'sign-or-encrypt-message)
  :init
  (mu4e t))








;; # ==== [Utilities]




;; Terminal
(use-package vterm
  :pin manual
  :ensure nil ;; guix will handle this (emacs-vterm package)
  :config
  (setq vterm-always-compile-module t)
  (setq vterm-ignore-blink-cursor nil)
  (add-hook 'vterm-mode-hook
            #'(lambda ()
                (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix))))

(use-package eterm-256color
  :ensure t
  :after vterm 
  :config
  (add-hook 'vterm-mode-hook #'eterm-256color-mode))








;; # ==== [EXWM]


(use-package epg
  :ensure t
  :config
  (setq epg-pinentry-mode 'loopback)
  :init
  (pinentry-start))

(defun exwm/update-class ()
  (exwm-workspace-rename-buffer exwm-class-name))

(defun exwm/run-in-background (command)
  (let ((command-parts (split-string command "[ ]+")))
    (apply #'call-process `(,(car command-parts) nil 0 nil ,@(cdr command-parts)))))

(defun exwm/exwm-init-hook ()
  (exwm/run-in-background "dunst")
  (exwm-workspace-switch-create 0))

(defun exwm/exwm-update-title ()
  (pcase exwm-class-name
    ("Firefox" (exwm-workspace-rename-buffer (format "Firefox: %s" exwm-title)))
    ("qutebrowser" (exwm-workspace-rename-buffer (format "QB: %s" exwm-title)))))

(defun exwm/position-window ()
  (let* ((pos (frame-position))
         (pos-x (car pos))
         (pos-y (cdr pos)))

    (exwm-floating-move (- pos-x) (- pos-y))))

(defun exwm/configure-window-by-class ()
  (interactive)
  (pcase exwm-class-name
    ("Firefox" (exwm-workspace-move-window 2))
    ("mpv" (exwm-floating-toggle-floating)
     (exwm-layout-toggle-mode-line))))

(defun exwm/update-displays ()
  (exwm/run-in-background "autorandr --change --force")
  (message "Display config: %s"
           (string-trim (shell-command-to-string "autorandr --current")))
  (exwm/update-workspace-monitor-mapping))

(defun exwm/update-workspace-monitor-mapping ()
  (let ((monitor-params (split-string (shell-command-to-string (concat (getenv "XDG_CONFIG_HOME") "/emacs/exwm/monitors-exwm.sh")))))
    (let* ((wm-map (list 0 (car monitor-params))) (monitor-params (cdr monitor-params)))
      (let* ((cnt (string-to-number (car monitor-params))) (monitor-params (cdr monitor-params)))
        (dotimes (i cnt)
          (setq wm-map (append wm-map (list (+ i 1) (car monitor-params))))
          (setq monitor-params (cdr monitor-params)))
        (setq exwm-workspace-number (+ cnt 1))
        (setq exwm-randr-workspace-monitor-plist wm-map)))))

(defun exwm/dunstctl (command)
  (start-process-shell-command "dunstctl" nil (concat "dunstctl " command)))

(defun exwm/disable-desktop-notifications ()
  (interactive)
  (start-process-shell-command "notify-send" nil "notify-send \"DUNST_COMMAND_PAUSE\""))

(defun exwm/enable-desktop-notifications ()
  (interactive)
  (start-process-shell-command "notify-send" nil "notify-send \"DUNST_COMMAND_RESUME\""))

(defun exwm/toggle-desktop-notifications ()
  (interactive)
  (start-process-shell-command "notify-send" nil "notify-send \"DUNST_COMMAND_TOGGLE\""))

(use-package exwm
  :ensure t
  :config
  (require 'exwm-xim)
  (exwm-xim-enable)
  (push ?\C-\\ exwm-input-prefix-keys)

  (add-hook 'exwm-init-hook #'exwm/exwm-init-hook)
  (add-hook 'exwm-update-class-hook #'exwm/update-class)
  (add-hook 'exwm-update-title-hook #'exwm/exwm-update-title)
  (add-hook 'exwm-manage-finish-hook #'exwm/configure-window-by-class)

  (setq exwm-layout-show-all-buffers t)
  (setq exwm-workspace-show-all-buffers t)
  (setq exwm-workspace-warp-cursor t)
  (setq mouse-autoselect-window t
        focus-follows-mouse t)

  (require 'exwm-randr)
  (exwm-randr-enable)
  (add-hook 'exwm-randr-screen-change-hook #'exwm/update-displays)
  (exwm/update-displays)

  (setq exwm-floating-border-width 16)
  (setq exwm-floating-border-color "#37474F")

  ;; Remap CapsLock to Ctrl
  (start-process-shell-command "xmodmap" nil (concat "xmodmap " (getenv "XDG_CONFIG_HOME") "/X11/xmodmap"))
  
  (setq exwm-input-prefix-keys
        '(?\C-x
          ?\C-u
          ?\C-h
          ?\M-x
          ?\M-`
          ?\M-&
          ?\M-:
          ?\C-\M-j
          ?\C-\ ))

  (define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)

  (setq exwm-input-global-keys
        `(([?\s-r] . exwm-reset)

          ([s-left] . windmove-left)
          ([s-right] . windmove-right)
          ([s-up] . windmove-up)
          ([s-down] . windmove-down)

          ([?\s-b] . windmove-left)
          ([?\s-f] . windmove-right)
          ([?\s-p] . windmove-up)
          ([?\s-n] . windmove-down)

          ([?\s-F] . exwm-layout-toggle-fullscreen)
          ([?\s-t] . exwm-floating-toggle-floating)
          ([?\s-m] . (lambda ()
                       (interactive)
                       (exwm-layout-toggle-mode-line)
                       (exwm-workspace-toggle-minibuffer)))
          ([?\s-i] . exwm-input-toggle-keyboard)
          ([?\s-q] . kill-this-buffer)

          ([?\s-d] . helm-run-external-command)
          ([?\s-&] . (lambda (command)
                       (interactive (list (read-shell-command "$ ")))
                       (start-process-shell-command command nil command)))
          
          ([?\s-w] . exwm-workspace-switch)
          ;; 's-N': Switch to certain workspace with Super (Win) plus a number key (0 - 9)
          ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
                        (lambda ()
                          (interactive)
                          (exwm-workspace-switch-create ,i))))
                    (number-sequence 0 9))))

  (exwm-input-set-key (kbd "s-h") (lambda () (interactive) (exwm/dunstctl "history-pop")))
  (exwm-input-set-key (kbd "s-H") (lambda () (interactive) (exwm/dunstctl "close-all")))

  (setq exwm-input-simulation-keys
        '(
          ;; movement
          ([?\C-b] . left)
          ([?\M-b] . C-left)
          ([?\C-f] . right)
          ([?\M-f] . C-right)
          ([?\C-p] . up)
          ([?\C-n] . down)
          ([?\C-a] . home)
          ([?\C-e] . end)
          ([?\M-v] . prior)
          ([?\C-v] . next)
          ([?\C-d] . delete)
          ([?\C-k] . (S-end delete))
          ;; cut/paste
          ([?\C-w] . ?\C-x)
          ([?\M-w] . ?\C-c)
          ([?\C-y] . ?\C-v)
          ;; search
          ([?\C-s] . ?\C-f))))
;; (exwm-enable) will be invoked from xinitrc

(use-package desktop-environment
  :after exwm
  :config (desktop-environment-mode)
  :custom
  (desktop-environment-brightness-small-increment "2%+")
  (desktop-environment-brightness-small-decrement "2%-")
  (desktop-environment-brightness-normal-increment "5%+")
  (desktop-environment-brightness-normal-decrement "5%-"))








;; # ==== [Dashboard]




(defun clean-buffer-list ()
  (progn
    (kill-buffer "*straight-process*")
    (kill-buffer "*quelpa-build-checkout*")))
(add-hook 'after-init-hook #'clean-buffer-list)


(use-package dashboard
  :ensure t
  :after exwm
  :config
  (setq dashboard-banner-logo-title "")
  (setq dashboard-startup-banner 'official)
  (setq dashboard-footer-messages '(""))
  (setq dashboard-center-content t)
  (setq dashboard-vertically-center-content nil)
  (setq dashboard-show-shortcuts t)
  (setq dashboard-items '((agenda . 16)))
  (setq dashboard-agenda-sort-strategy '(time-up priority-down))
  (setq dashboard-navigation-cycle t)
  (setq dashboard-icon-types 'all-the-icons)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-week-agenda t)
  (dashboard-setup-startup-hook)
  (dashboard-open))








;; # ==== [LLM assistance]




(use-package ellama
  :init
  ;; setup key bindings
  (setopt ellama-keymap-prefix "C-c e")
  ;; language you want ellama to translate to
  (setopt ellama-language "English")
  ;; could be llm-openai for example
  (require 'llm-ollama)
  (setopt ellama-provider
	        (make-llm-ollama
	         ;; this model should be pulled to use it
	         ;; value should be the same as you print in terminal during pull
	         :chat-model "llama3:8b-instruct-q8_0"
	         :embedding-model "nomic-embed-text"
	         :default-chat-non-standard-params '(("num_ctx" . 8192))))
  ;; Predefined llm providers for interactive switching.
  ;; You shouldn't add ollama providers here - it can be selected interactively
  ;; without it. It is just example.
  (setopt ellama-providers
		      '(("zephyr" . (make-llm-ollama
				                 :chat-model "zephyr:7b-beta-q6_K"
				                 :embedding-model "zephyr:7b-beta-q6_K"))
		        ("mistral" . (make-llm-ollama
				                  :chat-model "mistral:7b-instruct-v0.2-q6_K"
				                  :embedding-model "mistral:7b-instruct-v0.2-q6_K"))
		        ("mixtral" . (make-llm-ollama
				                  :chat-model "mixtral:8x7b-instruct-v0.1-q3_K_M-4k"
				                  :embedding-model "mixtral:8x7b-instruct-v0.1-q3_K_M-4k"))))
  ;; Naming new sessions with llm
  (setopt ellama-naming-provider
	        (make-llm-ollama
	         :chat-model "llama3:8b-instruct-q8_0"
	         :embedding-model "nomic-embed-text"
	         :default-chat-non-standard-params '(("stop" . ("\n")))))
  (setopt ellama-naming-scheme 'ellama-generate-name-by-llm)
  ;; Translation llm provider
  (setopt ellama-translation-provider (make-llm-ollama
				                               :chat-model "phi3:14b-medium-128k-instruct-q6_K"
				                               :embedding-model "nomic-embed-text")))

