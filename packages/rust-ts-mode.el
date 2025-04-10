;;; packages/rust-ts-mode.el --- Rust tree-sitter mode configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for Rust tree-sitter mode.

;;; Code:

(use-package rust-ts-mode
  :ensure rust-ts-mode
  :mode "\\.rs\\'"
  :defer 't
  :custom
  (rust-indent-level 2)
  :config
  (add-to-list 'treesit-language-source-alist '(rust "https://github.com/tree-sitter/tree-sitter-rust" "master" "src")))

(provide 'packages/rust-ts-mode)
;;; rust-ts-mode.el ends here