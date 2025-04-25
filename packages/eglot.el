;;; packages/eglot.el --- LSP client configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for the Eglot LSP client.

;;; Code:

(use-package eglot
  :ensure nil
  :custom
  (eglot-autoshutdown t)
  (eglot-events-buffer-size 0)
  (eglot-events-buffer-config '(:size 0 :format full))
  (eglot-prefer-plaintext t)
  (jsonrpc-event-hook nil)
  (eglot-code-action-indications nil) ;; EMACS-31 -- annoying as hell
  (eglot-highlight-symbol-at-point t)
  :init
  (fset #'jsonrpc--log-event #'ignore)

  (defun emacs-solo/eglot-setup ()
    "Setup eglot mode with specific exclusions."
    (unless (eq major-mode 'emacs-lisp-mode)
      (eglot-ensure)))

  (add-hook 'prog-mode-hook #'emacs-solo/eglot-setup)

  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs '((ruby-mode ruby-ts-mode) "ruby-lsp"))
    (add-to-list 'eglot-server-programs '((go-mode go-ts-mode) "gopls")))

  :config
  (custom-set-faces
   '(eglot-highlight-symbol-face
     ((t (:background "#2a3f5f"
          :foreground nil
          :distant-foreground nil
          :weight semi-bold)))))

  :bind (:map
         eglot-mode-map
         ("C-c l a" . eglot-code-actions)
         ("C-c l o" . eglot-code-actions-organize-imports)
         ("C-c l r" . eglot-rename)
         ("C-c l f" . eglot-format)))

;;; eglot.el ends here