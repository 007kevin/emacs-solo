;;; packages/js-ts-mode.el --- JavaScript tree-sitter mode configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for JavaScript tree-sitter mode.

;;; Code:

(use-package js-ts-mode
  :ensure js ;; I care about js-base-mode but it is locked behind the feature "js"
  :mode ("\\.jsx?\\'" "\\.js?\\'")
  :defer 't
  :custom
  (js-indent-level 2)
  :config
  (add-to-list 'treesit-language-source-alist '(javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src"))
  (add-to-list 'treesit-language-source-alist '(jsdoc "https://github.com/tree-sitter/tree-sitter-jsdoc" "master" "src")))

;;; js-ts-mode.el ends here
