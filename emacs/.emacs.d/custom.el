;;; -*- lexical-binding: t -*-
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(gruvbox))
 '(custom-safe-themes
   '("d5fd482fcb0fe42e849caba275a01d4925e422963d1cd165565b31d3f4189c87"
     default))
 '(notmuch-saved-searches
   '((:name "unread" :query "tag:unread AND path:alpha/**" :key [117])
     (:name "flagged" :query "tag:flagged" :key [102])
     (:name "drafts" :query "tag:draft" :key [100])
     (:name "all mail" :query "*" :key [97])
     (:name "cgit" :query "to:cgit@lists.zx2c4.com")
     (:name "opensmtpd" :query "to:misc@opensmtpd.org")
     (:name "sent" :query
            "(from:hskim@dilluti0n.com OR from:hskimse1@gmail.com) AND NOT tag:draft"
            :key [115])
     (:name "inbox" :query "path:alpha/INBOX/** AND NOT tag:deleted"
            :key [105])))
 '(package-selected-packages
   '(async bash-completion cape company consult corfu crux eglot-booster
           elfeed forge fussy fzf fzf-native ghostel gptel
           gruvbox-theme kdl-mode keycast marginalia orderless ox-hugo
           rg solidity-mode undo-tree vertico))
 '(package-vc-selected-packages
   '((fzf-native :vc-backend Git :url
                 "https://github.com/dangduc/fzf-native.git")
     (eglot-booster :vc-backend Git :url
                    "https://github.com/jdtsmith/eglot-booster.git")))
 '(safe-local-variable-values
   '((eval defun hugo/run-server nil (interactive)
           (async-shell-command "hugo server -D" "*hugo-server*"))))
 '(user-full-name "Hee-Suk Kim")
 '(user-mail-address "hskimse1@gmail.com"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
