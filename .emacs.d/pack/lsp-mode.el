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
