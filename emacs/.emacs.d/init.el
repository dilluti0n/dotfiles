(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(setq inhibit-startup-screen t
      vc-follow-symlinks t
      backup-directory-alist `(("." . ,(concat user-emacs-directory "backups")))
      default-input-method "korean-hangul"
      ring-bell-function 'ignore
      split-width-threshold 130)

(global-set-key (kbd "S-SPC") 'toggle-input-method)

(set-fontset-font t 'hangul
                  (font-spec :family "Noto Sans CJK KR"))

(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(tab-bar-mode 0)
(column-number-mode t)
(recentf-mode 1)
(save-place-mode 1)
(setq history-length 25)
(savehist-mode 1)
(add-to-list 'default-frame-alist '(font . "Cascadia Code-12"))

;; tab is 8 spaces !!!!
(setq tab-width 8)

(setq-default show-trailing-whitespace nil)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; tramp
(setq remote-file-name-inhibit-cache nil
      tramp-verbose 1
      tramp-use-ssh-controlmaster-options nil)

;; default hooks
(add-hook 'prog-mode-hook
	  (lambda ()
	    (display-line-numbers-mode t)
	    (setq-local indent-tabs-mode (memq major-mode
					       '(c-mode c-ts-mode c++-mode c++-ts-mode)))))

(global-set-key (kbd "C-x c c") 'compile)
(global-set-key (kbd "C-x c r") 'recompile)

;; tree-sitter
(require 'treesit)
(dolist (grammar
	 '((css . ("https://github.com/tree-sitter/tree-sitter-css" "v0.20.0"))
	   (bash . ("https://github.com/tree-sitter/tree-sitter-bash" "v0.23.3"))
	   (html . ("https://github.com/tree-sitter/tree-sitter-html" "v0.20.1"))
	   (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript" "v0.21.2" "src"))
	   (json . ("https://github.com/tree-sitter/tree-sitter-json" "v0.20.2"))
	   (python . ("https://github.com/tree-sitter/tree-sitter-python" "v0.20.4"))
	   (go . ("https://github.com/tree-sitter/tree-sitter-go" "v0.20.0"))
	   (gomod . ("https://github.com/camdencheek/tree-sitter-go-mod"))
	   (markdown . ("https://github.com/ikatyang/tree-sitter-markdown"))
	   (make . ("https://github.com/alemuller/tree-sitter-make"))
	   (elisp . ("https://github.com/Wilfred/tree-sitter-elisp"))
	   (cmake . ("https://github.com/uyha/tree-sitter-cmake"))
	   (c . ("https://github.com/tree-sitter/tree-sitter-c" "v0.23.6"))
	   (cpp . ("https://github.com/tree-sitter/tree-sitter-cpp"))
	   (toml . ("https://github.com/tree-sitter/tree-sitter-toml"))
	   (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "tsx/src"))
	   (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "typescript/src"))
	   (yaml . ("https://github.com/ikatyang/tree-sitter-yaml" "v0.5.0"))
	   (prisma . ("https://github.com/victorhqc/tree-sitter-prisma"))
	   (rust . ("https://github.com/tree-sitter/tree-sitter-rust" "v0.23.3"))))
  (add-to-list 'treesit-language-source-alist grammar))

(defun install-treesit-grammars ()
  (dolist (grammar treesit-language-source-alist)
    (treesit-install-language-grammar (car grammar))))

(dolist (mapping
	 '(
	   ("\\.ts\\'" . typescript-ts-mode)
	   ("\\.js\\'" . js-ts-mode)
	   ("\\.json\\'" . json-ts-mode)
	   ("\\.go\\'" . go-ts-mode)
	   ("\\.rs\\'" . rust-ts-mode)
           ("\\.yml\\'" . yaml-ts-mode)
           ("\\.yaml\\'" . yaml-ts-mode)
           )
         )
  (add-to-list 'auto-mode-alist mapping))

(dolist (mapping
	 '((python-mode . python-ts-mode)
	   (css-mode . css-ts-mode)
	   (typescript-mode . typescript-ts-mode)
	   ;; (js-mode . typescript-ts-mode)
	   ;; (js2-mode . typescript-ts-mode)
	   (c-mode . c-ts-mode)
	   (c++-mode . c++-ts-mode)
	   (c-or-c++-mode . c-or-c++-ts-mode)
	   (bash-mode . bash-ts-mode)
	   (json-mode . json-ts-mode)
	   (js-json-mode . json-ts-mode)
	   (sh-mode . bash-ts-mode)
	   (sh-base-mode . bash-ts-mode)))
  (add-to-list 'major-mode-remap-alist mapping))

;; cc-mode c-ts-mode c++-ts-mode
(setq-default c-basic-offset tab-width
	      c-default-style '((awk-mode . "awk")
				(other . "linux"))
	      c-ts-mode-indent-style 'linux)
(setq-default c-ts-mode-indent-offset c-basic-offset)

(dolist (hook '(c-ts-mode-hook c++-ts-mode-hook))
  (add-hook hook #'subword-mode))

;; compile
(with-eval-after-load 'compile
  (add-to-list 'compilation-error-regexp-alist-alist
               '(rustc-arrow
                 "^\\s-*--> \\([^:\n]+\\):\\([0-9]+\\):\\([0-9]+\\)"
                 1 2 3))
  (add-to-list 'compilation-error-regexp-alist 'rustc-arrow))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(defun package-install-if-not (package)
  "If PACKAGE is installed, return t. If not, try to `package-install' it
and return t if it is installed successfully. Else, return nil."
  (if (package-installed-p package)
      t
    (progn
      (unless package-archive-contents
	(package-refresh-contents))
      (package-install package)
      (package-installed-p package))))

(defun ensure-require (package &optional feature)
  "`require' FEATURE (or PACKAGE) if available, install if needed.
Return non-nil if successful, nil otherwise."
  (let ((feat (or feature package)))
    (if (require feat nil t)
	t
      (progn
	(package-install-if-not package)
	(require feat)))))

;; project.el
(with-eval-after-load 'project
  (add-to-list 'project-vc-extra-root-markers ".project-root"))

(ensure-require 'magit)

;;
;; eglot settings (with eglot-booster)
;;
(ensure-require 'eglot)
(define-key eglot-mode-map (kbd "C-c r") 'eglot-rename)
(define-key eglot-mode-map (kbd "C-c o") 'eglot-code-action-organize-imports)
(define-key eglot-mode-map (kbd "C-c h") 'eldoc)
(define-key flymake-mode-map (kbd "M-n") 'flymake-goto-next-error)
(define-key flymake-mode-map (kbd "M-p") 'flymake-goto-prev-error)
(define-key flymake-mode-map (kbd "C-x c b") 'flymake-show-buffer-diagnostics)
(setq eglot-ignored-server-capabilities '(:documentOnTypeFormattingProvider)
      eglot-events-buffer-config '(:size 0 :format full))
(setq eldoc-echo-area-use-multiline-p nil)

;; clangd
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               `((c-mode c-ts-mode c++-mode c++-ts-mode)
                 . ("clangd"
                    "--background-index"
                    "--clang-tidy=false"
                    "--header-insertion=never"
                    "--completion-style=detailed"
                    "--pch-storage=memory"
                    "-j=4"))))

;; rust-analyzer
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((rust-ts-mode rust-mode) . ("rust-analyzer")))

  (setq-default eglot-workspace-configuration
                '(:rust-analyzer
                  (:checkOnSave (:enable t
                                 :command "clippy"
                                 :extraArgs ["--target-dir" "target/analyzer"])
                   :cargo (:buildScripts (:enable t)
                           :features "all")
                   :procMacro (:enable t)
                   :completion (:autoimport (:enable t)
                                :postfix (:enable t))
                   :inlayHints (:bindingModeHints (:enable t)
                                :closureReturnTypeHints (:enable "always")
                                :parameterHints (:enable t))
                   :diagnostics (:experimental (:enable t))))))

(unless (package-installed-p 'eglot-booster)
  (package-vc-install "https://github.com/jdtsmith/eglot-booster.git"))
(with-demoted-errors "Eglot-booster error: %S"
  (require 'eglot-booster)
  (eglot-booster-mode))                 ;This is fail when emacs-lsp-booster executable is not available

;;
;; completion settings (completion <- fussy with fzf-native backend <- orderless)
;;
(ensure-require 'orderless)
(setq completion-category-overrides
      '((file (styles partial-completion))
        (consult-grep (styles orderless))
        (consult-fd (styles orderless)))
      completion-category-defaults nil ;; Disable defaults, use our settings
      ;; Emacs 31: partial-completion behaves like substring
      completion-pcm-leading-wildcard t)

(ensure-require 'fussy)
(fussy-setup)
(setq fussy-filter-default-styles '(orderless)) ;; complation-style -> fussy -> orderless
(fussy-company-setup)
(fussy-eglot-setup)

;; set fzf-native for fussy backend
;; TODO: use package-vc-install
(unless (package-installed-p 'fzf-native)
  (package-vc-install "https://github.com/dangduc/fzf-native.git"))
(require 'fzf-native)
(setq fzf-native-always-compile-module t)
(setq fussy-score-fn 'fussy-fzf-native-score)
(fzf-native-load-dyn)

;; Prompt indicator for `completing-read-multiple'.
(when (< emacs-major-version 31)
  (advice-add #'completing-read-multiple :filter-args
	      (lambda (args)
		(cons (format "[CRM%s] %s"
			      (string-replace "[ \t]*" "" crm-separator)
			      (car args))
		      (cdr args)))))

;;
;; completion frontends (vertico, company)
;;
(ensure-require 'vertico)
(vertico-mode)
(setq enable-recursive-minibuffers t
      minibuffer-prompt-properties '(read-only t cursor-intangible t face minibuffer-prompt))
(setq minibuffer-default-prompt-format " [%s]")

(ensure-require 'marginalia)
(marginalia-mode)

(ensure-require 'consult)
;; (keymap-global-set "C-x b" 'consult-buffer)
(keymap-global-set "C-c C-s" 'consult-grep)

(ensure-require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(setq company-minimum-prefix-length 1
      company-idle-delay 0
      company-show-numbers nil
      company-tooltip-align-annotations nil
      company-require-match 'never)
;;
;; Mail (mu4e with mbsync, msmtp)
;;
(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")
(require 'mu4e)

(setq mu4e-maildir "~/Mail"
      mu4e-get-mail-command "mbsync alpha"
      mu4e-update-interval nil
      mu4e-change-filenames-when-moving t) ;; mbsync

(setq mu4e-contexts
      (list
       (make-mu4e-context
        :name "alpha"
        :match-func
        (lambda (msg)
          (when msg
            (string-prefix-p "/alpha" (mu4e-message-field msg :maildir))))
        :vars '((user-mail-address      . "hskim@dilluti0n.com")
                (user-full-name         . "Hee-Suk Kim")
                (mu4e-sent-folder       . "/alpha/Sent")
                (mu4e-drafts-folder     . "/alpha/Drafts")
                (mu4e-trash-folder      . "/alpha/Trash")
                (mu4e-refile-folder     . "/alpha/Archive")
                (mu4e-sent-messages-behavior . sent)))))

(setq mu4e-context-policy 'pick-first
      mu4e-compose-context-policy 'pick-first)

(setq mail-user-agent 'mu4e-user-agent
      message-mail-user-agent 'mu4e-user-agent
      read-mail-command 'mu4e)

(setq mu4e-bookmarks
      '((:name "unread" :query "flag:unread AND NOT flag:trashed" :key ?u)
        (:name "cgit" :query "to:cgit@lists.zx2c4.com" :key ?c)
        (:name "opensmtpd" :query "to:misc@opensmtpd.org" :key ?o)
        (:name "gnupg-devel" :query "to:gnupg-devel@gnupg.org" :key ?p)
        (:name "bitcoin-dev" :query "to:bitcoindev@googlegroups.com" :key ?b)))

(add-to-list 'load-path "/usr/share/emacs/site-lisp/notmuch")
(require 'notmuch)
(setq notmuch-fcc-dirs "alpha/Sent"
      notmuch-draft-folder "alpha/Drafts")
(setq-default notmuch-search-oldest-first nil)

;; msmtp
(setq send-mail-function 'sendmail-send-it
      message-send-mail-function 'sendmail-send-it
      sendmail-program (executable-find "msmtp")
      mail-specify-envelope-from t
      message-sendmail-envelope-from 'header
      mail-envelope-from 'header
      mml-enable-flowed nil
      mml-secure-openpgp-sign-with-sender t)

(add-hook 'message-setup-hook 'mml-secure-message-sign-pgpmime)

;;
;; irc
;;
(ensure-require 'erc)
(ensure-require 'erc-services)

(add-to-list 'erc-modules 'sasl 'autojoin)
(erc-update-modules)

(defun start-erc ()
  (interactive)
  (let ((erc-sasl-mechanism 'plain)
        (erc-sasl-user "dilluti0n")
        (erc-sasl-password (auth-source-pass-get 'secret "hskim/irc.libera.chat"))
        (erc-autojoin-timing 'ident)
        (erc-autojoin-delay 3)
        (erc-autojoin-channels-alist '(("#gentoo"
                                        "#gentoo-guru"
                                        "#libssh"
                                        "#bitcoin"
                                        "#bitcoin-core-dev"
                                        "#emacs"
                                        "#plan9"
                                        "##math"))))

      (erc-tls :server "irc.libera.chat" :port 6697
           :nick "dilluti0n"
           :user "dilluti0n"))
  )

;;
;; miscellaneous
;;
(ensure-require 'undo-tree)
(global-undo-tree-mode)
(setq undo-tree-history-directory-alist `(("." . ,(concat user-emacs-directory "undo"))))

(ensure-require 'which-key)
(which-key-mode)

(ensure-require 'crux)

(ensure-require 'rg)
(rg-enable-default-bindings)

(ensure-require 'fzf)

(ensure-require 'which-func)
(which-function-mode +1)

(with-eval-after-load 'kdl-mode
    (defun kdl-indent-line-4 () (kdl-indent-line 4)))

(add-hook 'kdl-mode-hook
          (lambda ()
            (setq-local indent-line-function #'kdl-indent-line-4)))

(ensure-require 'ghostel)
(keymap-global-set "C-x m" 'ghostel)

;;
;; org-mode
;;
(package-install-if-not 'ox-hugo)
(with-eval-after-load 'ox
  (require 'ox-hugo))

(ensure-require 'org)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

(setq org-directory "/mnt/nas/org/"
      org-agenda-files '("/mnt/nas/org/inbox.org" "/mnt/nas/org/todo.org")
      org-agenda-format-date "%Y-%m-%d %a"
      org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELLED(c@)"))
      org-log-done 'time
      org-refile-targets '(("/mnt/nas/org/todo.org" :maxlevel . 2))
      org-capture-templates
      '(("t" "Todo" entry (file "/mnt/nas/org/inbox.org")
         "* TODO %?\n  %U\n  %a")))

;;
;; auctex
;;
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

;;
;; elfeed
;;
(ensure-require 'elfeed)
(setq elfeed-feeds
      '("https://ykiko.me/en/articles/index.xml"
        "https://annas-archive.pk/blog/rss.xml"
        "https://dilluti0n.com/p/feed.xml"
        "https://l.changeme.fr.eu.org/feed.rss"))

;; end of package

;; custom functions
;; alpha
(setq-default m/default-alpha 90)
(add-to-list 'default-frame-alist '(alpha-background . 100))

(defun alpha-set (value)
  "Sets the transparency of the frame window. 0=transparent/100=opaque"
  (interactive "nvalue: ")
  (set-frame-parameter nil 'alpha-background value))

(defun alpha-toggle ()
  "Toggles the transparency between opaque and current value"
  (interactive)
  (if (= (frame-parameter nil 'alpha-background) 100)
      (alpha-set m/default-alpha)
    (progn
      (setq m/default-alpha (frame-parameter nil 'alpha-background))
      (alpha-set 100))))

(global-set-key "\C-x\C-a" 'alpha-toggle)

;; terminal
(defun open-st-in-workdir ()
  (interactive)
  (call-process-shell-command
   (concat "setsid st -c bash -i -c cd " (expand-file-name default-directory)) nil 0))
(global-set-key (kbd "C-x c t") 'open-st-in-workdir)

;; copy pwd to kill ring
(defun copy-pwd-to-kill-ring ()
  "Copy the current buffer's default directory (PWD) to the kill ring."
  (interactive)
  (let ((pwd (expand-file-name default-directory)))
    (kill-new pwd)
    (message "Copied PWD to kill ring: %s" pwd)))
(global-set-key (kbd "C-x c p") 'copy-pwd-to-kill-ring)

;; tex-mode
(defun tex-render ()
  (interactive)
    (progn
      (tex-buffer)
      (print tex-directory)
      (print tex-zap-file)
      (let* ((tex-render-output-name (expand-file-name (concat tex-zap-file ".dvi") tex-directory))
	     (tex-render-output-buffer (get-file-buffer tex-render-output-name)))
	(progn
	  (print tex-render-output-name)
	  (if tex-render-output-buffer
	      (kill-buffer tex-render-output-buffer))
	  (find-file-other-window tex-render-output-name)))))

(defun yank-file-contents-to-kill-ring (filename)
  "Read contents of FILENAME and add to kill-ring."
  (interactive "fFile to yank: ")
  (with-temp-buffer
    (insert-file-contents filename)
    (kill-new (buffer-string))
    (message "File contents added to kill-ring.")))

(defun project-whitespace-cleanup-project-files ()
  "Run `whitespace-cleanup' on all project files using project.el."
  (interactive)
  (let ((project (project-current)))
    (when project
      (dolist (file (project-files project))
	(let ((path (expand-file-name file (project-root project))))
	  (when (file-exists-p path)
	    (with-current-buffer (find-file-noselect path)
	      (whitespace-cleanup)
	      (save-buffer)
	      (kill-buffer))))))))

;;; opposite of fill-paragraph
(defun unfill-paragraph ()
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

(define-key global-map "\M-Q" 'unfill-paragraph)

(defun rename-this-file (newname &optional ok-if-already-exists)
  "Rename currently visiting file"
  (interactive "FNew name: ")
  (let ((oldname (buffer-file-name)))
    (if (not oldname)
	(error "Buffer is not visiting a file")
      (rename-file oldname newname ok-if-already-exists)
      (set-visited-file-name newname))))

(defun fcd (&optional dir)
  "alias fcd='cd $(fd --type=directory --exclude='.git' -H |fzf)'"
  (interactive "DBase directory: ")
  (let* ((dir (or dir default-directory))
	 (cmd (format "fd --type=directory --exclude=.git -H . %s"
		      (shell-quote-argument
		       (file-name-as-directory (expand-file-name dir))))))
    (fzf-with-command cmd #'dired)))

(global-set-key (kbd "C-x C-d") (lambda () (interactive) (fcd "~")))

;;
;; sib!
;;

(defun sib--append-process-filter (process output)
  ;; Append process output to the end of the process buffer.
  (let ((buf (process-buffer process)))
    (when (buffer-live-p buf)
      (with-current-buffer buf
        (goto-char (point-max))
        (insert output)))))

(defun sib--sentinel (process _event)
  ;; Run sib-update-log only after a successful sib process exit.
  (when (eq (process-status process) 'exit)
    (let ((exit-status (process-exit-status process)))
      (if (= exit-status 0)
          (progn
            (message "sib finished successfully")
            (sib--update-log))
        (message "sib failed with exit status %d" exit-status)))))

(defun sib-ask (&optional prefix)
  (interactive "P")
  (require 'markdown-mode)

  (let* ((input (when (use-region-p)
                  (filter-buffer-substring
                   (region-beginning) (region-end))))
         (command (read-shell-command "Command: " "sib ask"))
         (buf (get-buffer-create "*sib*"))
         (err (get-buffer-create "*sib-error*"))
         (process-name (format "sib-%s" (make-temp-name ""))))

    ;; Keep existing contents and append new output at the end.
    (with-current-buffer buf
      (markdown-mode)
      (font-lock-ensure)
      (goto-char (point-max))
      (insert "\n\n---\n\n"))

    ;; Keep existing error output as well.
    (with-current-buffer err (goto-char (point-max)))

    (let ((process
           (make-process
            :name process-name
            :buffer buf
            :stderr err
            :command (list shell-file-name shell-command-switch command)
            :connection-type 'pipe
            :noquery t
            :filter #'sib--append-process-filter
            :sentinel #'sib--sentinel)))

      ;; Send the selected region to stdin if it has
      (when input (process-send-string process input))

      ;; Close stdin so the command can finish.
      (process-send-eof process))

    (pop-to-buffer buf)))

(defun sib--update-log ()
  (require 'markdown-mode)

  ;; Kill the previous log process, if any.
  (when-let ((old-buf (get-buffer "*sib-log*")))
    (when-let ((old-process (get-buffer-process old-buf)))
      (delete-process old-process))

    ;; Delete the previous log buffer completely.
    (with-current-buffer old-buf
      (set-buffer-modified-p nil))
    (kill-buffer old-buf))

  (let ((buf (get-buffer-create "*sib-log*"))
        (err (get-buffer-create "*sib-error*"))
        (process-name
         (format "sib-log-%s" (make-temp-name ""))))

    ;; Prepare the newly created log buffer.
    (with-current-buffer buf
      (markdown-mode)
      (font-lock-ensure)
      (goto-char (point-max)))

    (with-current-buffer err
      (goto-char (point-max)))

    ;; Run sib log asynchronously without async-shell-command.
    (make-process
     :name process-name
     :buffer buf
     :stderr err
     :command (list shell-file-name
                    shell-command-switch
                    "sib log")
     :connection-type 'pipe
     :noquery t
     :filter #'sib--append-process-filter
     :sentinel
     (lambda (process _event)
       (when (eq (process-status process) 'exit)
         (if (= (process-exit-status process) 0)
             (message "sib log: finished")
           (message "sib log: failed with exit status %d"
                    (process-exit-status process))))))))

(defun sib-log ()
  (interactive)
  (sib--update-log)
  (pop-to-buffer "*sib-log*"))

(defun sib-shutdown ()
  (interactive)
  (kill-buffer "*sib*")
  (kill-buffer "*sib-log*")
  (kill-buffer "*sib-error*"))


;; end of custom functions

;; native compile init.el

;; global keymaps
;; (global-set-key (kbd "C-x c v") 'vterm-other-window)

;; custom.el
(load-if-exists custom-file)
(put 'dired-find-alternate-file 'disabled nil)

(require 'server)
(unless (server-running-p)
  (server-start))
