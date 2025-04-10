;;; packages/compile.el --- Compilation mode configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for compilation mode.

;;; Code:

(use-package compile
  :ensure nil
  :custom
  (compilation-always-kill t)
  (compilation-scroll-output t)
  (ansi-color-for-compilation-mode t)
  :config
  ;; Not ideal, but I do not want this poluting the mode-line
  (defun emacs-solo/ignore-compilation-status (&rest _)
    (setq compilation-in-progress nil))
  (advice-add 'compilation-start :after #'emacs-solo/ignore-compilation-status)

  (add-hook 'compilation-filter-hook #'ansi-color-compilation-filter))

(provide 'packages/compile)
;;; compile.el ends here