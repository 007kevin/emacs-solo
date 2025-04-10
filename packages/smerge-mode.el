;;; packages/smerge-mode.el --- Merge conflict resolution configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for smerge-mode for resolving merge conflicts.

;;; Code:

(use-package smerge-mode
  :ensure nil
  :bind (:map smerge-mode-map
              ("C-c ^ u" . smerge-keep-upper)
              ("C-c ^ l" . smerge-keep-lower)
              ("C-c ^ n" . smerge-next)
              ("C-c ^ p" . smerge-previous)))

(provide 'packages/smerge-mode)
;;; smerge-mode.el ends here