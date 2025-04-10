;;; packages/typescript-ts-mode.el --- TypeScript tree-sitter mode configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for TypeScript tree-sitter mode.

;;; Code:

(use-package typescript-ts-mode
  :mode "\\.ts\\'"
  :defer 't
  :custom
  (typescript-indent-level 2)
  :config
  (add-to-list 'treesit-language-source-alist '(typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src"))
  (unbind-key "M-." typescript-ts-base-mode-map))

(provide 'packages/typescript-ts-mode)
;;; typescript-ts-mode.el ends here