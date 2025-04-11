;;; packages/dockerfile-ts-mode.el --- Dockerfile tree-sitter mode configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for Dockerfile tree-sitter mode.

;;; Code:

(use-package dockerfile-ts-mode
  :ensure dockerfile-ts-mode
  :mode "\\Dockerfile.*\\'"
  :defer 't
  :config
  (add-to-list 'treesit-language-source-alist '(dockerfile "https://github.com/camdencheek/tree-sitter-dockerfile" "main" "src")))

;;; dockerfile-ts-mode.el ends here