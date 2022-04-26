(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
	  (package-install 'use-package))

(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'custom-theme-load-path (expand-file-name "~/.emacs.d/themes/"))

(use-package auto-package-update
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

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
  (require 'rust-mode))

(use-package lsp-mode
  :ensure t
  :hook ((rust-mode . lsp)
		 (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode))

(use-package clojure-mode
  :ensure t)

(use-package cider
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
  (setq org-hide-emphasis-markers t))

(use-package evil-org
  :ensure t
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package org-roam
  :ensure t
  :custom (org-roam-directory "~/Documents/Roam")
  :config (org-roam-setup))

(evil-define-key 'normal 'global
  "ghnl" 'org-roam-buffer-toggle
  "ghnf" 'org-roam-node-find
  "ghni" 'org-roam-node-insert)

(evil-define-key 'normal org-mode-map
  "ghlp" 'org-latex-preview)

(use-package auth-source)

(use-package word-count
  :ensure nil)

(use-package haskell-mode
  :ensure t)

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
  (setq mu4e-sent-folder   "/[Gmail]/Sent")
  (setq mu4e-refile-folder "/[Gmail]/All Mail")
  (setq mu4e-trash-folder  "/[Gmail]/Trash")

  (setq mu4e-maildir-shortcuts
		'((:maildir "/Inbox"    :key ?i)
		  (:maildir "/[Gmail]/Drafts" :key ?d)
		  (:maildir "/[Gmail]/Sent" :key ?s)
		  (:maildir "/[Gmail]/Trash"     :key ?t)
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

(setq c-default-style '((c-mode . "linux")))
(add-hook 'c-mode-hook (lambda ()
			 (setq indent-tabs-mode t)
			 (setq tab-width 4)
			 (setq c-basic-offset 4)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-minibuffer-history-key "M-p")
 '(package-selected-packages
   '(omnisharp elfeed web-mode tide haskell-mode smart-mode-line-atom-one-dark-theme atom-one-dark-theme org-roam evil-collection which-key use-package smartparens rust-mode nord-theme lsp-mode helm flycheck evil-org company)))
 '(package-selected-packages '(smartparens which-key helm company use-package))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
