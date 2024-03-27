;; [appearence]
(setq inhibit-startup-screen t)
(setq backup-directory-alist '(("." . "~/.emacs_saves")))
(setq select-enable-clipboard t)
(setq split-width-threshold nil)
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(ido-mode 1)
(defun m/get-default-font ()
  (cond
   ((eq system-type 'darwin) "Menlo-18")
   ((eq system-type 'gnu/linux) "iosevka-20")))
(add-to-list 'default-frame-alist `(font . ,(m/get-default-font)))
(setq-default line-spacing 2)
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)
(setq column-number-mode 1)

;; [tabs, indents]
(setq-default tab-width 8
	      indent-tabs-mode nil)
(setq c-default-style "k&r"
      c-basic-offset 4)

;; [packages]
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
;; Refresh package descriptions
(unless package-archive-contents
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(use-package magit
  :ensure t)

(use-package highlight-numbers
  :ensure t)

(use-package gruber-darker-theme
  :ensure t
  :config
  (load-theme 'gruber-darker t))

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;; (load-theme 'BBEdit-Light t)

(use-package eglot
  :ensure t
  :hook ((c-mode c++-mode) . eglot-ensure)
  :config
  (setq eglot-shutdown t)
  ;; eldoc
  (setq eldoc-echo-area-use-multiline-p nil)
  (setq eldoc-idle-delay 0.1)
  ;; keymap
  (define-key eglot-mode-map (kbd "C-c r") 'eglot-rename)
  (define-key eglot-mode-map (kbd "C-c o") 'eglot-code-action-organize-imports)
  (define-key eglot-mode-map (kbd "C-c h") 'eldoc)
  (define-key eglot-mode-map (kbd "<f6>" ) 'xref-find-definitions)
  ;; optimization
  (setq eglot-events-buffer-size 0)
  (setq read-process-output-max (* 1024 1024))
  (setq gc-cons-threshold 100000000)
  )

(use-package flymake
  :config
  (define-key flymake-mode-map (kbd "M-n") 'flymake-goto-next-error)
  (define-key flymake-mode-map (kbd "M-p") 'flymake-goto-prev-error)
  )

(use-package flycheck-eglot
  :ensure t
  :after (flycheck)
  :custom (flycheck-eglot-exclusive nil)
  :config (flycheck-eglot-mode 1))

;; (use-package yasnippet
;;   :ensure t
;;   :hook
;;   (prog-mode . yas-global-mode)
;;   )

(use-package lsp-mode
  :ensure t
  :requires (lsp-ui)
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook
  (c-mode . (lambda () (unless (file-remote-p default-directory)
                         (lsp-deferred))))
  (lsp-mode . lsp-ui-mode)
  ;; (lsp-mode . lsp-enable-which-key-integration)
  :commands (lsp lsp-deferred)
  :config
  ;; Do not draw header line
  (setq lsp-headerline-breadcrumb-enable nil)
  ;; Optimization
  (setq read-process-output-max (* 1024 1024))
  (setq lsp-use-plists t)
  (setq lsp-log-io nil)
  (setq gc-cons-threshold 100000000)
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection "clangd")
    :major-modes '(c-mode c++-mode)
    :remote? nil
    :server-id 'clangd))
  )

(use-package lsp-ui
  :ensure t
  :custom
  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-show-diagnostics nil)
  (lsp-ui-sideline-delay 0.1)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-sideline-update-mode t)
  )

(use-package flycheck
  :ensure t)

(use-package highlight-numbers-mode
  :hook (prog-mode . highlight-numbers-mode))

(use-package company
  :ensure t
  :hook (prog-mode . company-mode)
  )
