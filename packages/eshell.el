;;; packages/eshell.el --- Emacs shell configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for the Emacs shell.

;;; Code:

;; Eshell integration
;; (use-package shell-pop
;;   :ensure t
;;   :custom
;;   (shell-pop-window-position "full")
;;   (shell-pop-shell-type '("eshell" "*eshell*" (lambda () (eshell))))
;;   (shell-pop-term-shell "eshell")
;;   :config
;;   (defun emacs-solo/shell-pop ()
;;     "Shell pop with cd to working dir."
;;     (interactive)
;;     ;; Overriding shell-pop-autocd-to-working-dir with `prefix' value.
;;     (let ((shell-pop-autocd-to-working-dir t))
;;       (if (string= (buffer-name) shell-pop-last-shell-buffer-name)
;;           (shell-pop-out)
;;         (shell-pop-up shell-pop-last-shell-buffer-index)))))

;; Vterm integration
(use-package shell-pop
  :ensure t
  :demand t
  :custom
  (shell-pop-window-position "full")
  (shell-pop-shell-type '("vterm" "*vterm*" (lambda () (vterm))))
  (shell-pop-term-shell "vterm")
  :hook
  (shell-pop-in-after . kk/shell-pop-in-after-hook)
  :bind
  (("<f1>" . kk/shell-pop))
  :config
  (defun kk/shell-pop ()
    "Shell pop with cd to working dir."
    (interactive)
    ;; Overriding shell-pop-autocd-to-working-dir with `prefix' value.
    (let ((shell-pop-autocd-to-working-dir t))
      (if (string= (buffer-name) shell-pop-last-shell-buffer-name)
          (shell-pop-out)
        (shell-pop-up shell-pop-last-shell-buffer-index))))

  (defun kk/shell-pop-in-after-hook ()
	(my/vterm-write-default-directory)
	(if (get-buffer vterm-tmux-buffer-name)
		(switch-to-buffer vterm-tmux-buffer-name)
      (let (display-buffer-alist)
		(vterm vterm-tmux-buffer-name)

		(when (not (my/vterm-in-tmux))
          (vterm-send-string "tmux new-session -A -s with_emacs")
          (vterm-send-return))
		))))


(use-package eshell
  :ensure nil
  :defer t
  :bind
  (("<f1>" . kk/shell-pop))
  :hook ((eshell-mode . turn-on-hide-mode-line-mode)
         (eshell-mode . emacs-solo/buffer-background-black))
  :config
  (defun emacs-solo/buffer-background-black ()
    "Change the background color of the current buffer for dark themes"
    (interactive)
    (unless (eq (frame-parameter nil 'background-mode) 'light)
      (setq buffer-face-mode-face `(:background "black"))
      (buffer-face-mode 1)))


  (defun eshell-here (&optional directory)
  "Go to eshell and set current directory to the buffer's directory. If already
on eshell, go to last buffer."
    (interactive)
    (if (and (not directory) (equal major-mode 'eshell-mode))
        (previous-buffer)
      (let* ((dir (file-name-directory (or directory (buffer-file-name) default-directory))))
        (eshell)
        (when (not (equal (expand-file-name (concat (eshell/pwd) "/")) (expand-file-name dir)))
          (progn (eshell/pushd ".")
                 (cd dir)
                 (goto-char (point-max))
                 (eshell-kill-input)
                 (eshell-send-input))))))

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

  (defun p10k-lean-eshell-prompt ()
    "A p10k lean style prompt for Eshell with parent directories."
    (let* ((exit-status eshell-last-command-status)
           (success (= exit-status 0))

           ;; Define colors
           (dir-color "#56b6c2")     ; Cyan for directory
           (git-color "#c678dd")     ; Purple for git info
           (good-color "#98c379")    ; G3reen for success
           (bad-color "#e06c75")     ; Red for failure

           ;; Get shortened path with parent directories
           (full-dir default-directory)
           (home-dir (expand-file-name "~"))
           (path-relative-to-home
            (if (string-prefix-p home-dir full-dir)
                (concat "~" (substring full-dir (length home-dir)))
              full-dir))

           ;; Format the path
           (formatted-path
            (propertize path-relative-to-home 'face `(:foreground ,dir-color)))

           ;; Git information
           (git-branch (when (locate-dominating-file default-directory ".git")
                         (condition-case nil
                             (let ((branch (car (process-lines "git" "symbolic-ref" "--short" "HEAD"))))
                               (concat " " (propertize branch 'face `(:foreground ,git-color :weight normal))))
                           (error "")))))

      ;; Construct the prompt
      (concat
       ;; Directory path
       formatted-path

       ;; Git branch (if we're in a git repo)
       (or git-branch "")

       ;; Prompt character (changes color based on previous command status)
       " "
       (propertize "❯" 'face `(:foreground ,(if success good-color bad-color) :weight bold))
       " ")))

  ;; Set the prompt function
  (setq eshell-prompt-function 'p10k-lean-eshell-prompt)

  ;; Set the regexp for identifying the prompt
  (setq eshell-prompt-regexp "^.* ❯ ")

  (custom-set-faces '(eshell-prompt ((t nil))))


  (add-hook 'eshell-mode-hook
            (lambda ()
              (setenv "TERM" "xterm-256color")))

  (setq eshell-visual-commands
        '("vi" "screen" "top"  "htop" "btm" "less" "more" "lynx" "ncftp" "pine" "tin" "trn"
          "elm" "irssi" "nmtui-connect" "nethack" "vim" "alsamixer" "nvim" "w3m"
          "ncmpcpp" "newsbeuter" "nethack" "mutt")))

;;; eshell.el ends here
