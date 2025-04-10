;;; packages/dired.el --- Directory editor configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for dired directory editor.

;;; Code:

(use-package dired
  :ensure nil
  :bind
  (("M-i" . emacs-solo/window-dired-vc-root-left))
  :custom
  (dired-dwim-target t)
  (dired-guess-shell-alist-user
   '(("\\.\\(png\\|jpe?g\\|tiff\\)" "feh" "xdg-open" "open")
     ("\\.\\(mp[34]\\|m4a\\|ogg\\|flac\\|webm\\|mkv\\)" "mpv" "xdg-open" "open")
     (".*" "xdg-open" "open")))
  (dired-kill-when-opening-new-dired-buffer t)
  (dired-listing-switches "-al --group-directories-first")
  (dired-hide-details-hide-absolute-location t)            ; EMACS-31
  :init
  (defun emacs-solo/dired-rsync-copy (dest)
  "Copy marked files in Dired to DEST using rsync async, with real-time processing of output."
  (interactive
   (list (expand-file-name (read-file-name "rsync to: "
                                           (dired-dwim-target-directory)))))
  (let* ((files (dired-get-marked-files nil current-prefix-arg))
         (command (append '("rsync" "-hPur") (mapcar #'shell-quote-argument files) (list (shell-quote-argument dest))))
         (buffer (get-buffer-create "*rsync*")))
    (with-current-buffer buffer
      (erase-buffer)
      (insert "Running rsync...\n"))

    (defun rsync-process-filter (proc string)
      (with-current-buffer (process-buffer proc)
        (goto-char (point-max))
        (insert string)
        (goto-char (point-max))
        (while (re-search-backward "\r" nil t)
          (replace-match "\n" nil nil))))

    (make-process
     :name "dired-rsync"
     :buffer buffer
     :command command
     :filter 'rsync-process-filter
     :sentinel
     (lambda (_proc event)
       (when (string-match-p "finished" event)
         (with-current-buffer buffer
           (goto-char (point-max))
           (insert "\n* rsync done *\n"))
         (dired-revert)))
     :stderr buffer)

    (display-buffer buffer)
    (message "rsync started...")))


  (defun emacs-solo/window-dired-vc-root-left (&optional directory-path)
    "Creates *Dired-Side* like an IDE side explorer"
    (interactive)
    (add-hook 'dired-mode-hook 'dired-hide-details-mode)

    (let ((dir (if directory-path
                   (dired-noselect directory-path)
         (if (eq (vc-root-dir) nil)
                     (dired-noselect default-directory)
                   (dired-noselect (vc-root-dir))))))

      (display-buffer-in-side-window
       dir `((side . left)
         (slot . 0)
         (window-width . 30)
         (window-parameters . ((no-other-window . t)
                   (no-delete-other-windows . t)
                   (mode-line-format . (" "
                            "%b"))))))
      (with-current-buffer dir
    (let ((window (get-buffer-window dir)))
          (when window
            (select-window window)
        (rename-buffer "*Dired-Side*")
        )))))

  (defun emacs-solo/window-dired-open-directory ()
    "Open the current directory in *Dired-Side* side window."
    (interactive)
    (emacs-solo/window-dired-vc-root-left (dired-get-file-for-visit)))

  (eval-after-load 'dired
  '(progn
     (define-key dired-mode-map (kbd "C-<return>") 'emacs-solo/window-dired-open-directory))))

(provide 'packages/dired)
;;; dired.el ends here