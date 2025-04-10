;;; packages/emacs-solo-weather.el --- Weather display utilities  -*- lexical-binding: t; -*-

;;; Commentary:
;; Functions for displaying weather information.

;;; Code:

(use-package emacs-solo-weather
  :ensure nil
  :no-require t
  :defer t
  :init
  (setq emacs-solo-weather-city "Indaiatuba")

  (defun emacs-solo/weather-buffer ()
    "Open a new Emacs buffer and asynchronously fetch wttr.in weather data."
    (interactive)
    (let* ((city (shell-quote-argument emacs-solo-weather-city))
           (buffer (get-buffer-create "*Weather*"))
           (url1 (format "curl -s 'wttr.in/%s'" city))
           (url2 (format "curl -s 'v2d.wttr.in/%s'" city)))
      (with-current-buffer buffer
        (read-only-mode -1)
        (erase-buffer)
        (insert "Fetching weather data...\n")
        (read-only-mode 1))
      (switch-to-buffer buffer)
      ;; Fetch both asynchronously
      (emacs-solo--fetch-weather url1 buffer)
      (emacs-solo--fetch-weather url2 buffer t)))

  (defun emacs-solo--fetch-weather (cmd buffer &optional second)
    "Run CMD asynchronously and insert results into BUFFER.
If SECOND is non-nil, separate the results with a newline."
    (make-process
     :name "weather-fetch"
     :buffer (generate-new-buffer " *weather-temp*")
     :command (list "sh" "-c" cmd)
     :sentinel
     (lambda (proc _event)
       (when (eq (process-status proc) 'exit)
         (let ((output (with-current-buffer (process-buffer proc)
                         (buffer-string))))
           (kill-buffer (process-buffer proc))
           (setq output (replace-regexp-in-string "^Follow.*\n" ""
                                                  (replace-regexp-in-string "[\x0f]" "" output)))
           (with-current-buffer buffer
             (read-only-mode -1)
             (when second (insert "\n\n"))
             (insert output)
             (ansi-color-apply-on-region (point-min) (point-max))
             (goto-char (point-min))
             (read-only-mode 1))))))))

(provide 'packages/emacs-solo-weather)
;;; emacs-solo-weather.el ends here