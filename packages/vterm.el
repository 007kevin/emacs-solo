;;; packages/vterm.el --- vterm configuration  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(use-package vterm
  :demand t
  :ensure t
  :hook ((vterm-mode . turn-on-hide-mode-line-mode)
         (vterm-mode . emacs-solo/buffer-background-black))
  :bind
  (:map vterm-mode-map
        ("M-1" . (lambda() (interactive) (tab-bar-select-tab 1)))
		("<f1>" . kk/shell-pop)
        ("<f2>" . my/dired-jump-reuse)
        ("C-g" . vterm-send-C-g)
		("C-w" . vterm-send-C-w)
		("C-y" . yank)
		("M-1" . (lambda () (interactive) (vterm-send-key "2" nil t nil nil)))
		("M-2" . (lambda () (interactive) (vterm-send-key "2" nil t nil nil)))
		("M-3" . (lambda () (interactive) (vterm-send-key "3" nil t nil nil)))
		("M-4" . (lambda () (interactive) (vterm-send-key "4" nil t nil nil)))
		("M-5" . (lambda () (interactive) (vterm-send-key "5" nil t nil nil)))
		("M-6" . (lambda () (interactive) (vterm-send-key "6" nil t nil nil)))
		("M-7" . (lambda () (interactive) (vterm-send-key "7" nil t nil nil)))
		("M-8" . (lambda () (interactive) (vterm-send-key "8" nil t nil nil)))
		("M-9" . (lambda () (interactive) (vterm-send-key "9" nil t nil nil)))
		("M-0" . (lambda () (interactive) (vterm-send-key "0" nil t nil nil))))
  :config
  (setq vterm-timer-delay nil)
  ;; https://www.reddit.com/r/emacs/comments/xyo2fo/orgmode_vterm_tmux/n
  (setq vterm-enable-manipulate-selection-data-by-osc52 t)

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
  (advice-add 'vterm--get-color :override #'old-version-of-vterm--get-color)

  ;; emacs + vterm synchronization code to work with bin/sync
  (defun get-current-directory ()
	(expand-file-name (file-name-directory (or (buffer-file-name) default-directory))))

  ;; emacs + vterm synchronization code to work with bin/sync
  (defun my/get-current-directory ()
	(expand-file-name (file-name-directory (or (buffer-file-name) default-directory))))

  (defun my/vterm-write-default-directory (&optional _)
	"Writes default-directory to `user-emacs-directory'/.vterm-default-directory.
So that the call to sync will change directory to the relevant one."
	(let ((vterm-file (expand-file-name ".local/cache/.vterm-default-directory" user-emacs-directory))
          (dir (my/get-current-directory)))
      (with-temp-file vterm-file
        (insert dir))))

  (defvar vterm-tmux-buffer-name "*vterm-tmux*")

  (defun my/vterm-in-tmux ()
	"Check if vterm buffer is running in tmux."
	(with-current-buffer vterm-tmux-buffer-name
	  (let ((process-environment '("TERM=screen")))
		(string-prefix-p "screen" (terminal-name)))))

  (defun my/vterm-tmux-here ()
	"Go to vterm or last buffer."
	(interactive)
	(if (equal major-mode 'vterm-mode)
		(previous-buffer)
      (progn
		(my/vterm-write-default-directory)
		(if (get-buffer vterm-tmux-buffer-name)
			(switch-to-buffer vterm-tmux-buffer-name)
          (let (display-buffer-alist)
			(vterm vterm-tmux-buffer-name)

			(when (not (my/vterm-in-tmux))
              (vterm-send-string "tmux new-session -A -s with_emacs")
              (vterm-send-return))

		  )))))
  )

;;; vterm.el ends here
