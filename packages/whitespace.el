;;; packages/whitespace.el --- Whitespace handling configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for whitespace handling.

;;; Code:

(use-package whitespace
  :ensure nil
  :defer t
  :hook (before-save . whitespace-cleanup)
  ;; if we wanna remove this hook at any time, eval:
  ;; (remove-hook 'before-save-hook #'whitespace-cleanup)
  )

;;; whitespace.el ends here