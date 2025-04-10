;;; packages/ruby-ts-mode.el --- Ruby tree-sitter mode configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for Ruby tree-sitter mode.

;;; Code:

(use-package ruby-ts-mode
  :ensure nil
  :mode "\\.rb\\'"
  :mode "Rakefile\\'"
  :mode "Gemfile\\'"
  :custom
  (add-to-list 'treesit-language-source-alist '(ruby "https://github.com/tree-sitter/tree-sitter-ruby" "master" "src"))
  (ruby-indent-level 2)
  (ruby-indent-tabs-mode nil))

(provide 'packages/ruby-ts-mode)
;;; ruby-ts-mode.el ends here