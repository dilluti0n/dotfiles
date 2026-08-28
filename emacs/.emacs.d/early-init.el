(defun add-path (name)
  (setenv "PATH" (concat (concat (getenv "PATH") ":") name))
  (setq exec-path (append exec-path (list name))))

(when (eq system-type 'darwin)
  (add-path "/usr/local/bin"))

(defun load-if-exists (file-name)
  "load file if exists"
  (if (file-exists-p file-name) (load file-name)))

(setq gc-cons-threshold (* 32 1024 1024))

(add-path (concat (getenv "HOME") "/.cargo/bin"))

;; sensitive keys
(load-if-exists (expand-file-name "env.el" user-emacs-directory))

;; Disable ime
(setenv "XMODIFIERS" "@im=none")
(setenv "GTK_IM_MODULE" "gtk-im-context-simple")
