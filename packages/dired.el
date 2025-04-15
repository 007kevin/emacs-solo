;;; packages/dired.el --- Directory editor configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for dired directory editor.

;;; Code:

(use-package dired
  :after emacs
  :ensure nil
  :bind
  (("<f2>" . my/dired-jump-reuse)
    ("RET" . dired-find-alternate-file)
    :map dired-mode-map
    ("d" . my/dired-dotfiles-toggle))
  :custom
  (dired-dwim-target t)
  (dired-kill-when-opening-new-dired-buffer t)
  (dired-hide-details-hide-absolute-location t)            ; EMACS-31
  :init
  (setq my-dired-switches-no-dotfiles   "-Bhl --group-directories-first -v")
  (setq my-dired-switches-show-dotfiles "-Bhl --group-directories-first -v -A")
  (setq dired-listing-switches my-dired-switches-no-dotfiles)

  (defun my/dired-dotfiles-toggle ()
    "Show/hide dot-files"
    (interactive)
    (when (equal major-mode 'dired-mode)
      (if (equal dired-listing-switches my-dired-switches-no-dotfiles)
          (progn
            (dired-sort-other my-dired-switches-show-dotfiles)
            (setq dired-listing-switches my-dired-switches-show-dotfiles))
        (progn
          (dired-sort-other my-dired-switches-no-dotfiles)
          (setq dired-listing-switches my-dired-switches-no-dotfiles))
        )))

  (defun my/not-root () (unless (string= dired-directory "/") t))
  (defun my/dired-jump-reuse ()
    (interactive)
    (if (and (derived-mode-p 'dired-mode)
             (= (length (get-buffer-window-list)) 1))
        (if (my/not-root)
            (let ((dir (expand-file-name dired-directory)))
              (find-alternate-file "..")
              (dired-goto-file dir)))
    (dired-jump)))

  )

;;; dired.el ends here