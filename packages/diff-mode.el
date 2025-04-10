;;; packages/diff-mode.el --- Diff mode configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for diff-mode.

;;; Code:

(use-package diff-mode
  :ensure nil
  :defer t
  :config
  (setq diff-default-read-only t)
  (setq diff-advance-after-apply-hunk t)
  (setq diff-update-on-the-fly t)
  (setq diff-font-lock-syntax 'hunk-also)
  (setq diff-font-lock-prettify nil))

(provide 'packages/diff-mode)
;;; diff-mode.el ends here