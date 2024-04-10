;; [appearence]
;; startup
(setq inhibit-startup-screen t)
(setq backup-directory-alist '(("." . "~/.emacs_saves")))
(setq select-enable-clipboard t)
(setq split-width-threshold nil)
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(ido-mode 1)
;; font
(defun m/get-default-font ()
  (cond
   ((eq system-type 'darwin) "Menlo-18")
   ((eq system-type 'gnu/linux) "iosevka-20")))
(add-to-list 'default-frame-alist `(font . ,(m/get-default-font)))
(setq-default line-spacing 2)
;; line-number
(add-hook 'prog-mode-hook (lambda () (display-line-numbers-mode)))
(add-hook 'dired-mode-hook (lambda () (display-line-numbers-mode)))
(setq-default display-line-numbers-type 'relative)
;; column-indicater (ruler)
(add-hook 'prog-mode-hook (lambda () (display-fill-column-indicator-mode)))
(setq-default display-fill-column-indicator-column 81)
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

;; Dired-mode
(require 'dired)
(defun dired-do-local-command ()
  "Do local command on remote connection"
  (interactive)
  (let* ((marked-files (dired-get-marked-files nil current-prefix-arg))
         (local-tmp-files (mapcar #'file-local-copy marked-files))
         (num-files (length local-tmp-files))
         (default-directory temporary-file-directory)
         (command (dired-read-shell-command "! on %s: " num-files marked-files)))
    (dired-do-shell-command command num-files local-tmp-files)))
(define-key dired-mode-map (kbd "\"") 'dired-do-local-command)

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

(load "~/.emacs.d/pack/eglot.el")
;; (load "~/.emacs.d/pack/lsp-mode.el")
