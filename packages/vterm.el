;;; packages/vterm.el --- vterm configuration  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(use-package vterm
  :after tab-bar
  :ensure t
  :hook ((vterm-mode . turn-on-hide-mode-line-mode)
         (vterm-mode . emacs-solo/buffer-background-black))
  :bind
  (:map vterm-copy-mode-map
        ("C-g" . vterm-copy-mode-done)
   :map vterm-mode-map
        ("C-y" . vterm-yank)
        ("<f2>" . my/dired-jump-reuse)
        ("C-g" . vterm-send-C-g)
        ("C-p" . (lambda () (interactive) (vterm-copy-mode) (previous-line)))
        ("C-n" . (lambda () (interactive) (vterm-copy-mode) (next-line)))
        ("M-1" . (lambda () (interactive) (tab-bar-select-or-create 1)))
        ("M-2" . (lambda () (interactive) (tab-bar-select-or-create 2)))
        ("M-3" . (lambda () (interactive) (tab-bar-select-or-create 3)))
        ("M-4" . (lambda () (interactive) (tab-bar-select-or-create 4)))
        ("M-5" . (lambda () (interactive) (tab-bar-select-or-create 5)))
        ("M-6" . (lambda () (interactive) (tab-bar-select-or-create 6)))
        ("M-7" . (lambda () (interactive) (tab-bar-select-or-create 7)))
        ("M-8" . (lambda () (interactive) (tab-bar-select-or-create 8)))
        ("M-9" . (lambda () (interactive) (tab-bar-select-or-create 9)))
        ("M-0" . (lambda () (interactive) (tab-bar-select-or-create 10))))
  :config
  (defun old-version-of-vterm--get-color (index &rest args)
    "This is the old version before it was broken by commit
https://github.com/akermu/emacs-libvterm/commit/e96c53f5035c841b20937b65142498bd8e161a40.
Re-introducing the old version fixes auto-dim-other-buffers for vterm buffers."
    (cond
     ((and (>= index 0) (< index 16))
      (face-foreground
       (elt vterm-color-palette index)
       nil 'default))
     ((= index -11)
      (face-foreground 'vterm-color-underline nil 'default))
     ((= index -12)
      (face-background 'vterm-color-inverse-video nil 'default))
     (t
      nil)))
  (advice-add 'vterm--get-color :override #'old-version-of-vterm--get-color))

;;; vterm.el ends here
