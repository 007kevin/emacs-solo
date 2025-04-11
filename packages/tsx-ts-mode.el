;;; packages/tsx-ts-mode.el --- TSX tree-sitter mode configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for TSX (TypeScript JSX) tree-sitter mode.

;;; Code:

(use-package tsx-ts-mode
  :mode "\\.tsx\\'"
  :defer 't
  :custom
  (typescript-indent-level 2)
  :config
  (add-to-list 'treesit-language-source-alist '(tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src"))
  (unbind-key "M-." typescript-ts-base-mode-map))

;;; tsx-ts-mode.el ends here