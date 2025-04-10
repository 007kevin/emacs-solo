;;; packages/emacs-solo-transparency.el --- Frame transparency functions  -*- lexical-binding: t; -*-

;;; Commentary:
;; Custom functions to set/unset transparency.

;;; Code:

(use-package emacs-solo-transparency
  :ensure nil
  :no-require t
  :defer t
  :init
  (defun emacs-solo/clear-terminal-background-color (&optional frame)
    (interactive)
    (or frame (setq frame (selected-frame)))
    "unsets the background color in terminal mode"
    (unless (display-graphic-p frame)
      ;; Set the terminal to a transparent version of the background color
      (send-string-to-terminal
       (format "\033]11;[90]%s\033\\"
               (face-attribute 'default :background)))
      (set-face-background 'default "unspecified-bg" frame)))

  (defun emacs-solo/transparency-set ()
    "Set frame transparency (Graphical Mode)."
    (interactive)
    (unless (display-graphic-p)
        (add-hook 'after-make-frame-functions 'emacs-solo/clear-terminal-background-color)
        (add-hook 'window-setup-hook 'emacs-solo/clear-terminal-background-color)
        (add-hook 'ef-themes-post-load-hook 'emacs-solo/clear-terminal-background-color))

    (when (eq system-type 'darwin)
      (set-frame-parameter (selected-frame) 'alpha '(90 90)))

    (dolist (frame (frame-list))
      (set-frame-parameter frame 'alpha-background 85)))


  (defun emacs-solo/transparency-unset ()
    "Unset frame transparency (Graphical Mode)."
    (interactive)
    (when (eq system-type 'darwin)
      (set-frame-parameter (selected-frame) 'alpha '(100 100)))
    (dolist (frame (frame-list))
      (set-frame-parameter frame 'alpha-background 100)))

  (add-hook 'after-init-hook #'emacs-solo/transparency-set))

(provide 'packages/emacs-solo-transparency)
;;; emacs-solo-transparency.el ends here