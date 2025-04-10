;;; packages/proced.el --- Process viewer configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for the process viewer.

;;; Code:

(use-package proced
  :ensure nil
  :defer t
  :custom
  (proced-enable-color-flag t)
  (proced-tree-flag t)
  (proced-auto-update-flag 'visible)
  (proced-auto-update-interval 1)
  (proced-descent t)
  (proced-filter 'user) ;; We can change interactively with `s'
  :config
  (add-hook 'proced-mode-hook
            (lambda ()
              (proced-toggle-auto-update 1))))

(provide 'packages/proced)
;;; proced.el ends here