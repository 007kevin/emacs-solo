;;; packages/uniquify.el --- Buffer name uniquification configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for buffer name uniquification.

;;; Code:

(use-package uniquify
  :ensure nil
  :config
  (setq uniquify-buffer-name-style 'forward)
  (setq uniquify-strip-common-suffix t)
  (setq uniquify-after-kill-buffer-p t))

(provide 'packages/uniquify)
;;; uniquify.el ends here