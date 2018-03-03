(defun iz/visit-emacs-config ()
  (interactive)
  (find-file "~/.emacs.d/config.org"))

(global-set-key (kbd "C-x e") 'iz/visit-emacs-config)

(defun iz/visit-blog-config ()
  (interactive)
  (find-file "~/Dropbox/BlogHugo"))

(global-set-key (kbd "C-x q") 'iz/visit-blog-config)

(defun iz/visit-worklog-config ()
  (interactive)
  (find-file "~/Dropbox/worklogs/2017WorkLog.org"))

(global-set-key (kbd "C-x w") 'iz/visit-worklog-config)

(defun iz/visit-dropbox ()
  (interactive)
  (find-file "~/Dropbox"))

(global-set-key (kbd "C-x r") 'iz/visit-dropbox)

(setq user-full-name "Isaac Zhou"
      user-mail-address "isaaczhou85@gmail.com"
      calendar-latitude 40.7
      calendar-longitude 74.0
      calendar-location-name "New York, NY")

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

(use-package leuven-theme)
(require 'powerline)
(powerline-default-theme)

;; (use-package cyberpunk-theme
;;   :if (window-system)
;;   :ensure t
;;   :init
;;   (progn
;;     (load-theme 'cyberpunk t)
;;     (set-face-attribute `mode-line nil
;;                         :box nil)
;;     (set-face-attribute `mode-line-inactive nil
;;                         :box nil)))

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

(when (window-system)
  (set-default-font "Fira Code 18"))
(let ((alist '((33 . ".\\(?:\\(?:==\\|!!\\)\\|[!=]\\)")
               (35 . ".\\(?:###\\|##\\|_(\\|[#(?[_{]\\)")
               (36 . ".\\(?:>\\)")
               (37 . ".\\(?:\\(?:%%\\)\\|%\\)")
               (38 . ".\\(?:\\(?:&&\\)\\|&\\)")
               (42 . ".\\(?:\\(?:\\*\\*/\\)\\|\\(?:\\*[*/]\\)\\|[*/>]\\)")
               (43 . ".\\(?:\\(?:\\+\\+\\)\\|[+>]\\)")
               (45 . ".\\(?:\\(?:-[>-]\\|<<\\|>>\\)\\|[<>}~-]\\)")
               (46 . ".\\(?:\\(?:\\.[.<]\\)\\|[.=-]\\)")
               (47 . ".\\(?:\\(?:\\*\\*\\|//\\|==\\)\\|[*/=>]\\)")
               (48 . ".\\(?:x[a-zA-Z]\\)")
               (58 . ".\\(?:::\\|[:=]\\)")
               (59 . ".\\(?:;;\\|;\\)")
               (60 . ".\\(?:\\(?:!--\\)\\|\\(?:~~\\|->\\|\\$>\\|\\*>\\|\\+>\\|--\\|<[<=-]\\|=[<=>]\\||>\\)\\|[*$+~/<=>|-]\\)")
               (61 . ".\\(?:\\(?:/=\\|:=\\|<<\\|=[=>]\\|>>\\)\\|[<=>~]\\)")
               (62 . ".\\(?:\\(?:=>\\|>[=>-]\\)\\|[=>-]\\)")
               (63 . ".\\(?:\\(\\?\\?\\)\\|[:=?]\\)")
               (91 . ".\\(?:]\\)")
               (92 . ".\\(?:\\(?:\\\\\\\\\\)\\|\\\\\\)")
               (94 . ".\\(?:=\\)")
               (119 . ".\\(?:ww\\)")
               (123 . ".\\(?:-\\)")
               (124 . ".\\(?:\\(?:|[=|]\\)\\|[=>|]\\)")
               (126 . ".\\(?:~>\\|~~\\|[>=@~-]\\)")
               )
             ))
  (dolist (char-regexp alist)
    (set-char-table-range composition-function-table (car char-regexp)
                          `([,(cdr char-regexp) 0 font-shape-gstring]))))

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

(require 'org-install)
(require 'ob-ipython)
(setq org-babel-python-command "/home/isaac/anaconda3/bin/python3")
(setq py-python-command "/home/isaac/anaconda3/bin/python3")

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (ipython . t)
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
           (string= lang "ipython")
           (string= lang "java")
           (string= lang "python")
           (string= lang "emacs-lisp")
           (string= lang "js")
           (string= lang "sqlite"))))
(setq org-confirm-babel-evaluate 'my-org-confirm-babel-evaluate)

;;; display/update images in the buffer after I evaluate
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)

(with-eval-after-load 'python
  (defun python-shell-completion-native-try ()
    "Return non-nil if can trigger native completion."
    (let ((python-shell-completion-native-enable t)
          (python-shell-completion-native-output-timeout
           python-shell-completion-native-try-output-timeout))
      (python-shell-completion-native-get-completions
       (get-buffer-process (current-buffer))
       nil "_"))))

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

;; (require 'helm-config)
;; (setq helm-mode t)
;; (setq helm-projectile t)
;; (setq helm-swoop t)
(use-package helm
  :ensure t
  :diminish helm-mode
  :init (progn
          (require 'helm-config)
          (use-package helm-projectile
            :ensure t
            :commands helm-projectile
            :bind ("C-c p h" . helm-projectile))
          (use-package helm-ag :defer 10 :ensure t)
          (setq helm-locate-command "mdfind -interpret -name %s %s"
                ;; helm-ff-newfile-prompt-p nil
                helm-M-x-fuzzy-match t)
          (helm-mode)
          (use-package helm-swoop
            :ensure t
            :bind ("H-w" . helm-swoop))
          )
  :bind (("C-c h" . helm-command-prefix)
         ("C-x b" . helm-mini)
         ("C-`" . helm-resume)
         ("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("C-c f" . copy-file)
         ("C-c d" . copy-directory)
         ("C-c n" . rename-file)
         )
  )

(use-package magit
  :ensure t
  :defer t
  :bind ("C-x g" . magit-status)
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
  (setq venv-location "~/anaconda3/envs/"))

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

(defun my-c-mode-hook ()
  (setq c-basic-offset 4)
  (c-set-offset 'substatement-open 0)   ; Curly braces alignment
  (c-set-offset 'case-label 4))         ; Switch case statements alignment

(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'java-mode-hook 'my-c-mode-hook)

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

(require 'yasnippet)
(yas-global-mode 1)

(ac-config-default)
(global-auto-complete-mode t)
(setq ac-auto-show-menu    0.2)
(setq ac-delay             0.2)
(setq ac-menu-height       20)
(setq ac-auto-start t)
(setq ac-show-menu-immediately-on-auto-complete t)

(use-package ox-pandoc
  :after ox
  :if (executable-find "pandoc")
  :config
  ;; default options for all output formats
  (setq org-pandoc-options '((standalone . t)
                             (latex-engine . xelatex)
                             (mathjax . t)
                             (parse-raw . t)))
  ;; cancel above settings only for 'docx' format
  (setq org-pandoc-options-for-docx '((standalone . nil))))

(defun isaac/org-hugo-export ()
  "Export current subheading to markdown using pandoc."
  (interactive)
  ;; Save cursor position
  (save-excursion
    ;; Go to top level heading for subtree
    (unless (eq (org-current-level) 1)
      (org-up-heading-all 10))
    ;; Set export format, pandoc options, post properties
    (let* ((org-pandoc-format 'markdown)
           (org-pandoc-options-for-markdown '((standalone . t)
                                              (atx-headers . t)
                                              (columns . 79)))
           (hl (org-element-at-point))
           (filename (org-element-property :EXPORT_FILE_NAME hl))
           (title (format "\"%s\"" (org-element-property :title hl)))
           (slug (format "\"%s\"" (org-element-property :SLUG hl)))
           (date (format "\"%s\"" (org-element-property :DATE hl)))
           (tags (org-get-tags-at))
           (categories
            (format "[\"%s\"]" (mapconcat 'identity tags "\",\""))))
      (if (string= (org-get-todo-state) "DRAFT")
          (message "Draft not exported")
        (progn
          ;; Make the export
          (org-export-to-file
              'pandoc
              (org-export-output-file-name
               (concat (make-temp-name ".tmp") ".org") t)
            nil t nil nil nil
            (lambda (f)
              (org-pandoc-run-to-buffer-or-file f 'markdown t nil)))
          ;; Use advice-add to add advice to existing process sentinel
          ;; to modify file /after/ the export process has finished.
          (advice-add
           #'org-pandoc-sentinel
           :after
           `(lambda (process event)
              (with-temp-file ,filename
                (insert-file-contents ,filename)
                (goto-char (point-min))
                ;; Remove default header
                (re-search-forward "---\\(.\\|\n\\)+?---\n\n")
                (replace-match "")
                (goto-char (point-min))
                ;; Insert new properties
                (insert
                 (format
                  "---\ntitle: %s\nslug: %s\ndate: %s\ncategories: %s\n---\n\n"
                  ,title ,slug ,date ,categories))
                ;; Demote headings and tweak code blocks
                (dolist (reps '(("^#" . "##")
                                ("``` {\\.\\(.+?\\)}" . "```\\1")))
                  (goto-char (point-min))
                  (while (re-search-forward (car reps) nil t)
                    (replace-match (cdr reps))))))
           '((name . "hugo-advice")))
          ;; We don't want our advice to stick around afterwards
          (advice-remove #'org-pandoc-sentinel 'hugo-advice)
          (when (string= (org-get-todo-state) "↑")
            (org-todo)))))))

(require 'ox-hugo)

(add-hook 'python-mode-hook 'anaconda-mode)
(add-hook 'python-mode-hook 'anaconda-eldoc-mode)
(add-hook 'ob-ipython-mode-hook 'anaconda-mode)
(add-hook 'ob-ipython-mode-hook 'anaconda-eldoc-mode)

(add-to-list 'python-shell-extra-pythonpaths "/home/isaac/anaconda3/bin/python")

(exec-path-from-shell-initialize)

(defun set-exec-path-from-shell-PATH ()
        (interactive)
        (let ((path-from-shell (replace-regexp-in-string "^.*\n.*shell\n" "" (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
        (setenv "PATH" path-from-shell)
        (setq exec-path (split-string path-from-shell path-separator))))

(set-exec-path-from-shell-PATH)

(defvar yt-iframe-format
  ;; You may want to change your width and height.
  (concat "<iframe width=\"440\""
          " height=\"335\""
          " src=\"https://www.youtube.com/embed/%s\""
          " frameborder=\"0\""
          " allowfullscreen>%s</iframe>"))

(org-add-link-type
 "yt"
 (lambda (handle)
   (browse-url
    (concat "https://www.youtube.com/embed/"
            handle)))
 (lambda (path desc backend)
   (cl-case backend
     (html (format yt-iframe-format
                   path (or desc "")))
     (latex (format "\href{%s}{%s}"
                    path (or desc "video"))))))

;; use web-mode for .jsx files
;; http://www.flycheck.org/manual/latest/index.html
(require 'flycheck)

(add-to-list 'auto-mode-alist '("\\.jsx$" . rjsx-mode))
(add-to-list 'auto-mode-alist '("\\.js$" . rjsx-mode))
;; (add-to-list 'auto-mode-alist '("\\.ejs" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.ejs" . emmet-mode))


;; turn on flychecking globally
(add-hook 'after-init-hook #'global-flycheck-mode)

;; disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(javascript-jshint)))

;; use eslint with web-mode for jsx files
(flycheck-add-mode 'javascript-eslint 'web-mode)

;; customize flycheck temp file prefix
(setq-default flycheck-temp-prefix ".flycheck")

;; disable json-jsonlist checking for json files
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(json-jsonlist)))

;; https://github.com/purcell/exec-path-from-shell
;; only need exec-path-from-shell on OSX
;; this hopefully sets up path and other vars better
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))
(defadvice js-jsx-indent-line (after js-jsx-indent-line-after-hack activate)
  "Workaround sgml-mode and follow airbnb component style."
  (let* ((cur-line (buffer-substring-no-properties
                    (line-beginning-position)
                    (line-end-position))))
    (if (string-match "^\\( +\\)\/?> *$" cur-line)
      (let* ((empty-spaces (match-string 1 cur-line)))
        (replace-regexp empty-spaces
                        (make-string (- (length empty-spaces) sgml-basic-offset) 32)
                        nil
                        (line-beginning-position) (line-end-position))))))

(use-package skewer-mode
  :commands skewer-mode
  :ensure t
  :config (skewer-setup))

(add-to-list 'auto-mode-alist '("components\\/.*\\.js\\'" . rjsx-mode))
(add-hook 'web-mode-hook  'rjsx-mode-hook)

(require 'emmet-mode)
(use-package emmet-mode
  :ensure t
  :commands emmet-mode
  :config
  (add-hook 'html-mode-hook 'emmet-mode)
  (add-hook 'css-mode-hook 'emmet-mode)
  (add-hook 'rjsx-mode-hook 'emmet-mode)
  (add-hook 'multi-web-mode-hook 'emmet-mode)
  (add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
  (add-hook 'web-mode-hook 'emmet-mode)
  (add-hook 'js2-mode-hook 'emmet-mode)
)

;; (add-hook 'js2-mode-hook 'ac-js2-mode)

;; for better jsx syntax-highlighting in web-mode
;; - courtesy of Patrick @halbtuerke
(defadvice web-mode-highlight-part (around tweak-jsx activate)
  (if (equal web-mode-content-type "jsx")
    (let ((web-mode-enable-part-face nil))
      ad-do-it)
    ad-do-it))

;; use local eslint from node_modules before global
;; http://emacs.stackexchange.com/questions/21205/flycheck-with-file-relative-eslint-executable
(defun my/use-eslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))
(add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)

(require 'prettier-js)
(add-hook 'js2-mode-hook 'prettier-js-mode)
(add-hook 'web-mode-hook 'prettier-js-mode)
(add-hook 'rjsx-mode-hook 'prettier-js-mode)
(add-hook 'js-mode-hook 'prettier-js-mode)
(add-hook 'multi-web-mode-hook 'prettier-js-mode)

(setq prettier-js-args '(
  ;; "--trailing-comma" "all"
  "--bracket-spacing" "false"
))

(defun enable-minor-mode (my-pair)
  "Enable minor mode if filename match the regexp.  MY-PAIR is a cons cell (regexp . minor-mode)."
  (if (buffer-file-name)
      (if (string-match (car my-pair) buffer-file-name)
      (funcall (cdr my-pair)))))

(add-hook 'web-mode-hook #'(lambda ()
                            (enable-minor-mode
                             '("\\.js?\\'" . prettier-js-mode))))

(add-hook 'html-mode-hook  'html-mode)
(add-hook 'html-mode-hook 'emmet-mode)
;; (add-hook 'html-mode-hook 'multi-web-mode)

;; (add-hook 'css-mode-hook  'css-mode)
(add-hook 'css-mode-hook 'rainbow-mode)

(setq python-indent-guess-indent-offset nil)
(setq python-indent-offset 4)

;; adjust indents for web-mode to 2 spaces
(defun my-web-mode-hook ()
  "Hooks for Web mode. Adjust indents"
  ;;; http://web-mode.org/
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-js-indent-offset 2)
  ;; (setq js-mode-indent-level 2)
  ;; (setq-default js2-basic-offset 2)
  ;; (setq javascript-indent-level 2)
  (setq web-mode-code-indent-offset 2))
(add-hook 'web-mode-hook  'my-web-mode-hook)

;; (global-aggressive-indent-mode 1)

(defun move-text-internal (arg)
   (cond
    ((and mark-active transient-mark-mode)
     (if (> (point) (mark))
            (exchange-point-and-mark))
     (let ((column (current-column))
              (text (delete-and-extract-region (point) (mark))))
       (forward-line arg)
       (move-to-column column t)
       (set-mark (point))
       (insert text)
       (exchange-point-and-mark)
       (setq deactivate-mark nil)))
    (t
     (beginning-of-line)
     (when (or (> arg 0) (not (bobp)))
       (forward-line)
       (when (or (< arg 0) (not (eobp)))
            (transpose-lines arg))
       (forward-line -1)))))

(defun move-text-down (arg)
   "Move region (transient-mark-mode active) or current line
  arg lines down."
   (interactive "*p")
   (move-text-internal arg))

(defun move-text-up (arg)
   "Move region (transient-mark-mode active) or current line
  arg lines up."
   (interactive "*p")
   (move-text-internal (- arg)))

(global-set-key [\M-\S-up] 'move-text-up)
(global-set-key [\M-\S-down] 'move-text-down)

(setq warning-minimum-level :emergency)
