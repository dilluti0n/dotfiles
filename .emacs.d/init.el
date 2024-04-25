;; [appearence]
;; startup
(setq inhibit-startup-screen t
      backup-directory-alist '(("." . "~/.emacs_saves"))
      select-enable-clipboard t
      split-width-threshold nil
      )

;; load custom ... stuffs on custom.el instead of init.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

(defun m/set-buffer-pop-height (buffer-name height)
  (add-to-list 'display-buffer-alist
               `(,buffer-name
                 (display-buffer-in-side-window)
                 `(window-height . ,height)
                 (side . bottom))))

(m/set-buffer-pop-height "\\*xref\\*" 0.3)
(m/set-buffer-pop-height "\\*eldoc\\*" 0.3)
(m/set-buffer-pop-height "\\*magit*\\*" 0.3)
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
;; (ido-mode 1)
;; transparancy
(defun t/alpha-init ()
  (set-frame-parameter nil 'alpha-background 90)
  (add-to-list 'default-frame-alist '(alpha-background . 90))
  )
(if (eq system-type 'gnu/linux) (t/alpha-init))
(defun set-alpha (value)
  "Sets the transparency of the frame window. 0=transparent/100=opaque"
  (interactive "nTransparency Value 0 - 100 opaque:")
  (set-frame-parameter (selected-frame) 'alpha-background value))

;; font
(defun m/get-default-font ()
  (cond
   ((eq system-type 'darwin) "Menlo-16")
   ((eq system-type 'gnu/linux) "iosevka-12")))
(add-to-list 'default-frame-alist `(font . ,(m/get-default-font)))
(setq-default line-spacing 2)
;; line-number
(add-hook 'prog-mode-hook (lambda () (display-line-numbers-mode)))
(add-hook 'dired-mode-hook (lambda () (display-line-numbers-mode)))
(setq-default display-line-numbers-type 'relative)
;; column-indicater (ruler)
;; (add-hook 'prog-mode-hook (lambda () (display-fill-column-indicator-mode)))
;; (setq-default display-fill-column-indicator-column 81)
(setq column-number-mode 1)
;; show useless whitespace
(add-hook 'prog-mode-hook (lambda ()
                            (setq-default show-trailing-whitespace t)))

;; [tabs, indents, prog-mode]
(setq-default tab-width 8
	      indent-tabs-mode nil)
(treesit-available-p)
(add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
(add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
(add-to-list 'major-mode-remap-alist
             '(c-or-c++-mode . c-or-c++-ts-mode))
(setq c-default-style "k&r"
      c-basic-offset 4)

;; [packages]
(require 'package)
(add-to-list 'package-archives
             '("gnu" . "https://elpa.gnu.org/") t)
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

;; (use-package gruber-darker-theme
;;   :ensure t
;;   :config
;;   (load-theme 'gruber-darker t))

(use-package zenburn-theme
  :ensure t
  :config
  (load-theme 'zenburn t))

(use-package ivy
  :ensure t
  :config
  (ivy-mode 1))

(use-package swiper
  :ensure t
  :after ivy)

(use-package counsel
  :ensure t
  :config
  (counsel-mode 1))

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;; (load-theme 'BBEdit-Light t)

(load "~/.emacs.d/pack/eglot.el")
;; (load "~/.emacs.d/pack/lsp-mode.el")
