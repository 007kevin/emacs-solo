;;; packages/elec-pair.el --- Auto-pairing configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for auto-pairing of delimiters.

;;; Code:

(use-package elec-pair
  :ensure nil
  :defer
  :hook (after-init . electric-pair-mode))

;;; elec-pair.el ends here