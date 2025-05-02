;;; packages/tab-bar.el --- Tab bar configuration  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(use-package tab-bar
  :demand t
  :ensure t
  :custom
  (tab-bar-close-button-show nil)
  (tab-bar-new-button-show nil)
  (tab-bar-tab-hints t)
  (tab-bar-show nil)
  (tab-bar-tab-name-function (lambda () ""))
  (tab-bar-auto-width-max '((15) 5))
  :bind
  (("M-2" . (lambda () (interactive) (tab-bar-select-or-create 2))))
  :config
  (defun number-to-letter (number)
    "Convert a number to its corresponding lowercase letter.
   1 -> a, 2 -> b, etc."
    (if (and (integerp number)
             (<= 1 number 26))
        (char-to-string (+ (1- number) ?a))
      (error "Number must be between 1 and 26")))

  (defun tab-bar-select-or-create (tab-number)
    (interactive)
    (if (<= tab-number (length (tab-bar-tabs)))
        ;; If the tab exists, select it
        (tab-bar-select-tab tab-number)
      ;; Otherwise, create tabs until we reach the desired number
      (let ((current-tabs (length (tab-bar-tabs))))
        (while (< current-tabs tab-number)
          (tab-bar-new-tab)
          ;; Open vterm in the newly created tab
		  (my/vterm-tmux-here)
          (setq current-tabs (1+ current-tabs)))
        ;; Select the newly created tab
        (tab-bar-select-tab tab-number)))))

;;; tab-bar.el ends here
