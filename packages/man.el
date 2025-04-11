;;; packages/man.el --- Manual page reader configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for the man page reader.

;;; Code:

(use-package man
  :ensure nil
  :commands (man)
  :config
  (setq Man-notify-method 'pushy)) ; does not obey `display-buffer-alist'

;;; man.el ends here