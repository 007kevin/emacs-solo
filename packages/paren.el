;;; packages/paren.el --- Parenthesis highlighting configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for parenthesis highlighting.

;;; Code:

(use-package paren
  :ensure nil
  :hook (after-init . show-paren-mode)
  :custom
  (show-paren-delay 0)
  (show-paren-style 'mixed)
  (show-paren-context-when-offscreen t)) ;; show matches within window splits

;;; paren.el ends here