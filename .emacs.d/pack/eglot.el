(use-package eglot
  :ensure t
  :hook ((c-mode c-ts-mode c++-ts-mode c++-mode) . eglot-ensure)
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

(use-package yasnippet
  :ensure t
  :hook
  (prog-mode . yas-global-mode)
  )

(use-package company
  :ensure t
  :hook (prog-mode . company-mode)
  )
