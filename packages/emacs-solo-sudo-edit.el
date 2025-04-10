;;; packages/emacs-solo-sudo-edit.el --- Sudo editing utilities  -*- lexical-binding: t; -*-

;;; Commentary:
;; Functions for editing files as root.
;; Inspired by: https://codeberg.org/daviwil/dotfiles/src/branch/master/Emacs.org#headline-28

;;; Code:

(use-package emacs-solo-sudo-edit
  :ensure nil
  :no-require t
  :defer t
  :init
  (defun emacs-solo/sudo-edit (&optional arg)
    "Edit currently visited file as root.
With a prefix ARG prompt for a file to visit.
Will also prompt for a file to visit if current
buffer is not visiting a file."
    (interactive "P")
    (if (or arg (not buffer-file-name))
        (find-file (concat "/sudo:root@localhost:"
                           (completing-read "Find file(as root): ")))
      (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name)))))

(provide 'packages/emacs-solo-sudo-edit)
;;; emacs-solo-sudo-edit.el ends here