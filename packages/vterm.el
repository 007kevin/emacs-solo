;;; packages/vterm.el --- vterm configuration  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; vterm + shell-pop with numbered pop-ups          -*- lexical-binding:t -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package vterm
  :ensure t
  :after shell-pop
  :hook ((vterm-mode . turn-on-hide-mode-line-mode)
         (vterm-mode . emacs-solo/buffer-background-black))
  :preface
  ;; -------------------------------------------------------------------
  ;; 0. Custom
  ;; -------------------------------------------------------------------

  ;; https://www.reddit.com/r/emacs/comments/xyo2fo/orgmode_vterm_tmux/n
  (setq vterm-enable-manipulate-selection-data-by-osc52 t)

  (setq vterm-timer-delay nil)

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

  ;; ------------------------------------------------------------
  ;; Watcher: run after `default-directory' changes
  ;; ------------------------------------------------------------
  (defun kk/get-current-directory ()
	"Return the current buffer’s directory as an absolute file name.
Falls back to `default-directory' when the buffer is not visiting a file."
	(expand-file-name
	 (file-name-directory (or (buffer-file-name) default-directory))))

  (defun kk/vterm-write-default-directory (&optional dir)
	"Write DIR (string) to …/.vterm-default-directory.
When DIR is nil use the directory of the current buffer."
	(let* ((dir  (or dir (kk/get-current-directory)))
           (file (expand-file-name
                  ".local/cache/.vterm-default-directory" user-emacs-directory)))
      (make-directory (file-name-directory file) :parents)
      (with-temp-file file
		(insert dir "\n"))))

  (defun kk/vterm--default-directory-watcher (_symbol newval operation _where)
	"Variable watcher for `default-directory'.
Calls `kk/vterm-write-default-directory' *after* every real SET."
	(when (eq operation 'set)                    ; ignore let/unlet, etc.
      ;; newval is guaranteed to be the freshly installed directory.
      (kk/vterm-write-default-directory newval)))

  ;; Activate the watcher
  (add-variable-watcher 'default-directory #'kk/vterm--default-directory-watcher)

  ;; Optional: write the file once at start-up so it exists immediately
  (kk/vterm-write-default-directory)

  ;; -------------------------------------------------------------------
  ;; 1. bookkeeping
  ;; -------------------------------------------------------------------
  (defvar kk/vterm-buffers nil
    "Alist (DIGIT . BUFFER) of living vterm buffers.")

  (defvar-local kk/vterm-number nil
    "Digit that identifies this vterm buffer.")

  ;; -------------------------------------------------------------------
  ;; 2.  header-line helper  (fixed-width fields)
  ;; -------------------------------------------------------------------
  (defun kk/vterm--field (n current)
	"Return a constant-width string representing vterm N.
CURRENT is the number of the vterm that is currently shown."
	(if (= n current)
		(format "[%d]" n)               ; width 3
      (format " %d " n)))               ; “space digit space” → width 3

  (defun kk/vterm-header ()
	"Return a centred header line like \" 1  2 [3] 4 \" for vterm buffers."
	(let* ((alive  (sort (mapcar #'car kk/vterm-buffers) #'<))
           (current kk/vterm-number)
           ;; build the line with constant-width fields
           (txt    (apply #'concat (mapcar (lambda (n) (kk/vterm--field n current))
                                           alive)))
           ;; centre it
           (margin (max 0 (/ (- (window-body-width) (string-width txt)) 2))))
      (concat (propertize " " 'display `(space :align-to ,margin)) txt)))

  (defun kk/vterm--header-setup ()
    (setq-local header-line-format '(:eval (kk/vterm-header))))

  (add-hook 'vterm-mode-hook #'kk/vterm--header-setup)

  ;; -------------------------------------------------------------------
  ;; 3.  create / fetch numbered vterms
  ;; -------------------------------------------------------------------
  (defun kk/vterm-get-or-create (n)
    "Return vterm N, creating it when necessary."
    (let ((buf (cdr (assoc n kk/vterm-buffers))))
      (unless (and buf (buffer-live-p buf))
        (setq buf (vterm (format "*vterm:%d*" n)))
        (with-current-buffer buf
          (setq-local kk/vterm-number n))
        (setf (alist-get n kk/vterm-buffers) buf))
      buf))

  ;; -------------------------------------------------------------------
  ;; 4.  toggle command
  ;; -------------------------------------------------------------------
  (defun kk/vterm-toggle (n)
    "Pop to vterm N in the current window; pop back if already there."
    (interactive "p")
    (let ((here (current-buffer)))
      (cond
       ;; already in that vterm → go back
       ((and (eq major-mode 'vterm-mode)
             (= (or kk/vterm-number -1) n)
             (window-parameter nil 'kk/vterm-prev))
        (switch-to-buffer (window-parameter nil 'kk/vterm-prev)))
       ;; otherwise show / create requested vterm
       (t
        (let ((buf (kk/vterm-get-or-create n)))
          (set-window-parameter nil 'kk/vterm-prev here)
          (switch-to-buffer buf))))))

  ;; -------------------------------------------------------------------
  ;; 5.  helper to build the nine small wrapper commands
  ;; -------------------------------------------------------------------
  (dotimes (i 9)
    (let ((n (1+ i)))
      (eval
       `(defun ,(intern (format "kk/vterm-toggle-%d" n)) ()
          ,(format "Toggle vterm %d." n)
          (interactive)
          (kk/vterm-toggle ,n)))))

  ;; -------------------------------------------------------------------
  ;; 6.  key-bindings
  ;;     – global map *and* vterm-mode-map so they work inside vterm
  ;; -------------------------------------------------------------------
  :bind
  (("M-1" . kk/vterm-toggle-1)
   ("M-2" . kk/vterm-toggle-2)
   ("M-3" . kk/vterm-toggle-3)
   ("M-4" . kk/vterm-toggle-4)
   ("M-5" . kk/vterm-toggle-5)
   ("M-6" . kk/vterm-toggle-6)
   ("M-7" . kk/vterm-toggle-7)
   ("M-8" . kk/vterm-toggle-8)
   ("M-9" . kk/vterm-toggle-9))
  :bind
  (:map vterm-mode-map          ; <— extra bindings only active in vterm
        ("M-1" . kk/vterm-toggle-1)
        ("M-2" . kk/vterm-toggle-2)
        ("M-3" . kk/vterm-toggle-3)
        ("M-4" . kk/vterm-toggle-4)
        ("M-5" . kk/vterm-toggle-5)
        ("M-6" . kk/vterm-toggle-6)
        ("M-7" . kk/vterm-toggle-7)
        ("M-8" . kk/vterm-toggle-8)
        ("M-9" . kk/vterm-toggle-9)))

;;; vterm.el ends here
