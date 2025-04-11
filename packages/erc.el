;;; packages/erc.el --- ERC IRC client configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for the ERC IRC client.

;;; Code:

(use-package erc
  :ensure nil
  :defer t
  :custom
  (erc-join-buffer 'window)
  (erc-hide-list '("JOIN" "PART" "QUIT"))
  (erc-timestamp-format "[%H:%M]")
  (erc-autojoin-channels-alist '((".*\\.libera\\.chat" "#emacs" "#systemcrafters")))
  :init
  (with-eval-after-load 'erc
    (add-to-list 'erc-modules 'sasl))

  (setopt erc-sasl-mechanism 'external)

  (defun erc-liberachat ()
    (interactive)
    (erc-tls :server "irc.libera.chat"
             :port 6697
             :user "Lionyx"
             :password ""
             :client-certificate
             (list
              (expand-file-name "cert.pem" user-emacs-directory)
              (expand-file-name "cert.pem" user-emacs-directory)))))

;;; erc.el ends here