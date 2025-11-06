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
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))
(add-to-list 'package-archives '("elpa" . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(setq package-archive-priorities '(("org" . 2) ("elpa" . 1) ("melpa" . 0)))
(package-initialize)

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
;; use-package
(straight-use-package 'use-package)
(setq package-enable-at-startup nil)
(setq use-package-verbose nil)

;; Quelpa
(unless (package-installed-p 'quelpa)
  (with-temp-buffer
    (url-insert-file-contents "https://raw.githubusercontent.com/quelpa/quelpa/master/quelpa.el")
    (eval-buffer)
    (quelpa-self-upgrade)))

(use-package quelpa
  :ensure t)

(use-package quelpa-use-package
  :ensure t
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
  (auto-package-update-prompt-before-update t) 
  (auto-package-update-hide-results t)
  :config
  (setq auto-package-update-excluded-packages '(mu4e vterm guix 
						                                         dash zmq magit-popup emacsql pg edit-indirect bui
						                                         finalize peg
						                                         geiser geiser-guile geiser-racket))
  (setq auto-package-update-delete-old-versions t)
  (auto-package-update-maybe))




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






;; # ===== [Guix managed emacs libraries]




(use-package dash
  :ensure nil
  :pin manual)

(use-package zmq
  :ensure nil
  :pin manual)

(use-package magit-popup
  :ensure nil
  :pin manual)

(use-package emacsql
  :ensure nil
  :pin manual)

(use-package pg
  :ensure nil
  :pin manual)

(use-package edit-indirect
  :ensure nil
  :pin manual)

(use-package bui
  :ensure nil
  :pin manual)

(use-package finalize
  :ensure nil
  :pin manual)

(use-package peg
  :ensure nil
  :pin manual)




;; # ===== [Secret Management]




(setq auth-sources `(,(concat (getenv "USER_SECRET_DIR") "authinfo.gpg")))




;; # ===== [Appearance]




;; * ---- <Emacs appearance settings>


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
  (setq-default tab-width 4)
  (setq initial-major-mode 'text-mode)
  (setq initial-scratch-message ""))




;; * ---- <Themes>




(defun my/nano-theme ()
  (progn
    ;; UI
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

    ;; Font
    (setq nano-font-family-monospaced "JuliaMono")
    (setq nano-font-size 12)

    ;; Nano theme
    (nano-toggle-theme)))

;; Nano Emacs
(use-package nano-theme
  :ensure t
  :after exwm
  :quelpa (nano-emacs
           :fetcher github
           :repo "rougier/nano-emacs")
  :config
  ;; Font
  (add-to-list 'default-frame-alist '(font . "JuliaMono"))
  (set-face-attribute 'default nil :font "JuliaMono" :height 120 :weight 'regular)
  (set-face-attribute 'bold nil :font "JuliaMono" :height 120 :weight 'bold)
  ;; Modeline
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

  ;; Load packages
  (require 'nano-base-colors)
  (require 'nano-colors)
  (require 'nano-faces)
  (require 'nano-theme-light)
  (require 'nano-modeline)
  (require 'nano-layout)
  
  ;; Nano-theme
  (my/nano-theme)

  ;; EXWM Hook
  (add-hook 'after-make-frame-functions
            #'(lambda (frame)
  	            (select-frame frame)
  	            (when (display-graphic-p frame)
                  (set-frame-parameter exwm--frame 'internal-border-width 32)
                  (redraw-frame)
                  (my/nano-theme)))))

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

;; IEdit
(use-package iedit
  :ensure t)


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
  :ensure t
  :config
  (setq recentf-max-saved-items 128)
  (setq recentf-filename-handlers
	(append '(abbreviate-file-name) recentf-filename-handlers))
  (recentf-mode))

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
(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

;; treemacs-all-the-icons
(use-package treemacs-all-the-icons
  :after (treemacs all-the-icons)
  :ensure t)

;; TRAMP for remote access
(setq remote-file-name-inhibit-locks t
      tramp-use-scp-direct-remote-copying t
      remote-file-name-inhibit-auto-save-visited t)

;; Openwith for external programs
(use-package openwith
  :ensure t
  :init
  (openwith-mode 1)
  :config
  (setq openwith-associations
        (list
         (list (openwith-make-extension-regexp
                '("pdf" "ps" "ps.gz" "dvi"))
               "sioyek"
               '(file))
         (list (openwith-make-extension-regexp
                '("epub"))
               "FBReader"
               '(file))
         (list (openwith-make-extension-regexp
                '("doc" "xls" "xlsx" "ppt" "pptx" "odt" "ods" "odg" "odp"))
               "libreoffice"
               '(file))
         (list (openwith-make-extension-regexp
                '("mp4" "mov" "flv" "avi" "wmv" "mkv"))
               "mpv"
               '(file)))))

;; avy for efficient navigation
(use-package avy
  :ensure t
  :config
  (avy-setup-default)
  (global-set-key (kbd "C-c C-j") 'avy-resume))








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
(use-package magit
  :ensure t)








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

;; helm-bibtex
(use-package helm-bibtex
  :ensure t
  :config
  (setq bibtex-completion-bibliography (getenv "USER_BIBTEX_DIR")
        bibtex-completion-library-path (getenv "USER_BOOK_DIR")
        bibtex-completion-pdf-field "File"
        bibtex-completion-notes-path (getenv "USER_ORG_DIR")
        bibtex-completion-additional-search-fields '(keywords))
  :bind
  (("C-x B" . helm-bibtex)))

;; helpful source code search
(use-package helpful
  :ensure t
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







;; # ==== [Org Mode]




;; * ---- Org mode


;; org
(use-package org
  :straight t
  :ensure t
  :defer t
  :bind (:map org-mode-map
	          ("C-<tab>" . org-cycle))
  :mode
  ("\\.org'" . org-mode)
  :config
  ;; Org directory setup
  (setq org-directory (getenv "USER_ORG_DIR"))
  (make-directory org-directory t)

  (setq org-journal-directory (concat org-directory "journal"))
  (make-directory org-journal-directory t)
  (make-directory (concat org-directory "notes") t)
  (make-directory (concat org-directory "agenda") t)
  (make-directory (concat org-directory "agenda/.archive") t)
  (make-directory (concat org-directory "roam") t)
  (make-directory (concat org-directory ".archive") t)
  (setq org-archive-location (concat org-directory ".archive/"))
  (make-directory (concat org-directory ".files") t)
  (make-directory (concat org-directory ".files/images") t)
  (make-directory (concat org-directory ".files/static") t)

  (make-directory (concat (getenv "USER_HTML_DIR") "images") t)
  (make-directory (concat (getenv "USER_HTML_DIR") "static") t)

  ;; Org symbols and font-lock setup
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

  (add-hook 'org-mode-hook
	        (lambda ()
	          "Beautify Org Checkbox Symbol"
	          (push '("[ ]" . "☐") prettify-symbols-alist)
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

  ;; org-tempo for structured editing
  (require 'org-tempo)

  ;; Org Agenda  Basic Setup  
  (setq org-default-notes-file (concat (concat org-directory "notes/") "default.org"))
  (setq org-contacts-default-notes-file (concat (concat org-directory "notes/") "contacts.org"))
  
  ;; Org Agenda Capture Setup
  (setq org-agenda-directory (concat org-directory "agenda/"))
  (setq org-agenda-files (cons org-default-notes-file (directory-files-recursively org-agenda-directory "\\.org$")))
  (setq org-use-property-inheritance t)

  (global-set-key (kbd "C-c l") #'org-store-link)
  (global-set-key (kbd "C-c a") #'org-agenda)
  (global-set-key (kbd "C-c c") #'org-capture)
  (global-set-key (kbd "C-c i") (lambda () (interactive) (org-capture 0)))

  (setq org-todo-keywords
        '((sequence "TODO(t)" "ACTIVE(a)" "ONHOLD(h)" "DONE(d)")))
  
  (setq org-todo-keyword-faces
        '(("TODO" . (:foreground "skyblue" :weight bold))
          ("ACTIVE" . (:foreground "blue" :weight bold))
          ("ONHOLD" . (:foreground "gray"))
          ("DONE" . (:foreground "green"))))

  (setq org-agenda-deadline-faces
        '((1.0 . (:foreground "red" :weight bold))
          (3.0 . (:foreground "orange" :weight bold))
          (7.0 . (:foreground "yellow" :weight bold))))

  (setq org-agenda-category-icon-alist
        `(("TASK" ,(list (all-the-icons-faicon "briefcase")) nil nil :ascent center)
          ("MEETING" ,(list (all-the-icons-faicon "comments")) nil nil :ascent center)
          ("CHORES",(list (all-the-icons-faicon "home")) nil nil :ascent center)
          ("ROUTINE" ,(list (all-the-icons-faicon "clock-o")) nil nil :ascent center)))

  ;; Org Agenda Capture Setup
  ;; * ---- Capture templates for Org mode
  (setq org-capture-template/agenda/todo
        "TODO \[#%^{PRIORITY|B|A|C}\] %?
:PROPERTIES:
:CATEGORY: %^{Category|TASK|MEETING|CHORES|ROUTINE}
:EFFORT: %(my/org-agenda-capture-prompt-effort)
:REFERENCE: %a
:END:
SCHEDULED: 
DEADLINE: 

%i")

  (setq org-capture-template/agenda/todo-scheduled
        "TODO \[#%^{PRIORITY|B|A|C}\] %?
:PROPERTIES:
:CATEGORY: %^{Category|TASK|MEETING|CHORES|ROUTINE}
:EFFORT: %(my/org-agenda-capture-prompt-effort)
:REFERENCE: %a
:END:
SCHEDULED: %^{Schedule}T
DEADLINE: 

%i")

  (setq org-capture-template/agenda/todo-deadlined
        "TODO \[#%^{PRIORITY|B|A|C}\] %?
:PROPERTIES:
:CATEGORY: %^{Category|TASK|MEETING|CHORES|ROUTINE}
:EFFORT: %(my-org-agenda-capture-prompt-effort)
:REFERENCE: %a
:END:
SCHEDULED: 
DEADLINE: %^{Deadline}t

%i")

  (setq org-capture-template/agenda/note
        "NOTE written at: %u

%?")

  (setq org-capture-template/agenda/project
        ":PROPERTIES:
:PROJECT_NAME: %^{Enter the project name}
:PROJECT_STATUS: %^{Project status|ACTIVE|INACTIVE}
:PROJECT_START: %^{Project start date}t
:PROJECT_END: %^{Project end date}t
:PROJECT_PROGRESS: 0\%
:END:

* Overview
%?



* Capture
** Note




** Todo




* Plan




")


  ;; Org Agenda Capture helper functions
  (defun my/org-agenda-capture-insert-template (target-directory template-string)
    (if (and (buffer-file-name)
             (string-equal "org" (file-name-extension (buffer-file-name)))
             (string-prefix-p (expand-file-name target-directory)
                              (expand-file-name (buffer-file-name))))
        (let ((level (or (org-current-level)
                         0))
              (heading-prefix ""))
          ;; Calculate the new heading level
          (setq level (+ level 1))
          ;; Create the heading prefix with the appropriate number of asterisks
          (setq heading-prefix (make-string level ?*))
          (concat heading-prefix " " template-string))
      (concat "*** " template-string)))

  (defun my/org-agenda-capture-prompt-effort ()
    "Prompt for effort value in HH:MM format with validation."
    (let* ((effort-options '("Unknown" "0:05" "0:10" "0:30" "1:00" "1:30" "3:00" "6:00"))
           (custom "Custom")
           (choice (completing-read "Effort (HH:MM): " 
                                    (append effort-options (list custom)))))
      (cond
       ((string= choice "Unknown") 
        "")
       ((string= choice custom)
        (let ((input ""))
          (while (not (string-match-p "^[0-9]+:[0-5][0-9]$" input))
            (setq input (read-string "Enter effort (HH:MM): "))
            (when (not (string-match-p "^[0-9]+:[0-5][0-9]$" input))
              (message "Invalid format. Please use HH:MM format.")
              (sit-for 1)))
          input))
       (t choice))))

  (defun my/org-agenda-open-project (&optional _arg)
    (let ((org-files (directory-files org-agenda-directory))
          (selected-file nil))
      ;; Prompt user to select an agenda org file
      (setq selected-file (completing-read "Select the project org file: "
                                           (mapcar #'file-name-nondirectory org-files)
                                           nil t))
      ;; Find the full path of the selected file
      (setq selected-file (expand-file-name selected-file org-agenda-directory))
      (find-file selected-file)))

  (defun my/org-agenda-project-destination (target-directory)
    "Prompt for a filename and create an org file in target-directory."
    (let* ((org-files (directory-files target-directory nil "\\.org$"))
           (not-chosen t)
           (filename nil)
           (fullpath nil)
           (buf nil))
      (while not-chosen
        (setq filename (read-string "Enter filename for the new project file: "))
        (setq filename (if (string-equal "org" (file-name-extension filename))
                           filename
                         (concat filename ".org")))
        (if (member filename org-files)
            (progn
              (message "Project file with the given name already exists!")
              (sit-for 1))
          (setq not-chosen nil)))

      (setq fullpath (expand-file-name filename target-directory))
      
      ;; Open the file and move cursor to the very start
      (set-buffer (org-capture-target-buffer fullpath))
      (goto-char (point-min))))

  (defun my/org-agenda-capture-destination (target-directory level-1-heading level-2-heading)
    "Function for designating the destination(both file and location) of org agenda capture."
    (if (and (buffer-file-name)
             (string-equal "org" (file-name-extension (buffer-file-name)))
             (string-prefix-p (expand-file-name target-directory)
                              (expand-file-name (buffer-file-name))))
        ;; When current buffer is an org file, and is one of org agenda project file
        (progn
          ;; Check if current line is empty (only spaces or tabs)
          (if (save-excursion
                (beginning-of-line)
                (looking-at "[ \t]*$"))
              ;; Line is empty (only spaces or tabs)
              (progn
                (beginning-of-line)
                (delete-horizontal-space))
            ;; If line is not empty
            (progn
              (end-of-line)
              (newline)
              (beginning-of-line)))
          ;; Place cursor
          (point-marker))
      ;; When current buffer isn't an org file in the org agenda project directory
      (progn
        ;; Get list of org files in target-directory
        (let ((org-files (directory-files target-directory t "\\.org$"))
              (selected-file nil))
          ;; Prompt user to select an org file
          (setq selected-file (completing-read "Select the project org file: "
                                               (mapcar #'file-name-nondirectory org-files)
                                               nil t))
          ;; Find the full path of the selected file
          (setq selected-file (expand-file-name selected-file target-directory))
          ;; Open the selected
          ;; (find-file selected-file)
          (set-buffer (org-capture-target-buffer selected-file))
          ;; Try to find the level 1 heading
          (goto-char (point-min))
          (let ((found-level-1 (org-find-exact-headline-in-buffer level-1-heading)))
            ;; If level 1 heading doesn't exist, create one
            (unless found-level-1
              (goto-char (point-max))
              ;; Make sure that we are at the beginning of an empty line
              (unless (bolp) (insert "\n"))
              (insert (format "* %s" level-1-heading))
              ;; Move to the heading we just created
              (goto-char (point-max))
              (search-backward (format "* %s" level-1-heading)))

            ;; If it exists, go to level 1 heading
            (when found-level-1
              (goto-char found-level-1))

            ;; Now at level 1 heading, narrow to its subtree to search for level 2 heading
            (org-narrow-to-subtree)

            ;; Search for level 2 heading
            (let ((found-level-2 (org-find-exact-headline-in-buffer level-2-heading)))
              ;; If level 2 heading doesn't exist, create one
              (unless found-level-2
                (goto-char (point-max))
                ;; Ensure that we are at the beginning of an empty line
                (unless (bolp) (insert "\n"))
                (insert (format "** %s\n" level-2-heading))
                ;; Move to the heading we just created
                (goto-char (point-max))
                (search-backward (format "** %s" level-2-heading)))

              ;; If it exists, go to it
              (when found-level-2
                (goto-char found-level-2))
              
              ;; Ensure there's a newline for the new entry
              (end-of-line)
              (unless (bolp) (insert "\n"))

              ;; Remove the org narrowing before the return
              (widen)
              (point-marker)))))))

  (setq org-capture-templates
	    `(("t" "TODO" plain (function (lambda ()
                                        (my/org-agenda-capture-destination org-agenda-directory "Capture" "Todo")))
           (function (lambda ()
                       (my/org-agenda-capture-insert-template org-agenda-directory org-capture-template/agenda/todo)))
           :empty-lines 1 :clock-in t :clock-resume t)

          ("s" "TODO Scheduled" plain (function (lambda ()
                                                  (my/org-agenda-capture-destination org-agenda-directory "Capture" "Todo")))
           (function (lambda ()
                       (my/org-agenda-capture-insert-template org-agenda-directory org-capture-template/agenda/todo-scheduled)))
           :empty-lines 1 :clock-in t :clock-resume t)

          ("d" "TODO Deadlined" plain (function (lambda ()
                                                  (my/org-agenda-capture-destination org-agenda-directory "Capture" "Todo")))
           (function (lambda ()
                       (my/org-agenda-capture-insert-template org-agenda-directory org-capture-template/agenda/todo-deadlined)))
           :empty-lines 1 :clock-in t :clock-resume t)

          ("n" "Note" plain (function (lambda ()
                                        (my/org-agenda-capture-destination org-agenda-directory "Capture" "Note")))
           (function (lambda ()
                       (my/org-agenda-capture-insert-template org-agenda-directory org-capture-template/agenda/note)))
           :empty-lines 1)

          ("j" "Journal" entry (file ,(expand-file-name (concat (format-time-string "%Y-%m-%d-%a" (current-time)) ".org") org-journal-directory))
           (function (lambda ()
                       (let ((template-file-name (expand-file-name "journal-template.org" (concat org-directory "notes"))))
                         (if (file-exists-p template-file-name)
                             (org-file-contents template-file-name)
                           "")))))

          ("P" "New Project" plain (function (lambda () (my/org-agenda-project-destination org-agenda-directory)))
           (function (lambda ()
                       org-capture-template/agenda/project)))))

  
  ;; Org Agenda View Setup
  ;; Time related
  (setq calender-week-start-day 1)
  (setq org-agenda-start-on-weekday 1)
  (setq org-clock-persist 'history)
  (setq org-log-done 'time)
  (setq org-agenda-log-mode-items '(closed clock))
  (setq org-agenda-entry-types '(:deadline :scheduled :timestamp :sexp))
  (setq org-agenda-start-with-log-mode nil)
  (setq org-agenda-include-inactive-timestamps t)
  (setq org-read-date-prefer-future nil)
  (setq org-read-date-force-compatible-dates t)
  (org-clock-persistence-insinuate)

  ;; Presentation
  (setq org-cycle-hide-drawer-startup t) ;; Hide properties, its too verbose.
  (setq org-columns-default-format "%50ITEM(Task) %16CLOCKSUM %16TIMESTAMP_IA")
  (setq org-agenda-prefix-format
        '((agenda  . "%-12t %i ")
          (todo    . "%-12s %i ")
          (tags    . "%-12s %i ")
          (search  . "%-12s %i ")))

  (setq org-agenda-current-time-string
        " ←────────────────── NOW")
  (setq org-agenda-time-grid
        '((daily today)
          (600 800 1000 1200 1400 1600 1800 2000 2200 2400)
          ". . . ."
          "- - - - - - - - - - - - - - - - - - - - - - - "))
  (setq org-agenda-timegrid-use-ampm nil)
  (setq org-agenda-time-leading-zero t)

  (defun my-org-agenda-cmp-by-project-name (a b)
    "Compare agenda entries A and B by their PROJECT_NAME property."
    (let* ((pa (or (org-entry-get (get-text-property 0 'org-marker a) "PROJECT_NAME") ""))
           (pb (or (org-entry-get (get-text-property 0 'org-marker b) "PROJECT_NAME") ""))
           (result (string-collate-lessp pa pb nil t)))
      (if result -1 (if (string= pa pb) 0 1))))
  (setq org-agenda-cmp-user-defined 'my-org-agenda-cmp-by-project-name)

  (defun my-org-agenda-project-view (parm)
    "Generate a project report based on org agenda files."

    (let ((report-text (concat (propertize "Project Reports" 'face 'bold ) "\n\n---------------------------------------\n\n")))
      ;; Loop over org agenda files
      (dolist (file (org-agenda-files))
        (with-current-buffer (find-file-noselect file)
          (let ((project-name (org-entry-get (point-min) "PROJECT_NAME"))
                (project-status (org-entry-get (point-min) "PROJECT_STATUS"))
                (project-progress (org-entry-get (point-min) "PROJECT_PROGRESS"))
                (project-end (org-entry-get (point-min) "PROJECT_END")))

            (message project-name)
            ;; Only when the project is ACTIVE
            (when (and project-status
                       (string-equal "ACTIVE" project-status))
              ;; Find Overview section text
              (save-excursion
                (goto-char (point-min))
                (let ((overview-found (org-find-exact-headline-in-buffer "Overview"))
                      (overview-text nil))
                  (if overview-found
                      (progn
                        (goto-char overview-found)
                        (forward-line 1)
                        (let ((start (point))
                              (end (org-end-of-subtree)))
                          (setq overview-text (buffer-substring-no-properties start end))))
                    (setq overview-text ""))
                  ;; Generate clock report
                  (goto-char (point-min))
                  (org-clock-sum)
                  (let* ((hours (/ org-clock-file-total-minutes 60))
                         (minutes (% org-clock-file-total-minutes 60))
                         (total-time (format "%d:%02d" hours minutes)))

                    (setq report-text (concat report-text
                                              (format "%s: %s\n" (propertize "■ Project" 'face 'bold) project-name)
                                              (format "%s: %s\n" (propertize "    Due Date" 'face 'bold) project-end)
                                              (format "%s: %s\n" (propertize "    Progress" 'face 'bold) project-progress)
                                              (format "%s: %s\n" (propertize "    Time Spent" 'face 'bold) total-time)
                                              "\n"
                                              overview-text
                                              "\n\n---------------------------------------\n\n")))))))))
      (insert (propertize report-text 'read-only t))))

  (setq org-agenda-custom-commands
        '(("d" "Daily View"
           ((tags-todo "+PRIORITY=\"A\"+CATEGORY=\"TASK\"|+PRIORITY=\"A\"+CATEGORY=\"MEETING\""
                       ((org-agenda-overriding-header "Today's Highlights")
                        (org-agenda-span 'day)
                        (org-deadline-warning-days 3)
                        (org-agenda-sorting-strategy '((todo urgency-down effort-down category-up)))
                        (org-agenda-skip-function
                         '(or
                           (org-agenda-skip-entry-if 'regexp "^[ ]*SCHEDULED:[ ]*$")
                           (org-agenda-skip-entry-if 'notscheduled)
                           (org-agenda-skip-entry-if 'todo '("ONHOLD" "DONE"))))))
            (agenda ""
                    ((org-agenda-overriding-header "Today's Schedule")
                     (org-agenda-span 'day)
                     (org-agenda-time-grid '((daily today required-time)
                                             (600 800 1000 1200 1400 1600 1800 2000 2200 2400)
                                             ". . . ."
                                             "- - - - - - - - - - - - - - - - - - - - - - - "))
                     (org-agenda-sorting-strategy '((agenda time-up timestamp-up scheduled-up urgency-down effort-down)))
                     (org-agenda-skip-function
                      '(or                        
                        (org-agenda-skip-entry-if 'todo '("ONHOLD" "DONE"))))))))

          ("n" "Next Day Planning"
           ((agenda ""
                    ((org-agenda-overriding-header "Scheduled Tomorrow")
                     (org-agenda-span 'day)
                     (org-agenda-start-day "+1d")
                     (org-agenda-time-grid '((daily today required-time)
                                             (600 1200 1800 2400)
                                             ". . . ."
                                             "- - - - - - - - - - - - - - - - - - - - - - - "))
                     (org-agenda-sorting-strategy '((agenda time-up timestamp-up scheduled-up urgency-down effort-down)))
                     (org-agenda-skip-function
                      '(or
                        (org-agenda-skip-entry-if 'todo '("ONHOLD" "DONE"))))))
            (tags-todo "+PROJECT_STATUS=\"ACTIVE\"+CATEGORY=\"TASK\""
                       ((org-agenda-overriding-header "Available Tasks")
                        (org-agenda-start-day "+1d")
                        (org-deadline-warning-days 3)
                        (org-agenda-sorting-strategy '((todo user-defined-up urgency-down effort-down)))
                        (org-agenda-skip-function
                         '(or
                           (org-agenda-skip-entry-if 'notregexp "^[ ]*SCHEDULED: [ ]*$")
                           (org-agenda-skip-entry-if 'scheduled)
                           (org-agenda-skip-entry-if 'todo '("ONHOLD" "DONE"))))))
            (tags-todo "+PROJECT_STATUS=\"ACTIVE\"+CATEGORY=\"CHORES\""
                       ((org-agenda-overriding-header "Available Chores")
                        (org-agenda-start-day "+1d")
                        (org-deadline-warning-days 3)
                        (org-agenda-sorting-strategy '((todo user-defined-up urgency-down effort-down)))
                        (org-agenda-skip-function
                         '(or
                           (org-agenda-skip-entry-if 'notregexp "^[ ]*SCHEDULED: [ ]*$")
                           (org-agenda-skip-entry-if 'scheduled)
                           (org-agenda-skip-entry-if 'todo '("ONHOLD" "DONE"))))))))

          ("w" "Weekly View"
           ((agenda ""
                    ((org-agenda-overriding-header "Schedules This Week")
                     (org-agenda-span 'week)
                     (org-deadline-warning-days 7)
                     (org-agenda-show-all-dates t)
                     (org-agenda-time-grid '((daily today required-time)
                                             (1200 2400)
                                             ". . . ."
                                             "- - - - - - - - - - - - - - - - - - - - - - - "))                     
                     (org-agenda-entry-types '(:timestamp :deadline :scheduled))
                     (org-agenda-skip-function
                      '(or
                        (org-agenda-skip-entry-if 'regexp ":CATEGORY: CHORES")
                        (org-agenda-skip-entry-if 'regexp ":CATEGORY: ROUTINE")))
                     (org-agenda-sorting-strategy '((agenda time-up timestamp-up scheduled-up urgency-down effort-down)))))))

          ("o" "Open Project File"
           my/org-agenda-open-project)
          
          ("P" "Project View"
           ((my-org-agenda-project-view nil)))

          ("c" "Chores"
           ((tags-todo "+PROJECT_STATUS=\"ACTIVE\"+CATEGORY=\"CHORES\""
                       ((org-agenda-overriding-header "Simple Chores")
                        (org-agenda-sorting-strategy '((todo user-defined-up category-up urgency-down effort-down)))                        
                        (org-agenda-skip-function
                         '(or
                           (org-agenda-skip-entry-if 'notregexp "^[ ]*SCHEDULED: [ ]*$")
                           (org-agenda-skip-entry-if 'scheduled)
                           (org-agenda-skip-entry-if 'todo '("ONHOLD" "DONE"))))))))

          ("h" "on Hold Tasks"
           ((tags-todo "+PROJECT_STATUS=\"ACTIVE\"+TODO=\"ONHOLD\""
                       ((org-agenda-overriding-header "On Hold Tasks")
                        (org-agenda-sorting-strategy '((todo user-defined-up category-up urgency-down effort-down)))))))))


  (setq org-refile-targets (quote ((nil :maxlevel . 9)
				                   (org-agenda-files :maxlevel . 9))))

  (defun refresh-org-agenda-files ()
    "Refresh 'org-agenda-files' variable if the current buffer is an .org file."
    (when (and (buffer-file-name)
               (string-equal "org" (file-name-extension (buffer-file-name)))
               (or (string-equal org-agenda-directory (file-name-directory (buffer-file-name)))
                   (string-equal (concat (getenv "USER_ORG_SHORTCUT_DIR") "agenda/") (file-name-directory (buffer-file-name)))))
      (progn
        (org-agenda-file-to-front)
        (let ((return-buffer-name (buffer-name)))
          (dashboard-refresh-buffer)
          (switch-to-buffer return-buffer-name)))))
  (add-hook 'after-save-hook 'refresh-org-agenda-files)

  (defun clean-org-agenda-files ()
    "Remove non-existent files from org-agenda-files"
    (interactive)
    (let ((existing-files nil))
      ;; Get the current list of agenda files
      (dolist (org-file (org-agenda-files))
        (if (file-exists-p org-file)
            (push org-file existing-files)))

      (org-store-new-agenda-file-list (nreverse existing-files))))
  (advice-add 'org-agenda :before #'clean-org-agenda-files)

  ;; org-clock for alarm
  (if (file-exists-p (concat (getenv "USER_MUSIC_DIR") "SFX/bell.wav"))
      (setq org-clock-sound (concat (getenv "USER_MUSIC_DIR") "SFX/bell.wav")))

  ;; Insert source code block with shortcut
  (defun my/org-insert-src-block (lang)
    "Insert an org source block."
    (interactive "sLanguage: ")
    (insert "#+BEGIN_SRC " lang "\n\n#+END_SRC")
    (forward-line -1))
  (define-key org-mode-map (kbd "C-c s") 'my/org-insert-src-block)

  ;; org-babel language extension
  (use-package ob-prolog
    :ensure t
    :after org)
  (use-package ob-lean4
    :ensure t
    :after org
    :quelpa (ob-lean4 :fetcher github :repo "Maverobot/ob-lean4"
                      :files ("ob-lean4.el")))
  (use-package ob-restclient
    :ensure t)

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
     (julia . t)
     (python . t)
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
     (css . t)
     (restclient . t)))

  ;; org-babel python3
  (setq org-babel-python-command "python3")

  ;; refresh org inline image every execution
  (setq org-image-actual-width '(1024 512 256))
  (add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images))

;; org-contacts
(use-package org-contacts
  :ensure t
  :after org
  :config
  (setq org-contacts-files (list org-contacts-default-notes-file))
  (setq org-capture-templates
        (append org-capture-templates
                '(("C" "Contacts" entry (file org-contacts-default-notes-file)
                   "* %(org-contacts-template-name)\n:PROPERTIES:\n:ALIAS:\n:EMAIL: %(org-contacts-template-email)\n:PHONE: \n:AFFILIATION: \n:END:\n%i" :empty-lines 1 :kill-buffer t)))))

;; org-auto-tangle
(use-package org-auto-tangle
  :ensure t
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))

;; org-bullets
(use-package org-bullets
  :after org
  :ensure t
  :init
  (setq org-bullets-bullet-list
	    '("🟥" "🟧" "🟨" "🟩" "🟦" "🟪"))
  :hook (org-mode . org-bullets-mode))

;; org-side-tree
(use-package org-side-tree
  :after org
  :ensure t
  :bind (:map org-mode-map
	            ("C-c t" . org-side-tree))
  :config
  (setq org-side-tree-persistent nil
        org-side-tree-fontify t
        org-side-tree-enable-folding t))

;; Asynchronous src block execution for org-babel
(use-package ob-async
  :after org
  :ensure t
  :config
  (setq ob-async-no-async-languages-alist '("python"))
  (add-hook 'ob-async-pre-execute-src-block-hook
            #'(lambda ()
	              (setq inferior-julia-program-name "julia"))))

;; org-roam
(use-package org-roam
  :ensure t
  :after org 
  :init
  (setq org-roam-v2-ack t)
  (org-roam-db-autosync-mode)
  :custom
  (org-roam-directory (concat org-directory "roam/"))
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
   '(("f" "Fleeting Note" plain
      "%?"
      :if-new (file+head "${slug}-%<%Y%m%d%H%M%S>-F.org" "#+TITLE: ${title}\n#+FILETAGS: FLEETING\n\n")
      :unarrowed t)
     ("k" "Knowledge Note" plain
      "%?"
      :if-new (file+head "${slug}-%<%Y%m%d%H%M%S>-K.org" "#+TITLE: ${title}\n#+FILETAGS: KNOWLEDGE\n\n")
      :unarrowed t)
     ("i" "Index Note" plain
      "%?"
      :if-new (file+head "${slug}-%<%Y%m%d%H%M%S>-I.org" "#+TITLE: ${title}\n#+FILETAGS: INDEX\n\n")
      :unarrowed t)
     ("r" "Research Note" plain
      "%?"
      :if-new (file+head "${slug}-%<%Y%m%d%H%M%S>-R.org" "#+TITLE: ${title}\n#+FILETAGS: RESEARCH\n\n")
      :unarrowed t)))
  (setq org-roam-node-display-template
        (concat (propertize "${tags:10}" 'face 'org-tag) "${title:*}"))
  :bind
  (("C-c r l" . org-roam-buffer-toggle)
   ("C-c r f" . org-roam-node-find)
   ("C-c r i" . org-roam-node-insert)
   ("C-c r c" . org-roam-capture)
   ("C-c r g" . org-id-get-create)
   :map org-mode-map
   ("C-M-i" . completion-at-point))
  :config
  (org-roam-setup))

(use-package websocket
  :ensure t
  :after org-roam)

(use-package org-roam-ui
  :ensure t
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

;; org-roam-ql for query
(use-package org-roam-ql
  ;; If using straight
  :straight (org-roam-ql :type git :host github :repo "ahmed-shariff/org-roam-ql"
                         :files (:defaults (:exclude "org-roam-ql-ql.el")))
  ;; Simple configuration
  :after (org-roam)
  :bind ((:map org-roam-mode-map
               ;; Have org-roam-ql's transient available in org-roam-mode buffers
               ("v" . org-roam-ql-buffer-dispatch)
               :map minibuffer-mode-map
               ;; Be able to add titles in queries while in minibuffer.
               ;; This is similar to `org-roam-node-insert', but adds
               ;; only title as a string.
               ("C-c n i" . org-roam-ql-insert-node-title))))

(use-package org-ref
  :ensure t
  :after org-roam)

(use-package org-roam-bibtex
  :ensure t
  :after (org-roam helm-bibtex)
  :bind
  (:map org-mode-map ("C-c n B" . orb-note-actions-default))
  :config
  (require 'org-ref)
  (org-roam-bibtex-mode))

;; org-download
(use-package org-download
  :ensure t
  :after org 
  :init
  (setq-default org-download-image-dir (concat org-directory ".files/images/"))
  :bind
  (:map org-mode-map
        (("s-s" . org-download-screenshot)
         ("s-y" . org-download-yank)))
  :config
  (add-hook 'dired-mode-hook 'org-download-enable)
  (setq-default org-download-timestamp t))

;; org-fc for spaced repetition
(use-package hydra
  :ensure t)

(use-package org-fc
  :ensure t
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








;; * ---- <Language Server>


;; eglot
(use-package eglot
  :after
  (flycheck company yasnippet)
  :hook
  ((haskell-mode . eglot-ensure)
   (tuareg-mode . eglot-ensure)
   (c-mode . eglot-ensure)
   (c++-mode . eglot-ensure)
   (rust-mode . eglot-ensure)
   (python-mode . eglot-ensure)
   (julia-mode . eglot-ensure)
   (r-mode . eglot-ensure)
   (java-mode . eglot-ensure)
   (scala-mode . eglot-ensure)
   (csharp-mode . eglot-ensure)
   (go-mode . eglot-ensure)
   (cmake-mode . eglot-ensure)
   (shell-mode . eglot-ensure)
   (html-mode . eglot-ensure)
   (css-mode . eglot-ensure)
   (js-mode . eglot-ensure)
   (LaTeX-mode . eglot-ensure)))

(use-package eglot-inactive-regions
  :ensure t
  :after eglot)

(use-package eglot-signature-eldoc-talkative
  :ensure
  :after eglot)


;; Enable nice rendering of diagnostics like compile errors.
(use-package flycheck
  :ensure t
  :init
  (add-hook 'after-init-hook #'global-flycheck-mode)
  :config
  (setq flycheck-scheme-chicken-executable "chicken-csc"))

(use-package flycheck-eglot
  :ensure t
  :after (flycheck eglot)
  :config
  (global-flycheck-eglot-mode 1))

;; company
(use-package company
  :ensure t
  :hook 
  (prog-mode . company-mode)
  :bind
  (:map company-active-map
        ("<tab>" . company-complete-selection))
  :config
  (setq company-idle-delay 0.05)
  (setq company-minimum-prefix-length 1)
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous)
  (define-key company-active-map (kbd "<tab>") #'company-abort)

  ;; Company color scheme
  (add-hook 'company-mode-hook
            (lambda ()
              (set-face-foreground 'company-tooltip-selection "white")
              (set-face-background 'company-tooltip-selection "#37474F")
              (set-face-background 'company-tooltip-common-selection "#FC996E"))))

;; company-box
(use-package company-box
  :ensure t
  :after company
  :hook (company-mode . company-box-mode))


;; yasnippet
(use-package yasnippet
  :ensure t)








;; # ==== [Other Languages Support]




;; [x86 Assembly]
(use-package nasm-mode
  :ensure t
  :config
  (add-hook 'asm-mode-hook 'nasm-mode))

;; [RISC-V Assembly]
(use-package riscv-mode
  :ensure t)

;; [Ocaml]
(use-package tuareg
  :ensure t)

(use-package ocaml-eglot
  :ensure t)

;; [Haskell]
(use-package haskell-mode
  :ensure t)

;; [Rust]
(use-package rust-mode
  :ensure t)

;; [Forth]
(use-package forth-mode
  :ensure t
  :mode ("\\.fs\\'" . forth-mode)
  :config
  (autoload 'forth-mode "gforth.el")
  (autoload 'forth-block-mode "gforth.el"))


;; <LISP family>
(use-package aggressive-indent
  :ensure t
  :config
  (add-hook 'lisp-mode-hook             #'aggressive-indent-mode)
  (add-hook 'lisp-interaction-mode-hook #'aggressive-indent-mode)
  (add-hook 'scheme-mode-hook           #'aggressive-indent-mode)
  (add-hook 'emacs-lisp-mode-hook       #'aggressive-indent-mode)
  (add-hook 'common-lisp-mode-hook      #'aggressive-indent-mode))

(use-package lisp-extra-font-lock
  :ensure t
  :config
  (lisp-extra-font-lock-global-mode 1)
  (add-hook 'lisp-mode-hook             #'lisp-extra-font-lock-mode)
  (add-hook 'lisp-interaction-mode-hook #'lisp-extra-font-lock-mode)
  (add-hook 'scheme-mode-hook           #'lisp-extra-font-lock-mode)
  (add-hook 'emacs-lisp-mode-hook       #'lisp-extra-font-lock-mode)
  (add-hook 'common-lisp-mode-hook      #'lisp-extra-font-lock-mode))

;; paredit: structural editing
(use-package paredit
  :ensure t
  :config
  (add-hook 'lisp-mode-hook             'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
  (add-hook 'scheme-mode-hook           'enable-paredit-mode)
  (add-hook 'emacs-lisp-mode-hook       'enable-paredit-mode)
  (add-hook 'common-lisp-mode-hook      'enable-paredit-mode))

;; smartparens
(use-package smartparens
  :ensure t)

;; [Scheme]
(use-package geiser
  :ensure nil
  :pin manual
  :mode ("\\.scm\\'" . scheme-mode)
  :commands (geiser run-geiser)
  :config
  (setq geiser-default-implementation 'guile)
  (setq geiser-active-implementations '(guile chicken racket))
  (setq geiser-repl-query-on-exit-p nil)
  (setq geiser-repl-autodoc-p t)
  (add-hook 'geiser-repl-mode #'smartparens-mode))

(use-package geiser-guile 
  :after geiser
  :ensure nil
  :pin manual)

(use-package geiser-chicken
  :after geiser
  :ensure t
  :config
  (setq geiser-chicken-binary "csi"))

(use-package geiser-racket
  :after geiser
  :ensure nil
  :pin manual)


;; [Common Lisp]
(use-package sly
  :ensure t
  :mode ("\\.lisp\\'" . common-lisp-mode)
  :commands (sly)
  :config
  (setq inferior-lisp-program "sbcl")
  (add-hook 'sly-repl-mode #'smartparens-mode))


;; [Coq]
(use-package proof-general
  :ensure t
  :mode ("\\.v\\'" . coq-mode))

(use-package company-coq
  :ensure t
  :after (company proof-general)
  :config
  (add-hook 'coq-mode-hook #'company-coq-mode))


;; [Lean]
(use-package lean4-mode
  :ensure t
  :mode ("\\.lean\\'" . lean4-mode)
  :straight (lean4-mode
	           :type git
	           :host github
	           :repo "leanprover/lean4-mode"
	           :files ("*.el" "data"))
  ;; to defer loading the package until required
  :commands (lean4-mode))


;; [Python]
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt --InteractiveShell.display_page=True")


;; [Julia]
(use-package julia-mode
  :ensure t)

(use-package julia-repl
  :after vterm
  :ensure t
  :init
  :hook (julia-mode . julia-repl-mode)
  :config
  (julia-repl-set-terminal-backend 'vterm))

(use-package eglot-jl
  :ensure t)


;; [Golang]
(use-package go-mode
  :ensure t)


;; [Java]
(use-package eglot-java
  :ensure t)








;; * ---- Documentation




;; <Hledger>
;; hledger-mode
(use-package hledger-mode
  :ensure t
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
  :ensure t
  :after (flycheck hledger-mode)
  :demand t)


;; <UML>
;; PlantUML
(use-package plantuml-mode
  :ensure t
  :mode ("\\.puml\\'" . plantuml-mode))

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
	             '(output-pdf "sioyek"))
  ;; Do not run eglot within templated TeX files
  (add-hook 'LaTeX-mode-hook
	          (lambda ()
	            (unless (string-match "\.hogan\.tex$" (buffer-name))
		            (eglot))
	            (setq-local flycheck-checker 'tex-chktex)))
  (add-hook 'LaTeX-mode-hook #'smartparens-mode)
  (add-hook 'LaTeX-mode-hook #'prettify-symbols-mode)
  (add-hook 'LaTeX-mode-hook #'display-line-numbers-mode))

;; auctex-latexmk
(use-package auctex-latexmk
  :ensure t
  :after tex
  :config
  (auctex-latexmk-setup))

;; Preview LaTeX in Org mode
;; Helper function that fix org source block conflict with xenops
(defun fn/xenops-src-parse-at-point ()
  (-if-let* ((element (xenops-parse-element-at-point 'src))
             (org-babel-info
              (xenops-src-do-in-org-mode
               (org-babel-get-src-block-info 'light (org-element-context)))))
      (xenops-util-plist-update
       element
       :type 'src
       :language (nth 0 org-babel-info)
       :org-babel-info org-babel-info)))

(use-package xenops
  :ensure t
  :after org
  :config
  (setq org-latex-packages-alist
	    '(("" "amsmath" t)))
  (setq xenops-math-image-scale-factor 1.7)
  (setq xenops-reveal-on-entry t)
  (advice-add 'xenops-src-parse-at-point :override 'fn/xenops-src-parse-at-point)
  (add-hook 'org-mode-hook #'xenops-mode)
  (add-hook 'latex-mode-hook #'xenops-mode)
  (add-hook 'Latex-mode-hook #'xenops-mode))




;; <GNUPlot>
(use-package gnuplot
  :ensure t
  :mode ("\\.gpi\\'" . gnuplot-mode)
  :config
  (autoload 'gnuplot-mode "gnuplot" "Gnuplot major mode" t)
  (autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot-mode" t))








;; # ==== [Utilities]




;; Terminal
(defun vterm/rename-buffer ()
        (interactive)
        (let ((n 0)
              (new-name nil))
          (while (get-buffer (format "*vterm-%d*" n))
            (setq n (1+ n)))
          (setq new-name (format "*vterm-%d*" n))
          (rename-buffer new-name)))

(use-package vterm
  :pin manual
  :ensure nil ;; guix will handle this (emacs-vterm package)
  :config
  (setq vterm-always-compile-module t)
  (setq vterm-ignore-blink-cursor nil)
  (add-hook 'vterm-mode-hook
            #'(lambda ()
                (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix)))
  (add-hook 'vterm-mode-hook 'vterm/rename-buffer))

(use-package eterm-256color
  :ensure t
  :after vterm 
  :config
  (add-hook 'vterm-mode-hook #'eterm-256color-mode))








;; # ==== [Guix]




(use-package guix
  :pin manual
  :ensure nil)








;; # ==== [EXWM]



(use-package epg
  :ensure t
  :config
  (setq epg-pinentry-mode 'loopback))

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
  (exwm-xim-mode 1)
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
  (exwm-randr-mode 1)
  (add-hook 'exwm-randr-screen-change-hook #'exwm/update-displays)
  (exwm/update-displays)

  (setq exwm-floating-border-width 12)
  (setq exwm-floating-border-color "#37474F")
  
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
          ([?\s-q] . kill-current-buffer)

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
  :ensure t
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
  (setq dashboard-items '((agenda . 16)))
  (setq dashboard-week-agenda t)
  (setq dashboard-agenda-sort-strategy '(time-up priority-down))
  (setq dashboard-agenda-release-buffers t)
  (setq dashboard-navigation-cycle t)
  (setq dashboard-icon-types 'all-the-icons)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (dashboard-setup-startup-hook)
  (dashboard-open))








;; # ==== [Email]




;; mu4e
(if (file-exists-p (car auth-sources))
    (use-package mu4e
      :ensure nil
      :pin manual
      :defer 20
      :after exwm
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
      (mu4e t)))








;; # ==== [LLM assistance]




;; GPTel
(defun gptel/get-llm-providers ()
  (let ((service-provider-list '("generativelanguage.googleapis.com" "api.perplexity.ai" "api.anthropic.com" "api.groq.com" "api.deepseek.com" "api.x.ai"))
	    (providers-list '()))
    (dolist (provider service-provider-list)
	  (let ((auth-info (car (auth-source-search :max 1
						                        :host provider
						                        :user "apikey"
						                        :require '(:secret)))))
	    (if auth-info
	        (let ((apikey (plist-get auth-info :secret)))
	          (cond
		       ((stringp apikey) (push (cons provider apikey) providers-list))
		       ((functionp apikey) (push (cons provider (funcall apikey)) providers-list)))))))
    providers-list))

(use-package markdown-mode
  :ensure t
  :config
  (setq markdown-enable-wiki-links t
        markdown-enable-math t
        markdown-fontify-code-blocks-natively t))

(if (file-exists-p (car auth-sources))
    (use-package gptel
      :ensure t
      :defer t
      :after exwm
      :config
      (setq gptel-default-mode 'org-mode)
      (setq gptel-track-media t)
      (setq gptel-include-reasoning nil)
      (setf (alist-get 'org-mode gptel-prompt-prefix-alist)
            (propertize "* @User\n"
                        'face '(:weight bold :foreground "blue")))
      (setf (alist-get 'org-mode gptel-response-prefix-alist)
            (propertize "* @LLM\n"
                        'face '(:weight bold :foreground "green")))
      (add-hook 'gptel-mode-hook (lambda () (toggle-truncate-lines 0)))
      (add-hook 'gptel-post-stream-hook 'gptel-auto-scroll)

      (defun my/gptel-post-response (begin end)
        (when (derived-mode-p 'org-mode)
          (set-mark begin)
          (goto-char end)
          (activate-mark)
          (org-latex-preview)
          (deactivate-mark))
        (goto-char (point-max)))
      (add-hook 'gptel-post-response-functions 'my/gptel-post-response)

      (defun my/gptel-clear ()
        (interactive)
        (let ((inhibit-read-only t))
          (delete-region (point-min) (point-max))
          (insert "* @User\n")
          (goto-char (point-max))))
      (define-key gptel-mode-map (kbd "C-c C-r") #'my/gptel-clear)

      (defun my/gptel-locate-buffer ()
        "Find and return the first buffer with gptel minor mode active."
        (catch 'found
          (dolist (buf (buffer-list))
            (with-current-buffer buf
              (when (bound-and-true-p gptel-mode)
                (throw 'found buf))))
          nil))

      (setq my/gptel-screenshot-dir "/tmp/gptel-screenshots/")
      (make-directory my/gptel-screenshot-dir t)
      (mapc #'delete-file
            (directory-files my/gptel-screenshot-dir t "^[^.]"))
      (make-directory my/gptel-screenshot-dir t)

      (defun my/capture-region-screenshot ()
        (interactive)
        (let* ((dir my/gptel-screenshot-dir)
               (filename (format "%s%s-region-screenshot.png"
                                 dir
                                 (format-time-string "%Y%m%d-%H%M%S")))
               (command (format "import %s" filename)))
          (make-directory dir t)
          (shell-command command)
          filename))

      (defun my/gptel-insert-screenshot ()
        (interactive)
        (let ((gptel-buf (my/gptel-locate-buffer)))
          (if (not gptel-buf)
              (message "There is no opened gptel buffer.")
            (let ((filename (my/capture-region-screenshot)))
              (with-current-buffer gptel-buf
                (goto-char (point-max))
                (insert (format "[[file:%s]]\n" filename))
                (forward-line))))))
      (global-set-key (kbd "C-c g s") 'my/gptel-insert-screenshot)

      (defun my/gptel-insert-text ()
        (interactive)
        (if (use-region-p)
            (let ((gptel-buf (my/gptel-locate-buffer)))
              (if gptel-buf
                  (let ((region-text (buffer-substring-no-properties (region-beginning) (region-end))))
                    (with-current-buffer gptel-buf
                      (goto-char (point-max))
                      (insert region-text)
                      (insert "\n")
                      (forward-line)))
                (message "There is no opened gptel buffer.")))
          (message "No region selected.")))
      (global-set-key (kbd "C-c g t") 'my/gptel-insert-text)      

      (setq gptel-directives
            '((default . "You are a large language model living in Emacs and a helpful assistant. Respond with correct information, in structured manner following the grammar of Emacs Org document.")
              (survey . "You are a large language model and a research assistant for my literature survey. Please provide reliable references to support your answer concretely.")
              (programming . "You are a large language model and a careful programmer. Whenever you write code output, your code output should comply with the following format.

#+BEGIN_SRC <lang>
<your-code-here>
#+END_SRC

Replace <lang> with the name of the programming language of your code output in lowercases(for example; python), and place your code output in <your-code-here> part.
Please write code in simple and idiomatic style possible rather than short, fancy but unnecessarily complicated manner.")
              (math . "You are a large language model and a logical mathematician, skilled at both pure and applied mathematics. Whenever you write mathematical expressions, your mathematical expressions should be written in LaTeX grammar and surrounded by \\[ tag and \\] tag, just like the following.

\\[ <your-expressions-here> \\]

Replace <your-expressions-here> with mathematical expressions written in LaTeX grammar. Please provide motivation and intuition behind your mathematical approach. Also present the whole process in step by step reasoning chains.")
              (writing. "You are a large language model and a writing assistant. Respond concisely.")
              (chat . "You are a large language model and a conversation partner. Respond concisely.")))
      (dolist (provider-info (gptel/get-llm-providers))
        (let ((provider (car provider-info))
	          (apikey (cdr provider-info)))
	      (cond
           ((string= provider "api.openai.com")
	        (setq gptel-api-key apikey))
	       ((string= provider "generativelanguage.googleapis.com")
	        (setq gptel-model 'gemini-2.5-pro
                  gptel-backend (gptel-make-gemini "Gemini"
			                      :key apikey
			                      :stream t)))
	       ((string= provider "api.perplexity.ai")
	        (setq gptel-model 'sonar
                  gptel-backend (gptel-make-perplexity "Perplexity"
				                  :key apikey
				                  :stream t)))
	       ((string= provider "api.anthropic.com")
	        (setq gptel-model 'claude-3-sonnet-20240229
                  gptel-backend (gptel-make-anthropic "Claude"
				                  :key apikey
				                  :stream t)))
	       ((string= provider "api.groq.com")
	        (setq gptel-model 'mixtral-8x7b-32768
                  gptel-backend (gptel-make-openai "Groq"
			                      :key apikey
			                      :host "api.groq.com"
			                      :endpoint "/openai/v1/chat/completions"
			                      :stream t
			                      :models '(llama-3.1-70b-versatile
					                        llama-3.1-8b-instant
					                        llama3-70b-8192
					                        llama3-8b-8192
					                        mixtral-8x7b-32768
					                        gemma-7b-it))))
	       ((string= provider "api.deepseek.com")
	        (setq gptel-model 'deepseek-chat
                  gptel-backend (gptel-make-openai "Deepseek"
			                      :key apikey
			                      :host "api.deepseek.com"
			                      :endpoint "/chat/completions"
			                      :stream t
			                      :models '(deepseek-chat deepseek-coder deepseek-reasoner))))
	       ((string= provider "api.x.ai")
	        (setq gptel-model 'grok-beta
                  gptel-backend (gptel-make-openai "xAI"
			                      :key apikey
			                      :host "api.x.ai"
			                      :endpoint "/v1/chat/completions"
			                      :stream t
			                      :models '(grok-beta)))))))))



;; agent-shell
(use-package shell-maker
  :ensure t)

(use-package acp
  :ensure t
  :vc (:url "https://github.com/xenodium/acp.el"))

(defun agent-shell/get-llm-providers ()
  (let ((service-provider-list '("generativelanguage.googleapis.com" "api.anthropic.com" "api.openai.com"))
	    (providers-list '()))
    (dolist (provider service-provider-list)
	  (let ((auth-info (car (auth-source-search :max 1
						                        :host provider
						                        :user "apikey"
						                        :require '(:secret)))))
	    (if auth-info
	        (let ((apikey (plist-get auth-info :secret)))
	          (cond
		       ((stringp apikey) (push (cons provider apikey) providers-list))
		       ((functionp apikey) (push (cons provider (funcall apikey)) providers-list)))))))
    providers-list))

(if (file-exists-p (car auth-sources))
    (use-package agent-shell
      :defer t
      :after (shell-maker acp exwm)
      :vc (:url "https://github.com/xenodium/agent-shell")
      :config
      (dolist (provider-info (agent-shell/get-llm-providers))
        (let ((provider (car provider-info))
	          (apikey (cdr provider-info)))
	      (cond
	       ((string= provider "api.openai.com")
            (setq agent-shell-openai-authentication
                  (agent-shell-openai-make-authentication :api-key apikey)))
           ((string= provider "generativelanguage.googleapis.com")
            (setq agent-shell-google-authentication
                  (agent-shell-google-make-authentication :api-key apikey)))
	       ((string= provider "api.anthropic.com")
            (setq agent-shell-anthropic-authentication
                  (agent-shell-anthropic-make-authentication :api-key apikey))))))))
