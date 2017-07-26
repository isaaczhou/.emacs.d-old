(setq user-full-name "Isaac Zhou"
      user-mail-address "isaaczhou85@gmail.com")

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

(use-package cyberpunk-theme
  :if (window-system)
  :ensure t
  :init
  (progn
    (load-theme 'cyberpunk t)
    (set-face-attribute `mode-line nil
                        :box nil)
    (set-face-attribute `mode-line-inactive nil
                        :box nil)))

(use-package solarized-theme
  :defer 10
  :init
  (setq solarized-use-variable-pitch nil)
  :ensure t)

(defun switch-theme (theme)
  "Disables any currently active themes and loads THEME."
  ;; This interactive call is taken from `load-theme'
  (interactive
   (list
    (intern (completing-read "Load custom theme: "
                             (mapc 'symbol-name
                                   (custom-available-themes))))))
  (let ((enabled-themes custom-enabled-themes))
    (mapc #'disable-theme custom-enabled-themes)
    (load-theme theme t)))

(defun disable-active-themes ()
  "Disables any currently active themes listed in `custom-enabled-themes'."
  (interactive)
  (mapc #'disable-theme custom-enabled-themes))

(bind-key "<f9>" 'switch-theme)
(bind-key "<f8>" 'disable-active-themes)

(add-to-list 'default-frame-alist
             '(font . "Source Code Pro-18"))

(let ((font (if (= emacs-major-version 25)
                "Symbola"
              (cond ((string-equal system-type "darwin")    "Apple Color Emoji")
                    ((string-equal system-type "gnu/linux") "Symbola")))))
  (set-fontset-font t 'unicode font nil 'prepend))

;; These functions are useful. Activate them.
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)

;; Answering just 'y' or 'n' will do
(defalias 'yes-or-no-p 'y-or-n-p)

;; Keep all backup and auto-save files in one directory
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

;; UTF-8 please
(setq locale-coding-system 'utf-8) ; pretty
(set-terminal-coding-system 'utf-8) ; pretty
(set-keyboard-coding-system 'utf-8) ; pretty
(set-selection-coding-system 'utf-8) ; please
(prefer-coding-system 'utf-8) ; with sugar on top
(setq-default indent-tabs-mode nil)

;; Turn off the blinking cursor
(blink-cursor-mode -1)

(setq-default indent-tabs-mode nil)
(setq-default indicate-empty-lines t)

;; Don't count two spaces after a period as the end of a sentence.
;; Just one space is needed.
(setq sentence-end-double-space nil)

;; delete the region when typing, just like as we expect nowadays.
(delete-selection-mode t)

(show-paren-mode t)

(column-number-mode t)

(global-visual-line-mode)
(diminish 'visual-line-mode)

(setq uniquify-buffer-name-style 'forward)

;; -i gets alias definitions from .bash_profile
(setq shell-command-switch "-ic")

;; Don't beep at me
(setq visible-bell t)

(defun occur-dwim ()
  "Call `occur' with a sane default."
  (interactive)
  (push (if (region-active-p)
            (buffer-substring-no-properties
             (region-beginning)
             (region-end))
          (thing-at-point 'symbol))
        regexp-history)
  (call-interactively 'occur))

(bind-key "M-s o" 'occur-dwim)

(use-package page-break-lines
  :ensure t)

(when (string-equal system-type "darwin")
  ;; delete files by moving them to the trash
  (setq delete-by-moving-to-trash t)
  (setq trash-directory "~/.Trash")

  ;; Don't make new frames when opening a new file with Emacs
  (setq ns-pop-up-frames nil)

  ;; set the Fn key as the hyper key
  (setq ns-function-modifier 'hyper)

  ;; Use Command-` to switch between Emacs windows (not frames)
  (bind-key "s-`" 'other-window)
  
  ;; Use Command-Shift-` to switch Emacs frames in reverse
  (bind-key "s-~" (lambda() () (interactive) (other-window -1)))

  ;; Because of the keybindings above, set one for `other-frame'
  (bind-key "s-1" 'other-frame)

  ;; Fullscreen!
  (setq ns-use-native-fullscreen nil) ; Not Lion style
  (bind-key "<s-return>" 'toggle-frame-fullscreen)

  ;; buffer switching
  (bind-key "s-{" 'previous-buffer)
  (bind-key "s-}" 'next-buffer)

  ;; Compiling
  (bind-key "H-c" 'compile)
  (bind-key "H-r" 'recompile)
  (bind-key "H-s" (defun save-and-recompile () (interactive) (save-buffer) (recompile)))

  ;; disable the key that minimizes emacs to the dock because I don't
  ;; minimize my windows
  ;; (global-unset-key (kbd "C-z"))

  (defun open-dir-in-finder ()
    "Open a new Finder window to the path of the current buffer"
    (interactive)
    (start-process "mai-open-dir-process" nil "open" "."))
  (bind-key "C-c o f" 'open-dir-in-finder)

  (defun open-dir-in-iterm ()
    "Open the current directory of the buffer in iTerm."
    (interactive)
    (let* ((iterm-app-path "/Applications/iTerm.app")
           (iterm-brew-path "/opt/homebrew-cask/Caskroom/iterm2/1.0.0/iTerm.app")
           (iterm-path (if (file-directory-p iterm-app-path)
                           iterm-app-path
                         iterm-brew-path)))
      (start-process "mai-open-dir-process" nil "open" "-a" iterm-path ".")))
  (bind-key "C-c o t" 'open-dir-in-iterm)

  ;; Not going to use these commands
  (put 'ns-print-buffer 'disabled t)
  (put 'suspend-frame 'disabled t))

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :ensure t
  :init
  (exec-path-from-shell-initialize))

(let* ((cmd "sw_vers -productVersion")
       (macos-version (string-to-int
                     (cadr (split-string
                            (shell-command-to-string cmd)
                            "\\."))))
       (elcapitan-version 11))
  (when (>= macos-version elcapitan-version)
    (setq visible-bell nil)
    (setq ring-bell-function 'ignore)

    ;; El Capitan full screen animation is quick and delightful (enough to start using it).
    (setq ns-use-native-fullscreen t)))

;; make ibuffer the default buffer lister.
(defalias 'list-buffers 'ibuffer)

(add-hook 'dired-mode-hook 'auto-revert-mode)

;; Also auto refresh dired, but be quiet about it
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

(use-package recentf
  :bind ("C-x C-r" . helm-recentf)
  :config
  (recentf-mode t)
  (setq recentf-max-saved-items 200))

(use-package org
  :ensure org-plus-contrib)

(bind-key "C-c l" 'org-store-link)
(bind-key "C-c c" 'org-capture)
(bind-key "C-c a" 'org-agenda)

(setq org-agenda-files
      (delq nil
            (mapcar (lambda (x) (and (file-exists-p x) x))
                    '("~/Dropbox/Agenda"))))

(bind-key "C-c c" 'org-capture)
(setq org-default-notes-file "~/Dropbox/Notes/notes.org")

(setq org-use-speed-commands t)

(setq org-image-actual-width 550)

(setq org-highlight-latex-and-related '(latex script entities))

(setq org-tags-column 45)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (C . t)
   (calc . t)
   (latex . t)
   (java . t)
   (ruby . t)
   (lisp . t)
   (scheme . t)
   (shell . t)
   (sqlite . t)
   (js . t)))

(defun my-org-confirm-babel-evaluate (lang body)
  "Do not confirm evaluation for these languages."
  (not (or (string= lang "C")
           (string= lang "java")
           (string= lang "python")
           (string= lang "emacs-lisp")
           (string= lang "sqlite"))))
(setq org-confirm-babel-evaluate 'my-org-confirm-babel-evaluate)

(setq org-src-fontify-natively t
      org-src-window-setup 'current-window
      org-src-strip-leading-and-trailing-blank-lines t
      org-src-preserve-indentation t
      org-src-tab-acts-natively t)

(setq org-latex-pdf-process (list "latexmk -pdf %f"))

(add-hook 'org-mode-hook
(lambda () (org-bullets-mode t)))

(global-prettify-symbols-mode t)

;; mdfind is the command line interface to Spotlight
(setq locate-command "mdfind")

(bind-key "s-C-<left>"  'shrink-window-horizontally)
(bind-key "s-C-<right>" 'enlarge-window-horizontally)
(bind-key "s-C-<down>"  'shrink-window)
(bind-key "s-C-<up>"    'enlarge-window)

(defun vsplit-other-window ()
  "Splits the window vertically and switches to that window."
  (interactive)
  (split-window-vertically)
  (other-window 1 nil))
(defun hsplit-other-window ()
  "Splits the window horizontally and switches to that window."
  (interactive)
  (split-window-horizontally)
  (other-window 1 nil))

(bind-key "C-x 2" 'vsplit-other-window)
(bind-key "C-x 3" 'hsplit-other-window)

(use-package winner
  :config
  (winner-mode t)
  :bind (("M-s-<left>" . winner-undo)
         ("M-s-<right>" . winner-redo)))

(use-package transpose-frame
  :ensure t
  :bind ("H-t" . transpose-frame))

(use-package ido
  :init
  (setq ido-enable-flex-matching t)
  (setq ido-everywhere t)
  (ido-mode t)
  (use-package ido-vertical-mode
    :ensure t
    :defer t
    :init (ido-vertical-mode 1)
    (setq ido-vertical-define-keys 'C-n-and-C-p-only)))

(use-package whitespace
  :bind ("s-<f10>" . whitespace-mode))

(use-package ag
  :commands ag
  :ensure t)

(use-package ace-jump-mode
  :ensure t
  :diminish ace-jump-mode
  :commands ace-jump-mode
  :bind ("C-S-s" . ace-jump-mode))

(use-package ace-window
  :ensure t
  :config
  (setq aw-keys '(?a ?o ?e ?u ?h ?t ?n ?s))
  (ace-window-display-mode)
  :bind ("s-o" . ace-window))

(use-package android-mode
  :ensure t
  :defer t)

(use-package c-eldoc
  :commands c-turn-on-eldoc-mode
  :ensure t
  :init (add-hook 'c-mode-hook #'c-turn-on-eldoc-mode))

(use-package clojure-mode
  :defer t
  :ensure t)

(use-package dash-at-point
  :ensure t
  :bind (("s-D"     . dash-at-point)
         ("C-c e"   . dash-at-point-with-docset)))

(use-package helm
  :ensure t
  :diminish helm-mode
  :init (progn
          (require 'helm-config)
          (use-package helm-projectile
            :ensure t
            :commands helm-projectile
            :bind ("C-c p h" . helm-projectile))
          (use-package helm-ag :defer 10  :ensure t)
          (setq helm-locate-command "mdfind -interpret -name %s %s"
                helm-ff-newfile-prompt-p nil
                helm-M-x-fuzzy-match t)
          (helm-mode)
          (use-package helm-swoop
            :ensure t
            :bind ("H-w" . helm-swoop)))
  :bind (("C-c h" . helm-command-prefix)
         ("C-x b" . helm-mini)
         ("C-`" . helm-resume)
         ("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)))

(use-package magit
  :ensure t
  :defer t
  :bind ("C-c g" . magit-status)
  :config
  (define-key magit-status-mode-map (kbd "q") 'magit-quit-session))

;; full screen magit-status
(defadvice magit-status (around magit-fullscreen activate)
  (window-configuration-to-register :magit-fullscreen)
  ad-do-it
  (delete-other-windows))

(defun magit-quit-session ()
  "Restores the previous window configuration and kills the magit buffer"
  (interactive)
  (kill-buffer)
  (jump-to-register :magit-fullscreen))

(use-package edit-server
  :ensure t
  :config
  (edit-server-start)
  (setq edit-server-default-major-mode 'markdown-mode)
  (setq edit-server-new-frame nil))

(use-package ein
  :ensure t
  :defer t)

(use-package expand-region
  :ensure t
  :bind ("C-@" . er/expand-region))

(use-package flycheck
  :ensure t
  :defer 10
  :config (setq flycheck-html-tidy-executable "tidy5"))

(use-package gist
  :ensure t
  :commands gist-list)

(use-package macrostep
  :ensure t
  :bind ("H-`" . macrostep-expand))

(use-package markdown-mode
  :ensure t
  :mode (("\\.markdown\\'" . markdown-mode)
         ("\\.md\\'"       . markdown-mode)))

(use-package multiple-cursors
  :ensure t
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C-<"     . mc/mark-all-like-this)
         ("C-!"         . mc/mark-next-symbol-like-this)
         ("s-d"         . mc/mark-all-dwim)))

(use-package olivetti
  :ensure t
  :bind ("s-<f6>" . olivetti-mode))

(use-package projectile
  :ensure t
  :diminish projectile-mode
  :commands (projectile-mode projectile-switch-project)
  :bind ("C-c p p" . projectile-switch-project)
  :config
  (projectile-global-mode t)
  (setq projectile-enable-caching t)
  (setq projectile-switch-project-action 'projectile-dired))

(use-package python-mode
  :defer t
  :ensure t)

(use-package racket-mode
  :ensure t
  :commands racket-mode
  :config
  (setq racket-smart-open-bracket-enable t))

(use-package geiser
  :ensure t
  :defer t
  :config
  (setq geiser-default-implementation '(racket)))

(use-package restclient
  :ensure t
  :mode ("\\.restclient\\'" . restclient-mode))

(use-package smartparens
  :ensure t
  :defer t
  :diminish smartparens-mode
  :config
  (add-to-list 'sp--lisp-modes 'racket-mode)
  (add-to-list 'sp--lisp-modes 'geiser-mode)
  (require 'smartparens-config)

  ;; Set up some pairings for org mode markup. These pairings won't
  ;; activate by default; they'll only apply for wrapping regions.
  (sp-local-pair 'org-mode "~" "~" :actions '(wrap))
  (sp-local-pair 'org-mode "/" "/" :actions '(wrap))
  (sp-local-pair 'org-mode "*" "*" :actions '(wrap)))

(use-package smartscan
  :ensure t
  :config (global-smartscan-mode 1)
  :bind (("s-n" . smartscan-symbol-go-forward)
         ("s-p" . smartscan-symbol-go-backward)))

(use-package smex
  :if (not (featurep 'helm-mode))
  :ensure t
  :bind ("M-x" . smex))

(use-package skewer-mode
  :commands skewer-mode
  :ensure t
  :config (skewer-setup))

(use-package smooth-scrolling
  :ensure t)

(use-package typescript-mode
  :ensure t
  :defer t)

(use-package visual-regexp
  :ensure t
  :init
  (use-package visual-regexp-steroids :ensure t)
  :bind (("C-c r" . vr/replace)
         ("C-c q" . vr/query-replace)
         ("C-c m" . vr/mc-mark) ; Need multiple cursors
         ("C-M-r" . vr/isearch-backward)
         ("C-M-s" . vr/isearch-forward)))

(use-package yasnippet
  :ensure t
  :defer t
  :diminish yas-minor-mode
  :config
  (setq yas-snippet-dirs (concat user-emacs-directory "snippets"))
  (yas-global-mode))

(use-package emmet-mode
  :ensure t
  :commands emmet-mode
  :config
  (add-hook 'html-mode-hook 'emmet-mode)
  (add-hook 'css-mode-hook 'emmet-mode))

(use-package zoom-frm
  :ensure t
  :bind (("C-M-=" . zoom-in/out)
         ("H-z"   . toggle-zoom-frame)
         ("s-<f1>" . toggle-zoom-frame))
  :config
  (setq frame-zoom-font-difference 10))

(use-package scratch
  :ensure t
  :commands scratch)

(use-package shell-pop
  :ensure t
  :bind ("M-<f12>" . shell-pop))

(use-package slime
  :ensure t
  :defer 10
  :init
  (setq inferior-lisp-program "/usr/local/bin/sbcl")
  (add-to-list 'slime-contribs 'slime-fancy))

(use-package quickrun
  :defer 10
  :ensure t
  :bind ("H-q" . quickrun))

(use-package visible-mode
  :bind (("H-v" . visible-mode)
         ("s-<f2>" . visible-mode)))

(use-package virtualenvwrapper
  :ensure t
  :defer t
  :config
  (setq venv-location "~/.virtualenvs"))

(use-package xquery-mode
  :ensure t
  :defer t)

(use-package latex-extra
  :defer t
  :ensure t)

(use-package latex-preview-pane
  :ensure t
  :defer t)

(use-package undo-tree
  :ensure t)

(use-package crux
  :ensure t
  :bind (("C-c o o" . crux-open-with)
         ("C-c u" . crux-view-url)))

(require 'subr-x) ;; #'string-trim
(defvar mai/user-settings-dir nil
  "The directory with user-specific Emacs settings for this
  user.")

;; Settings for currently logged in user
(setq mai/user-settings-dir
      (concat user-emacs-directory
              "users/"
              (string-trim (shell-command-to-string "hostname -s"))))
(add-to-list 'load-path mai/user-settings-dir)

;; Load settings specific for the current user
(when (file-exists-p mai/user-settings-dir)
  (mapc 'load (directory-files mai/user-settings-dir nil "^[^#].*el$")))

(defun my-c-mode-hook ()
  (setq c-basic-offset 4)
  (c-set-offset 'substatement-open 0)   ; Curly braces alignment
  (c-set-offset 'case-label 4))         ; Switch case statements alignment

(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'java-mode-hook 'my-c-mode-hook)

(use-package jasmin)

(use-package rust-mode
  :ensure t
  :defer t)

(setq display-time-default-load-average nil)

(setq battery-mode-line-format "[%b%p%% %t]")

(use-package doc-view
  :commands doc-view-mode
  :config
  (define-key doc-view-mode-map (kbd "<right>") 'doc-view-next-page)
  (define-key doc-view-mode-map (kbd "<left>") 'doc-view-previous-page))

(setq mouse-wheel-scroll-amount (quote (0.01)))

(use-package server
  :config
  (server-start))



(require 'package)
(package-initialize)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)

(defvar local-packages '(projectile auto-complete epc jedi))

(defun uninstalled-packages (packages)
  (delq nil
	(mapcar (lambda (p) (if (package-installed-p p nil) nil p)) packages)))

;; This delightful bit adapted from:
;; http://batsov.com/articles/2012/02/19/package-management-in-emacs-the-good-the-bad-and-the-ugly/

(let ((need-to-install (uninstalled-packages local-packages)))
  (when need-to-install
    (progn
      (package-refresh-contents)
      (dolist (p need-to-install)
	(package-install p)))))

;; Global Jedi config vars

(defvar jedi-config:use-system-python nil
  "Will use system python and active environment for Jedi server.
May be necessary for some GUI environments (e.g., Mac OS X)")

(defvar jedi-config:with-virtualenv nil
  "Set to non-nil to point to a particular virtualenv.")

(defvar jedi-config:vcs-root-sentinel ".git")

(defvar jedi-config:python-module-sentinel "__init__.py")

;; Helper functions

;; Small helper to scrape text from shell output
(defun get-shell-output (cmd)
  (replace-regexp-in-string "[ \t\n]*$" "" (shell-command-to-string cmd)))

;; Ensure that PATH is taken from shell
;; Necessary on some environments without virtualenv
;; Taken from: http://stackoverflow.com/questions/8606954/path-and-exec-path-set-but-emacs-does-not-find-executable

(defun set-exec-path-from-shell-PATH ()
  "Set up Emacs' `exec-path' and PATH environment variable to match that used by the user's shell."
  (interactive)
  (let ((path-from-shell (get-shell-output "$SHELL --login -i -c 'echo $PATH'")))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

;; Package specific initialization
(add-hook
 'after-init-hook
 '(lambda ()

    ;; Looks like you need Emacs 24 for projectile
    (unless (< emacs-major-version 24)
      (require 'projectile)
      (projectile-global-mode))

    ;; Auto-complete
    (require 'auto-complete-config)
    (ac-config-default)

    ;; Uncomment next line if you like the menu right away
    ;; (setq ac-show-menu-immediately-on-auto-complete t)

    ;; Can also express in terms of ac-delay var, e.g.:
    ;;   (setq ac-auto-show-menu (* ac-delay 2))

    ;; Jedi
    (require 'jedi)

    ;; (Many) config helpers follow

    ;; Alternative methods of finding the current project root
    ;; Method 1: basic
    (defun get-project-root (buf repo-file &optional init-file)
      "Just uses the vc-find-root function to figure out the project root.
       Won't always work for some directory layouts."
      (let* ((buf-dir (expand-file-name (file-name-directory (buffer-file-name buf))))
	     (project-root (vc-find-root buf-dir repo-file)))
	(if project-root
	    (expand-file-name project-root)
	  nil)))

    ;; Method 2: slightly more robust
    (defun get-project-root-with-file (buf repo-file &optional init-file)
      "Guesses that the python root is the less 'deep' of either:
         -- the root directory of the repository, or
         -- the directory before the first directory after the root
            having the init-file file (e.g., '__init__.py'."

      ;; make list of directories from root, removing empty
      (defun make-dir-list (path)
        (delq nil (mapcar (lambda (x) (and (not (string= x "")) x))
                          (split-string path "/"))))
      ;; convert a list of directories to a path starting at "/"
      (defun dir-list-to-path (dirs)
        (mapconcat 'identity (cons "" dirs) "/"))
      ;; a little something to try to find the "best" root directory
      (defun try-find-best-root (base-dir buffer-dir current)
        (cond
         (base-dir ;; traverse until we reach the base
          (try-find-best-root (cdr base-dir) (cdr buffer-dir)
                              (append current (list (car buffer-dir)))))

         (buffer-dir ;; try until we hit the current directory
          (let* ((next-dir (append current (list (car buffer-dir))))
                 (file-file (concat (dir-list-to-path next-dir) "/" init-file)))
            (if (file-exists-p file-file)
                (dir-list-to-path current)
              (try-find-best-root nil (cdr buffer-dir) next-dir))))

         (t nil)))

      (let* ((buffer-dir (expand-file-name (file-name-directory (buffer-file-name buf))))
             (vc-root-dir (vc-find-root buffer-dir repo-file)))
        (if (and init-file vc-root-dir)
            (try-find-best-root
             (make-dir-list (expand-file-name vc-root-dir))
             (make-dir-list buffer-dir)
             '())
          vc-root-dir))) ;; default to vc root if init file not given

    ;; Set this variable to find project root
    (defvar jedi-config:find-root-function 'get-project-root-with-file)

    (defun current-buffer-project-root ()
      (funcall jedi-config:find-root-function
               (current-buffer)
               jedi-config:vcs-root-sentinel
               jedi-config:python-module-sentinel))

    (defun jedi-config:setup-server-args ()
      ;; little helper macro for building the arglist
      (defmacro add-args (arg-list arg-name arg-value)
        `(setq ,arg-list (append ,arg-list (list ,arg-name ,arg-value))))
      ;; and now define the args
      (let ((project-root (current-buffer-project-root)))

        (make-local-variable 'jedi:server-args)

        (when project-root
          (message (format "Adding system path: %s" project-root))
          (add-args jedi:server-args "--sys-path" project-root))

        (when jedi-config:with-virtualenv
          (message (format "Adding virtualenv: %s" jedi-config:with-virtualenv))
          (add-args jedi:server-args "--virtual-env" jedi-config:with-virtualenv))))

    ;; Use system python
    (defun jedi-config:set-python-executable ()
      (set-exec-path-from-shell-PATH)
      (make-local-variable 'jedi:server-command)
      (set 'jedi:server-command
           (list (executable-find "python") ;; may need help if running from GUI
                 (cadr default-jedi-server-command))))

    ;; Now hook everything up
    ;; Hook up to autocomplete
    (add-to-list 'ac-sources 'ac-source-jedi-direct)

    ;; Enable Jedi setup on mode start
    (add-hook 'python-mode-hook 'jedi:setup)

    ;; Buffer-specific server options
    (add-hook 'python-mode-hook
              'jedi-config:setup-server-args)
    (when jedi-config:use-system-python
      (add-hook 'python-mode-hook
                'jedi-config:set-python-executable))

    ;; And custom keybindings
    (defun jedi-config:setup-keys ()
      (local-set-key (kbd "M-.") 'jedi:goto-definition)
      (local-set-key (kbd "M-,") 'jedi:goto-definition-pop-marker)
      (local-set-key (kbd "M-?") 'jedi:show-doc)
      (local-set-key (kbd "M-/") 'jedi:get-in-function-call))

    ;; Don't let tooltip show up automatically
    (setq jedi:get-in-function-call-delay 10000000)
    ;; Start completion at method dot
    (setq jedi:complete-on-dot t)
    ;; Use custom keybinds
    (add-hook 'python-mode-hook 'jedi-config:setup-keys)

    ))
;; End of Python IDE set up

(electric-pair-mode 1)
(global-visual-line-mode 1)
