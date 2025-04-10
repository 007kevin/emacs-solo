;;; packages/toml-ts-mode.el --- TOML tree-sitter mode configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for TOML tree-sitter mode.

;;; Code:

(use-package toml-ts-mode
  :ensure toml-ts-mode
  :mode "\\.toml\\'"
  :defer 't
  :config
  (add-to-list 'treesit-language-source-alist '(toml "https://github.com/ikatyang/tree-sitter-toml" "master" "src")))

(provide 'packages/toml-ts-mode)
;;; toml-ts-mode.el ends here