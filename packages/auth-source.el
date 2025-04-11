;;; packages/auth-source.el --- Authentication configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Configuration for authentication sources and user identity.

;;; Code:

(use-package auth-source
  :ensure nil
  :defer t
  :config
  (setq auth-sources
        (list (expand-file-name ".authinfo.gpg" user-emacs-directory)))
  (setq user-full-name "Rahul Martim Juliato"
        user-mail-address "rahul.juliato@gmail.com")

  ;; Use `pass` as an auth-source
  (when (file-exists-p "~/.password-store")
    (auth-source-pass-enable)))
;;; auth-source.el ends here