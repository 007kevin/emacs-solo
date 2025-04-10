;;; packages/eshell.el --- Emacs shell configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for the Emacs shell.

;;; Code:

(use-package eshell
  :ensure nil
  :defer t
  :config
  (defun emacs-solo/eshell-pick-history ()
    "Show Eshell history in a completing-read picker and insert the selected command."
    (interactive)
    (let* ((history-file (expand-file-name "eshell/history" user-emacs-directory))
           (history-entries (when (file-exists-p history-file)
                              (with-temp-buffer
                                (insert-file-contents history-file)
                                (split-string (buffer-string) "\n" t))))
           (selection (completing-read "Eshell History: " history-entries)))
      (when selection
        (insert selection))))


  (defun eshell/cat-with-syntax-highlighting (filename)
    "Like cat(1) but with syntax highlighting.
  Stole from aweshell"
    (let ((existing-buffer (get-file-buffer filename))
          (buffer (find-file-noselect filename)))
      (eshell-print
       (with-current-buffer buffer
         (if (fboundp 'font-lock-ensure)
             (font-lock-ensure)
           (with-no-warnings
             (font-lock-fontify-buffer)))
         (let ((contents (buffer-string)))
           (remove-text-properties 0 (length contents) '(read-only nil) contents)
           contents)))
      (unless existing-buffer
        (kill-buffer buffer))
      nil))
  (advice-add 'eshell/cat :override #'eshell/cat-with-syntax-highlighting)


  (add-hook 'eshell-mode-hook
            (lambda ()
              (local-set-key (kbd "C-c l") #'emacs-solo/eshell-pick-history)
              (local-set-key (kbd "C-l")
                             (lambda ()
                               (interactive)
                               (eshell/clear 1)
                               (eshell-send-input)))))

  (require 'vc)
  (require 'vc-git)
  (setopt eshell-prompt-function
        (lambda ()
          (concat
           "┌─("
           (if (> eshell-last-command-status 0)
               "❌"
             "🐂")
           " " (number-to-string eshell-last-command-status)
           ")──("
           "🧘 " (or (file-remote-p default-directory 'user) (user-login-name))
           ")──("
           "💻 " (or (file-remote-p default-directory 'host) (system-name))
           ")──("
           "🕝 " (format-time-string "%H:%M:%S" (current-time))
           ")──("
           "📁 "
           (concat (if (>= (length (eshell/pwd)) 40)
                       (concat "..." (car (last (butlast (split-string (eshell/pwd) "/") 0))))
                     (abbreviate-file-name (eshell/pwd))))
           ")\n"

           (when (and (fboundp 'vc-git-root) (vc-git-root default-directory))
             (concat
              "├─(🌿 " (car (vc-git-branches))
              (let* ((branch (car (vc-git-branches)))
                     (behind (string-to-number
                              (shell-command-to-string
                               (concat "git rev-list --count HEAD..origin/" branch)))))
                (if (> behind 0)
                    (concat "  ⬇️ " (number-to-string behind))))

              (let ((modified (length (split-string
                                       (shell-command-to-string
                                        "git ls-files --modified") "\n" t)))
                    (untracked (length (split-string
                                        (shell-command-to-string
                                         "git ls-files --others --exclude-standard") "\n" t))))
                (concat
                 (if (> modified 0)
                     (concat "  ✏️ " (number-to-string modified)))
                 (if (> untracked 0)
                     (concat "  📄 " ))))
              ")\n"))
           "└─➜ ")))

  (setq eshell-prompt-regexp "└─➜ ")

  (add-hook 'eshell-mode-hook (lambda () (setenv "TERM" "xterm-256color")))

  (setq eshell-visual-commands
        '("vi" "screen" "top"  "htop" "btm" "less" "more" "lynx" "ncftp" "pine" "tin" "trn"
          "elm" "irssi" "nmtui-connect" "nethack" "vim" "alsamixer" "nvim" "w3m"
          "ncmpcpp" "newsbeuter" "nethack" "mutt")))

(provide 'packages/eshell)
;;; eshell.el ends here