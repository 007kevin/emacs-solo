;;; packages/isearch.el --- Incremental search configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for incremental search.

;;; Code:

(use-package isearch
  :after consult
  :ensure nil
  :bind (:map isearch-mode-map
         ("C-s" . search-buffer-continue)
         ("C-r" . search-buffer-continue)
         ("C-n" . isearch-repeat-forward)
         ("C-p" . isearch-repeat-backward)
         ;; just quit when invoking C-s again in vertico mode
         :map vertico-map ("C-s" . minibuffer-keyboard-quit)
         ;; disable C-s invoking `consult-history' in minibuffer-mode
         :map minibuffer-local-map ("C-s" . nil)
         :map minibuffer-mode-map ("C-s" . nil))
  :config
  (setq isearch-lazy-count t)
  (setq lazy-count-prefix-format "(%s/%s) ")
  (setq lazy-count-suffix-format nil)
  (setq search-whitespace-regexp ".*?")
  (setq isearch-wrap-function 'ignore)

  (defun isearch-copy-selected-word ()
    "Copy the current `isearch` selection to the kill ring."
    (interactive)
    (when isearch-other-end
      (let ((selection (buffer-substring-no-properties isearch-other-end (point))))
        (kill-new selection)
        (isearch-exit))))

  ;; Bind `M-w` in isearch to copy the selected word, so M-s M-. M-w
  ;; does a great job of 'copying the current word under cursor'.
  (define-key isearch-mode-map (kbd "M-w") 'isearch-copy-selected-word)


  (defun search-buffer-continue ()
    "Make isearch and buffer search seamless. Press C-s will jump to buffer search
with current isearch args."
    (interactive)
    (let ((isearch-arg (isearch--state-string (isearch--get-state)))
          (search-nonincremental-instead nil))
      (isearch-exit)
      (search-buffer isearch-arg)))

  (defun search-buffer (&optional arg)
    "Copy of `+default/search-buffer' modifed to accept initial argument"
    (interactive)
    (let (start end multiline-p)
      (save-restriction
        (when (region-active-p)
          (setq start (region-beginning)
                end   (region-end)
                multiline-p (/= (line-number-at-pos start)
                                (line-number-at-pos end)))
          (deactivate-mark)
          (when multiline-p
            (narrow-to-region start end)))
        (if (and start end (not multiline-p))
            (consult-line
             (replace-regexp-in-string
              " " "\\\\ "
              (rxt-quote-pcre
               (buffer-substring-no-properties start end))))
          (consult-line arg)))))

  ;; when changing isearch direction, move to the other match immediately
  (setq isearch-repeat-on-direction-change t)















  )

;;; isearch.el ends here
