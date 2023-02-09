(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;(add-to-list 'package-archives '("org" . "https://git.sr.ht/~bzg/org-contrib"))
(package-initialize t)

(package-refresh-contents)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
	  (package-install 'use-package))

(use-package org-contrib
	     :ensure t)

(add-to-list 'load-path "~/.config/emacs/lisp/")
(add-to-list 'load-path "~/src/emacs-application-framework/")
(add-to-list 'custom-theme-load-path (expand-file-name "~/.emacs.d/themes/"))

(set-face-attribute 'default t :font "Hack Nerd Font Mono 10")

;(use-package auto-package-update
;  :ensure t
;  :config
;  (setq auto-package-update-delete-old-versions t)
;  (setq auto-package-update-hide-results t)
;  (auto-package-update-maybe))

;; let's get encryption established
(setenv "GPG_AGENT_INFO" nil)  ;; use emacs pinentry
(setq auth-source-debug t)

; (setq epg-gpg-program "gpg2")  ;; not necessary
(use-package epa-file
  :config
  (epa-file-enable)
  (setq epa-pinentry-mode 'loopback)
					;(setq epg-pinentry-mode 'loopback)
  (pinentry-start))

;(use-package org-crypt
;	     :ensure t
;:config (org-crypt-use-before-save-magic))

(use-package company
  :ensure t
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  :config
  (setq company-dabbrev-downcase 0)
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 1)
  (setq company-tooltip-align-annotations t))

(use-package helm
  :ensure t

  :init
  (require 'helm-config)
  :config
  (global-set-key (kbd "M-x") #'helm-M-x)
  (global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
  (global-set-key (kbd "C-x C-f") #'helm-find-files)
  (helm-mode 1))

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package smartparens
  :ensure t
  :init
  (smartparens-global-mode))

(use-package one-themes
  :demand t
  :ensure t
  :config
  (load-theme 'one-dark t))

(use-package smart-mode-line-atom-one-dark-theme
  :demand t
  :ensure t)
  

(use-package smart-mode-line
  :after 'smart-mode-line-atom-one-dark-theme
  :ensure t
  :config
  (setq sml/theme 'atom-one-dark)
  (sml/setup))

(use-package evil
  :demand t
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package undo-tree
  :ensure t
  :after 'evil
  :config
  (global-undo-tree-mode)
  (evil-set-undo-system 'undo-tree))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(use-package rust-mode
  :ensure t
  :init
  (add-hook 'rust-mode-hook
	    (lambda () (setq indent-tabs-mode nil)))
  (setq rust-format-on-save t))

(use-package dap-mode
  :ensure t
  :config
  (setq dap-default-terminal-kind "integrated")
  (dap-auto-configure-mode +1))

(use-package dap-gdb-lldb
  :after dap-cpptools)

(use-package dap-cpptools
  :after dap-mode
  :config
  (dap-register-debug-template "Rust::Run"
			       (list :type "gdb"
				     :request "launch"
				     :name "Rust::Run"
				     :gdbpath "rust-gdb"
				     :target nil
				     :cwd nil)))
(use-package wgsl-mode
  :load-path "lisp/wgsl-mode"
  :config (add-to-list 'lsp-language-id-configuration '(wgsl-mode . "wgsl"))
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection "/home/jozef/.cargo/bin/wgsl_analyzer")
                    :activation-fn (lsp-activate-on "wgsl")
                    :server-id 'wgsl-analyzer)))


(use-package lua-mode
  :ensure t)

(use-package lsp-mode
  :ensure t
  :hook ((rust-mode . lsp)
		 (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  ;:config
  ;(setq lsp-rust-analyzer-cargo-watch-command "check")
  ;(setq lsp-rust-analyzer-display-inlay-hints t)
  ;(setq lsp-rust-analyzer-display-parameter-hints t)
  ;(setq lsp-rust-analyzer-display-lifetime-elision-hints-enable 'skip_trivial)
  ;(setq lsp-rust-analyzer-cargo-watch-args '("-D clippy::unwrap_used"
  ;				     "-W clippy::trivial_casts")))
)

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode))

(use-package clojure-mode
  :ensure t)

(use-package cider
  :ensure t)

(use-package racket-mode
  :ensure t)

(use-package js2-mode
  :ensure t)

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

(use-package web-mode
  :ensure t
  :demand t
  :config
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode)))

(use-package websocket
  :ensure t)

(use-package tide
  :ensure t
  :demand t
  :hook
  (typescript-mode-hook . setup-tide-mode)
  (before-save-hook . tide-format-before-save)
  (web-mode-hook . (lambda ()
					 (when (string-equal "tsx" (file-name-extension buffer-file-name))
					   (setup-tide-mode))))
  :config
  (setq company-tooltip-align-annotations t)
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
  (flycheck-add-mode 'typescript-tslint 'web-mode))

(use-package org
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((gnuplot . t)
     (emacs-lisp . t)
     (C . t)))
  (setq org-todo-keywords
	'((sequence "TODO" "IN-PROGRESS" "|" "DONE" "CANCELLED")))
  (setq org-hide-emphasis-markers t))

;; Tabline settings
(tab-bar-mode -1)
(setq tab-line-new-button-show nil)  ;; do not show add-new button
(setq tab-line-close-button-show nil)  ;; do not show close button

(use-package org-modern
  :ensure t
  :config
  (setq
   ;; Edit settings
   org-auto-align-tags nil
   org-tags-column 0
   org-catch-invisible-edits 'show-and-error
   org-special-ctrl-a/e t
   org-insert-heading-respect-content t

   ;; Org styling, hide markup etc.
   org-hide-emphasis-markers t
   org-pretty-entities t
   org-ellipsis "…"

   ;; Agenda styling
   org-agenda-tags-column 0
   org-agenda-block-separator ?─
   org-agenda-time-grid
   '((daily today require-timed)
     (800 1000 1200 1400 1600 1800 2000)
     " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
   org-agenda-current-time-string
   "⭠ now ─────────────────────────────────────────────────")
  (global-org-modern-mode))


(use-package evil-org
  :ensure t
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package org-roam
  :ensure t
  :custom (org-roam-directory "~/Documents/notes")
  :config (org-roam-db-autosync-mode))

(use-package org-roam-ui
  :ensure t)

(use-package org-element
  :after org)

(use-package vulpea
  :ensure t
  :demand t
  ;; hook into org-roam-db-autosync-mode you wish to enable
  ;; persistence of meta values (see respective section in README to
  ;; find out what meta means)
  :hook ((org-roam-db-autosync-mode . vulpea-db-autosync-enable)))

(defun vulpea-project-p ()
  "Return non-nil if current buffer has any todo entry.

TODO entries marked as done are ignored, meaning the this
function returns nil if current buffer contains only completed
tasks."
  (seq-find                                 ; (3)
   (lambda (type)
     (eq type 'todo))
   (org-element-map                         ; (2)
       (org-element-parse-buffer 'headline) ; (1)
       'headline
     (lambda (h)
       (org-element-property :todo-type h)))))

(defun vulpea-project-update-tag ()
    "Update PROJECT tag in the current buffer."
    (when (and (not (active-minibuffer-window))
               (vulpea-buffer-p))
      (save-excursion
        (goto-char (point-min))
        (let* ((tags (vulpea-buffer-tags-get))
               (original-tags tags))
          (if (vulpea-project-p)
              (setq tags (cons "project" tags))
            (setq tags (remove "project" tags)))

          ;; cleanup duplicates
          (setq tags (seq-uniq tags))

          ;; update tags if changed
          (when (or (seq-difference tags original-tags)
                    (seq-difference original-tags tags))
            (apply #'vulpea-buffer-tags-set tags))))))

(defun vulpea-buffer-p ()
  "Return non-nil if the currently visited buffer is a note."
  (and buffer-file-name
       (string-prefix-p
        (expand-file-name (file-name-as-directory org-roam-directory))
        (file-name-directory buffer-file-name))))

(defun vulpea-project-files ()
    "Return a list of note files containing 'project' tag." ;
    (seq-uniq
     (seq-map
      #'car
      (org-roam-db-query
       [:select [nodes:file]
        :from tags
        :left-join nodes
        :on (= tags:node-id nodes:id)
        :where (like tag (quote "%\"project\"%"))]))))

(defun vulpea-agenda-files-update (&rest _)
  "Update the value of `org-agenda-files'."
  (setq org-agenda-files (vulpea-project-files)))

(add-hook 'find-file-hook #'vulpea-project-update-tag)
(add-hook 'before-save-hook #'vulpea-project-update-tag)

(advice-add 'org-agenda :before #'vulpea-agenda-files-update)
(advice-add 'org-todo-list :before #'vulpea-agenda-files-update)

(use-package tex
  :ensure auctex
  :after org
  :config
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5)))

;; (use-package gnuplot
;;   :ensure t
;;   :after org)

(use-package gnuplot-mode
  :after gnuplot
  :ensure t
  :config

)



(require 'subr-x)
(defun org+-babel-after-execute ()
  "Redisplay inline images after executing source blocks with graphics results."
  (when-let ((info (org-babel-get-src-block-info t))
         (params (org-babel-process-params (nth 2 info)))
         (result-params (cdr (assq :result-params params)))
         ((member "graphics" result-params)))
    (org-display-inline-images)))

(add-hook 'org-babel-after-execute-hook #'org+-babel-after-execute)

(use-package org-pomodoro
  :ensure t)

(use-package pdf-tools
  :ensure t
  :config
  (pdf-loader-install)
  (setq pdf-view-display-size 'fit-height))

(use-package hydra
  :ensure t)

(use-package org-fc
  :load-path "~/src/org-fc/"
  :custom (org-fc-directories '("~/Documents/notes/"))
  :config
  (require 'org-fc-hydra))

(evil-define-minor-mode-key '(normal insert emacs) 'org-fc-review-flip-mode
  (kbd "RET") 'org-fc-review-flip
  (kbd "n") 'org-fc-review-flip
  (kbd "s") 'org-fc-review-suspend-card
  (kbd "q") 'org-fc-review-quit)

(evil-define-minor-mode-key '(normal insert emacs) 'org-fc-review-rate-mode
  (kbd "a") 'org-fc-review-rate-again
  (kbd "h") 'org-fc-review-rate-hard
  (kbd "g") 'org-fc-review-rate-good
  (kbd "e") 'org-fc-review-rate-easy
  (kbd "s") 'org-fc-review-suspend-card
  (kbd "q") 'org-fc-review-quit)

(evil-define-key 'normal 'global
  "ghnl" 'org-roam-buffer-toggle
  "ghnf" 'org-roam-node-find
  "ghni" 'org-roam-node-insert
  "gha" 'org-agenda
  "gho" 'helm-find-files)

(evil-define-key 'normal org-agenda
  "ghs" 'org-agenda-schedule)

(evil-define-key 'normal org-mode-map
  "ghlp" 'org-latex-preview
  "ghfcn" 'org-fc-type-normal-init
  "ghp" 'org-pomodoro
  "ghs" 'insert-org-image)

(use-package yasnippet
  :ensure t
  :config
  (setq yas-snippet-dirs '("~/.config/emacs/snippets/"))
  (yas-global-mode 1))

(use-package auth-source)

(use-package haskell-mode
  :ensure t
  :config
  (setq haskell-process-type 'stack-ghci))

(use-package omnisharp
  :ensure t
  :hook ((csharp-mode . omnisharp-mode)))

(use-package elfeed
  :ensure t
  :config
  (setq elfeed-feeds
	'(("https://news.ycombinator.com/rss" hacker)
	  ("https://www.reddit.com/r/emacs.rss" emacs)
	  ("http://yetanothermathprogrammingconsultant.blogspot.com/feeds/posts/default" programming)
	  ("https://www.reddit.com/r/programming.rss" programming))))

(use-package org-attach-screenshot
  :ensure t
  :config
  (setq org-attach-screenshot-command-line "~/.config/emacs/shell-scripts/screenshot %f")
  (setq org-attach-screenshot-dirfunction
	(lambda ()
	  (progn (cl-assert (buffer-file-name))
		 (concat (file-name-sans-extension (buffer-file-name))
			 "-att")))))

(defun get-newest-file-from-dir  (path)
      "Get latest file (including directory) in PATH."
      (car (directory-files path 'full nil #'file-newer-than-file-p)))

(defun insert-org-image ()
  "Moves image from Dropbox folder to ./media, inserting org-mode link"
  (interactive)
  (let* ((indir (expand-file-name "~/Documents/notes/images/"))
         (infile (get-newest-file-from-dir indir))
             (outdir (concat (file-name-directory (buffer-file-name)) "/media"))
             (outfile (expand-file-name (file-name-nondirectory infile) outdir)))
    (unless (file-directory-p outdir)
      (make-directory outdir t))
    (rename-file infile outfile)
    (insert (concat (concat "[[./media/" (file-name-nondirectory outfile)) "]]")))
  (newline)
  (newline)
  (org-redisplay-inline-images))

(use-package mu4e
  :ensure nil
  :config
    ;; This is set to 't' to avoid mail syncing issues when using mbsync
  (setq mu4e-change-filenames-when-moving t)

  ;; Refresh mail using isync every 10 minutes
  (setq mu4e-update-interval (* 10 60))
  (setq mu4e-get-mail-command "mbsync -a")
  (setq mu4e-maildir "~/Mail")

  
  
  (setq mu4e-drafts-folder "/[Gmail]/Drafts")
  (setq mu4e-sent-folder   "/[Gmail]/Sent Mail")
  (setq mu4e-refile-folder "/[Gmail]/All Mail")
  (setq mu4e-trash-folder  "/[Gmail]/Trash")

  (setq mu4e-maildir-shortcuts
		'((:maildir "/Inbox"    :key ?i)
		  (:maildir "/[Gmail]/Drafts" :key ?d)
		  (:maildir "/[Gmail]/Sent Mail" :key ?s)
		  (:maildir "/[Gmail]/Trash"     :key ?t)
		  (:maildir "/[Gmail]/Spam"     :key ?p)
		  (:maildir "/[Gmail]/All Mail"  :key ?a))))

(require 'smtpmail)
(setq message-send-mail-function 'smtpmail-send-it
	  smtpmail-stream-type 'starttls
	  smtpmail-default-smtp-server "smtp.gmail.com"
	  smtpmail-smtp-server "smtp.gmail.com"
	  smtpmail-smtp-service 587)

(setq
 user-mail-address "jabczunjozef@gmail.com"
 user-full-name  "Jozef Jabczun")

(setq ring-bell-function 'ignore)

(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

(show-paren-mode 1)
(setq show-paren-style 'parenthesis)
(setq show-paren-when-point-in-periphery t)
(setq show-paren-when-point-inside-paren t)

(eldoc-mode 1)

(global-display-line-numbers-mode)
(setq display-line-numbers-type 'relative)

(defun my-c-mode-common-hook ()
 ;; my customizations for all of c-mode, c++-mode, objc-mode, java-mode
 (c-set-offset 'substatement-open 0)
 ;; other customizations can go here

 ;(setq c++-tab-always-indent t)
 (setq c-basic-offset 4)                  ;; Default is 2
 (setq c-indent-level 4)                  ;; Default is 2

 (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
 (setq tab-width 4)
 (setq indent-tabs-mode t)  ; use spaces only if nil
 )

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

(use-package eimp)

(use-package sideframe)

(defun file-browser ()
  "Opens file browser"
  (interactive)
  (sideframe-make 'left 32 'dark))

(use-package magit
  :ensure t)

(setq backup-directory-alist '(("." . "~/.cache/emacs/backup/")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-minibuffer-history-key "M-p")
 '(package-selected-packages
   '(org-modern dap-cpptools org-roam-ui helm-R undo-tree lua-mode magit vulpea racket-mode org-attach-screenshot yasnippet org-pomodoro hydra org-fc pdf-tools org-babel org-babel-gnuplot gnuplot gnuplot-mode org-plot preview-latex auctex pinentry desktop-environment which-key web-mode use-package tide smartparens smart-mode-line-atom-one-dark-theme rust-mode org-roam one-themes omnisharp lsp-mode js2-mode helm haskell-mode exwm evil-org evil-collection elfeed company cider auto-package-update)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
