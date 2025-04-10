;;; packages/newsticker.el --- RSS feed reader configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for the newsticker RSS feed reader.

;;; Code:

(use-package newsticker
  :ensure nil
  :defer t
  :custom
  (newsticker-treeview-treewindow-width 40)
  :hook
  (newsticker-treeview-item-mode . (lambda ()
                                     (define-key newsticker-treeview-item-mode-map
                                                 (kbd "V")
                                                 'emacs-solo/newsticker-play-yt-video-from-buffer)))
  :init
  (defun emacs-solo/newsticker-play-yt-video-from-buffer ()
    "Plays with mpv async, the current buffer found '* videoId: '."
    (interactive)
    (save-excursion
      (goto-char (point-min))
      (when (re-search-forward "^\\* videoId: \\(\\w+\\)" nil t)
        (let ((video-id (match-string 1)))
          (start-process "mpv-video" nil "mpv" (format "https://www.youtube.com/watch?v=%s" video-id))
          (message "Playing with mpv: %s" video-id))))))

(provide 'packages/newsticker)
;;; newsticker.el ends here