;;; packages/yaml-ts-mode.el --- YAML tree-sitter mode configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for YAML tree-sitter mode.

;;; Code:

(use-package yaml-ts-mode
  :ensure yaml-ts-mode
  :mode "\\.ya?ml\\'"
  :defer 't
  :config
  (add-to-list 'treesit-language-source-alist '(yaml "https://github.com/tree-sitter-grammars/tree-sitter-yaml" "master" "src")))

(provide 'packages/yaml-ts-mode)
;;; yaml-ts-mode.el ends here