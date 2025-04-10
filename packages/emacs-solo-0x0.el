;;; packages/emacs-solo-0x0.el --- File sharing utilities  -*- lexical-binding: t; -*-

;;; Commentary:
;; Functions for sharing files via 0x0.st.
;; Inspired by: https://codeberg.org/daviwil/dotfiles/src/branch/master/Emacs.org#headline-28

;;; Code:

(use-package emacs-solo-0x0
  :ensure nil
  :no-require t
  :defer t
  :init
  (defun emacs-solo/0x0-upload-text ()
    (interactive)
    (let* ((contents (if (use-region-p)
                         (buffer-substring-no-properties (region-beginning) (region-end))
                       (buffer-string)))
           (temp-file (make-temp-file "0x0" nil ".txt" contents)))
      (message "Sending %s to 0x0.st..." temp-file)
      (let ((url (string-trim-right
                  (shell-command-to-string
                   (format "curl -s -F'file=@%s' https://0x0.st" temp-file)))))
        (message "The URL is %s" url)
        (kill-new url)
        (delete-file temp-file))))

  (defun emacs-solo/0x0-upload-file (file-path)
    (interactive "fSelect a file to upload: ")
    (message "Sending %s to 0x0.st..." file-path)
    (let ((url (string-trim-right
                (shell-command-to-string
                 (format "curl -s -F'file=@%s' https://0x0.st" (expand-file-name file-path))))))
      (message "The URL is %s" url)
      (kill-new url))))

(provide 'packages/emacs-solo-0x0)
;;; emacs-solo-0x0.el ends here