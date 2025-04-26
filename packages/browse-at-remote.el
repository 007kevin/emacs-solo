;;; packages/browse-at-remote.el --- ERC IRC client configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for the browsing remote repositories.

;;; Code:

(use-package f :ensure t)
(use-package s :ensure t)
(use-package dash :ensure t)
(use-package browse-at-remote
  :after f s dash
  :config
  (defalias 'github 'browse-at-remote))

;;; browse-at-remote.el ends here
