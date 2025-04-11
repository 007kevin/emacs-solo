;;; packages/rcirc.el --- IRC client configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for the built-in IRC client.

;;; Code:

(use-package rcirc
  :ensure nil
  :custom
  (rcirc-debug t)
  (rcirc-default-nick "Lionyx")
  (rcirc-default-user-name "Lionyx")
  (rcirc-default-full-name "Lionyx")
  (rcirc-server-alist `(("irc.libera.chat"
                         :channels ("#emacs" "#systemcrafters")
                         :port 6697
                         :encryption tls)))
  (rcirc-reconnect-delay 5)
  (rcirc-fill-column 100)
  (rcirc-track-ignore-server-buffer-flag t)
  :config
  (setopt rcirc-authinfo
          `(("irc.libera.chat" certfp
             ,(expand-file-name "cert.pem" user-emacs-directory)
             ,(expand-file-name "cert.pem" user-emacs-directory)))))

;;; rcirc.el ends here