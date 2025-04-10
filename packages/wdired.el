;;; packages/wdired.el --- Writable dired configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for writable dired mode.

;;; Code:

(use-package wdired
  :ensure nil
  :commands (wdired-change-to-wdired-mode)
  :config
  (setq wdired-allow-to-change-permissions t)
  (setq wdired-create-parent-directories t))

(provide 'packages/wdired)
;;; wdired.el ends here