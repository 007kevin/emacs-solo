;;; packages/emacs-solo-hooks.el --- Custom hooks  -*- lexical-binding: t; -*-

;;; Commentary:
;; Custom hooks for various modes.

;;; Code:

(use-package emacs-solo-hooks
  :ensure nil
  :no-require t
  :defer t
  :init

  (defun emacs-solo/prefer-tabs ()
    "Disables indent-tabs-mode, and prefer spaces over tabs."
    (interactive)
    (indent-tabs-mode -1))

  (add-hook 'prog-mode-hook #'emacs-solo/prefer-tabs))

;;; emacs-solo-hooks.el ends here