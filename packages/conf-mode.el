;;; packages/conf-mode.el --- Configuration file mode setup  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for working with configuration files.

;;; Code:

(use-package conf-mode
  :ensure nil
  :mode ("\\.env\\..*\\'" "\\.env\\'")
  :init
  (add-to-list 'auto-mode-alist '("\\.env\\'" . conf-mode)))

;;; conf-mode.el ends here