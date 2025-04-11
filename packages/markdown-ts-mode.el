;;; packages/markdown-ts-mode.el --- Markdown tree-sitter mode configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for Markdown tree-sitter mode (EMACS-31).

;;; Code:

(use-package markdown-ts-mode
  :ensure nil
  :mode "\\.md\\'"
  :defer 't
  :config
  (add-to-list 'major-mode-remap-alist '(markdown-mode . markdown-ts-mode))
  (add-to-list 'treesit-language-source-alist '(markdown "https://github.com/tree-sitter-grammars/tree-sitter-markdown" "split_parser" "tree-sitter-markdown/src"))
  (add-to-list 'treesit-language-source-alist '(markdown-inline "https://github.com/tree-sitter-grammars/tree-sitter-markdown" "split_parser" "tree-sitter-markdown-inline/src")))

;;; markdown-ts-mode.el ends here