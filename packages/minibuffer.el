;;; packages/minibuffer.el --- Minibuffer configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for the minibuffer and completion.

;;; Code:

(use-package minibuffer
  :ensure nil
  :custom
  (completion-styles '(partial-completion flex initials))
  (completion-ignore-case t)
  (completion-show-help t)
  ;; (completion-auto-select t) ;; NOTE: only turn this on if not using icomplete, can also be 'second-tab
  (completions-max-height 20)
  (completions-format 'one-column)
  (enable-recursive-minibuffers t)
  (read-file-name-completion-ignore-case t)
  (read-buffer-completion-ignore-case t)
  :config
  ;; Keep the cursor out of the read-only portions of the.minibuffer
  (setq minibuffer-prompt-properties
        '(read-only t intangible t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Keep minibuffer lines unwrapped, long lines like on M-y will be truncated
  (add-hook 'minibuffer-setup-hook
          (lambda () (setq truncate-lines t)))

  (minibuffer-depth-indicate-mode 1)
  (minibuffer-electric-default-mode 1))

;;; minibuffer.el ends here